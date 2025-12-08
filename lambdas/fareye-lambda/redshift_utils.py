import os
import json
import redshift_connector

def insert_event_to_redshift(conn_params, table, event):
    conn = redshift_connector.connect(
        host=conn_params["host"],
        database=conn_params["dbname"],
        user=conn_params["user"],
        password=conn_params["password"],
        port=conn_params["port"]
    )

    cursor = conn.cursor()

    sql = f"INSERT INTO {table} (event_data) VALUES (%s)"
    cursor.execute(sql, (json.dumps(event),))

    conn.commit()
    cursor.close()
    conn.close()

