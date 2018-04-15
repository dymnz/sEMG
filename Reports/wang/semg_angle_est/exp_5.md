### 5th Experiment

Supination Bicep signal characteristic check. 

Should have **no** ramp-up/ramp-down when the Pro/Sup. Use the muscle on the forearm.




* Muscle:
  * ~Biceps Brachii~ Supinator Muscle (CH2)
  * Pronator Teres (CH1)
* Protocol
  * Zero-load, palm facing down, making a fist
  * Forearm and Wrist are on the table. Hand should always contact the table, to avoid raising forearm.
  * Constant angular speed
  * 0 degree is defined as palm facing down flat on the table, >0 as wrist turn right.
  * **Resting position is palm down, all muscle relaxed, truning ~30d clockwise**
  * Each dataset consists of 5~10 epoch w/ resting interval in between each epoch
  * R^2 error metric should be used to avoid bias for small value estimation
* Movement types
  * Pronation: <0 degree only. From 0d move toward -90d then pause. Start moving toward 0d then stop.
    * S2WA_5_PRO_
  * Supination: >0 degree only. From 0d move toward 90d then pause. Start moving toward 0d then stop.
    * S2WA_5_SUP_
  * Extension/Flexion: Full range. From 0d move toward 90d then pause. Start moving toward 0d then pause. From 0d move toward -90d then pause. Start moving toward 0d then stop.
    * S2WA_5_PROSUP_

---

### 5th Experiment - LSTM, ICA, RMS @ 100pts, Downsampled @ 10hz

#### No bias removed
* ./rnn S2WA_5_SUP_1_ICA_DS10_RMS100_SEG S2WA_5_SUP_1_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        990 = 0.0013854416
  * RMSE: 13.783262 1.629723
  * Unusable result
* ./rnn S2WA_5_SUP_1_ICA_DS10_RMS100_SEG S2WA_5_SUP_1_ICA_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3990 = 0.0002906017
  * RMSE: 13.855376 2.288882
  * Unusable result

#### Remove Roll/Pitch bias
* ./rnn S2WA_5_SUP_1_ICA_DS10_RMS100_SEG S2WA_5_SUP_1_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        990 = 0.0032986534
  * RMSE: 5.384581 2.030023
* ./rnn S2WA_5_SUP_1_ICA_DS10_RMS100_SEG S2WA_5_SUP_1_ICA_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3990 = 0.0023513278
  * RMSE: 6.572655 2.388198
* ./rnn S2WA_5_SUP_1_ICA_DS10_RMS100_SEG S2WA_5_SUP_1_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        990 = 0.0038553311
  * RMSE: 7.690342 1.947271 

* ./rnn S2WA_5_PRO_1_ICA_DS10_RMS100_SEG S2WA_5_PRO_1_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        990 = 0.0017491735
  * RMSE: 8.200478 3.469380
  * Only the last segment failed to fit, others are better
* ./rnn S2WA_5_PRO_1_ICA_DS10_RMS100_SEG S2WA_5_PRO_1_ICA_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3990 = 0.0005720460
  * RMSE: 34.902401 5.549883 
  * Output stuck at constant after 3rd segment

* SUP better, PRO worse

---

### 5th Experiment - LSTM, ICA, RMS @ 100pts, Downsampled @ 10hz - FULL-FULL

* ./rnn S2WA_5_SUP_1_ICA_DS10_RMS100_FULL S2WA_5_SUP_1_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        990 = 0.0047350848
  * RMSE: 5.766148 2.278525 
* ./rnn S2WA_5_SUP_1_ICA_DS10_RMS100_FULL S2WA_5_SUP_1_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        990 = 0.0072456402
  * RMSE: 7.283078 2.188362 

* ./rnn S2WA_5_SUP_1_ICA_DS10_RMS100_FULL S2WA_5_SUP_2_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        990 = 0.0046685493
  * RMSE: 9.823844 2.926461
* ./rnn S2WA_5_SUP_1_ICA_DS10_RMS100_FULL S2WA_5_SUP_2_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        990 = 0.0058554906
  * RMSE: 10.124050 5.710233


* ./rnn S2WA_5_PRO_1_ICA_DS10_RMS100_FULL S2WA_5_PRO_1_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        990 = 0.0045499852
  * RMSE: 5.615390 2.237433 
