### 6th Experiment

Supination/Pronation part 3. Custom device to assist rotation.

* Muscle:
  * Pronator Teres (CH1, red)
  * Supinator Muscle (CH2, green)  
* Protocol
  * Zero-load, palm facing down, making a fist
  * Forearm and Wrist are on the table. Hand should always contact the table, to avoid raising forearm.
  * Constant angular speed
  * ~0 degree is defined as palm facing down flat on the table~, 0 degree is defined as palm resting on table w/ thumb pointing up, >0 as wrist turn right (SUP).
  * **Resting position is palm down, all muscle relaxed, truning ~30d clockwise**
    * **The bias is removed in the preprocessing process, especially for Roll bias. (same in exp-5)**
  * **Ref. electrode moved to wrist**, follow the placement of other paper.
  * **Fixed custom device to assist PRO/SUP motion to avoid Flexion/Extension of wrist**
  * Each dataset consists of 5~10 epoch w/ resting interval in between each epoch
  * R^2 error metric should be used to avoid bias for small value estimation
* Movement types
  * Pronation: <0 degree only. From 0d move toward -90d then pause. Start moving toward 0d then stop.
    * S2WA_6_PRO_ (S2WA_6_FREE_PRO_ for no device support)
  * Supination: >0 degree only. From 0d move toward 90d then pause. Start moving toward 0d then stop.
    * S2WA_6_SUP_ (S2WA_6_FREE_SUP_ for no device support)
  * Extension/Flexion: Full range. From 0d move toward 90d then pause. Start moving toward 0d then pause. From 0d move toward -90d then pause. Start moving toward 0d then stop.
    * S2WA_6_PROSUP_ (S2WA_6_FREE_PROSUP_ for no device support)

---

### 6th Experiment - LSTM, ICA, RMS @ 100pts, Downsampled @ 10hz - FULL-FULL - self

* ./rnn S2WA_6_SUP_1_ICA_DS10_RMS100_FULL S2WA_6_SUP_1_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0097739228
  * RMSE:  8.72381   2.04570  
* ./rnn S2WA_6_SUP_1_ICA_DS10_RMS100_FULL S2WA_6_SUP_1_ICA_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0048212871
  * RMSE:  6.93421   1.87490  
* ./rnn S2WA_6_SUP_1_ICA_DS10_RMS100_FULL S2WA_6_SUP_1_ICA_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0019211735
  * RMSE:  3.32799   2.11276 

* ./rnn S2WA_6_SUP_2_ICA_DS4_RMS100_FULL S2WA_6_SUP_2_ICA_DS4_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0054591409
  * RMSE:  6.57386   1.47211  
* ./rnn S2WA_6_SUP_2_ICA_DS4_RMS100_FULL S2WA_6_SUP_2_ICA_DS4_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0023053195
  * RMSE:  3.95235   1.54808  
* ./rnn S2WA_6_SUP_2_ICA_DS4_RMS100_FULL S2WA_6_SUP_2_ICA_DS4_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0011408151
  * RMSE:  2.59244   1.57428  

* ./rnn S2WA_6_SUP_3_ICA_DS10_RMS100_FULL S2WA_6_SUP_3_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0033698387
  * RMSE:  4.89424   1.99839  
* ./rnn S2WA_6_SUP_3_ICA_DS10_RMS100_FULL S2WA_6_SUP_3_ICA_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0019015728
  * RMSE:  3.42633   1.82248  
* ./rnn S2WA_6_SUP_3_ICA_DS10_RMS100_FULL S2WA_6_SUP_3_ICA_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0012564938
  * RMSE:  3.11215   0.77155  


* ./rnn S2WA_6_PRO_1_ICA_DS10_RMS100_FULL S2WA_6_PRO_1_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0029785201
  * RMSE:  3.96562   2.81107  
* ./rnn S2WA_6_PRO_1_ICA_DS10_RMS100_FULL S2WA_6_PRO_1_ICA_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0018395635
  * RMSE:  3.42137   1.78642  
* ./rnn S2WA_6_PRO_1_ICA_DS10_RMS100_FULL S2WA_6_PRO_1_ICA_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0011405661
  * RMSE:  2.84178   1.19967  

* ./rnn S2WA_6_PRO_2_ICA_DS10_RMS100_FULL S2WA_6_PRO_2_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0036069748
  * RMSE:  4.90270   2.09422  
* ./rnn S2WA_6_PRO_2_ICA_DS10_RMS100_FULL S2WA_6_PRO_2_ICA_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0027979274
  * RMSE:  4.48446   1.15198  
* ./rnn S2WA_6_PRO_2_ICA_DS10_RMS100_FULL S2WA_6_PRO_2_ICA_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0013622751
  * RMSE:  3.00685   1.77244  
 
