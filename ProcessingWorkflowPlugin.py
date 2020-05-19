"""
***************************************************************************
   ProcessingWorkflowPlugin.py
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

from builtins import object
import os
import sys
import inspect
from qgis.core import QgsApplication
from processing_workflow.WorkflowProvider import WorkflowProvider
from processing_workflow.WorkflowAlgListListener import WorkflowAlgListListener
from processing_workflow.WorkflowOnlyAlgorithmProvider import WorkflowOnlyAlgorithmProvider


cmd_folder = os.path.split(inspect.getfile(inspect.currentframe()))[0]
if cmd_folder not in sys.path:
    sys.path.insert(0, cmd_folder)


class ProcessingWorkflowPlugin(object):

    def __init__(self, iface):
        self.provider = WorkflowProvider()
        self.workflowOnlyAlgorithmProvider = WorkflowOnlyAlgorithmProvider()
        # Save reference to the QGIS interface
        self.iface = iface

    def initGui(self):
        self.algListener = WorkflowAlgListListener(self.provider,
                                                   self.workflowOnlyAlgorithmProvider)
        QgsApplication.processingRegistry().providerAdded.connect(
                self.algListener.algsListHasChanged)
        QgsApplication.processingRegistry().providerRemoved.connect(
                self.algListener.algsListHasChanged)
        QgsApplication.processingRegistry().addProvider(self.provider)
        QgsApplication.processingRegistry().addProvider(self.workflowOnlyAlgorithmProvider)

    def unload(self):
        QgsApplication.processingRegistry().providerAdded.disconnect(
                self.algListener.algsListHasChanged)
        QgsApplication.processingRegistry().providerRemoved.disconnect(
                self.algListener.algsListHasChanged)

        QgsApplication.processingRegistry().removeProvider(self.provider)
        QgsApplication.processingRegistry().removeProvider(self.workflowOnlyAlgorithmProvider)
