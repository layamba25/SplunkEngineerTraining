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

class PaloAltoTrafficLog:
    def __init__(self, dstip, dstport):
        self.fake = Faker()
        self.dstip = dstip
        self.dstport = dstport
    
    def generate_log(self):
        syslog_header = create_syslog_header("PaloAltoTraffic")
        fields = [
        "N/A", #FUTURE_USE
        fake.iso8601(), #Receive Time
        str(fake.random_int()), #Serial Number
        # fake.random_element(elements=("TRAFFIC", "THREAT", "SYSTEM")), #Type
        "TRAFFIC", #Type
        fake.random_element(elements=("start", "end", "drop", "deny")), # Threat/Content Type
        "N/A", #FUTURE_USE
        fake.iso8601(), #Generated Time
        fake.ipv4(), #Source Address
        fake.ipv4(), #Destination Address
        fake.ipv4(), #NAT Source IP
        fake.ipv4(), #NAT Destination IP
        fake.random_element(elements=("rule1", "rule2", "rule3", "rule4", "rule5")), #Rule Name
        fake.random_element(elements=("user1", "user2", "user3", "user4", "user5")), #Source User
        fake.random_element(elements=("user1", "user2", "user3", "user4", "user5")), #Destination User
        fake.random_element(elements=("app1", "app2", "app3", "app4", "app5")), #Application
        fake.random_element(elements=("vsys1", "vsys2", "vsys3", "vsys4", "vsys5")), #Virtual System
        fake.random_element(elements=("zone1", "zone2", "zone3", "zone4", "zone5")), #Source Zone
        fake.random_element(elements=("zone1", "zone2", "zone3", "zone4", "zone5")), #Destination Zone
        fake.random_element(elements=("ethernet1/1", "ethernet1/2", "ethernet1/3", "ethernet1/4", "ethernet1/5")), #Inbound Interface
        fake.random_element(elements=("ethernet1/1", "ethernet1/2", "ethernet1/3", "ethernet1/4", "ethernet1/5")), #Outbound Interface
        fake.random_element(elements=("allow", "deny", "update")), #Log Action
        "N/A", #FUTURE_USE
        str(fake.random_int()), #Session ID
        str(random.randint(1,5)), #Repeat Count
        fake.random_element(elements=("80", "443", "10000", "10001", "0x3")), #Source Port
        fake.random_element(elements=("80", "443", "10000", "10001", "0x3")), #Destination Port
        fake.random_element(elements=("80", "443", "10000", "10001", "0x3")), #NAT Source Port
        fake.random_element(elements=("80", "443", "10000", "10001", "0x3")), #NAT Destination Port
        fake.random_element(elements=("0x80000000", "0x40000000", "0x20000000", "0x10000000", "0x08000000", "0x02000000", "0x01000000", "0x00800000", "0x00400000", "0x00200000", "0x00100000", "0x00080000", "0x00040000", "0x00020000", "0x00010000", "0x00008000", "0x00002000", "0x00000800", "0x00000400", "0x00000100")), #Flags
        fake.random_element(elements=("tcp", "udp", "icmp", "sctp", "esp", "ah", "gre", "igmp", "ipip", "pim", "ospf", "vrrp", "ipip", "ipsec", "l2tp")), #Protocol
        fake.random_element(elements=("allow", "deny", "drop", "block", "drop ICMP", "reset both", "reset client", "reset server", "reset both", "block ip", "block url", "block ip override", "block url override", "block continue", "block override", "block continue override", "block packet-buffer", "block packet-buffer override", "block ip packet-buffer", "block ip packet-buffer override", "block url packet-buffer", "block url packet-buffer override", "block continue packet-buffer", "block continue packet-buffer override", "block ip continue packet-buffer", "block ip continue packet-buffer override", "block url continue packet-buffer", "block url continue packet-buffer override", "block session", "block session override", "block ip session", "block ip session override", "block url session", "block url session override", "block continue session", "block continue session override", "block ip continue session", "block ip continue session override", "block url continue session", "block url continue session override")), #Action
        str(fake.random_int()), #Bytes
        str(fake.random_int()), #Bytes Sent
        str(fake.random_int()), #Bytes Received
        str(fake.random_int()), #Packets
        fake.iso8601(), #Start Time
        str(random.randint(1,10)), #Elapsed Time
        "general", #Category
        "N/A", #FUTURE_USE
        str(fake.random_int()), #Sequence Number
        "0x0", #Action Flags
        fake.country(), #Source Location
        fake.country(), #Destination Location
        "N/A", #FUTURE_USE
        str(fake.random_int()), #Packets Sent
        str(fake.random_int()), #Packets Received
        # "TCP FIN", #Session End Reason
        fake.random_element(elements=("threat", "policy-deny", "decrypt-cert-validation", "decrypt-unsupport-param", "decrypt-error", "tcp-rst-from-clien", "tcp-rst-from-server", "resources-unavailable", "tcp-fin", "tcp-reuse", "decoder", "aged-out","unknown", "n/a")), #Session End Reason
        "Root", #Device Group Hierarchy Level 1
        "SubGroup1", #Device Group Hierarchy Level 2
        "SubGroup2", #Device Group Hierarchy Level 3
        "SubGroup3", #Device Group Hierarchy Level 4
        "vsysName", #Virtual System Name
        "device1", #Device Name
        "firewall", #Action Source  
        fake.uuid4(), #Source VM UUID
        fake.uuid4(), #Destination VM UUID
        str(fake.random_int()), #Tunnel ID IMPLIES TUNNEL TYPE
        str(fake.random_int()), #Monitor Tag
        str(fake.random_int()), #Parent Session ID
        fake.iso8601(), #Parent Start Time
        fake.random_element(elements=("ipsec", "gre", "l2tp", "mpls", "vxlan", "n/a")), #Tunnel Type
        "1", #SCTP Association ID
        "0",  #SCTP Chunks
        "0",  #SCTP Chunks Sent
        "0", #SCTP Chunks Received
        fake.uuid4(), #Rule UUID
        fake.random_element(elements=("Parent session ID—HTTP/2 connection", "0—SSL session")), #HTTP/2 Connection
        "0", #App Flag Count
        str(fake.random_int()), #Policy ID
        "1", #Link Switches
        "Cluster1", #SD-WAN Cluster
        "Edge", #SD-WAN Device Type
        "Private", #SD-WAN Cluster Type
        "Site1", #SD-WAN Site
        "DUG1" #Dynamic User Group Name
    ]
        msg = " ".join(fields)
        return f"{syslog_header} - {msg}"

