### 7-2th Experiment

Torque & Gravity Issue, see exp_7. New ICA normalization.

* Muscle:
  * Pronator Teres (CH1, red)
  * Supinator Muscle (CH2, green)  
* Protocol
  * Zero-load, palm facing down, making a fist
  * Forearm and Wrist are on the table. Hand should always contact the table, to avoid raising forearm.
  * Constant angular speed
  * 0 degree is defined as palm facing down flat on the table, 
    ~0 degree is defined as palm resting on table w/ thumb pointing up~, >0 as wrist turn right (SUP).
  * **Resting position is palm down, all muscle relaxed, 0  degree**
    * **The bias is removed in the preprocessing process, especially for Roll bias. (same in exp-5)**
  * **Ref. electrode moved to wrist**, follow the placement of other paper.
  * **Fixed custom device to assist PRO/SUP motion to avoid Flexion/Extension of wrist**
  * **Supinator Muscle electrode is 30d to perpendicular to arm**
  * Each dataset consists of 5~10 epoch w/ resting interval in between each epoch
  * R^2 error metric should be used to avoid bias for small value estimation
* Movement types
  * Pronation: <0 degree only. From 0d move toward -90d then pause. Start moving toward 0d then stop.
    * S2WA_7_PRO_ 
  * Supination: >0 degree only. From 0d move toward 90d then pause. Start moving toward 0d then stop.
    * S2WA_7_SUP_
  * Pronation/Supination: Full range. From 0d move toward 90d then pause. Start moving toward 0d then pause. From 0d move toward -90d then pause. Start moving toward 0d then stop.
    * S2WA_7_PROSUP_
  * Pattern
    * _1: Fixed_amp Fixed_interval, long pause  (train)
    * _2: Fixed_amp Var_interval, long pause    (train)
    * _3: Var_amp Var_interval, long pause      (train/test)
    * _4: Var_amp Var_interval, long pause      (test)
    * _5: Var_amp Var_interval, brief pause     (test)

---  

### 7-2th Experiment - LSTM, ICA, RMS @ 100pts, Downsampled @ 10hz - FULL-FULL - self
* ./rnn S2WA_7_SUP_1_newICA_DS10_RMS100_FULL S2WA_7_SUP_1_newICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0022508020
  * RMSE:  3.92960   1.58820  
* ./rnn S2WA_7_SUP_1_newICA_DS10_RMS100_FULL S2WA_7_SUP_1_newICA_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0014090618
  * RMSE:  2.85896   1.84685  
* ./rnn S2WA_7_SUP_1_newICA_DS10_RMS100_FULL S2WA_7_SUP_1_newICA_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0010904996
  * RMSE:  2.51324   1.54598  

* ./rnn S2WA_7_SUP_2_newICA_DS10_RMS100_FULL S2WA_7_SUP_2_newICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0030308565
  * RMSE:  4.78272   1.48565  
* ./rnn S2WA_7_SUP_2_newICA_DS10_RMS100_FULL S2WA_7_SUP_2_newICA_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0026370440
  * RMSE:  4.11344   2.10537  
* ./rnn S2WA_7_SUP_2_newICA_DS10_RMS100_FULL S2WA_7_SUP_2_newICA_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0016079475
  * RMSE:  3.41000   0.87190  

* ./rnn S2WA_7_SUP_3_newICA_DS10_RMS100_FULL S2WA_7_SUP_3_newICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0047885979
  * RMSE:  5.58801   2.62146  
* ./rnn S2WA_7_SUP_3_newICA_DS10_RMS100_FULL S2WA_7_SUP_3_newICA_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0027560550
  * RMSE:  4.59230   1.60478  
* ./rnn S2WA_7_SUP_3_newICA_DS10_RMS100_FULL S2WA_7_SUP_3_newICA_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0023131084
  * RMSE:  3.94485   1.52453  

* ./rnn S2WA_7_SUP_4_newICA_DS10_RMS100_FULL S2WA_7_SUP_4_newICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0066496280
  * RMSE:  6.97801   2.25526  
* ./rnn S2WA_7_SUP_4_newICA_DS10_RMS100_FULL S2WA_7_SUP_4_newICA_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0043876523
  * RMSE:  5.79310   1.79237  
