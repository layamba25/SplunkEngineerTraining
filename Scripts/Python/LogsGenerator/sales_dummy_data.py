from faker import Faker
import random
import time
import socket

fake = Faker()

def generate_sales_data():
    fields = [
        # fake.date_time().strftime("%Y-%m-%d %H:%M:%S"),  # _time should be from the year 2020
        fake.date_time_between(start_date='-3y', end_date='now').strftime("%Y-%m-%d %H:%M:%S"),  # _time should be from the year 2020
        fake.random_number(digits=6),  # AcctID
        fake.bothify(text='??-####'),  # Code
        fake.company(),  # Vendor
        fake.city(),  # VendorCity
        fake.country(),  # VendorCountry
        fake.random_number(digits=6),  # VendorID
        fake.latitude(),  # VendorLatitude
        fake.longitude(),  # VendorLongitude
        fake.state(),  # VendorStateProvince
        fake.random_number(digits=4),  # categoryId
        fake.random_number(digits=3),  # price
        fake.random_number(digits=6),  # productId
        fake.word(),  # product_name
        fake.random_number(digits=3)  # sale_price
    ]

    return ','.join(map(str, fields))

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
    
                message_sales = generate_sales_data()
                s.sendall(message_sales.encode())
                print(f"Message sent to {server_ip}:{server_port} -> {message_sales}")
    
                sleep_time = random.random() * 0.1
                time.sleep(sleep_time)
except KeyboardInterrupt:
    print("Interrupted by user")
    s.close()