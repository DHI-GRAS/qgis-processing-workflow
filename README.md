Processing-Workflow
===================

Plugin for QGIS Processing Toolbox for creating processing workflows. The workflows provide step-by-step instructions and guidance for less experienced users thus facilitating capacity building in Earth observation data analysis and GIS tasks.

After installing and activating the plugin, it also needs to be activated in Processing options which are accessible from QGIS main menu (Processing > Options...). The path to the directory where the workflow files are stored (by default in the processing folder in user's QGIS directory) can also be set:

![](https://github.com/TIGER-NET/screenshots/blob/master/Processing-Workflow/activate.png)

After the activation the workflow library can be accessed through the Processing Toolbox and also from an icon on the QGIS task bar (if that option was selected):

![](https://github.com/TIGER-NET/screenshots/blob/master/Processing-Workflow/location.png)

A workflow consists of a number of steps, with each step having an instruction pane on the left and the algorithm window on the right. After a step execution is started (by pressing the Run button) and completed, the next step will automatically open. It is also possible to skip steps without execution and go back to previous steps by using the buttons at the bottom of the workflow dialog:

![](https://github.com/TIGER-NET/screenshots/blob/master/Processing-Workflow/workflow.png)

New workflows can be easily added by using the Workflow Creator which can be accessed from the Processing Toolbox (Workflows > Tools > Create new workflow). Existing workflows can also be edited by right clicking on them and selecting Edit workflow: 

![](https://github.com/TIGER-NET/screenshots/blob/master/Processing-Workflow/edit.png)

In the Workflow Creator new algorithms can be added to a workflow by double clicking on any algorithm in the list on the left. All algorithms available in the Processing Toolbox, including models and scripts, can be added to a workflow. To remove an algorithm from a workflow the *Remove step* button at the bottom of the dialog should be used. The order of the algorithms can be changed by dragging the tabs with algorithm names at the top of the dialog. Basic styling of the instructions can be performed using the styling toolbar located above the instruction pane and Markdown syntax, or HTML can be pasted into the pane for more advanced styling.

![](https://github.com/TIGER-NET/screenshots/blob/master/Processing-Workflow/creator.png)

An instruction step can be added to the workflow using the "Workflow instructions" algorithm found under "Workflow-only tools". An instruction step is basically an instruction pane stretched to cover the whole of the workflow step dialog, thus allowing more elaborate presentation of information. Similarly to normal step instructions, the text can be styled using the styling toolbar, Markdown syntax or HTML can be pasted in. In case of the latter, images can be included in the text using the HTML ``` <img src=" "> ``` tag with path of the image being relative to the location of the workflow file.

![](https://github.com/TIGER-NET/screenshots/blob/master/Processing-Workflow/instruction_step.png)

To save a workflow its name and group should be entered at the top of the dialog and the save button clicked. Workflows are saved in a text file which contains information on the number and order of steps, the instructions for each step and any pre-set values of numeric, text, drop-down list or boolean algorithm parameters. The workflows can also be tested before saving by using the Test button.

Workflows can be grouped into collections. A collection consists of a number of workflows, with an own icon on the taskbar and in Processing Toolbox, own grouping in the Processing Toolbox, own workflow library and own CSS styling. Each collection can be individually activated and deactivated (and the taskbar icon can be shown or hidden) from Processing Options under the Provider > Processing Workflows section. 

![](https://github.com/TIGER-NET/screenshots/blob/master/Processing-Workflow/collection.png)

In the file system a collection consists of a folder containing the workflow files and a collection.conf file. The collection.conf file contains a short and a long name of the collection, as well as a longer text describing the collection which is shown in the About tab of the collection library dialog. It also contains the paths to the icon image and CSS style files (those files are automatically copied into the collection directory if initially they are outside). The collection.conf file can be created using "Create new collection" functionality located in the Processing Toolbox under Processing Workflows > Tools. If a folder containing an existing collection.conf file is selected, that file will be loaded and can be edited.  

![](https://github.com/TIGER-NET/screenshots/blob/master/Processing-Workflow/new_collection.png)

This plugin is part of the Water Observation Information System (WOIS) developed under the TIGER-NET project and GlobWetland Toolbox developed under the GlobWetland Agrica project. Both projects were funded by the European Space Agency as part of a long-term initiative aiming at promoting the use of Earth Observation (EO) for improved Integrated Water Resources Management (IWRM) and environemntal monitoring and reporting in Africa. 

The plugin contains Python markdown package. See https://github.com/Python-Markdown/markdown for license and details.

Copyright (C) 2014-2018 DHI GRAS (www.dhi-gras.com)