* ./rnn S2WA_7_SUP_4_newICA_DS10_RMS100_FULL S2WA_7_SUP_4_newICA_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0032867495
  * RMSE:  5.11625   1.19289  

* ./rnn S2WA_7_SUP_5_newICA_DS10_RMS100_FULL S2WA_7_SUP_5_newICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0050714276
  * RMSE:  5.92752   2.50214  
* ./rnn S2WA_7_SUP_5_newICA_DS10_RMS100_FULL S2WA_7_SUP_5_newICA_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0035579835
  * RMSE:  5.16648   1.45740  
* ./rnn S2WA_7_SUP_5_newICA_DS10_RMS100_FULL S2WA_7_SUP_5_newICA_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0034925235
  * RMSE:  5.25885   1.57996  

---

* ./rnn S2WA_7_PRO_1_newICA_DS10_RMS100_FULL S2WA_7_PRO_1_newICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0020915501
  * RMSE:  3.35862   2.37489  
* ./rnn S2WA_7_PRO_1_newICA_DS10_RMS100_FULL S2WA_7_PRO_1_newICA_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0014231450
  * RMSE:  3.18100   1.25455  
* ./rnn S2WA_7_PRO_1_newICA_DS10_RMS100_FULL S2WA_7_PRO_1_newICA_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0009461779
  * RMSE:  2.55606   1.16671  

* ./rnn S2WA_7_PRO_2_newICA_DS10_RMS100_FULL S2WA_7_PRO_2_newICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0015428700
  * RMSE:  3.14995   1.74281  
* ./rnn S2WA_7_PRO_2_newICA_DS10_RMS100_FULL S2WA_7_PRO_2_newICA_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0014779224
  * RMSE:  2.78277   1.96108  
* ./rnn S2WA_7_PRO_2_newICA_DS10_RMS100_FULL S2WA_7_PRO_2_newICA_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0013455628
  * RMSE:  2.67029   1.90776  

* ./rnn S2WA_7_PRO_3_newICA_DS10_RMS100_FULL S2WA_7_PRO_3_newICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0028227812
  * RMSE:  4.37102   1.80880  
* ./rnn S2WA_7_PRO_3_newICA_DS10_RMS100_FULL S2WA_7_PRO_3_newICA_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0017324158
  * RMSE:  3.47743   1.60123  
* ./rnn S2WA_7_PRO_3_newICA_DS10_RMS100_FULL S2WA_7_PRO_3_newICA_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0013494876
  * RMSE:  2.71390   1.97627  

* ./rnn S2WA_7_PRO_4_newICA_DS10_RMS100_FULL S2WA_7_PRO_4_newICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0019642182
  * RMSE:  3.05738   2.71849  
* ./rnn S2WA_7_PRO_4_newICA_DS10_RMS100_FULL S2WA_7_PRO_4_newICA_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0014016855
  * RMSE:  2.45393   2.34981  
* ./rnn S2WA_7_PRO_4_newICA_DS10_RMS100_FULL S2WA_7_PRO_4_newICA_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0014876281
  * RMSE:  2.78404   1.98361  

* ./rnn S2WA_7_PRO_5_newICA_DS10_RMS100_FULL S2WA_7_PRO_5_newICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0016278307
  * RMSE:  3.25848   1.53398  
* ./rnn S2WA_7_PRO_5_newICA_DS10_RMS100_FULL S2WA_7_PRO_5_newICA_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0010394400
  * RMSE:  2.65414   1.23164  
* ./rnn S2WA_7_PRO_5_newICA_DS10_RMS100_FULL S2WA_7_PRO_5_newICA_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0007638599
  * RMSE:  2.16539   1.26099  

---

### 7-2th Experiment - LSTM, ICA, RMS @ 100pts, Downsampled @ 10hz - FULL-FULL - Cross

* ./rnn S2WA_7_SUP_1_SUP_2_newICA_DS10_RMS100_FULL S2WA_7_SUP_3_newICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0028072164
  * RMSE:  7.26845   1.20288  
* ./rnn S2WA_7_SUP_1_SUP_2_newICA_DS10_RMS100_FULL S2WA_7_SUP_3_newICA_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0226090630
  * RMSE: 23.64552   2.50966  
