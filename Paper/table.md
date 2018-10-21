```
sEMG Signal Separation for Real-time Wrist Angle Estimation

### 1 - 緒論 ###
1.1 研究動機與目的
1.2 論文架構


### 2 - Background ###
2.1 EMG
    2.1.1 EMG
    2.1.2 sEMG
2.2 Angle Decoding (from past paper)
    2.2.1 Limb in general
    2.2.2 Wrist Angle
2.3 sEMG Feature 
    2.3.1 MAV
    2.3.2 RMS
    2.3.3 Wavelet
2.4 sEMG Signal Separation (BSS)
    2.4.1 nICA
    2.4.2 TDSEP (Used in Gesture Recognition)
2.5 Decoder
    2.5.1 MLP
    2.5.2 BPNN
    2.5.3 LSTM (type of RNN)

### 3 - Processing Procedure & Analysis ###
3.1 Difference in nICA/TDSEP
3.2 Electrode configuration & Their Effect on Exp.
    3.2.1 # of Electrodes
    3.2.2 Placement (Muscle Location & Randomness)
3.3 Parameter & Their Effect on Exp.
    3.3.1 nICA (Tolerance for stopping condition)
    3.3.2 TDSEP (*tau*)
    3.3.3 LSTM (Learning rate adjusting w/ ADA-DELTA / Hidden node count)
3.4 Flowchart 
    3.4.1 Find Demixing Matrix 
        (Record - RMS - Find Demixing mat.)
    3.4.2 Processing for Testing 
        (Record - Mean remove - Windowed RMS - Demix - Decimation - Normalization)
  
### 4 - Result & Discussion ###
4.1 Data Collection & Processing
    4.1.1 Hardware (IMU angle / Active eletrode / Amp / ADC)
    4.1.2 Software (Processing 3 / Matlab / C)  
4.2 Performance Metric
    4.2.1 Ground Truth
    4.2.2 RMSE
    4.2.3 Cross-validation
4.3 Compare Result of RMS-only / nICA / TDSEP
    4.3.1 Under 4 electrode
    4.3.2 Under 6 electrode


### 5 - Conclusion ###
5.1 Conclusion


```