* ./rnn S2WA_6_PRO_3_ICA_DS10_RMS100_FULL S2WA_6_PRO_3_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0045111451
  * RMSE:  6.02484   1.12129  
* ./rnn S2WA_6_PRO_3_ICA_DS10_RMS100_FULL S2WA_6_PRO_3_ICA_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0024824306
  * RMSE:  3.85579   2.22357  
* ./rnn S2WA_6_PRO_3_ICA_DS10_RMS100_FULL S2WA_6_PRO_3_ICA_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0019333706
  * RMSE:  3.48839   2.02115  

---

### 6th Experiment - LSTM, ICA, RMS @ 100pts, Downsampled @ 10hz - FULL-FULL - cross

* ./rnn S2WA_6_SUP_1_SUP_2_ICA_DS10_RMS100_FULL S2WA_6_SUP_3_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0050474781
  * RMSE:  4.41819   1.29636  
* ./rnn S2WA_6_SUP_1_SUP_2_ICA_DS10_RMS100_FULL S2WA_6_SUP_3_ICA_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0027639791
  * RMSE:  5.33823   1.15040  
* ./rnn S2WA_6_SUP_1_SUP_2_ICA_DS10_RMS100_FULL S2WA_6_SUP_3_ICA_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0008823592
  * RMSE:  6.12372   1.10971  


* ./rnn S2WA_6_PRO_1_PRO_2_ICA_DS10_RMS100_FULL S2WA_6_PRO_3_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0028902956
  * RMSE:  7.67560   1.27594  
* ./rnn S2WA_6_PRO_1_PRO_2_ICA_DS10_RMS100_FULL S2WA_6_PRO_3_ICA_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0024927835
  * RMSE:  7.26704   2.22919  
* ./rnn S2WA_6_PRO_1_PRO_2_ICA_DS10_RMS100_FULL S2WA_6_PRO_3_ICA_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0017309384
  * RMSE:  6.55895   1.82289  


---

### 6th Experiment - LSTM, JOINT_ICA, RMS @ 100pts, Downsampled @ 10hz - FULL-FULL - cross


* ./rnn S2WA_6_PRO_1_PRO_2_SUP_1_SUP_2_ICA_DS10_RMS100_FULL S2WA_6_PRO_3_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0052762729
  * RMSE: 14.19950   3.33194  
* ./rnn S2WA_6_PRO_1_PRO_2_SUP_1_SUP_2_ICA_DS10_RMS100_FULL S2WA_6_PRO_3_ICA_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0084225748
  * RMSE: 11.36765   3.87123  
* ./rnn S2WA_6_PRO_1_PRO_2_SUP_1_SUP_2_ICA_DS10_RMS100_FULL S2WA_6_PRO_3_ICA_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0020201908
  * RMSE: 10.10113   3.63186   
* ./rnn S2WA_6_PRO_1_PRO_2_SUP_1_SUP_2_ICA_DS10_RMS100_FULL S2WA_6_PRO_3_ICA_DS10_RMS100_FULL 8 8000 10 100000 4
  * average loss at epoch:       7999 = 0.0016283858
  * RMSE: 11.07163   2.87255  
* ./rnn S2WA_6_PRO_1_PRO_2_SUP_1_SUP_2_ICA_DS10_RMS100_FULL S2WA_6_PRO_3_ICA_DS10_RMS100_FULL 8 12000 10 100000 4
  * average loss at epoch:      11999 = 0.0019260402
  * RMSE:  7.09950   2.91231  

* ./rnn S2WA_6_PRO_1_PRO_2_SUP_1_SUP_2_ICA_DS10_RMS100_FULL S2WA_6_PRO_3_ICA_DS10_RMS100_FULL 16 1000 10 100000 4
  * average loss at epoch:        999 = 0.0044123082
  * RMSE: 10.77178   3.14336  
* ./rnn S2WA_6_PRO_1_PRO_2_SUP_1_SUP_2_ICA_DS10_RMS100_FULL S2WA_6_PRO_3_ICA_DS10_RMS100_FULL 16 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0023348956
  * RMSE: 15.40207   3.11169  
* ./rnn S2WA_6_PRO_1_PRO_2_SUP_1_SUP_2_ICA_DS10_RMS100_FULL S2WA_6_PRO_3_ICA_DS10_RMS100_FULL 16 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0008444713
  * RMSE:  7.03764   2.29889  



---

### 6th Experiment - LSTM, JOINT_ICA, RMS @ 100pts, Downsampled @ 10hz - FULL-FULL - PROSUP

#### PROSUP_1

From the validation above, epoch = 4000 should give the best result

* ./rnn S2WA_6_PRO_1_PRO_2_SUP_1_SUP_2_ICA_DS10_RMS100_FULL S2WA_6_PROSUP_1_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0050712429
  * RMSE: 22.54863   2.57446  