* ./rnn S2WA_7_SUP_1_SUP_2_newICA_DS10_RMS100_FULL S2WA_7_SUP_3_newICA_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0008993648
  * RMSE:  6.04418   1.58727  


* ./rnn S2WA_7_SUP_1_SUP_2_SUP_3_newICA_DS10_RMS100_FULL S2WA_7_SUP_4_newICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0025630103
  * RMSE:  8.49997   1.86558  
* ./rnn S2WA_7_SUP_1_SUP_2_SUP_3_newICA_DS10_RMS100_FULL S2WA_7_SUP_4_newICA_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0020377002
  * RMSE:  9.07352   0.95121  
* ./rnn S2WA_7_SUP_1_SUP_2_SUP_3_newICA_DS10_RMS100_FULL S2WA_7_SUP_4_newICA_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0032661136
  * RMSE:  7.01789   2.16908  

* ./rnn S2WA_7_SUP_1_SUP_2_SUP_3_newICA_DS10_RMS100_FULL S2WA_7_SUP_5_newICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0025600559
  * RMSE: 14.55283   2.39764  
* ./rnn S2WA_7_SUP_1_SUP_2_SUP_3_newICA_DS10_RMS100_FULL S2WA_7_SUP_5_newICA_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0040133218
  * RMSE:  9.36331   2.18715  
* ./rnn S2WA_7_SUP_1_SUP_2_SUP_3_newICA_DS10_RMS100_FULL S2WA_7_SUP_5_newICA_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0019610294
  * RMSE:  7.71945   1.29165  

* ./rnn S2WA_7_SUP_1_SUP_2_SUP_3_SUP_4_newICA_DS10_RMS100_FULL S2WA_7_SUP_5_newICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0044687507
  * RMSE:  8.52170   2.40068  
* ./rnn S2WA_7_SUP_1_SUP_2_SUP_3_SUP_4_newICA_DS10_RMS100_FULL S2WA_7_SUP_5_newICA_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0027161302
  * RMSE: 62.24738  13.81018  
* ./rnn S2WA_7_SUP_1_SUP_2_SUP_3_SUP_4_newICA_DS10_RMS100_FULL S2WA_7_SUP_5_newICA_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0021703465
  * RMSE: 29.37736   1.83957  

---

* ./rnn S2WA_7_PRO_1_PRO_2_newICA_DS10_RMS100_FULL S2WA_7_PRO_3_newICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0022387226
  * RMSE:  6.12610   1.86026  
* ./rnn S2WA_7_PRO_1_PRO_2_newICA_DS10_RMS100_FULL S2WA_7_PRO_3_newICA_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0012738589
  * RMSE: 43.77162  76.87433  
* ./rnn S2WA_7_PRO_1_PRO_2_newICA_DS10_RMS100_FULL S2WA_7_PRO_3_newICA_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0015774067
  * RMSE:  6.89662   1.49042  

* ./rnn S2WA_7_PRO_1_PRO_2_PRO_3_newICA_DS10_RMS100_FULL S2WA_7_PRO_4_newICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0013699892
  * RMSE:  4.61958   1.47905  
* ./rnn S2WA_7_PRO_1_PRO_2_PRO_3_newICA_DS10_RMS100_FULL S2WA_7_PRO_4_newICA_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0017044612
  * RMSE:  6.90881   2.16765  
* ./rnn S2WA_7_PRO_1_PRO_2_PRO_3_newICA_DS10_RMS100_FULL S2WA_7_PRO_4_newICA_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0010276437
  * RMSE:  5.15871   1.08346  

* ./rnn S2WA_7_PRO_1_PRO_2_PRO_3_newICA_DS10_RMS100_FULL S2WA_7_PRO_5_newICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0018819394
  * RMSE:  5.01129   1.85796  
* ./rnn S2WA_7_PRO_1_PRO_2_PRO_3_newICA_DS10_RMS100_FULL S2WA_7_PRO_5_newICA_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0008989372
  * RMSE:  5.30243   1.95178  
* ./rnn S2WA_7_PRO_1_PRO_2_PRO_3_newICA_DS10_RMS100_FULL S2WA_7_PRO_5_newICA_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0014746879
  * RMSE:  5.80513   0.96968  

* ./rnn S2WA_7_PRO_1_PRO_2_PRO_3_PRO_4_newICA_DS10_RMS100_FULL S2WA_7_PRO_5_newICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0027381720
  * RMSE:  3.11369   2.13100  
