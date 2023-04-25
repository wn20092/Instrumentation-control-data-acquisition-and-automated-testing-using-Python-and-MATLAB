# -*- coding: utf-8 -*-
"""
@author: Yutong Xue
"""

import FRProcess
import matplotlib.pyplot as plt
import numpy as np

class Caller:

    freqsResponse = object
    freqs = []
    result = []
    phaseOut = []
    result_dB = []

    def __init__(self):
        self.freqsResponse = FRProcess.FRProcess()

    def setParam(self, maxFreq, minFreq, numberOfDataPoints, voltage, noiseReduce):
        self.freqsResponse.freqMax = maxFreq
        self.freqsResponse.freqMin = minFreq
        self.freqsResponse.numberOfDataPoints = numberOfDataPoints
        self.freqsResponse.Vpp = voltage
        self.freqsResponse.noiseReduce = noiseReduce

    def getResultFromRohde(self):
        self.freqs, self.phaseOut, self.result = self.freqsResponse.getResult()
        self.result_dB = 20*np.log10(self.result)
        return self.freqs, self.phaseOut, self.result, self.result_dB