* ./rnn S2WA_6_PRO_1_PRO_2_SUP_1_SUP_2_ICA_DS10_RMS100_FULL S2WA_6_PROSUP_1_ICA_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0030215589
  * RMSE:  9.95915   1.67827  
* ./rnn S2WA_6_PRO_1_PRO_2_SUP_1_SUP_2_ICA_DS10_RMS100_FULL S2WA_6_PROSUP_1_ICA_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0031780212
  * RMSE: 30.78693  36.12661  


* ./rnn S2WA_6_PRO_1_PRO_2_PRO_3_SUP_1_SUP_2_SUP_3_ICA_DS10_RMS100_FULL S2WA_6_PROSUP_1_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0050428554
  * RMSE: 18.62723   2.42528  
* ./rnn S2WA_6_PRO_1_PRO_2_PRO_3_SUP_1_SUP_2_SUP_3_ICA_DS10_RMS100_FULL S2WA_6_PROSUP_1_ICA_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0087864422
  * RMSE:  8.16637   2.16795  
* ./rnn S2WA_6_PRO_1_PRO_2_PRO_3_SUP_1_SUP_2_SUP_3_ICA_DS10_RMS100_FULL S2WA_6_PROSUP_1_ICA_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0028846290
  * RMSE: 112.69095 62.90601  

* ./rnn S2WA_6_PRO_1_PRO_2_PRO_3_SUP_1_SUP_2_SUP_3_ICA_DS10_RMS100_FULL S2WA_6_PROSUP_2_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0054779605
  * RMSE: 10.27600   1.72061  
* ./rnn S2WA_6_PRO_1_PRO_2_PRO_3_SUP_1_SUP_2_SUP_3_ICA_DS10_RMS100_FULL S2WA_6_PROSUP_2_ICA_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0025591977
  * RMSE: 20.08727   1.88172  
* ./rnn S2WA_6_PRO_1_PRO_2_PRO_3_SUP_1_SUP_2_SUP_3_ICA_DS10_RMS100_FULL S2WA_6_PROSUP_2_ICA_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0027752824
  * RMSE: 179.41027 86.42617  

* ./rnn S2WA_6_PRO_1_PRO_2_PRO_3_SUP_1_SUP_2_SUP_3_PROSUP_1_ICA_DS10_RMS100_FULL S2WA_6_PROSUP_2_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0050625788
  * RMSE: 10.18544   1.51446  
* ./rnn S2WA_6_PRO_1_PRO_2_PRO_3_SUP_1_SUP_2_SUP_3_PROSUP_1_ICA_DS10_RMS100_FULL S2WA_6_PROSUP_2_ICA_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0183852593
  * RMSE: 11.36756   2.31489  
* ./rnn S2WA_6_PRO_1_PRO_2_PRO_3_SUP_1_SUP_2_SUP_3_PROSUP_1_ICA_DS10_RMS100_FULL S2WA_6_PROSUP_2_ICA_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0035368620
  * RMSE: 18.16719   1.43648  


* None of the testing can avoid *Torque and Gravity* issue, see below
---

### 6th Experiment - Notes

* Pronator electrode location seems to be bad (**May be caused by Torque&Gravity issues**)
  * sEMG response:
    * Pronation: Pro(2) + Sup(1), in equal magnitude <-
    * Supination: Mostly Sup(1) 
* Small amplitude in both Pro&Sup, the force required to rotate forearm is too small
  * Torque may be needed, like in other paper
    * Heavier forearm?
    * Heavy load for hand?

* PRO/SUP performance are better, **What improves the test result?**
  1. Ref. electrode placement change
  2. Fixed device to assist motion
  3. Better muscle locating

---


### 6th Experiment - Issues

* *Torque and Gravity*
  * No torque is required when Gravity is assisting the movement (i.e. No muscle activity)
    * In the case of "0 degree is defined as palm resting on table w/ thumb pointing up", Gravity is helping the *Pronation* movement
    * See *Meeting 2018/04/20 - SEMG_WRIST_ANGLE_2* for more explanation
  * Possible solution
    * Switch back to "0 degree is defined as palm facing down flat on the table"
      * The reason to change in this experiment
        1. The neutral position for forearm should be "0 degree is defined as palm resting on table w/ thumb pointing up", where both SUP&PRO has ~90d displacement
        2. In "0 degree is defined as palm facing down flat on the table", SUP has a ~150d displacement, while PRO has ~60d
    * Custom device requires torque to turn
      * Requires a fixed torque for both clockwise & couter-clockwise rotation
        * How???

### TODO
- [x] 6-2 Free hand results （S2WA_6_FREE_）
- [x] 6-3 w/o ICA