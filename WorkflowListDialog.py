# -*- coding: utf-8 -*-

"""
***************************************************************************
   WorkflowListDialog.py
-------------------------------------
    Copyright (C) 2014 TIGER-NET (www.tiger-net.org)

***************************************************************************
* This plugin is part of the Water Observation Information System (WOIS)  *
* developed under the TIGER-NET project funded by the European Space      *
* Agency as part of the long-term TIGER initiative aiming at promoting    *
* the use of Earth Observation (EO) for improved Integrated Water         *
* Resources Management (IWRM) in Africa.                                  *
*                                                                         *
* WOIS is a free software i.e. you can redistribute it and/or modify      *
* it under the terms of the GNU General Public License as published       *
* by the Free Software Foundation, either version 3 of the License,       *
* or (at your option) any later version.                                  *
*                                                                         *
* WOIS is distributed in the hope that it will be useful, but WITHOUT ANY *
* WARRANTY; without even the implied warranty of MERCHANTABILITY or       *
* FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License   *
* for more details.                                                       *
*                                                                         *
* You should have received a copy of the GNU General Public License along *
* with this program.  If not, see <http://www.gnu.org/licenses/>.         *
***************************************************************************
"""

from builtins import str
from qgis.PyQt.QtWidgets import (QDialog, QTabWidget, QVBoxLayout, QGridLayout,
                                 QLineEdit, QTreeWidget, QScrollArea, QWidget, QLabel, QSizePolicy,
                                 QFrame, QTreeWidgetItem, QDialogButtonBox, QPushButton)
from qgis.PyQt.QtGui import QCursor
from qgis.PyQt import QtCore
from qgis.core import QgsApplication
from processing.gui.MessageDialog import MessageDialog
from processing.gui.Postprocessing import handleAlgorithmResults
from processing.gui.AlgorithmExecutor import execute
from processing.gui.MessageBarProgress import MessageBarProgress
from processing.tools import dataobjects

try:
    _fromUtf8 = QtCore.QString.fromUtf8
except AttributeError:
    def _fromUtf8(s):
        return s


