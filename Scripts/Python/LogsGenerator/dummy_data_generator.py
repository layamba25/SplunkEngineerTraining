import threading
import random
import time
import socket
from ipaddress import ip_address

from fortigate_log import FortiGateFWLog
from cisco_log import CiscoESTreamerLog, CiscoISELog, CiscoASALog
from palo_log import PaloAltoThreatLog, PaloAltoTrafficLog, PaloAltoSystemLog
from web_log import WebLog, AccessLog

class LogGenerator:
    LOG_TYPES = {
        1: FortiGateFWLog,
        2: CiscoESTreamerLog,
        3: CiscoISELog,
        4: CiscoASALog,
        5: PaloAltoThreatLog,
        6: PaloAltoTrafficLog,
        7: PaloAltoSystemLog,
        8: WebLog,
        9: AccessLog,

    }

    def __init__(self, dstip, dstport, protocol, selected_logs):
        self.dstip = dstip
        self.dstport = dstport
        self.protocol = protocol
        self.selected_logs = selected_logs

    def run_parallel(self):
        threads = []
        for log_type in self.selected_logs:
            log_class = self.LOG_TYPES[log_type]
            log_instance = log_class(self.dstip, self.dstport)
            t = threading.Thread(target=self.display_log, args=(log_instance,))
            threads.append(t)
            t.start()

        for thread in threads:
            thread.join()

    def display_log(self, log_instance):
        sock_type = socket.SOCK_STREAM if self.protocol == 'TCP' else socket.SOCK_DGRAM
        s = socket.socket(socket.AF_INET, sock_type)
        s.connect((self.dstip, int(self.dstport)))
        try:
            while True:
                events_per_second = random.randint(0, 5)
                for _ in range(events_per_second):
                    log_message = log_instance.generate_log()
                    print(log_message) # Optionally print to the console
                    s.sendall(log_message.encode() + b'\n')
                sleep_time = random.random() * 0.1
                time.sleep(sleep_time)
        except KeyboardInterrupt:
            print("\nLog generation stopped.")
        finally:
            s.close()

def is_valid_ip(ip):
    try:
        ip_address(ip)
        return True
    except ValueError:
        return False

def is_valid_port(port):
    try:
        port_num = int(port)
        if 1 <= port_num <= 65535:
            return True
        else:
            return False
    except ValueError:
        return False

def main():
    print("Available log types:")
    available_log_types = LogGenerator.LOG_TYPES.keys()
    for key, value in LogGenerator.LOG_TYPES.items():
        print(f"{key}: {value.__name__}")

    while True:
        try:
            selected_logs_input = input("Enter the log types to generate (comma-separated): ")
            selected_logs = list(map(int, selected_logs_input.split(",")))
            if not all(log_type in available_log_types for log_type in selected_logs):
                raise ValueError("Invalid log type selected.")
            break
        except ValueError as e:
            print(str(e))
            print("Please enter only the log types listed.")

    while True:
        dstip = input("Enter the destination IP: ")
        if is_valid_ip(dstip) or socket.gethostbyname(dstip):
            break
        print("Please enter a valid IP address or a resolvable hostname.")

    while True:
        dstport = input("Enter the destination port: ")
        if is_valid_port(dstport):
            break
        print("Please enter a valid port number between 1 and 65535.")

    while True:
        protocol = input("Enter the protocol (TCP/UDP): ").upper().strip()
        if protocol in ["TCP", "UDP"]:
            break
        print("Please enter a valid protocol (TCP/UDP).")

    generator = LogGenerator(dstip, dstport, protocol, selected_logs)
    generator.run_parallel()

if __name__ == "__main__":
    main()
