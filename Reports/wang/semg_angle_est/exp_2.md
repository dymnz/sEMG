### 2nd Experiment

Flexion/Extension, better posture for cleaner signal.

* Muscle:
  * Extensor Digitorum
  * Flexor Digitorum Superficialis
* Protocol]
  * Zero-load, palm facing down, making a fist
  * ~Wrist hang free w/ forearm resting on a surface~ Forearm and Wrist are on the table. For Flexion, knuckles are supposed to touch the table; for Extension, the bottom of the wrist is supposed to touch the table.
  * Constant angular speed
  * 0 degree is defined as palm facing down flat on the table, <0 degree as finger moving up
  * Each dataset consists of 5~10 epoch w/ resting interval in between each epoch
  * R^2 error metric should be used to avoid bias for small value estimation
* Movement types
  * Extension: <0 degree only. From 0d move toward 90d then pause. Start moving toward 0d then stop.
    * S2WA_TABLE_EXT_
  * Flexion: >0 degree only. From 0d move toward -90d then pause. Start moving toward 0d then stop.
    * S2WA_TABLE_FLX_
  * Extension/Flexion: Full range. From 0d move toward 90d then pause. Start moving toward 0d then pause. From 0d move toward -90d then pause. Start moving toward 0d then stop.
    * S2WA_TABLE_FULL_

---
### Dataset Description
* S2WA_TABLE_EXT_
  * S2WA_TABLE_EXT_1
  * S2WA_TABLE_EXT_2
  * S2WA_TABLE_EXT_3
  * S2WA_TABLE_EXT_4


---

### 2nd Experiment - LSTM, Downsampled @200hz

* ./rnn S2WA_TABLE_EXT_1_DS200_RMS0_SEG S2WA_TABLE_EXT_1_DS200_RMS0_FULL 4 1000 10 100000 4
  * average loss at epoch:        990 = 0.0031638994
  * RMSE:  2.93931 RMSE:  8.643317
* ./rnn S2WA_TABLE_EXT_1_DS200_RMS0_SEG S2WA_TABLE_EXT_1_DS200_RMS0_FULL 4 2000 10 100000 4
  * average loss at epoch:       1990 = 0.0023613836
  * RMSE: 2.764745 9.202441 
* ./rnn S2WA_TABLE_EXT_2_DS200_RMS0_SEG S2WA_TABLE_EXT_2_DS200_RMS0_FULL 4 1000 10 100000 4
  * average loss at epoch:        990 = 0.0027357501
  * RMSE: 2.401553 3.941856 
  * 5 samples only, near perfect fit
* ./rnn S2WA_TABLE_EXT_3_DS200_RMS0_SEG S2WA_TABLE_EXT_3_DS200_RMS0_FULL 4 1000 10 100000 4
  * average loss at epoch:        990 = 0.0034593083
  * RMSE: 2.641603 6.113749 
* ./rnn S2WA_TABLE_EXT_4_DS200_RMS0_SEG S2WA_TABLE_EXT_4_DS200_RMS0_FULL 4 1000 10 100000 4
  * average loss at epoch:        990 = 0.0045425698
  * RMSE: 2.102075 5.667385

---
### 2nd Experiment - LSTM, RMS @100Hz, Downsampled @100hz - Cross
* ./rnn S2WA_TABLE_EXT_1_DS100_RMS100_SEG S2WA_TABLE_EXT_1_DS100_RMS100_FULL 4 1000 10 100000 4
  * average loss at epoch:        990 = 0.0051206272
  * RMSE: 3.105261 5.311703 

---
### 2nd Experiment - LSTM, Downsampled @200hz - Cross

* ./rnn S2WA_TABLE_EXT_3_DS200_RMS0_SEG S2WA_TABLE_EXT_1_DS200_RMS0_FULL 4 1000 10 100000 4
  * average loss at epoch:        990 = 0.0034593083
  * RMSE: 3.536438 12.651630 

---
### 2nd Experiment - LSTM, Downsampled @200hz - Joined dataset 1234_SEG and test on 1234_FULL
* ./rnn S2WA_TABLE_EXT_1234_DS200_RMS0_SEG S2WA_TABLE_EXT_1_DS200_RMS0_FULL 4 1000 10 100000 4
  * average loss at epoch:        990 = 0.0090901520
  * RMSE: 3.127341 7.406722 
  * Error should be lower, error spiked at the end
* ./rnn S2WA_TABLE_EXT_1234_DS10_RMS100_SEG S2WA_TABLE_EXT_1_DS10_RMS100_FULL 4 1000 10 100000 4
  * average loss at epoch:        990 = 0.0050383045
  * RMSE: 2.787939 12.429198 
* ./rnn S2WA_TABLE_EXT_1234_DS10_RMS100_SEG S2WA_TABLE_EXT_1_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        990 = 0.0038009041
  * RMSE: 2.734106 5.365706 

---
### 2nd Experiment - LSTM, RMS @ 100pts, Downsampled @ 10hz - Joined dataset 3-1 Cross

* ./rnn S2WA_TABLE_EXT_123_DS10_RMS100_SEG S2WA_TABLE_EXT_4_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        990 = 0.0025406332
  * RMSE: 2.294775 10.680675 
* ./rnn S2WA_TABLE_EXT_124_DS10_RMS100_SEG S2WA_TABLE_EXT_3_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        990 = 0.0029623917
  * RMSE: 3.008465 8.210306 
