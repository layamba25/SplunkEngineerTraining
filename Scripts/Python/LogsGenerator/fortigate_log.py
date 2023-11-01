from faker import Faker

fake = Faker()

class FortiGateFWLog:
    def __init__(self, dstip, dstport):
        self.fake = Faker()
        self.dstip = dstip
        self.dstport = dstport
    
    def generate_log(self):
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
