import random
import time
import socket
from faker import Faker

fake = Faker()

def generate_dummy_palo_traffic():
    # https://docs.paloaltonetworks.com/pan-os/9-1/pan-os-admin/monitoring/use-syslog-for-monitoring/syslog-field-descriptions/traffic-log-fields
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
    return ",".join(fields)

def generate_dummy_palo_threat():
    # https://docs.paloaltonetworks.com/pan-os/9-1/pan-os-admin/monitoring/use-syslog-for-monitoring/syslog-field-descriptions/threat-log-fields
    fields = [
        "N/A", #FUTURE_USE
        fake.iso8601(), #Receive Time
        str(fake.bothify(text='????-????')), #Serial Number
        fake.random_element(elements=('Type1', 'Type2', 'Type3')), #Type
        fake.random_element(elements=('Threat1', 'Threat2', 'Threat3')), #Threat/Content Type
        "N/A", #FUTURE_USE
        fake.iso8601(), #Generated Time
        fake.ipv4(), #Source Address
        fake.ipv4(), #Destination Address
        fake.ipv4(), #NAT Source IP
        fake.ipv4(), #NAT Destination IP
        fake.random_element(elements=('Rule1', 'Rule2', 'Rule3')), #Rule Name
        fake.name(), #Source User
        fake.name(), #Destination User
        fake.random_element(elements=('App1', 'App2', 'App3')), #Application
        fake.random_element(elements=('System1', 'System2', 'System3')), #Virtual System
        fake.random_element(elements=('Zone1', 'Zone2', 'Zone3')), #Source Zone
        fake.random_element(elements=('Zone1', 'Zone2', 'Zone3')), #Destination Zone
        fake.random_element(elements=('Interface1', 'Interface2', 'Interface3')), #Inbound Interface
        fake.random_element(elements=('Interface1', 'Interface2', 'Interface3')), #Outbound Interface
        fake.random_element(elements=('Action1', 'Action2', 'Action3')), #Log Action
        "N/A", #FUTURE_USE
        str(fake.random_number()), #Session ID
        str(fake.random_digit()), #Repeat Count
        str(fake.random_number()), #Source Port
        str(fake.random_number()), #Destination Port
        str(fake.random_number()), #NAT Source Port
        str(fake.random_number()), #NAT Destination Port
        fake.random_element(elements=('Flag1', 'Flag2', 'Flag3')), #Flags
        fake.random_element(elements=('Protocol1', 'Protocol2', 'Protocol3')), #Protocol
        fake.random_element(elements=('Action1', 'Action2', 'Action3')), #Action
        fake.file_name(), #URL/Filename
        str(fake.random_number()), #Threat ID
        fake.random_element(elements=('Category1', 'Category2', 'Category3')), #Category
        fake.random_element(elements=('Severity1', 'Severity2', 'Severity3')), #Severity
        fake.random_element(elements=('Direction1', 'Direction2', 'Direction3')), #Direction
        str(fake.random_number()), #Sequence Number
        fake.random_element(elements=('Flag1', 'Flag2', 'Flag3')), #Action Flags
        fake.country(), #Source Location
        fake.country(), #Destination Location
        "N/A", #FUTURE_USE
        fake.random_element(elements=('Type1', 'Type2', 'Type3')), #Content Type
        fake.random_element(elements=('ID1', 'ID2', 'ID3')), #PCAP_ID
        fake.sha1(), #File Digest
        fake.random_element(elements=('Cloud1', 'Cloud2', 'Cloud3')), #Cloud
        str(fake.random_number()), #URL Index
        fake.user_agent(), #User Agent
        fake.file_extension(), #File Type
        fake.ipv4(), #X-Forwarded-For
        fake.uri(), #Referer
        fake.email(), #Sender
        fake.sentence(), #Subject
        fake.email(), #Recipient
        str(fake.random_number()), #Report ID
        fake.random_element(elements=('Level1', 'Level2', 'Level3')), #Device Group Hierarchy Level 1
        fake.random_element(elements=('Level1', 'Level2', 'Level3')), #Device Group Hierarchy Level 2
        fake.random_element(elements=('Level1', 'Level2', 'Level3')), #Device Group Hierarchy Level 3
        fake.random_element(elements=('Level1', 'Level2', 'Level3')), #Device Group Hierarchy Level 4
        fake.random_element(elements=('System1', 'System2', 'System3')), #Virtual System Name
        fake.random_element(elements=('Device1', 'Device2', 'Device3')), #Device Name
        "N/A", #FUTURE_USE
        fake.uuid4(), #Source VM UUID
        fake.uuid4(), #Destination VM UUID
        fake.random_element(elements=('GET', 'POST', 'PUT', 'DELETE')), #HTTP Method
        str(fake.random_number()), #Tunnel ID/IMSI
        str(fake.random_number()), #Monitor Tag/IMEI
        str(fake.random_number()), #Parent Session ID
        fake.iso8601(), #Parent Start Time
        fake.random_element(elements=('Type1', 'Type2', 'Type3')), #Tunnel Type
        fake.random_element(elements=('Category1', 'Category2', 'Category3')), #Threat Category
        fake.random_element(elements=('Version1', 'Version2', 'Version3')), #Content Version
        "N/A", #FUTURE_USE
        str(fake.random_number()), #SCTP Association ID
        str(fake.random_number()), #Payload Protocol ID
        fake.random_element(elements=('Header1', 'Header2', 'Header3')), #HTTP Headers
        fake.random_element(elements=('Category1', 'Category2', 'Category3')), #URL Category List
        fake.uuid4(), #Rule UUID
        fake.random_element(elements=('Yes', 'No')), #HTTP/2 Connection
        fake.random_element(elements=('Group1', 'Group2', 'Group3')) #Dynamic User Group Name
    ]
    return ",".join(fields)

