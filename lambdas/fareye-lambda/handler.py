import json
import boto3
import os
import traceback

redshift = boto3.client("redshift-data")

# Read config from env
WORKGROUP = os.environ.get("REDSHIFT_WORKGROUP")
SECRET_ARN = os.environ.get("REDSHIFT_SECRET_ARN")
DATABASE = os.environ.get("REDSHIFT_DB")

def save_to_redshift(payload):
    try:
        order_id = payload.get("order_id")
        s3_raw = payload.get("s3_raw")
        s3_pdf = payload.get("s3_pdf")
        source = payload.get("source", "unknown")
        nested_payload = json.dumps(payload.get("payload", {}))

        print(f"Inserting into Redshift: {order_id}")

        # 1️⃣ Submit the SQL query
        resp = redshift.execute_statement(
            WorkgroupName=WORKGROUP,
            Database=DATABASE,
            SecretArn=SECRET_ARN,
            Sql="""
                INSERT INTO orders (order_id, s3_raw, s3_pdf, source, payload)
                VALUES (:order_id, :s3_raw, :s3_pdf, :source, JSON_PARSE(:payload));
            """,
            Parameters=[
                {"name": "order_id", "value": order_id},
                {"name": "s3_raw", "value": s3_raw},
                {"name": "s3_pdf", "value": s3_pdf},
                {"name": "source", "value": source},
                {"name": "payload", "value": nested_payload},
            ]
        )

        print("Query submitted:", resp)

        # 2️⃣ WAIT for the query to finish
        statement_id = resp["Id"]

        status = redshift.describe_statement(Id=statement_id)
        while status["Status"] not in ["FINISHED", "FAILED"]:
            status = redshift.describe_statement(Id=statement_id)

        print("Final Redshift Status:", status)

        if status["Status"] == "FAILED":
            print("❌ Redshift Error:", status["Error"])
            raise Exception(status["Error"])

        print("✅ Insert success for:", order_id)
        return status

    except Exception as e:
        print("🔥 ERROR inserting into Redshift:", str(e))
        raise e


def lambda_handler(event, context):
    print("Event received:", json.dumps(event))
    for record in event["Records"]:
        try:
            body = record["body"]
            if isinstance(body, str):
                payload = json.loads(body)
            else:
                payload = body
                
            print("Payload:", payload)
            save_to_redshift(payload)
        except Exception as e:
             print(f"Error processing record: {e}")
             raise e

    return {"status": "ok"}
