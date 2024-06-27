#!/usr/bin/env python3

import sys, signal, os
import PyQt6.QtWidgets as QtWidgets
import PyQt6.QtCore as QtCore
from Window1 import MainWindow1

def main(args):
    os.environ["QT_LOGGING_RULES"]="*.debug=false;qt.qpa.*=false"
    qtApp = QtWidgets.QApplication(args)
    signal.signal(signal.SIGINT,signal.SIG_DFL)
    mainWin1 = MainWindow1()
    mainWin1.show()
    return qtApp.exec()


if __name__ == '__main__':
    sys.exit(main(sys.argv) or 0)
