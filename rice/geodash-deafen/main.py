#!/usr/bin/env python3
from socket import *
import os

server = socket(AF_INET, SOCK_STREAM)
server.setsockopt(SOL_SOCKET, SO_REUSEADDR, 1)
server.bind(("0.0.0.0", 44555))
server.listen(5)

while True:
    client, _ = server.accept()
    with client:
        data = client.recv(1024).decode().strip()
        print(data)
        if data == "DEAFEN":
            os.system("equibop --toggle-deafen")
