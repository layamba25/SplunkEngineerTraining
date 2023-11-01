# Load the .NET TCPListener class
Add-Type -TypeDefinition @"
    using System;
    using System.Net;
    using System.Net.Sockets;
    using System.Text;
    
    public class TcpServer {
        private TcpListener _listener;
        public TcpServer(int port) {
            _listener = new TcpListener(IPAddress.Any, port);
        }
        public void Start() {
            _listener.Start();
            Console.WriteLine("Listener started on " + _listener.LocalEndpoint);
            while(true) {
                var client = _listener.AcceptTcpClient();
                Console.WriteLine("Accepted connection from " + ((IPEndPoint)client.Client.RemoteEndPoint).Address);
                var buffer = new byte[1024];
                var stream = client.GetStream();
                while(client.Connected) {
                    if(stream.DataAvailable) {
                        var length = stream.Read(buffer, 0, buffer.Length);
                        var message = Encoding.ASCII.GetString(buffer, 0, length);
                        Console.WriteLine("Received: " + message);
                    }
                }
                client.Close();
            }
        }
    }
"@

# Create an instance of the listener and start it
$server = New-Object TcpServer -ArgumentList 514
$server.Start()