* ./rnn S2WA_5_PRO_1_ICA_DS10_RMS100_FULL S2WA_5_PRO_1_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        990 = 0.0050687817
  * RMSE: 6.105148 2.319811 


* ./rnn S2WA_5_PRO_1_ICA_DS10_RMS100_FULL S2WA_5_PRO_2_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        990 = 0.0045395872
  * RMSE: 10.992201 2.262021
  * Spike (error) in testing sample, RMSE should be lower. 8 is near perfect fit
* ./rnn S2WA_5_PRO_1_ICA_DS10_RMS100_FULL S2WA_5_PRO_2_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        990 = 0.0044615086
  * RMSE: 8.044998 2.528875 
  * Spike (error) in testing sample, RMSE should be lower. 8 is near perfect fit

---

### 5th Experiment - LSTM, ICA, RMS @ 100pts, Downsampled @ 4hz - FULL-FULL

* ./rnn S2WA_5_SUP_1_ICA_DS4_RMS100_FULL S2WA_5_SUP_1_ICA_DS4_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        990 = 0.0036089236
  * RMSE: 4.909523 2.001146 
* ./rnn S2WA_5_SUP_1_ICA_DS4_RMS100_FULL S2WA_5_SUP_1_ICA_DS4_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        990 = 0.0037130069
  * RMSE: 5.043553 1.958406

* ./rnn S2WA_5_SUP_1_ICA_DS4_RMS100_FULL S2WA_5_SUP_2_ICA_DS4_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        990 = 0.0037019676
  * RMSE: 8.418637 3.494865 
* ./rnn S2WA_5_SUP_1_ICA_DS4_RMS100_FULL S2WA_5_SUP_2_ICA_DS4_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        990 = 0.0074856227
  * RMSE: 11.553801 1.975514

* ./rnn S2WA_5_PRO_1_ICA_DS4_RMS100_FULL S2WA_5_PRO_1_ICA_DS4_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        990 = 0.0043057251
  * RMSE: 5.408214 2.133253
* ./rnn S2WA_5_PRO_1_ICA_DS4_RMS100_FULL S2WA_5_PRO_1_ICA_DS4_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        990 = 0.0078222536
  * RMSE: 7.302066 3.072417


* ./rnn S2WA_5_PRO_1_ICA_DS4_RMS100_FULL S2WA_5_PRO_2_ICA_DS4_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        990 = 0.0035849831
  * RMSE: 10.535129 3.315282
  * Spike (error) in testing sample, RMSE should be lower. 8 is near perfect fit
* ./rnn S2WA_5_PRO_1_ICA_DS4_RMS100_FULL S2WA_5_PRO_2_ICA_DS4_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        990 = 0.0035971302
  * RMSE: 11.297884 2.199912
  * Spike (error) in testing sample, RMSE should be lower. 8 is near perfect fit

---

### 5th Experiment - LSTM, **NOTHING**, RMS @ 100pts, Downsampled @ 10hz

#### Remove Roll/Pitch bias

* ./rnn S2WA_5_SUP_1_DS10_RMS100_SEG S2WA_5_SUP_1_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        990 = 0.0038406577
  * RMSE: 8.626129 2.534827 
* ./rnn S2WA_5_SUP_1_DS10_RMS100_SEG S2WA_5_SUP_2_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        990 = 0.0038406577
  * RMSE: 28.770424 60.492143
  * Good for first 4/5, then broke
* ./rnn S2WA_5_SUP_1_DS10_RMS100_SEG S2WA_5_SUP_2_DS10_RMS100_FULL 8 1000 10 100000 45
  * average loss at epoch:        990 = 0.0034724972
  * RMSE: 48.655055 7.007303


* SUP doesn't need ICA


---

### 5th Experiment - LSTM, ICA, RMS @ 100pts, Downsampled @ 10hz - Cross

#### Remove Roll bias
* ./rnn S2WA_5_SUP_1_ICA_DS10_RMS100_SEG S2WA_5_SUP_2_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        990 = 0.0032986534
  * RMSE: 13.676936 2.202257
  * Followed trend, but didn't hit value
