# -*- coding: utf-8 -*-
"""
@author: Yutong Xue
"""
import sys
from PyQt5.QtWidgets import QDialog, QApplication, QPushButton, QVBoxLayout, QLineEdit, QComboBox, QWidget

from PyQt5.QtCore import Qt, QTimer

from matplotlib.backends.backend_qt5agg import FigureCanvasQTAgg as FigureCanvas
from matplotlib.backends.backend_qt5agg import NavigationToolbar2QT as NavigationToolbar
import matplotlib.pyplot as plt


import random

import OPcaller

class OPGui:
    window = object


    # inner class main window which inherits QDialog
    class Window(QDialog, QWidget):

        OPcaller = object
        timeList = []
        trace = []
        frequency = 1000
        Vpp = 5
        mode = 0

        # constructor
        def __init__(self, parent=None):
            super(OPGui.Window,self).__init__(parent)

            # change connect ways with scroll down box selections
            # self.readObj = ReadRawData.ReadRawData()
            # self.readObj.connect()

            e1 = QLineEdit()
            e1.setPlaceholderText("Frequency (Hz)")
            e1.setAlignment(Qt.AlignCenter)
            e1.editingFinished.connect(self.frequencyChange)
            
            e2 = QLineEdit()
            e2.setPlaceholderText("Vpp (V)")
            e2.setAlignment(Qt.AlignCenter)
            e2.editingFinished.connect(self.voltageChange)

            self.setWindowTitle("GUI")

            # a figure instance to plot on
            self.figure = plt.figure()

            # this is the Canvas Widget that
            # displays the 'figure'it takes the
            # 'figure' instance as a parameter to __init__
            self.canvas = FigureCanvas(self.figure)

            # this is the Navigation widget as navigation bar at the top of the window
            # it takes the Canvas widget and a parent
            self.toolbar = NavigationToolbar(self.canvas, self)

            self.queryButton = QPushButton('Acquire')
            self.queryButton.clicked.connect(self.queryButtonClick)
            
            self.instructionMode = QComboBox(self)
            self.instructionMode.addItems(['Noise Reduce ON', 'Noise Reduce Off'])
            self.instructionMode.currentIndexChanged.connect(self.instructionModeChanged)

            # creating a Vertical Box layout
            layout = QVBoxLayout()

            # adding tool bar to the layout
            layout.addWidget(self.toolbar)

            # adding canvas to the layout
            layout.addWidget(self.canvas)

            # adding text box to the layout
            layout.addWidget(e1)
            layout.addWidget(e2)

            layout.addWidget(self.instructionMode)
            layout.addWidget(self.queryButton)

            # setting layout to the main window
            self.setLayout(layout)

        def queryButtonClick(self):
            self.OPcaller = OPcaller.OPcaller()
            self.updatePlot()
            self.show()

        def updatePlot(self):
            # Drop off the first y element, append a new one.
            self.timeList, self.trace = self.queryData()

            self.figure.clear()
            ax = self.figure.add_subplot()

            self.axLabel(ax)

            # plot data
            ax.plot(self.timeList, self.trace, 'r')

            # refresh canvas
            self.canvas.draw()
        
        def axLabel(self, ax):
            ax.set_title('Output of Oscilloscope')
            ax.set_xlabel('Time (s)')
            ax.set_ylabel('Voltage (V)')

        def frequencyChange(self):
            self.frequency = int(self.sender().text())
            
        def voltageChange(self):
            self.Vpp = int(self.sender().text())
            
        def instructionModeChanged(self):
            self.mode = int(self.sender().text())

        def queryData(self):
            return self.OPcaller.plotting(self.frequency, self.Vpp)
        
            

