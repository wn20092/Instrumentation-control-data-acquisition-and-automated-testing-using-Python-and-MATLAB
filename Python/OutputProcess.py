# -*- coding: utf-8 -*-
"""
@author: Yutong Xue
"""
import ConnectionObj
import time
import numpy as np

class OutputProcess:
    
    connection = object
    timeList = []
    trace = []
    Vpp = 5
    frequency = 1000
    
    
    def __init__(self):
        self.connection = ConnectionObj.ConnectionObj()
        
    def basicSetting(self):
        self.connection.rtb.clear_status()
        self.connection.rtb.reset()

        # -----------------------------------------------------------
        # Basic Settings:
        # ---------------------------- -------------------------------
        self.connection.rtb.write_str("TIM:ACQT 0.01")  # 10ms Acquisition time
        range1 = 5
        self.connection.rtb.write_str("CHAN1:RANG " + str(range1))  # Horizontal range 5V (0.5V/div)
        self.connection.rtb.write_str("CHAN1:OFFS 0.0")  # Offset 0
        self.connection.rtb.write_str("CHAN1:STAT ON")  # Switch Channel 1 ONå
        
    def triggerSetting(self):
        self.connection.rtb.write_str("TRIG:A:MODE AUTO")  # Trigger Auto mode in case of no signal is applied
        self.connection.rtb.write_str("TRIG:A:TYPE EDGE;:TRIG:A:EDGE:SLOP POS")  # Trigger type Edge Positive
        self.connection.rtb.write_str("TRIG:A:SOUR CH1")  # Trigger source CH1
        self.connection.rtb.write_str("TRIG:A:LEV1 0.05")  # Trigger level 0.05V
        self.connection.rtb.query_opc()  # Using *OPC? query waits until all the instrument settings are finished

        self.connection.rtb.write_str("WGENerator:FUNCtion SINusoid")
        self.connection.rtb.write_str("WGENerator:FREQuency " + str(self.frequency))
        
        self.connection.rtb.write_str("WGENerator:VOLTage " + str(self.Vpp))
        self.connection.rtb.write_str("WGENerator:OUTPut:LOAD HIGHz")
        self.connection.rtb.write_str("WGENerator:OUTPut ON")

        self.connection.rtb.write_str("AUToscale")
        time.sleep(3)
################
        self.connection.rtb.write("MEASurement1 ON")
        self.connection.rtb.write_str('MEASurement1:SOURce CH1')  # Measure channel 1 for input
        self.connection.rtb.write_str('MEASurement1:MAIN PEAK')  # Set to measure peak voltage
        self.connection.rtb.write_str('MEASurement1:STATistics ON')
        
        test = float(self.connection.rtb.query_str('MEASurement1:RESult:AVG?'))
        verticalrange = 1.25 * (test)
        self.connection.rtb.instrument_status_checking = False
        self.connection.rtb.write_str('CHANnel1:RANGe ' + str(verticalrange))
        self.connection.rtb.write_str('MEASurement1 OFF')

###################
        timespan1 = (1 / self.frequency) * 3
        self.connection.rtb.write_str('TIMebase:SCALe ' + str(timespan1/12))
        self.connection.rtb.visa_timeout = 2000  # Acquisition timeout - set it higher than the acquisition time
        self.connection.rtb.write_str("SING")
        self.connection.rtb.query_opc()  # Using *OPC? query waits until the instrument finished the Acquisition
        self.connection.rtb.process_all_commands()
        
    def fetchWaveform(self):
        # Fetching the waveform in ASCII 

        self.trace = self.connection.rtb.query_bin_or_ascii_float_list('FORM ASC;:CHAN1:DATA?')  # Query ascii array of floats
        xinc = float(self.connection.rtb.query_str("CHANnel1:DATA:XINCrement?"))
        xorg = float(self.connection.rtb.query_str("CHANnel1:DATA:XORigin?"))

        self.timeList = np.arange(xorg,xinc*(len(self.trace))+xorg,xinc) 
        # -----------------------------------------------------------
        # Making an instrument screenshot and transferring the file to the PC
        # -----------------------------------------------------------
        self.connection.rtb.write_str("MMEM:CDIR '/INT/'")  # Change the directory
        self.connection.rtb.instrument_status_checking = False  # Ignore errors generated by the MMEM:DEL command,
        self.connection.rtb.write_str("MMEM:DEL 'Dev_Screenshot.png'")  # Delete the file if it already exists

        self.connection.rtb.clear_status()
        self.connection.rtb.instrument_status_checking = True  # Error checking back ON
        self.connection.rtb.write_str("HCOP:LANG PNG;:MMEM:NAME 'Dev_Screenshot'")  # Hardcopy settings for taking a screenshot - notice no file extension here
        self.connection.rtb.write_str("HCOP:IMM")  # Make the screenshot now
        self.connection.rtb.read_file_from_instrument_to_pc(r'Dev_Screenshot.png', r'./Screenshot.png')

        print(r"Screenshot file saved to PC 'Screenshot.png'")
        
    def settings(self, frequency, Vpp):
        self.Vpp = Vpp
        self.frequency = frequency
        
        
    def getResult(self):
        self.basicSetting()
        self.triggerSetting()
        self.fetchWaveform()
        self.connection.rtb.close()
        return self.timeList, self.trace