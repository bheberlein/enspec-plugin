from pathlib import Path

from qgis.PyQt.QtCore import Qt
from qgis.PyQt.QtGui import QIcon
from qgis.PyQt.QtWidgets import (
    QAction,
    QToolBar
)


""" Core classes for EnSpec QGIS plugin. """


# : ----------------- PLUGIN ----------------- :

class EnSpecPlugin:

    _name = 'EnSpec'

    # Initialize plugin utilities registry
    _utilities = []

    def __init__(self, iface):
        # Save reference to the QGIS interface
        self.iface = iface

    def initGui(self):

        # Create toolbar
        toolbar_name = f'{self._name} Toolbar'
        self.toolbar = QToolBar(toolbar_name)
        self.toolbar.setToolTip(toolbar_name)
        # Add toolbar to the window
        self.iface.mainWindow().addToolBar(Qt.TopToolBarArea, self.toolbar)

        # Create instances of the various utilities
        self.utils = [util(self) for util in self.__class__._utilities]

        # Connect any signals to canvas
        # self.iface.mapCanvas().renderComplete.connect(self.myaction)

    def unload(self):
        # Unload utilities
        for util in self.utils:
            util.unload()

        self.iface.mainWindow().removeToolBar(self.toolbar)

        self.toolbar = None

        # Disconnect any signals from canvas
        ...


# : ----------- UTILITY FRAMEWORK ------------ :

class EnSpecUtilityType(type):

    def __new__(metacls, name, bases, attrs, **kwargs):
        cls = super().__new__(metacls, name, bases, attrs)
        if bases:
            # Register subclasses
            EnSpecPlugin._utilities.append(cls)
        return cls


class EnSpecUtility(metaclass=EnSpecUtilityType):

    def __init__(self, name, icon, plugin):

        self.plugin = plugin
        self.name = name

        self.action = None
        self.connection = None

        if icon is not None:
            self.icon = QIcon(str(icon))
        else:
            self.icon = None

        self.initGui()

    def initGui(self):
        # Create an action to launch the utility
        self.action = QAction(self.icon,
                              self.__class__.__name__,
                              self.plugin.iface.mainWindow())

        # Set action information
        self.action.setObjectName(self.__class__.__name__)
        self.action.setWhatsThis(f'Configure {self.__class__.__name__}.')
        self.action.setStatusTip('Eat your dark, leafy greens!')

        # Establish connection between action trigger event & utility launch
        self.connection = self.action.triggered.connect(self.run)

        # Add the utility to the EnSpec plugin menu
        self.plugin.iface.addPluginToMenu(f'&{self.plugin._name}', self.action)
        # Add the utility to the EnSpec toolbar
        self.plugin.toolbar.addAction(self.action)

    def unload(self):
        # Disconnect signal-slot
        self.action.triggered.disconnect(self.run)
        self.connection = None
        # Remove the utility from the EnSpec plugin menu
        self.plugin.iface.removePluginMenu(f'&{self.plugin._name}', self.action)
        # Remove the utility from the EnSpec toolbar
        self.plugin.toolbar.removeAction(self.action)

    def run(self):
        pass


# : --------------- UTILITIES  --------------- :

class TestUtility(EnSpecUtility):

    _icon = Path(__file__).parent/'resource/qt/icon.png'

    def __init__(self, plugin):
        super().__init__(name='Test Utility', icon=self._icon, plugin=plugin)