* ./rnn S2WA_7_PRO_1_PRO_2_PRO_3_PRO_4_newICA_DS10_RMS100_FULL S2WA_7_PRO_5_newICA_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0013239947
  * RMSE:  3.25762   1.28057  
* ./rnn S2WA_7_PRO_1_PRO_2_PRO_3_PRO_4_newICA_DS10_RMS100_FULL S2WA_7_PRO_5_newICA_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0010611085
  * RMSE:  5.32767   1.34965  

---

### 7-2th Experiment - LSTM, ICA, RMS @ 100pts, Downsampled @ 10hz - 
                      FULL-FULL - Generalization


* ./rnn S2WA_7_SUP_1_SUP_2_SUP_3_SUP_4_PRO_1_PRO_2_PRO_3_PRO_4_newICA_DS10_RMS100_FULL S2WA_7_SUP_5_newICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0041188546
  * RMSE: 12.85955   2.96227  
* ./rnn S2WA_7_SUP_1_SUP_2_SUP_3_SUP_4_PRO_1_PRO_2_PRO_3_PRO_4_newICA_DS10_RMS100_FULL S2WA_7_SUP_5_newICA_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0033994118
  * RMSE:  8.86352   2.03742  
* ./rnn S2WA_7_SUP_1_SUP_2_SUP_3_SUP_4_PRO_1_PRO_2_PRO_3_PRO_4_newICA_DS10_RMS100_FULL S2WA_7_SUP_5_newICA_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0025187681
  * RMSE: 13.06212   1.52627  

* ./rnn S2WA_7_SUP_1_SUP_2_SUP_3_SUP_4_PRO_1_PRO_2_PRO_3_PRO_4_newICA_DS10_RMS100_FULL S2WA_7_PRO_5_newICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0040680068
  * RMSE:  5.03638   1.32995  
* ./rnn S2WA_7_SUP_1_SUP_2_SUP_3_SUP_4_PRO_1_PRO_2_PRO_3_PRO_4_newICA_DS10_RMS100_FULL S2WA_7_PRO_5_newICA_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0032486770
  * RMSE: 186.12563 407.35348 
* ./rnn S2WA_7_SUP_1_SUP_2_SUP_3_SUP_4_PRO_1_PRO_2_PRO_3_PRO_4_newICA_DS10_RMS100_FULL S2WA_7_PRO_5_newICA_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0034883262
  * RMSE: 18.56205   1.84548  

---

### 7-2th Experiment - LSTM, ICA, RMS @ 100pts, Downsampled @ 10hz - 
                      FULL-FULL



* ./rnn S2WA_7_SUP_1_SUP_2_SUP_3_SUP_4_PRO_1_PRO_2_PRO_3_PRO_4_newICA_DS10_RMS100_FULL S2WA_7_PROSUP_1_newICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0042019816
  * RMSE: 10.84828   2.22775  
* ./rnn S2WA_7_SUP_1_SUP_2_SUP_3_SUP_4_PRO_1_PRO_2_PRO_3_PRO_4_newICA_DS10_RMS100_FULL S2WA_7_PROSUP_1_newICA_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0026108660
  * RMSE: 12.33456   2.07827  
* ./rnn S2WA_7_SUP_1_SUP_2_SUP_3_SUP_4_PRO_1_PRO_2_PRO_3_PRO_4_newICA_DS10_RMS100_FULL S2WA_7_PROSUP_1_newICA_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0021239297
  * RMSE: 29.11365  23.77422  

* ./rnn S2WA_7_SUP_1_SUP_2_SUP_3_SUP_4_SUP_5_PRO_1_PRO_2_PRO_3_PRO_4_PRO_5_newICA_DS10_RMS100_FULL S2WA_7_PROSUP_1_newICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0045597695
  * RMSE: 21.20602   1.87417  
* ./rnn S2WA_7_SUP_1_SUP_2_SUP_3_SUP_4_SUP_5_PRO_1_PRO_2_PRO_3_PRO_4_PRO_5_newICA_DS10_RMS100_FULL S2WA_7_PROSUP_1_newICA_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0033419860
  * RMSE: 11.48207   1.55152  
