import random
import time
import socket
from faker import Faker

fake = Faker()

def generate_cisco_esa_logs():
    fields = [
        fake.date(pattern="%Y-%m-%d %H:%M:%S"), #Timestamp
        "mid=", fake.uuid4(), #Message ID
        "to=", fake.email(), #Recipient
        "from=", fake.email(), #Sender
        "subject=", fake.sentence(nb_words=5), #Subject
        "ICID=", str(fake.random_number(digits=5)), #Incoming Connection ID
        "DCID=", str(fake.random_number(digits=5)), #Delivery Connection ID
        "RID=", str(fake.random_number(digits=5)), #Recipient ID
        "status=", fake.random_element(elements=('deliver', 'bounce', 'delay', 'quarantine')) #Status
    ]
    return ' '.join(fields)

def generate_cisco_wsa_logs():
    fields = [
        fake.date(pattern="%d/%b/%Y:%H:%M:%S %z"), #Timestamp
        fake.ipv4(), #Client IP
        fake.random_number(digits=5), #Client to Server bytes
        fake.random_number(digits=5), #Server to Client bytes
        fake.random_element(elements=('GET', 'POST', 'PUT', 'DELETE')), #HTTP Method
        fake.uri(), #URL
        fake.random_element(elements=('BLOCK', 'ALLOW')), #Access
        fake.random_element(elements=('text/html', 'application/json', 'application/xml')), #Content Type
        fake.random_element(elements=('complete', 'partial', 'none')), #Transaction Result
        fake.random_element(elements=('application', 'audio', 'font', 'example', 'image', 'message', 'model', 'multipart', 'text', 'video')), #Category
        fake.ipv4(), #Server IP
        fake.user_name(), #User Name
        str(fake.random_int(min=1, max=65535)), #Client Source Port
        str(fake.random_int(min=1, max=65535)) #Server Port
    ]
    return ' '.join(fields)

def generate_cisco_asa_logs():
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
    return ' '.join(fields)

def generate_cisco_meraki_logs():
    fields = [
        fake.date(pattern="%b %d %H:%M:%S"), #Timestamp
        fake.random_element(elements=('emerg', 'alert', 'crit', 'err', 'warning', 'notice', 'info', 'debug')), #Priority
        fake.domain_name(), #Host
        "src=", fake.ipv4(), #Source IP
        "dst=", fake.ipv4(), #Destination IP
        "application=", fake.file_name(), #Application
        "protocol=", fake.random_element(elements=('tcp', 'udp', 'icmp')), #Protocol
        "action=", fake.random_element(elements=('allow', 'deny')), #Action
        "bytes=", str(fake.random_int(min=1, max=10000)), #Bytes
        "duration=", str(fake.random_int(min=1, max=60)) #Duration in seconds
    ]
    return ' '.join(fields)

def generate_cisco_ise_logs():
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
    return ' '.join(fields)

def generate_cisco_estreamer_logs():
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
        fake.sentence(nb_words=6), # Description
    ]
    return fields

def generate_cisco_umbrella_logs():
    fields = [
        fake.date(pattern="%Y-%m-%d %H:%M:%S"), #Timestamp
        fake.random_element(elements=('Blocked', 'Allowed')), #Action
        fake.random_element(elements=('IP', 'Domain')), #Type
        fake.ipv4(), #Internal IP
        fake.ipv4(), #External IP
        fake.domain_name(), #Internal Domain
        fake.domain_name(), #External Domain
        fake.random_element(elements=('A', 'AAAA', 'CNAME', 'MX', 'NS', 'PTR', 'SOA', 'SRV', 'TXT')), #Record Type
        fake.random_element(elements=('IN', 'OUT')), #Direction
        fake.random_element(elements=('Internal', 'External')), #Internal/External
    ]
    return fields

def generate_cisco_firepower_logs():
    fields = [
        fake.date(pattern="%Y-%m-%d %H:%M:%S"), #Timestamp
        fake.random_element(elements=('Alert', 'Block', 'Pass')), #Action
        fake.ipv4(), #Source IP
        fake.ipv4(), #Destination IP
        fake.random_int(min=1, max=65535), #Source Port
        fake.random_int(min=1, max=65535), #Destination Port
        fake.random_element(elements=('TCP', 'UDP', 'ICMP', 'Unknown')), #Protocol
        fake.random_element(elements=('Low', 'Medium', 'High', 'Critical')), #Impact Level
        fake.sentence(nb_words=6), #Description
    ]
    return fields

def generate_cisco_wsa_squid():
    fields = [
        fake.date(pattern="%d/%b/%Y:%H:%M:%S %z"), #Timestamp
        fake.random_element(elements=('TCP_DENIED', 'TCP_MISS', 'TCP_HIT', 'TCP_REFRESH_HIT', 'TCP_REFRESH_MISS', 'TCP_CLIENT_REFRESH', 'TCP_IMS_HIT', 'TCP_IMS_MISS', 'TCP_SWAPFAIL_MISS', 'TCP_DENIED', 'TCP_OFFLINE_HIT',
        'TCP_MEM_HIT',)), #Action
        fake.ipv4(), #Client IP
        fake.random_int(min=1, max=65535), #Client Source Port
        fake.ipv4(), #Server IP
        fake.random_int(min=1, max=65535), #Server Port
        fake.random_element(elements=('GET', 'POST', 'PUT', 'DELETE')), #HTTP Method
        fake.uri(), #URL
        fake.random_element(elements=('text/html', 'application/json', 'application/xml')), #Content Type
        fake.random_element(elements=('complete', 'partial', 'none')), #Transaction Result
        fake.random_element(elements=('application', 'audio', 'font', 'example', 'image', 'message', 'model', 'multipart', 'text', 'video')), #Category
        fake.user_name(), #User Name
    ]

    # fields = [
    #     str(round(time.time(), 2)),  # UNIX timestamp as a floating point
    #     str(random.randint(1, 10000)),  # Random duration
    #     fake.ipv4(),  # IP address
    #     random.choice(["TCP_DENIED/403", "TCP_REFRESH_HIT/200"]),  # TCP status
    #     str(random.randint(500, 10000)),  # Response size in bytes
    #     "GET",  # HTTP method
    #     fake.url(),  # URL
    #     fake.email(domain="buttercupgames.com"),  # Email
    #     "NONE/- -",  # Placeholder field
    #     "BLOCK_AMW_REQ-DefaultGroup-Demo_Clients-NONE-NONE-NONE",  # Additional info
    #     f"<{random.choice(['IW_comp', 'IW_adv', 'nc', 'IW_scty', 'IW_mail', 'IW_adlt', 'IW_hlth', 'IW_trvl'])},-7.9,13,'Unknown',100,11269,37876,-,-,-,-,-,-,-,-,{random.choice(['IW_comp', 'IW_adv', 'nc', 'IW_scty', 'IW_mail', 'IW_adlt', 'IW_hlth', 'IW_trvl'])},-> - -"  # More additional info
    # ]
    return fields

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

            # Cisco ASA dummy data

            message_cisco_asa = generate_cisco_asa_logs()
            
            s.sendall(message_cisco_asa.encode())
            print(f"Message sent to {server_ip}:{server_port} -> {message_cisco_asa}")

            sleep_time = random.random() * 0.1
            time.sleep(sleep_time)  
            
          
except KeyboardInterrupt:
    print("\nScript stopped by user. Closing socket.")
    s.close()

