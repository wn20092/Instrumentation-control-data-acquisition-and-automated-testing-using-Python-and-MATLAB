# -*- coding: utf-8 -*-
"""
@author: Yutong Xue
"""

import ConnectionObj
import numpy as np
import time

class FRProcess:
    connection = object
    
    freqMax = 6
    freqMin = 3
    numberOfDataPoints = 10
    Vpp = 5
    noiseReduce = True
    freqs = []
    VppIN = []
    VppOut = []
    phaseOut = []
    result = []
    
    # initialise with acquired ConnectionOBJ object
    def __init__(self):
        self.connection = ConnectionObj.ConnectionObj()
        
        
    def basicSetting(self):
        self.connection.rtb.reset()

        # rtb.write_str("TIM:ACQT 0.01")  # 10ms Acquisition time
        self.connection.rtb.write_str("CHAN1:STAT ON")  # turn on Channel 1 and 2
        self.connection.rtb.write_str("CHAN2:STAT ON")
        self.connection.rtb.write_str("CHAN3:STAT OFF")  # Switch Channel 1 ON
        self.connection.rtb.write_str("CHAN4:STAT OFF")

        self.connection.rtb.clear_status()
        # -----------------------------------------------------------
        # Obtaining Data
        # ---------------------------- ------------------------------
        self.connection.rtb.write_str("WGENerator:FUNCtion SINusoid")

        self.connection.rtb.write_str("WGENerator:OUTPut:LOAD HIGHz")
        self.connection.rtb.write_str("WGENerator:OUTPut ON")

        #freqMax = 6
        #freqMin = 3
        #numberOfDataPoints = 10
        self.freqs = np.logspace(self.freqMin, self.freqMax, self.numberOfDataPoints)

        #Vpp = 5
        self.connection.rtb.write_str("WGENerator:VOLTage " + str(self.Vpp))
        
    def autoScale(self, channel):
        channel = str(channel)
        self.connection.rtb.write_str('CHAN' + channel + ':OFFset 0')
        time.sleep(0.5)
        self.connection.rtb.write_str('TRIGger:A:SOURce CH' + channel)

        self.connection.rtb.write_str('TRIGger:A:TYPE EDGE')  # Set positive edge trigger
        self.connection.rtb.write_str('TRIGger:A:EDGE:SLOpe POSitive')
        self.connection.rtb.write_str('TRIGger:A:FINDlevel')
        time.sleep(0.5)
        
    def setyscale(self):
        self.autoScale(1)  # autoscale channel 1
        self.autoScale(2)  # autoscale channel 2
        
    def measurevolts(self):  # def to measure average peak to peak voltages
        # Measure Vin
        self.connection.rtb.write("MEASurement1 ON")
        self.connection.rtb.write_str('MEASurement1:SOURce CH1')
        self.connection.rtb.write_str('MEASurement1:MAIN PEAK')
        self.connection.rtb.write_str('MEASurement1:STATistics ON')
        time.sleep(1)
        test = float(self.connection.rtb.query_str('MEASurement1:RESult:AVG?'))
        verticalrange = 1.25 * (test)
        time.sleep(1)
        self.connection.rtb.write_str('CHANnel1:RANGe ' + str(verticalrange))
        time.sleep(1)
        time.sleep(1) # Wait

        Vpin = float(self.connection.rtb.query_str('MEASurement1:RESult:AVG?'))
        time.sleep(2)
        self.VppIN.append(Vpin)
        time.sleep(1)

        # Measure Vout
        self.connection.rtb.write_str('MEASurement2 ON')
        self.connection.rtb.write_str('MEASurement2:SOURce CH2')
        self.connection.rtb.write_str('MEASurement2:MAIN PEAK')
        self.connection.rtb.write_str('MEASurement2:STATistics ON')
        time.sleep(1)
        test2 = float(self.connection.rtb.query_str('MEASurement2:RESult:AVG?'))
        verticalrange2 = 1.25 * (test2)
      
        self.connection.rtb.instrument_status_checking = False
        self.connection.rtb.write_str('CHANnel2:RANGe ' + str(verticalrange2))
        time.sleep(1)
        time.sleep(1)
        Vpout = float(self.connection.rtb.query_str('MEASurement2:RESult:AVG?'))
        time.sleep(2)
        self.VppOut.append(Vpout)
        time.sleep(1)
        
        # Measure phase
        self.connection.rtb.write_str('MEASurement3 ON')
        self.connection.rtb.write_str('MEASurement3:SOURce CH2,CH1')
        self.connection.rtb.write_str('MEASurement3:MAIN PHASe')
        time.sleep(2)
        phase = float(self.connection.rtb.query_str('MEASurement3:RESult:AVG?'))
        time.sleep(2)
        self.phaseOut.append(phase)
        time.sleep(1)
        
    def recordValues(self):
        # Iterate through every frequency and record values for each frequency
        for i in range(len(self.freqs)):
            self.connection.rtb.write_str("WGENerator:FREQuency " + str(self.freqs[i]))
            time.sleep(3)
            self.connection.rtb.write_str("AUToscale")
            time.sleep(4)
            self.setyscale()

            timespan1 = (1 / (self.freqs[i])) * 3
            self.connection.rtb.write_str('TIMebase:SCALe ' + str(timespan1 / 12))  # Set timescale
            time.sleep(2)
            self.measurevolts()

        self.connection.rtb.close()
        
    def getResult(self):
        self.basicSetting()
        self.recordValues()
        for i in range(len(self.VppOut)):
            self.result.append(self.VppOut[i] / self.VppIN[i])
        
        return self.freqs, self.phaseOut, self.result