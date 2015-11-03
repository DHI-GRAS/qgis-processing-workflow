# -*- coding: utf-8 -*-

# Form implementation generated from reading ui file 'C:\Users\rfn\.qgis2\python\plugins\processing_workflow\ui\CollectionDialog5.ui'
#
# Created: Tue Nov 03 13:44:07 2015
#      by: PyQt4 UI code generator 4.10.2
#
# WARNING! All changes made in this file will be lost!

from PyQt4 import QtCore, QtGui

try:
    _fromUtf8 = QtCore.QString.fromUtf8
except AttributeError:
    def _fromUtf8(s):
        return s

try:
    _encoding = QtGui.QApplication.UnicodeUTF8
    def _translate(context, text, disambig):
        return QtGui.QApplication.translate(context, text, disambig, _encoding)
except AttributeError:
    def _translate(context, text, disambig):
        return QtGui.QApplication.translate(context, text, disambig)

class Ui_Dialog(object):
    def setupUi(self, Dialog):
        Dialog.setObjectName(_fromUtf8("Dialog"))
        Dialog.resize(429, 347)
        self.gridLayout_2 = QtGui.QGridLayout(Dialog)
        self.gridLayout_2.setObjectName(_fromUtf8("gridLayout_2"))
        self.gridLayout = QtGui.QGridLayout()
        self.gridLayout.setObjectName(_fromUtf8("gridLayout"))
        self.label_8 = QtGui.QLabel(Dialog)
        self.label_8.setObjectName(_fromUtf8("label_8"))
        self.gridLayout.addWidget(self.label_8, 0, 0, 1, 1)
        self.lineEdit_folder = QtGui.QLineEdit(Dialog)
        self.lineEdit_folder.setEnabled(False)
        self.lineEdit_folder.setPlaceholderText(_fromUtf8(""))
        self.lineEdit_folder.setObjectName(_fromUtf8("lineEdit_folder"))
        self.gridLayout.addWidget(self.lineEdit_folder, 0, 1, 1, 1)
        self.toolButton_folder = QtGui.QToolButton(Dialog)
        self.toolButton_folder.setObjectName(_fromUtf8("toolButton_folder"))
        self.gridLayout.addWidget(self.toolButton_folder, 0, 2, 1, 1)
        self.label_5 = QtGui.QLabel(Dialog)
        self.label_5.setObjectName(_fromUtf8("label_5"))
        self.gridLayout.addWidget(self.label_5, 1, 0, 1, 1)
        self.lineEdit_desc = QtGui.QLineEdit(Dialog)
        self.lineEdit_desc.setPlaceholderText(_fromUtf8(""))
        self.lineEdit_desc.setObjectName(_fromUtf8("lineEdit_desc"))
        self.gridLayout.addWidget(self.lineEdit_desc, 1, 1, 1, 1)
        self.label_6 = QtGui.QLabel(Dialog)
        self.label_6.setObjectName(_fromUtf8("label_6"))
        self.gridLayout.addWidget(self.label_6, 2, 0, 1, 1)
        self.label_7 = QtGui.QLabel(Dialog)
        self.label_7.setEnabled(True)
        self.label_7.setObjectName(_fromUtf8("label_7"))
        self.gridLayout.addWidget(self.label_7, 3, 0, 1, 1)
        self.lineEdit_icon = QtGui.QLineEdit(Dialog)
        self.lineEdit_icon.setEnabled(True)
        self.lineEdit_icon.setPlaceholderText(_fromUtf8(""))
        self.lineEdit_icon.setObjectName(_fromUtf8("lineEdit_icon"))
        self.gridLayout.addWidget(self.lineEdit_icon, 3, 1, 1, 1)
        self.label_4 = QtGui.QLabel(Dialog)
        self.label_4.setObjectName(_fromUtf8("label_4"))
        self.gridLayout.addWidget(self.label_4, 4, 0, 1, 1)
        self.textEdit_about = QtGui.QTextEdit(Dialog)
        self.textEdit_about.setObjectName(_fromUtf8("textEdit_about"))
        self.gridLayout.addWidget(self.textEdit_about, 4, 1, 1, 3)
        self.toolButton_icon = QtGui.QToolButton(Dialog)
        self.toolButton_icon.setObjectName(_fromUtf8("toolButton_icon"))
        self.gridLayout.addWidget(self.toolButton_icon, 3, 2, 1, 1)
        self.lineEdit_name = QtGui.QLineEdit(Dialog)
        self.lineEdit_name.setPlaceholderText(_fromUtf8(""))
        self.lineEdit_name.setObjectName(_fromUtf8("lineEdit_name"))
        self.gridLayout.addWidget(self.lineEdit_name, 2, 1, 1, 1)
        self.gridLayout_2.addLayout(self.gridLayout, 0, 0, 1, 2)
        self.label = QtGui.QLabel(Dialog)
        self.label.setText(_fromUtf8(""))
        self.label.setObjectName(_fromUtf8("label"))
        self.gridLayout_2.addWidget(self.label, 1, 0, 1, 1)
        self.horizontalLayout = QtGui.QHBoxLayout()
        self.horizontalLayout.setObjectName(_fromUtf8("horizontalLayout"))
        self.pushButton_cancel = QtGui.QPushButton(Dialog)
        self.pushButton_cancel.setObjectName(_fromUtf8("pushButton_cancel"))
        self.horizontalLayout.addWidget(self.pushButton_cancel)
        self.pushButton_save = QtGui.QPushButton(Dialog)
        self.pushButton_save.setEnabled(False)
        self.pushButton_save.setObjectName(_fromUtf8("pushButton_save"))
        self.horizontalLayout.addWidget(self.pushButton_save)
        self.gridLayout_2.addLayout(self.horizontalLayout, 1, 1, 1, 1)

        self.retranslateUi(Dialog)
        QtCore.QMetaObject.connectSlotsByName(Dialog)

    def retranslateUi(self, Dialog):
        Dialog.setWindowTitle(_translate("Dialog", "Dialog", None))
        self.label_8.setText(_translate("Dialog", "Folder", None))
        self.toolButton_folder.setText(_translate("Dialog", "...", None))
        self.label_5.setText(_translate("Dialog", "Description", None))
        self.label_6.setText(_translate("Dialog", "Name", None))
        self.label_7.setText(_translate("Dialog", "Icon", None))
        self.label_4.setText(_translate("Dialog", "About collection", None))
        self.toolButton_icon.setText(_translate("Dialog", "...", None))
        self.pushButton_cancel.setText(_translate("Dialog", "Cancel", None))
        self.pushButton_save.setText(_translate("Dialog", "Save", None))