* ./rnn S2WA_5_SUP_1_ICA_DS10_RMS100_SEG S2WA_5_SUP_2_ICA_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3990 = 0.0021549286
  * RMSE: 11.707137 3.564635
  * Followed trend, but didn't hit value
* ./rnn S2WA_5_SUP_1_ICA_DS10_RMS100_SEG S2WA_5_SUP_2_ICA_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3990 = 0.0021549286
  * RMSE: 11.707137 3.564635  
* ./rnn S2WA_5_SUP_1_ICA_DS10_RMS100_SEG S2WA_5_SUP_2_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        990 = 0.0038465208
  * RMSE: 16.890134 2.768739  
* ./rnn S2WA_5_SUP_1_ICA_DS10_RMS100_SEG S2WA_5_SUP_2_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        990 = 0.0032085108
  * RMSE: 13.658835 2.177817


* ./rnn S2WA_5_PRO_1_ICA_DS10_RMS100_SEG S2WA_5_PRO_2_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        990 = 0.0013211438
  * RMSE: 8.281724 2.454976 
  * Spike (error) in testing sample, RMSE should be lower, near perfect fit
* ./rnn S2WA_5_PRO_1_ICA_DS10_RMS100_SEG S2WA_5_PRO_2_ICA_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3990 = 0.0007428093
  * RMSE: 8.540334 1.685161 
  * Spike (error) in testing sample, RMSE should be lower, near perfect fit

* SUP worse, PRO better

---

### 5th Experiment - LSTM, **PRO_ICA**, RMS @ 100pts, Downsampled @ 10hz

* ./rnn S2WA_5_SUP_1_PRO_ICA_DS10_RMS100_SEG S2WA_5_SUP_1_PRO_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        990 = 0.0045633957
  * RMSE: 6.149516 2.057592

* ./rnn S2WA_5_SUP_1_PRO_ICA_DS10_RMS100_SEG S2WA_5_SUP_2_PRO_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        990 = 0.0039901892
  * RMSE: 10.788443 1.963241 

---

### 5th Experiment - LSTM, JOINT_ICA (SUP_1,PRO_1), RMS @ 100pts, Downsampled @ 10hz - Self and Cross

* ./rnn S2WA_5_SUP_1_JOINT_ICA_DS10_RMS100_SEG S2WA_5_SUP_1_JOINT_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        990 = 0.0037710357
  * RMSE: 9.672453 2.618202

* ./rnn S2WA_5_PRO_1_JOINT_ICA_DS10_RMS100_SEG S2WA_5_PRO_1_JOINT_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        990 = 0.0013604426
  * RMSE: 22.220393 7.519730 
  * Output stuck at constant after 3rd segment
* ./rnn S2WA_5_PRO_1_JOINT_ICA_DS10_RMS100_SEG S2WA_5_PRO_1_JOINT_ICA_DS10_RMS100_FULL 8 1000 10 100000 21
  * average loss at epoch:        990 = 0.0021598938
  * RMSE: 12.287261 4.692125  
* ./rnn S2WA_5_PRO_1_JOINT_ICA_DS10_RMS100_SEG S2WA_5_PRO_1_JOINT_ICA_DS10_RMS100_FULL 8 2000 10 100000 21
  * average loss at epoch:       1990 = 0.0012314424
  * RMSE: 14.562202 4.326793
* ./rnn S2WA_5_PRO_1_JOINT_ICA_DS10_RMS100_SEG S2WA_5_PRO_2_JOINT_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        990 = 0.0017373474
  * RMSE: 17.240396 3.770408


* In both SUP & PRO, JOINT_ICA degrades performance, especially for PRO

---

### 5th Experiment - LSTM, ICA, RMS @ 100pts, Downsampled @ 10hz - Joined dataset SUP1_PRO1 test PROSUP-1

* ./rnn S2WA_5_PRO_1_SUP_1_ICA_DS10_RMS100_SEG S2WA_5_PROSUP_1_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        990 = 0.0551020183
  * RMSE: 44.761523 8.320772
* ./rnn S2WA_5_PRO_1_SUP_1_ICA_DS10_RMS100_SEG S2WA_5_PROSUP_1_ICA_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1990 = 0.0114675558
  * RMSE: 56.685634 9.187118
