import os
import socket
import requests

def send_to_log_insight(event_type, id_event, event_msg, li_server, script_name):
    """
    Log an event to specified Log Insight server

    Arguments:
    event_type: INFO, WARNING, ERROR
    id_event: Event identifier
    event_msg: Event body
    li_server: Log Insight server to send event entry to
    script_name: Current script name

    Example:
    >>> send_to_log_insight('loginsight.vmadbro.com', 'INFO', 'This is an event')

    Notes:
    N/A
    """

    id_agent = socket.gethostname()

    rest_url = 'http://' + li_server +':9000/api/v1/events/ingest/' + id_agent

    rest_body = {"events": [{
        "fields": [
            {"name":"EventType", "content":event_type},
            {"name":"EventID", "content":id_event},
            {"name":"AgentID", "content":id_agent},
            {"name":"ScriptName", "content":script_name}
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
EVENT_TYPE = 'ERROR'
EVENT_MSG = 'Error this file has exploded bad'
SCRIPT_NAME = os.path.basename(__file__)
ID_EVENT = '103'

send_to_log_insight(EVENT_TYPE, ID_EVENT, EVENT_MSG, LI_SERVER, SCRIPT_NAME)
