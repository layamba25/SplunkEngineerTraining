import random
import time
import socket
from faker import Faker

fake = Faker()

def generate_fortigate_logs():
    
    fields = [
        f'date={fake.iso8601()}',
        f'time={fake.time()}',
        f'logid="{fake.random_int(min=1, max=100000)}"',
        f'type="traffic"',
        f'subtype="local"',
        f'level="notice"',
        f'vd="vdom1"',
        f'eventtime={fake.random_int(min=1, max=999999999999999999)}',
        f'srcip={fake.ipv4()}',
        f'srcport={fake.random_int(min=1, max=65535)}',
        f'srcintf="port{fake.random_int(min=1, max=24)}"',
        f'srcintfrole="undefined"',
        f'dstip={fake.ipv4()}',
        f'dstport={fake.random_int(min=1, max=65535)}',
        f'dstintf="vdom1"',
        f'dstintfrole="undefined"',
        f'sessionid={fake.random_int(min=1, max=999999)}',
        f'proto=6',
        f'action="server-rst"',
        f'policyid=0',
        f'policytype="local-in-policy"',
        f'service="HTTPS"',
        f'dstcountry="Reserved"',
        f'srccountry="Reserved"',
        f'trandisp="noop"',
        f'app="Web Management(HTTPS)"',
        f'duration={fake.random_int(min=1, max=60)}',
        f'sentbyte={fake.random_int(min=1, max=5000)}',
        f'rcvdbyte={fake.random_int(min=1, max=5000)}',
        f'sentpkt={fake.random_int(min=1, max=10)}',
        f'rcvdpkt={fake.random_int(min=1, max=10)}',
        f'appcat="unscanned"',
    ]
    return " ".join(fields)

       
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

            message_fgt = generate_fortigate_logs()
            
            s.sendall(message_fgt.encode())
            print(f"Message sent to {server_ip}:{server_port} -> {message_fgt}")

            sleep_time = random.random() * 0.1
            time.sleep(sleep_time)  
            
          
except KeyboardInterrupt:
    print("\nScript stopped by user. Closing socket.")
    s.close()