* ./rnn S2WA_7_SUP_1_SUP_2_SUP_3_SUP_4_SUP_5_PRO_1_PRO_2_PRO_3_PRO_4_PRO_5_newICA_DS10_RMS100_FULL S2WA_7_PROSUP_1_newICA_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0022746986
  * RMSE: 21.05726   2.11963  

* ./rnn S2WA_7_SUP_1_SUP_2_SUP_3_SUP_4_PRO_1_PRO_2_PRO_3_PRO_4_newICA_DS10_RMS100_FULL S2WA_7_PROSUP_2_newICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0041186299
  * RMSE: 22.76347   4.01028  
* ./rnn S2WA_7_SUP_1_SUP_2_SUP_3_SUP_4_PRO_1_PRO_2_PRO_3_PRO_4_newICA_DS10_RMS100_FULL S2WA_7_PROSUP_2_newICA_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0031040393
  * RMSE: 32.43591   3.30008  
* ./rnn S2WA_7_SUP_1_SUP_2_SUP_3_SUP_4_PRO_1_PRO_2_PRO_3_PRO_4_newICA_DS10_RMS100_FULL S2WA_7_PROSUP_2_newICA_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0018577120
  * RMSE: 38.11755   4.76906  

* ./rnn S2WA_7_SUP_1_SUP_2_SUP_3_SUP_4_SUP_5_PRO_1_PRO_2_PRO_3_PRO_4_PRO_5_newICA_DS10_RMS100_FULL S2WA_7_PROSUP_2_newICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0035681774
  * RMSE: 22.26575   2.82586  
* ./rnn S2WA_7_SUP_1_SUP_2_SUP_3_SUP_4_SUP_5_PRO_1_PRO_2_PRO_3_PRO_4_PRO_5_newICA_DS10_RMS100_FULL S2WA_7_PROSUP_2_newICA_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0029813939
  * RMSE: 14.26176   2.47026  
* ./rnn S2WA_7_SUP_1_SUP_2_SUP_3_SUP_4_SUP_5_PRO_1_PRO_2_PRO_3_PRO_4_PRO_5_newICA_DS10_RMS100_FULL S2WA_7_PROSUP_2_newICA_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0027226410
  * RMSE: 24.69667   2.67405  

* ./rnn S2WA_7_SUP_1_SUP_2_SUP_3_SUP_4_PRO_1_PRO_2_PRO_3_PRO_4_PROSUP_2_newICA_DS10_RMS100_FULL S2WA_7_PROSUP_1_newICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0051417368
  * RMSE: 26.94908   2.56641  
* ./rnn S2WA_7_SUP_1_SUP_2_SUP_3_SUP_4_PRO_1_PRO_2_PRO_3_PRO_4_PROSUP_2_newICA_DS10_RMS100_FULL S2WA_7_PROSUP_1_newICA_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0035740481
  * RMSE:  9.00327   1.57630  
* ./rnn S2WA_7_SUP_1_SUP_2_SUP_3_SUP_4_PRO_1_PRO_2_PRO_3_PRO_4_PROSUP_2_newICA_DS10_RMS100_FULL S2WA_7_PROSUP_1_newICA_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0024108725
  * RMSE:  7.90124   1.70519  

* ./rnn S2WA_7_SUP_1_SUP_2_SUP_3_SUP_4_SUP_5_PRO_1_PRO_2_PRO_3_PRO_4_PRO_5_PROSUP_1_newICA_DS10_RMS100_FULL S2WA_7_PROSUP_2_newICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0051656159
  * RMSE: 15.29849   2.40745  
* ./rnn S2WA_7_SUP_1_SUP_2_SUP_3_SUP_4_SUP_5_PRO_1_PRO_2_PRO_3_PRO_4_PRO_5_PROSUP_1_newICA_DS10_RMS100_FULL S2WA_7_PROSUP_2_newICA_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0049421134
  * RMSE: 10.08028   2.11590  
* ./rnn S2WA_7_SUP_1_SUP_2_SUP_3_SUP_4_SUP_5_PRO_1_PRO_2_PRO_3_PRO_4_PRO_5_PROSUP_1_newICA_DS10_RMS100_FULL S2WA_7_PROSUP_2_newICA_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0060887781
  * RMSE: 76.80942   6.36474  

