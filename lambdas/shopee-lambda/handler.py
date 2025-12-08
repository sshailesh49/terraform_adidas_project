import json
import os
import boto3
from common.s3_utils import upload_json

sqs = boto3.client("sqs")
RAW_BUCKET = os.environ.get("RAW_BUCKET")
QUEUE_URL = os.environ.get("SQS_URL")

def lambda_handler(event, context):
    payload = event.get("body") or event
    if isinstance(payload, str):
        payload = json.loads(payload)
    order_id = payload.get("order_id", "no-id")
    # store raw
    upload_json(RAW_BUCKET, f"raw/shopee-{order_id}.json", payload)
       # 3. push to SQS
    message = {
        "order_id": order_id,
        "s3_raw": f"raw/shopee-{order_id}.json",
        "s3_pdf": "Null",
        "source": "shopee",
        "payload": payload
    }
    sqs.send_message(QueueUrl=QUEUE_URL, MessageBody=json.dumps(message))

    #     # 3. push to SQS
    # sqs.send_message(QueueUrl=QUEUE_URL, MessageBody=json.dumps({
    #     "order_id": order_id,
    #     "s3_raw": raw_key,
    #     "s3_pdf": pdf_key,
    #     "source": "shopee",
    #     "payload": payload
    # }))
    return {"statusCode": 200, "body": json.dumps({"ok": True})}