# Dialog for listing the existing workflows
class WorkflowListDialog(QDialog):
    def __init__(self, workflowProvider):
        QDialog.__init__(self)
        self.workflowProvider = workflowProvider
        self.setupUi()
        self.setWindowFlags(self.windowFlags() | QtCore.Qt.WindowSystemMenuHint |
                            QtCore.Qt.WindowMinMaxButtonsHint)

        # set as window modal
        self.setWindowModality(1)

    def setupUi(self):
        self.resize(400, 500)
        self.setWindowTitle(self.workflowProvider.longName())
        self.setWindowIcon(self.workflowProvider.icon())
        self.tabWidget = QTabWidget()
        self.tabWidget.setMinimumWidth(300)

        # workflow tree
        # ==================================
        self.verticalLayout = QVBoxLayout()
        self.verticalLayout.setSpacing(2)
        self.verticalLayout.setMargin(0)
        self.searchBox = QLineEdit()
        self.searchBox.textChanged.connect(self.fillAlgorithmTree)
        self.verticalLayout.addWidget(self.searchBox)
        self.algorithmTree = QTreeWidget()
        self.algorithmTree.setHeaderHidden(True)
        self.fillAlgorithmTree()
        self.verticalLayout.addWidget(self.algorithmTree)
        self.algorithmTree.doubleClicked.connect(self.runWorkflow)

        self.algorithmsTab = QWidget()
        self.algorithmsTab.setLayout(self.verticalLayout)
        self.tabWidget.addTab(self.algorithmsTab, "Workflows")

        # About tab
        ###################
        self.aboutTab = QWidget()
        self.gridLayout = QGridLayout(self.aboutTab)
        self.gridLayout.setObjectName(_fromUtf8("gridLayout"))
        self.scrollArea = QScrollArea(self.aboutTab)
        self.scrollArea.setWidgetResizable(True)
        self.scrollArea.setObjectName(_fromUtf8("scrollArea"))
        self.scrollAreaWidgetContents = QWidget()
        self.scrollAreaWidgetContents.setGeometry(QtCore.QRect(0, 0, 535, 271))
        self.scrollAreaWidgetContents.setObjectName(_fromUtf8("scrollAreaWidgetContents"))
        self.scrollAreaWidgetContents.setStyleSheet("QWidget { background-color : white}")
        self.aboutVerticalLayout = QVBoxLayout(self.scrollAreaWidgetContents)
        self.aboutVerticalLayout.setObjectName(_fromUtf8("aboutVerticalLayout"))
        self.aboutLabel = QLabel(self.scrollAreaWidgetContents)
        sizePolicy = QSizePolicy(QSizePolicy.Preferred, QSizePolicy.Preferred)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.aboutLabel.sizePolicy().hasHeightForWidth())
        self.aboutLabel.setSizePolicy(sizePolicy)
        self.aboutLabel.setMinimumSize(QtCore.QSize(10, 10))
        self.aboutLabel.setCursor(QCursor(QtCore.Qt.ArrowCursor))
        self.aboutLabel.setFocusPolicy(QtCore.Qt.NoFocus)
        self.aboutLabel.setFrameShape(QFrame.NoFrame)
        self.aboutLabel.setTextFormat(QtCore.Qt.AutoText)
        self.aboutLabel.setScaledContents(False)
        self.aboutLabel.setAlignment(QtCore.Qt.AlignLeading|QtCore.Qt.AlignLeft|QtCore.Qt.AlignTop)
        self.aboutLabel.setWordWrap(True)
        self.aboutLabel.setOpenExternalLinks(True)
        self.aboutLabel.setTextInteractionFlags(QtCore.Qt.LinksAccessibleByMouse)
        self.aboutLabel.setObjectName(_fromUtf8("aboutLabel"))
        self.aboutVerticalLayout.addWidget(self.aboutLabel)
        self.scrollArea.setWidget(self.scrollAreaWidgetContents)
        self.gridLayout.addWidget(self.scrollArea, 1, 1, 1, 1)

        self.tabWidget.addTab(self.aboutTab, "About")

        # And the whole layout
        # ==========================

        self.buttonBox = QDialogButtonBox()
        self.buttonBox.setOrientation(QtCore.Qt.Horizontal)
        self.closeButton = QPushButton()
        self.closeButton.setText("Close")
        self.buttonBox.addButton(self.closeButton, QDialogButtonBox.ActionRole)
        #QtCore.QObject.connect(self.closeButton, QtCore.SIGNAL("clicked()"), self.closeWindow)
        self.closeButton.clicked.connect(self.closeWindow)

        self.globalLayout = QVBoxLayout()
        self.globalLayout.setSpacing(2)
        self.globalLayout.setMargin(0)
        self.globalLayout.addWidget(self.tabWidget)
        self.globalLayout.addWidget(self.buttonBox)
        self.setLayout(self.globalLayout)
        QtCore.QMetaObject.connectSlotsByName(self)

        self.retranslateUi()

    def retranslateUi(self):
        if self.workflowProvider.aboutHTML:
            self.aboutLabel.setText(self.tr(self.workflowProvider.aboutHTML))
        else:
            self.aboutLabel.setText(self.tr("<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.0//EN\" \"http://www.w3.org/TR/REC-html40/strict.dtd\">\n"
    "<html><head><meta name=\"qrichtext\" content=\"1\" /><style type=\"text/css\">\n"
    "p, li { white-space: pre-wrap; }\n"
    "</style></head><body style=\" font-family:\'MS Shell Dlg 2\'; font-size:8pt; font-weight:400; font-style:normal;\">\n"
    "<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\"><span style=\" font-family:\'Sans Serif\'; font-size:9pt;\">Processing Workflow Library</span></p>\n"
    "<p style=\"-qt-paragraph-type:empty; margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; font-family:\'Sans Serif\'; font-size:9pt;\"><br /></p>\n"
    "<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\"><span style=\" font-family:\'Sans Serif\'; font-size:9pt;\">This plugin was developed as part of the Water Observation Information System (WOIS) under the TIGER-NET project funded by the European Space Agency as part of the long-term TIGER initiative aiming at promoting the use of Earth Observation (EO) for improved Integrated Water Resources Management (IWRM) in Africa.</p>\n"
    "<p style=\"-qt-paragraph-type:empty; margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; font-family:\'Sans Serif\'; font-size:9pt;\"><br /></p>\n"
    "<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\"><span style=\" font-family:\'Sans Serif\'; font-size:9pt;\">WOIS is  a free software i.e. you can redistribute it and/or modify it under the terms of the GNU General Public License as  published by the Free Software Foundation, either version 3 of the  License, or (at your option) any later version.</span></p>\n"
    "<p style=\"-qt-paragraph-type:empty; margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; font-family:\'Sans Serif\'; font-size:9pt;\"><br /></p>\n"
    "<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\"><span style=\" font-family:\'Sans Serif\'; font-size:9pt;\">This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.</span></p>\n"
    "<p style=\"-qt-paragraph-type:empty; margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; font-family:\'Sans Serif\'; font-size:9pt;\"><br /></p>\n"
    "<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\"><span style=\" font-family:\'Sans Serif\'; font-size:9pt;\">You should have received a copy of the GNU General Public License along with this program.  If not, see http://www.gnu.org/licenses/.</span></p>\n"
    "<p style=\"-qt-paragraph-type:empty; margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; font-family:\'Sans Serif\'; font-size:9pt;\"><br /></p>\n"
    "<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\"><span style=\" font-family:\'Sans Serif\'; font-size:9pt;\">Copyright (C) 2014 TIGER-NET (<a href=\"www.tiger-net.org\">www.tiger-net.org</a>)</span></p>\n"
    "<p style=\"-qt-paragraph-type:empty; margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; font-family:\'Sans Serif\'; font-size:9pt;\"><br /></p>\n"))

    def closeWindow(self):
        self.close()

    # Execute the workflow, based on ProcessingToolbox.executeAlgorithm
    def runWorkflow(self):
        item = self.algorithmTree.currentItem()
        if isinstance(item, TreeAlgorithmItem):
            alg = item.alg.create()
        else:
            alg = None
        if alg is not None:
            ok, message = alg.canExecute()
            if not ok:
                dlg = MessageDialog()
                dlg.setTitle(self.tr('Error executing algorithm'))
                dlg.setMessage(
                    self.tr('<h3>This algorithm cannot '
                            'be run :-( </h3>\n{0}').format(message))
                dlg.exec_()
                return
                       
            feedback = MessageBarProgress(algname=alg.displayName())
            context = dataobjects.createContext(feedback)
            parameters = {}
            ret, results = execute(alg, parameters, context, feedback)
            handleAlgorithmResults(alg, context, feedback)
            feedback.close()

    # List all the available workflows
    def fillAlgorithmTree(self):
        self.algorithmTree.clear()
        text = str(self.searchBox.text())
        providerId = self.workflowProvider.id()
        algs = QgsApplication.processingRegistry().providerById(providerId).algorithms()
        groups = {}
        # add algorithms
        for alg in algs:
            if text == "" or text.lower() in alg.name.lower():
                if alg.group() in groups:
                    groupItem = groups[alg.group()]
                else:
                    groupItem = QTreeWidgetItem()
                    groupItem.setText(0, alg.group())
                    groups[alg.group()] = groupItem
                algItem = TreeAlgorithmItem(alg)
                groupItem.addChild(algItem)

        if len(groups) > 0:
            providerItem = QTreeWidgetItem()
            providerItem.setText(0, self.workflowProvider.longName())
            providerItem.setIcon(0, self.workflowProvider.icon())
            for groupItem in list(groups.values()):
                providerItem.addChild(groupItem)
            self.algorithmTree.addTopLevelItem(providerItem)
            providerItem.setExpanded(True)
            for groupItem in list(groups.values()):
                if text != "":
                    groupItem.setExpanded(True)

        self.algorithmTree.sortItems(0, QtCore.Qt.AscendingOrder)

    def tr(self, string, context=''):
        if context == '':
            context = self.__class__.__name__
        return QtCore.QCoreApplication.translate(context, string)


class TreeAlgorithmItem(QTreeWidgetItem):

    def __init__(self, alg):
        QTreeWidgetItem.__init__(self)
        self.alg = alg
        self.setText(0, alg.name())
        self.setIcon(0, alg.icon())
