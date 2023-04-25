# -*- coding: utf-8 -*-
"""
@author: Yutong Xue
"""
import OutputProcess
import matplotlib.pyplot as plt

class OPcaller:
    
    outputProcess = object
    
    def __init__(self):
        self.outputProcess = OutputProcess.OutputProcess()
        
    def plotting(self, frequency, Vpp):
        self.outputProcess.settings(frequency, Vpp)
        return self.outputProcess.getResult()
        # plt.plot(timeList, trace)
        # plt.xlabel('Time (s)')
        # plt.ylabel('Voltage (V)')
        # plt.title('Output of Oscilloscope')
        # plt.show()