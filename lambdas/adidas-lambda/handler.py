import json
import os
import boto3
from common.pdf_generator import create_pdf_bytes
from common.s3_utils import upload_json, upload_binary

sqs = boto3.client("sqs")

RAW_BUCKET = os.environ.get("RAW_BUCKET")
PDF_BUCKET = os.environ.get("PDF_BUCKET")
QUEUE_URL = os.environ.get("SQS_URL")

def lambda_handler(event, context):
    # If invoked via API Gateway, body may be string
    try:
        body = event.get("body")
        if isinstance(body, str):
            payload = json.loads(body)
        else:
            payload = event.get("body") or event
    except Exception:
        payload = event

    order_id = payload.get("order_id", "no-id")

    # 1. store raw payload in S3
    raw_key = f"raw/{order_id}.json"
    upload_json(RAW_BUCKET, raw_key, payload)

    # 2. create PDF and upload
    pdf_data = create_pdf_bytes(payload)
    pdf_key = f"pdf/{order_id}.pdf"
    upload_binary(PDF_BUCKET, pdf_key, pdf_data)

    # 3. push to SQS
    sqs.send_message(QueueUrl=QUEUE_URL, MessageBody=json.dumps({
        "order_id": order_id,
        "s3_raw": raw_key,
        "s3_pdf": pdf_key,
        "source": "adidas",
        "payload": payload
    }))

    return {
        "statusCode": 200,
        "body": json.dumps({"message": "accepted", "order_id": order_id})
    }
