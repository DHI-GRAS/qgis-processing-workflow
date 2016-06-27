"""
***************************************************************************
   WorkflowUtils.py
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

import os
from PyQt4 import QtGui
from processing.core.ProcessingConfig import ProcessingConfig
from processing.tools.system import mkdir

class WorkflowUtils:

    WORKFLOW_FOLDER = "WORKFLOW_FOLDER"
    workflowCollectionNames = []

    @staticmethod
    def workflowPath():
        folder = ProcessingConfig.getSetting(WorkflowUtils.WORKFLOW_FOLDER)
        if folder is None or not os.path.isdir(folder):
            folder = os.path.expanduser(
                    os.path.join('~', '.qgis2', 'processing', 'workflows'))
        mkdir(folder)

        return folder

    @staticmethod
    def workflowIcon():
        return  QtGui.QIcon(os.path.join(os.path.dirname(__file__), "images","icon.png"))

    @staticmethod
    def addWorkflowCollectionName(collectionName):
        WorkflowUtils.workflowCollectionNames.append(collectionName)


    @staticmethod
    def checkIfCollectionName(name):
        for collectionName in WorkflowUtils.workflowCollectionNames:
            if name == collectionName:
                return True
        return False