* ./rnn S2WA_5_PRO_1_SUP_1_ICA_DS10_RMS100_SEG S2WA_5_PROSUP_1_ICA_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3990 = 0.0035169229
  * RMSE: 43.102154 7.366494
* ./rnn S2WA_5_PRO_1_SUP_1_ICA_DS10_RMS100_SEG S2WA_5_PROSUP_1_ICA_DS10_RMS100_FULL 30 1000 10 100000 4
  * average loss at epoch:        990 = 0.0046999596
  * RMSE: 70.315917 21.093434


* No good result

---

### 5th Experiment - LSTM, ICA, RMS @ 100pts, Downsampled @ 4hz - Joined dataset SUP1_PRO1 test PROSUP-1


### ICA -> Downsample

* ./rnn S2WA_5_PRO_1_SUP_1_ICA_DS4_RMS100_FULL S2WA_5_PROSUP_1_ICA_DS4_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        990 = 0.0156929287
  * RMSE: 36.321189 6.557278 
* ./rnn S2WA_5_PRO_1_SUP_1_ICA_DS4_RMS100_FULL S2WA_5_PROSUP_1_ICA_DS4_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1990 = 0.0043041903
  * RMSE: 35.693378 6.390169 
* ./rnn S2WA_5_PRO_1_SUP_1_ICA_DS4_RMS100_FULL S2WA_5_PRO_1_SUP_1_ICA_DS4_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:       1990 = 0.0043041903
  * RMSE: 5.998747 5.161804 1.875154 1.955035 

### Downsample -> ICA

* ./rnn S2WA_5_PRO_1_SUP_1_ICA_DS4_RMS100_FULL S2WA_5_PROSUP_1_ICA_DS4_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        990 = 0.1279059993
  * RMSE: 33.330651 13.774554
* ./rnn S2WA_5_PRO_1_SUP_1_ICA_DS4_RMS100_FULL S2WA_5_PROSUP_1_ICA_DS4_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1990 = 0.0055997366
  * RMSE: 45.946183 9.753235


* Still bad

* ./rnn S2WA_5_PRO_1_SUP_1_ICA_DS4_RMS100_FULL S2WA_5_SUP_2_ICA_DS4_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0024691105
  * RMSE: 10.61834   2.74051
* ./rnn S2WA_5_PRO_1_SUP_1_ICA_DS4_RMS100_FULL S2WA_5_PRO_2_ICA_DS4_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0182230789
  * RMSE: 23.60064   4.11827
* ./rnn S2WA_5_PRO_1_SUP_1_ICA_DS4_RMS100_FULL S2WA_5_PRO_2_ICA_DS4_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0033735321
  * RMSE: 41.48366   6.79399  * 
---

### 5th Experiment - LSTM, **PRO_ICA**, RMS @ 100pts, Downsampled @ 10hz - Joined dataset SUP1_PRO1 test PROSUP-1

* ./rnn S2WA_5_PRO_1_SUP_1_PRO_ICA_DS10_RMS100_SEG S2WA_5_PROSUP_1_PRO_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        990 = 0.0630644073
  * RMSE: 52.705215 9.412556

* No good result
---

### 5th Experiment - LSTM, **PRO_ICA**, RMS @ 100pts, Downsampled @ 10hz - Joined dataset SUP1_PRO1 test PROSUP-1

* ./rnn S2WA_5_PRO_1_SUP_1_PRO_ICA_DS10_RMS100_SEG S2WA_5_PROSUP_1_PRO_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        990 = 0.0551020183
  * RMSE: 44.761523 8.320772

---




### 5th Experiment - Notes

* Hard to find the true neutral position for between SUP/PRO. Settle with the "Resting position" with no muscle activated.
* Individual ICA SUP/PRO performance good
* In both SUP&PRO, JOINT_ICA degrades performance, especially for PRO
* No acceptable FULL performance
  * Go ahead and make 4-ch sEMG?
* With low sampling rate (4Hz), most sequence can be enter directly to LSTM w/o segmentation, and the result may be better
  * Comparable or Better for seperate SUP/PRO, but still bad for FULL


### TODO
- [x] Joint FULL-FULL 4Hz
  * Bad result