class PaloAltoThreatLog:
    def __init__(self, dstip, dstport):
        self.fake = Faker()
        self.dstip = dstip
        self.dstport = dstport
    
    def generate_log(self):
        syslog_header = create_syslog_header("PaloAltoThreat")
        fields = [
        "N/A", #FUTURE_USE
        fake.iso8601(), #Receive Time
        str(fake.random_int()), #Serial Number
        # fake.random_element(elements=("TRAFFIC", "THREAT", "SYSTEM")), #Type
        "THREAT", #Type
        fake.random_element(elements=("start", "end", "drop", "deny")), # Threat/Content Type
        "N/A", #FUTURE_USE
        fake.iso8601(), #Generated Time
        fake.ipv4(), #Source Address
        fake.ipv4(), #Destination Address
        fake.ipv4(), #NAT Source IP
        fake.ipv4(), #NAT Destination IP
        fake.random_element(elements=("rule1", "rule2", "rule3", "rule4", "rule5")), #Rule Name
        fake.random_element(elements=("user1", "user2", "user3", "user4", "user5")), #Source User
        fake.random_element(elements=("user1", "user2", "user3", "user4", "user5")), #Destination User
        fake.random_element(elements=("app1", "app2", "app3", "app4", "app5")), #Application
        fake.random_element(elements=("vsys1", "vsys2", "vsys3", "vsys4", "vsys5")), #Virtual System
        fake.random_element(elements=("zone1", "zone2", "zone3", "zone4", "zone5")), #Source Zone
        fake.random_element(elements=("zone1", "zone2", "zone3", "zone4", "zone5")), #Destination Zone
        fake.random_element(elements=("ethernet1/1", "ethernet1/2", "ethernet1/3", "ethernet1/4", "ethernet1/5")), #Inbound Interface
        fake.random_element(elements=("ethernet1/1", "ethernet1/2", "ethernet1/3", "ethernet1/4", "ethernet1/5")), #Outbound Interface
        ]
        msg = " ".join(fields)
        return f"{syslog_header} - {msg}"
    
class PaloAltoSystemLog:
    def __init__(self, dstip, dstport):
        self.fake = Faker()
        self.dstip = dstip
        self.dstport = dstport
    
    def generate_log(self):
        syslog_header = create_syslog_header("PaloAltoSystem")
        fields = [
        "N/A", #FUTURE_USE
        fake.iso8601(), #Receive Time
        str(fake.random_int()), #Serial Number
        # fake.random_element(elements=("TRAFFIC", "THREAT", "SYSTEM")), #Type
        "SYSTEM", #Type
        fake.random_element(elements=("start", "end", "drop", "deny")), # Threat/Content Type
        "N/A", #FUTURE_USE
        fake.iso8601(), #Generated Time
        fake.ipv4(), #Source Address
        fake.ipv4(), #Destination Address
        fake.ipv4(), #NAT Source IP
        fake.ipv4(), #NAT Destination IP
        fake.random_element(elements=("rule1", "rule2", "rule3", "rule4", "rule5")), #Rule Name
        fake.random_element(elements=("user1", "user2", "user3", "user4", "user5")), #Source User
        fake.random_element(elements=("user1", "user2", "user3", "user4", "user5")), #Destination User
        fake.random_element(elements=("app1", "app2", "app3", "app4", "app5")), #Application
        fake.random_element(elements=("vsys1", "vsys2", "vsys3", "vsys4", "vsys5")), #Virtual System
        fake.random_element(elements=("zone1", "zone2", "zone3", "zone4", "zone5")), #Source Zone
        fake.random_element(elements=("zone1", "zone2", "zone3", "zone4", "zone5")), #Destination Zone
        fake.random_element(elements=("ethernet1/1", "ethernet1/2", "ethernet1/3", "ethernet1/4", "ethernet1/5")), #Inbound Interface
        fake.random_element(elements=("ethernet1/1", "ethernet1/2", "ethernet1/3", "ethernet1/4", "ethernet1/5")), #Outbound Interface
        ]
        msg = " ".join(fields)
        return f"{syslog_header} - {msg}"
    