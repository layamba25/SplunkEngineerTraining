import random
import datetime
import random
import time
import socket
from faker import Faker

fake = Faker()

def generate_ip():
    return f"{random.randint(100, 255)}.{random.randint(50, 255)}.{random.randint(50, 255)}.{random.randint(50, 255)}"

def generate_datetime():
    now = datetime.datetime.now()
    return now.strftime("%d/%b/%Y:%H:%M:%S")

def generate_method():
    return random.choice(["GET", "POST"])

def generate_url():
    pages = ["product.screen", "cart.do", "category.screen", "oldlink"]
    actions = ["view", "addtocart", "remove", "checkout", "purchase"]
    product_ids = [f"GS-FG-A0{random.randint(1, 9)}", f"BS-AG-G0{random.randint(1, 9)}"]
    return f"/{random.choice(pages)}?action={random.choice(actions)}&itemId={random.choice(product_ids)}&JSESSIONID=SD{random.randint(3, 5)}SL{random.randint(6, 9)}FF{random.randint(1, 9)}ADFF{random.randint(1000, 9999)}"

def generate_status_code():
    return random.choice([200, 404, 500, 302])

def generate_response_size():
    return random.randint(200, 5000)

def generate_referer():
    domains = ["http://www.example.com", "http://www.google.com", "http://www.bing.com"]
    return random.choice(domains)

def generate_user_agent():
    agents = [
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.88 Safari/537.36",
        "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.0.2 Safari/605.1.15",
        "Mozilla/5.0 (Windows NT 6.1; WOW64; rv:54.0) Gecko/20100101 Firefox/54.0"
    ]
    return random.choice(agents)

def generate_log_entry():
    return f'{generate_ip()} - - [{generate_datetime()}] "{generate_method()} {generate_url()} HTTP 1.1" {generate_status_code()} {generate_response_size()} "{generate_referer()}" "{generate_user_agent()}"'

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

            # Apache web server dummy data

            message_apache = generate_log_entry()
            
            s.sendall(message_apache.encode())
            print(f"Message sent to {server_ip}:{server_port} -> {message_apache}")

            sleep_time = random.random() * 0.1
            time.sleep(sleep_time)
except KeyboardInterrupt:
    print("Exiting...")
    s.close()


# def generate_log_file(number_of_entries):
#     with open("web_access_log.txt", "w") as file:
#         for _ in range(number_of_entries):
#             log_entry = generate_log_entry()
#             file.write(log_entry + "\n")
#             print(log_entry)

# # Generate 1000 log entries for example
# generate_log_file(1000)
