import boto3
import json
s3 = boto3.client("s3")

def upload_json(bucket, key, obj):
    s3.put_object(Bucket=bucket, Key=key, Body=json.dumps(obj))

def upload_binary(bucket, key, data_bytes):
    s3.put_object(Bucket=bucket, Key=key, Body=data_bytes)
