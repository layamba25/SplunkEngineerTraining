import datetime
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

class CiscoESTreamerLog:
    def __init__(self, dstip, dstport):
        self.fake = Faker()
        self.dstip = dstip
        self.dstport = dstport

    def generate_log(self):
        syslog_header = create_syslog_header("CiscoESTreamer")
        fields = [
            fake.iso8601(), # Event Time
            fake.random_int(min=1, max=1000), # Event ID
            fake.random_element(elements=('Intrusion', 'File', 'Malware', 'Security Intelligence')), # Event Type
            fake.ipv4(), # Source IP
            fake.ipv4(), # Destination IP
            fake.random_int(min=1, max=65535), # Source Port
            fake.random_int(min=1, max=65535), # Destination Port
            fake.random_element(elements=('TCP', 'UDP', 'ICMP', 'Unknown')), # Protocol
            fake.random_element(elements=('Alert', 'Block', 'Pass')), # Action
            fake.random_element(elements=('Low', 'Medium', 'High', 'Critical')), # Impact Level
            fake.sentence(nb_words=6), # Description..
        ]
        msg = " ".join(fields)
        return f"{syslog_header} - {msg}"

class CiscoISELog:
    def __init__(self, dstip, dstport):
        self.fake = Faker()
        self.dstip = dstip
        self.dstport = dstport

    def generate_log(self):
        syslog_header = create_syslog_header("CiscoISE")
        fields = [
            fake.date(pattern="%Y-%m-%d %H:%M:%S"), #Timestamp
            fake.random_element(elements=('Passed-Authentication', 'Failed-Attempt', 'Endpoint-Profiled', 'Endpoint-Updated')), #Event Type
            fake.user_name(), #Username
            fake.ipv4(), #User IP
            fake.ipv4(), #Device IP
            "NAS-Identifier=", fake.word(), #NAS Identifier
            "NAS-IP-Address=", fake.ipv4(), #NAS IP Address
            "NAS-Port-Type=", fake.random_element(elements=('Virtual', 'Ethernet', 'Async', 'ISDN')), #NAS Port Type
            "Network-Device-Profile=", fake.word(), #Network Device Profile
            "Network-Device-Group=", fake.word(), #Network Device Group
            "NAS-Port=", str(fake.random_int(min=1, max=65535)), #NAS Port
            "RADIUS-Response=", fake.random_element(elements=('Access-Accept', 'Access-Reject', 'Access-Challenge')) #RADIUS Response
        ]
        msg = " ".join(fields)
        return f"{syslog_header} - {msg}"

class CiscoASALog:
    def __init__(self, dstip, dstport):
        self.fake = Faker()
        self.dstip = dstip
        self.dstport = dstport

    def generate_log(self):
        syslog_header = create_syslog_header("CiscoASA")
        fields = [
            "%ASA-", #Cisco ASA keyword
            str(fake.random_number(digits=1)), #Severity level
            str(fake.random_number(digits=6)), #Message ID
            fake.date(pattern="%b %d %Y %H:%M:%S"), #Timestamp
            fake.ipv4(), #Source IP
            str(fake.random_int(min=1, max=65535)), #Source port
            fake.ipv4(), #Destination IP
            str(fake.random_int(min=1, max=65535)), #Destination port
            fake.random_element(elements=('tcp', 'udp', 'icmp')), #Protocol
            fake.random_element(elements=('built', 'teardown')), #Action
            fake.ipv4(), #Device IP
            fake.text(max_nb_chars=50) #Description
        ]
        msg = " ".join(fields)
        return f"{syslog_header} - {msg}"
