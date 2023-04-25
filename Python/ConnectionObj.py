# -*- coding: utf-8 -*-
"""
@author: Yutong Xue
"""

from RsInstrument import *  # The RsInstrument package is hosted on pypi.org, see Readme.txt for more details


'''
    returns rtb connection object with basic settings
'''
class ConnectionObj:
    
    # here, rtb object has been declared as private
    rtb = object
    
    def __init__(self):
        try:
            # Adjust the VISA Resource string to fit your instrument
            self.rtb = RsInstrument('TCPIP0::192.168.1.2::inst0::INSTR', True, False)
            self.rtb.visa_timeout = 3000  # Timeout for VISA Read Operations
            self.rtb.opc_timeout = 15000  # Timeout for opc-synchronised operations
            self.rtb.instrument_status_checking = True  # Error check after each command
        except Exception as ex:
            print('Error initializing the instrument session:\n' + ex.args[0])
            exit()

        print(f'RTB2000 IDN: {self.rtb.idn_string}')
