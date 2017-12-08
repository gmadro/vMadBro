import requests
import socket

def send_to_log_insight(li_server, event_type, event_msg):
    """
    Send an event to specified Log Insight server

    Arguments:
    li_server -- Log Insight server to send event entry to
    event_type -- Event type: INFO, WARNING, ERROR
    event_msg -- Event body

    Example:
    send_to_log_insight('loginsight.vmadbro.com', 'INFO', 'This is an event')

    Notes:
    N/A
    """

    id_agent = socket.gethostname()

    rest_url = 'http://' + li_server +':9000/api/v1/events/ingest/' + id_agent

    rest_body = {"events": [{
        "fields": [
            {"name":"eventType", "content":event_type},
            {"name":"agentID", "content":id_agent}
            ],
        "text": event_msg
        }]
                }

    response = requests.post(rest_url, json=rest_body)

    print('Posting results to Log Insight server: ' + li_server)

    if response.status_code != 200:
        print('REST Call failed to Log Insight server')
        print(response.text)
    else:
        print('REST Call to Log Insight server successful')
        print(response.text)

LI_SERVER = 'loginsight.vmadbro.com'
EVENT_TYPE = 'INFO'
EVENT_MSG = 'Python ingestion test'

send_to_log_insight(LI_SERVER, EVENT_TYPE, EVENT_MSG)