* ./rnn S2WA_TABLE_EXT_134_DS10_RMS100_SEG S2WA_TABLE_EXT_2_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        990 = 0.0030375237
  * RMSE: 3.278073 8.303953 
* ./rnn S2WA_TABLE_EXT_234_DS10_RMS100_SEG S2WA_TABLE_EXT_1_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        990 = 0.0042378023
  * RMSE: 3.358546 7.915986 


* ./rnn S2WA_TABLE_FLX_123_DS10_RMS100_SEG S2WA_TABLE_FLX_4_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        990 = 0.0061534489
  * RMSE: 5.778389 10.802199
* ./rnn S2WA_TABLE_FLX_124_DS10_RMS100_SEG S2WA_TABLE_FLX_3_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        990 = 0.0038787139
  * RMSE: 4.422792 5.362184
* ./rnn S2WA_TABLE_FLX_134_DS10_RMS100_SEG S2WA_TABLE_FLX_2_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        990 = 0.0036404174
  * RMSE: 3.807661 6.390529 
* ./rnn S2WA_TABLE_FLX_234_DS10_RMS100_SEG S2WA_TABLE_FLX_1_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        990 = 0.0023186164
  * RMSE: 3.358546 7.915986 

---
### 2nd Experiment - LSTM, RMS @ 100pts, Downsampled @ 10hz - Joined dataset EXT_FLX test FULL-1

#### These data have mean subtraction. No mean subtraction should be needed after RMS.

* ./rnn S2WA_TABLE_EXT_1234_FLX_1234_DS10_RMS100_SEG S2WA_TABLE_FULL_1_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        990 = 0.1557802320
  * RMSE: 3.591887 15.491174 
  * NO NEG part (EXT) in the predicted sequence

* ./rnn S2WA_TABLE_EXT_1234_FLX_1234_DS10_RMS100_SEG S2WA_TABLE_FULL_1_DS10_RMS100_FULL 3 1000 10 100000 4
  * average loss at epoch:        990 = 0.0576532502
  * RMSE: 3.127129 17.878638 
  * NO NEG part (EXT) in the predicted sequence
---
### 2nd Experiment - LSTM, RMS @ 100pts, Downsampled @ 10hz - Joined dataset EXT_FLX test FULL-1

#### Mean subtraction is removed.

* ./rnn S2WA_TABLE_EXT_1234_FLX_1234_DS10_RMS100_SEG S2WA_TABLE_FULL_1_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        990 = 0.0278071397
  * RMSE: 6.966980 30.826442 
  * FLX predicted as EXT in 3rd session
* ./rnn S2WA_TABLE_EXT_1234_FLX_1234_DS10_RMS100_SEG S2WA_TABLE_FULL_1_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1990 = 0.0085097129
  * RMSE: 6.139854 29.095604 
  * FLX predicted as EXT in 3rd session

* ./rnn S2WA_TABLE_EXT_1234_FLX_1234_DS10_RMS100_SEG S2WA_TABLE_FULL_1_DS10_RMS100_FULL 4 1000 10 100000 4
  * average loss at epoch:        990 = 0.0164431914
  * RMSE: 3.844393 14.473709 
  * NO NEG part (EXT) in the predicted sequence
* ./rnn S2WA_TABLE_EXT_1234_FLX_1234_DS10_RMS100_SEG S2WA_TABLE_FULL_1_DS10_RMS100_FULL 4 2000 10 100000 4
  * average loss at epoch:        1990 = 0.0091110323
  * RMSE: 5.731267 21.892684 
  * NO NEG part (EXT) in the predicted sequence, Flipping EXT FLX in 3rd session

---

### 2nd Experiment - LSTM, ICA, RMS @ 100pts, Downsampled @ 10hz - Joined dataset EXT_FLX test FULL-1

#### Mean subtraction is removed.

* ./rnn S2WA_TABLE_EXT_1234_FLX_1234_ICA_DS10_RMS100_SEG S2WA_TABLE_FULL_1_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        990 = 0.0074163591
  * RMSE: 3.011252 14.988923
* ./rnn S2WA_TABLE_EXT_1234_FLX_1234_ICA_DS10_RMS100_SEG S2WA_TABLE_FULL_1_ICA_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:        1990 = 0.0090857487
  * RMSE: 3.243269 14.987769
* ./rnn S2WA_TABLE_EXT_1234_FLX_1234_ICA_DS10_RMS100_SEG S2WA_TABLE_FULL_1_ICA_DS10_RMS100_FULL 4 2000 10 100000 4
  * average loss at epoch:        1990 = 0.0071804053
  * RMSE: 5.109620 24.867637
  * NO NEG part (EXT) in the predicted sequence
---
### 2nd Experiment - Notes

* Training fitness is good (for EXT)
* Preprocess procedure
  * Training
    * sEMG centering
    * **ICA on training sEMG seq.**
    * RMS calc w/ 100pts (~200mS) windows
    * Downsample to 10Hz
    * Normalization
    * Segmentation of sEMG seq.
  * Testing
    * sEMG centering
    * **Demix w/ calculated ICA separating matrix on sEMG seq**.
    * RMS calc w/ 100pts (~200mS) windows
    * Downsample to 10Hz
    * Normalization
--- 

### TODO
- [x] Combining dataset
- [x] ICA
  * ICA done after RMS calc