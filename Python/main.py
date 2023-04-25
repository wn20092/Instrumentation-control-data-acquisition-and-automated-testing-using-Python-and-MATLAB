# -*- coding: utf-8 -*-
"""
@author: Yutong Xue
"""

import sys
from PyQt5.QtWidgets import QApplication, QMainWindow
from mainWindow import Ui_MainWindow


if __name__ == "__main__":
    App = QApplication(sys.argv)    # Create the QApplication object as the main GUI application entry point
    aw = Ui_MainWindow()
    w = QMainWindow()
    aw.setupUi(w)
    w.show()               # Show main form
    sys.exit(App.exec_())
