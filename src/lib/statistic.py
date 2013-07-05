#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# collect user infomation (Client)
# collect user infomation (Server)
#
import socket
import SocketServer
import logging

default_host = 'bb-testing-oped2012.vm.baidu.com'
default_port = 9090
default_logpath = '/home/work/sunshengxiang/var/go.log'

def client_report(message, ip = default_host, port = default_port):
    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    sock.sendto(message, (ip, port))
    #response = sock.recv(1024)
    #print "Received: %s" % response
    sock.close()

    #client("localhost", 9090, 'hello\tworld')
    
class MyUDPHandler(SocketServer.BaseRequestHandler):
    def handle(self):
        data = self.request[0].strip()
        s = self.request[1]
        print '%s wrote:' % self.client_address[0]
        print data
        FORMAT = '[%(asctime)-15s] %(levelname)s:  %(message)s'
        logging.basicConfig(format=FORMAT, filename = default_logpath, level = logging.INFO)
        logging.info(data)
        #s.sendto(data.upper(), self.client_address)

if __name__ == '__main__':
    HOST, PORT = '0.0.0.0', default_port
    server = SocketServer.UDPServer((HOST, PORT), MyUDPHandler)
    server.serve_forever()
