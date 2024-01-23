import datetime
import random
import socket
from faker import Faker

fake = Faker()

def create_syslog_header(app_name):
    prival = 22  # Example value, should be calculated based on facility and severity
    version = 1
    timestamp = datetime.datetime.now().isoformat()
    hostname = socket.gethostname()  # Or a specific hostname if known
    procid = "-"
    msgid = "-"

    syslog_header = f"<{prival}>{version} {timestamp} {hostname} {app_name} {procid} {msgid}"
    return syslog_header

class WebLog:
    def __init__(self, dstip, dstport):
        self.fake = Faker()
        self.dstip = dstip
        self.dstport = dstport

    def generate_log(self):
        syslog_header = create_syslog_header("Web")
        fields = [
            fake.ipv4(), # Source IP
            fake.ipv4(), # Destination IP
            fake.user_name(), # User
            fake.date(pattern="%d/%b/%Y:%H:%M:%S"), # Timestamp
            fake.random_element(elements=('GET', 'POST')), # Method
            fake.uri_path(), # URL
            fake.random_int(min=100, max=600), # Status Code
            fake.random_int(min=100, max=10000), # Response Size
            fake.uri(), # Referer
            fake.user_agent(), # User Agent
        ]
        msg = " ".join(fields)
        return f"{syslog_header} - {msg}"
    
class AccessLog:
    def __init__(self, dstip, dstport):
        self.fake = Faker()
        self.dstip = dstip
        self.dstport = dstport

    def generate_log(self):
        syslog_header = create_syslog_header("Access")
        fields = [
            fake.ipv4(), # Source IP
            fake.ipv4(), # Destination IP
            fake.user_name(), # User
            fake.date(pattern="%d/%b/%Y:%H:%M:%S"), # Timestamp
            fake.random_element(elements=('GET', 'POST')), # Method
            fake.uri_path(), # URL
            fake.random_int(min=100, max=600), # Status Code
            fake.random_int(min=100, max=10000), # Response Size
            fake.uri(), # Referer
            fake.user_agent(), # User Agent
        ]
        msg = " ".join(fields)
        return f"{syslog_header} - {msg}"