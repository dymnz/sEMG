### 1st Experiment

Wrist flexion/extension proportional control. sEMG to Wrist angle(*S2WA*).

Test if the two muscle is enough for wrist angle estimation.

* Muscle:
  * Extensor Digitorum
  * Flexor Digitorum Superficialis
* Protocol
  * Zero-load, palm facing down, making a fist
  * Wrist hang free w/ forearm resting on a surface
  * Constant angular speed
  * 0 degree is defined as palm facing down flat on the table, <0 degree as finger moving up
* Movement types
  * Extension: <0 degree only. From 0d move toward 90d then pause. Start moving toward 0d then stop.
    * S2WA_1_EXT1
  * Flexion: >0 degree only. From 0d move toward -90d then pause. Start moving toward 0d then stop.
    * S2WA_1_FLX1
  * Extension/Flexion: Full range. From 0d move toward 90d then pause. Start moving toward 0d then pause. From 0d move toward -90d then pause. Start moving toward 0d then stop.
    * S2WA_1_FULL1

---
### Pre-processing

* Segmented w/ fixed window, others as before
* Possible pre-processing
  * ICA (Shouldn't be needed for 2-ch sEMG mounted on opposing side of the forearm)

---

### 1st Experiment - Notes

* When flexing, *Flexor Digitorum Superficialis* show little amplitude until higher angle.
  * Gravity may affect the flexing as it helps reduce the need for muscle activity
    * May be fixed by Flexing/Extending on horizontal plane
      * Simple IMU is unusable on horizontal plane
* May need a constant torque for better sEMG-Wrist angle mapping
* Continuous angle estimation may be required, since sEMG reflects usage, not position. 
  * For NN, a session should starts from 0d. Training segments should start/end from 0d.

---

### 1st Experiment - LSTM, Downsampled @200Hz

* ./rnn S2WA_EXT_1_DS200_SEG S2WA_EXT_1_DS200_FULL 4 1000 10 100000 4 
  * average loss at epoch:        990 = 0.0070518111
  * average loss:  1178.778443

* ./rnn S2WA_EXT_1_DS200_SEG S2WA_EXT_1_DS200_FULL 8 1000 10 100000 4 
  * average loss at epoch:        990 = 0.0079773375 (0.0063042933 lowest)
  * average loss:  1161.590729 (Should be lower, training end at higher error)

* ./rnn S2WA_EXT_1_DS200_SEG S2WA_EXT_1_DS200_FULL 4 2000 10 100000 4 
  * average loss at epoch:       1990 = 0.0056364951
  * average loss:  1150.798829

* Persisting low level activation of Extensor makes estimation of Extension hard. Check how the paper test it.

### 1st Experiment - LSTM, RMS

* ./rnn S2WA_EXT_1_DS200_RMS60_SEG  S2WA_EXT_1_DS200_RMS60_FULL 4 1000 10 100000 4 
  * average loss at epoch:        990 = 0.0066860258  (0.0039338134 lowest)
  * RMSE:  2.588365 RMSE:  10.399536
* ./rnn S2WA_EXT_1_DS30_RMS60_SEG  S2WA_EXT_1_DS30_RMS60_FULL 4 1000 10 100000 4      
  * Threshold setting is bad
  * average loss at epoch:        990 = 0.0066860258  (0.0039338134 lowest)
  * RMSE:  2.606027 RMSE:  10.765839
* ./rnn S2WA_EXT_1_DS30_RMS60_SEG S2WA_EXT_1_DS30_RMS60_FULL 4 1990 10 100000 4 
  * Threshold setting is bad
  * average loss at epoch:       1980 = 0.0034572347
  * RMSE:  4.558867 RMSE:  25.326211
* ./rnn S2WA_EXT_1_DS60_RMS60_SEG S2WA_EXT_1_DS60_RMS60_FULL 4 1000 10 100000 4 
  * average loss at epoch:        990 = 0.0168195763
  * RMSE:  2.958079 RMSE:  17.920819
* ./rnn S2WA_EXT_1_DS30_RMS60_SEG S2WA_EXT_1_DS30_RMS60_FULL 4 4000 10 100000 4 
  * average loss at epoch:       3990 = 0.0082425181
  * RMSE:  4.567174 RMSE:  19.609496
* ./rnn S2WA_EXT_1_DS30_RMS30_SEG S2WA_EXT_1_DS30_RMS30_FULL 4 4000 10 100000 4 
  * average loss at epoch:       3990 = 0.0056238094
  * RMSE:  3.112980 RMSE:  19.660604
* ./rnn S2WA_EXT_1_DS30_RMS30_SEG S2WA_EXT_1_DS30_RMS30_FULL 4 1000 10 100000 4 
  * average loss at epoch:        990 = 0.0086650929
  * RMSE:  2.828978 RMSE:  18.018552
* ./rnn S2WA_EXT_1_DS100_RMS30_SEG S2WA_EXT_1_DS100_RMS30_FULL 4 1000 10 100000 4 
  * average loss at epoch:        990 = 0.0086650929
  * RMSE:  2.736200 RMSE:  12.440111
* ./rnn S2WA_EXT_1_DS100_RMS60_SEG S2WA_EXT_1_DS100_RMS60_FULL 4 1000 10 100000 4 
  * Stop @ 400, error increase afterward
  * average loss at epoch:        390 = 0.0036190963
  * RMSE:  2.750737 RMSE:  11.640750
* ./rnn S2WA_EXT_1_DS200_RMS60_SEG S2WA_EXT_1_DS200_RMS60_FULL 4 1000 10 100000 4 
  * average loss at epoch:        990 = 0.0056023360
  * RMSE:  2.631582 RMSE:  11.585921
* ./rnn S2WA_EXT_1_DS200_RMS30_SEG S2WA_EXT_1_DS200_RMS30_FULL 4 1000 10 100000 4 
  * average loss at epoch:        990 = 0.0071319122
  * RMSE:  2.730793 RMSE:  12.887403
### 1st Experiment - LSTM, ICA