#!/usr/bin/env python
# -*- coding: utf_8 -*-
"""
 Modbus乐联网透传 for python
 auther gyangbo@gmail.com
 This is distributed under GNU LGPL license, see license.txt
"""
import sys
import serial
import socket
import time
from random import *

leweiModbusServer = "modbus.lewei50.com"
leweiModbusPort = 9970

gatewayNo = '24'#gateway No. in lewei50
userKey = 'your_userkey_in_lewei50'

ser=None
#serial_port="/dev/ttyUSB0"
serial_port=0#serial_port = 8  means serial id 9 in windows
serial_timeout=1
serial_baud = 9600


def run(svr_status):
    global ser,serial_timeout,serial_port,serial_baud
    
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server_address = (leweiModbusServer, leweiModbusPort)
    print >>sys.stderr, 'connecting to %s port %s' % server_address
    #print serial_port
    try:
        try:
            try:
                if ser is None:
                    ser=serial.Serial(port=serial_port, baudrate=serial_baud, bytesize=8, parity="N", stopbits=1, xonxoff=0)
                    #ser.setTimeout(serial_timeout)
            except:
                print "fail to connect serial"
                ser.close()
                ser=None
            # Send data
            sock.connect(server_address)
            message = userKey+"_"+gatewayNo
            print >>sys.stderr, 'sending "%s"' % message
            sock.sendall(message)


            while 1:
                data = sock.recv(1024)
                print >>sys.stderr, 'received "%s"' % data
                '''try to send to serial'''
                try:
                    ser.write(data)
                    #wait 1 second to get feed back from serial
                    time.sleep(1)
                    
                    '''read from serial'''
                    n = ser.inWaiting()
                    print(n)
                    if(n>4):
                        serialData = ser.read(n)
                        sock.sendall(serialData)
                        
                except:
                    print "error write to serial"
                if data == "":
                    sock.close()
                    print "connection break!wait a while to reconnect"
                    time.sleep(10 + randint(1, 60))
                    run(0)
                    break

        finally:
            print >>sys.stderr, 'closing socket'
            sock.close()
    except:
        print "fail"
        
    
    

if __name__ == "__main__":
    run(0)
    
