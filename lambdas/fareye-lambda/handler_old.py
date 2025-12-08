import os
import json
import urllib3
import boto3
from .redshift_utils import insert_event_to_redshift

http = urllib3.PoolManager()
sqs = boto3.client("sqs")
FAREYE_URL = os.environ.get("FAREYE_API_URL")
FAREYE_KEY = os.environ.get("FAREYE_API_KEY")

# Redshift envs
REDSHIFT_TABLE = os.environ.get("REDSHIFT_TABLE", "events")
REDSHIFT_PARAMS = {
    "host": os.environ.get("REDSHIFT_HOST"),
    "port": os.environ.get("REDSHIFT_PORT", 5439),
    "user": os.environ.get("REDSHIFT_USER"),
    "password": os.environ.get("REDSHIFT_PASS"),
    "dbname": os.environ.get("REDSHIFT_DB", "dev")
}

def forward_to_fareye(payload):
    headers = {"Content-Type": "application/json", "Authorization": f"Bearer {FAREYE_KEY}"}
    resp = http.request("POST", FAREYE_URL, body=json.dumps(payload).encode("utf-8"), headers=headers)
    return resp.status, resp.data.decode("utf-8")

def lambda_handler(event, context):
    # event from SQS trigger: multiple records
    for rec in event.get("Records", []):
        body = json.loads(rec["body"])
        # call FarEye
        status, resp = forward_to_fareye(body)
        # store into Redshift (event + fareye response)
        ev = {"body": body, "fareye_status": status, "fareye_response": resp}
        insert_event_to_redshift(REDSHIFT_PARAMS, REDSHIFT_TABLE, ev)
    return {"status": "processed", "records": len(event.get("Records", []))}
