### Note
* Windows only

### Install
1. Labview 2015
2. NI-DAQmx 16.0

### Project
1. Open new project: Blank VI
2. Move to block diagram
3. Right click - Measurement I/O - NI-DAQmx
4. Drag new 'DAQ Assistant' onto the block diagram

### DAQ Assistant
1. In 'Create New' window
    * Acquire Signals - Analog Input - voltage - 'select the corresponding port'
2. In 'DAQ Assistant' window
    * Configuration: 'Differential'
    * Acquistuin Mode: 'Continuous Samples'
    * Set the sampling rate in 'Rate (Hz)' and 'Samples to Read'
3. Press 'Run' to test, then press 'OK'


### Block Diagram
1. 'Confrim Auto Loop Creation': 'Yes'

### Front Panel
1. Right click - Graph - Waveform chart and drag onto the panel
2. Right click - Graph - Waveform graph and drag onto the panel

### Block Diagram
1. From 'DAQ Assistant', drag two lines from 'Data' and connect to the two panels
2. Right click - File I/O - 'Write to Meas File' and drag onto the block diagram

### Configure to 'Write to Measurement File'
1. In Configure to 'Write to Measurement File' window
    * Select the file path and name
    * File Format:  'Microsoft excel'
    * If a file already exist: 'Overwrite file'
    * X Value (Time) Columns: 'One column per channel'
2. Press OK
3. Drag the data line to the block

### Front Panel
1. Press 'Run' (White arrow) and the 