def generate_dummy_palo_system():
    # https://docs.paloaltonetworks.com/pan-os/9-1/pan-os-admin/monitoring/use-syslog-for-monitoring/syslog-field-descriptions/system-log-fields
    fields = [
        "N/A", #FUTURE_USE
        fake.iso8601(), #Receive Time
        fake.bothify(text='????-????'), #Serial Number
        fake.random_element(elements=('SYSTEM')), #Type
        fake.random_element(elements=('Threat1', 'Threat2', 'Threat3')), #Content/Threat Type
        "N/A", #FUTURE_USE
        fake.iso8601(), #Generated Time
        fake.random_element(elements=('System1', 'System2', 'System3')), #Virtual System
        str(fake.random_number()), #Event ID
        fake.random_element(elements=('Object1', 'Object2', 'Object3')), #Object
        "N/A", #FUTURE_USE
        "N/A", #FUTURE_USE
        fake.random_element(elements=('Module1', 'Module2', 'Module3')), #Module
        fake.random_element(elements=('Severity1', 'Severity2', 'Severity3')), #Severity
        fake.sentence(), #Description
        str(fake.random_number()), #Sequence Number
        fake.random_element(elements=('Flag1', 'Flag2', 'Flag3')), #Action Flags
        fake.random_element(elements=('Level1', 'Level2', 'Level3')), #Device Group Hierarchy Level 1
        fake.random_element(elements=('Level1', 'Level2', 'Level3')), #Device Group Hierarchy Level 2
        fake.random_element(elements=('Level1', 'Level2', 'Level3')), #Device Group Hierarchy Level 3
        fake.random_element(elements=('Level1', 'Level2', 'Level3')), #Device Group Hierarchy Level 4
        fake.random_element(elements=('System1', 'System2', 'System3')), #Virtual System Name
        fake.random_element(elements=('Device1', 'Device2', 'Device3')), #Device Name
    ]
    return ",".join(fields)
# ask for server IP and port
server_ip = input("Enter server IP: ")
server_port = int(input("Enter server port: "))

# create a socket object
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

# connection to hostname on the port
s.connect((server_ip, server_port))

try:
    while True:
        events_per_second = random.randint(0, 5)
        for _ in range(events_per_second):

            # Traffic

            message_traffic = generate_dummy_palo_traffic()
            
            s.sendall(message_traffic.encode())
            print(f"Message sent to {server_ip}:{server_port} -> {message_traffic}")

            sleep_time = random.random() * 0.1
            time.sleep(sleep_time)  
            
            #  Threat

            message_threat = generate_dummy_palo_threat()
            
            s.sendall(message_threat.encode())
            print(f"Message sent to {server_ip}:{server_port} -> {message_threat}")

            sleep_time = random.random() * 0.1
            time.sleep(sleep_time)  

            # System

            message_system = generate_dummy_palo_system()
            s.sendall(message_system.encode())
            print(f"Message sent to {server_ip}:{server_port} -> {message_system}")
        time.sleep(1)  # sleep for one second
except KeyboardInterrupt:
    print("\nScript stopped by user. Closing socket.")
    s.close()
