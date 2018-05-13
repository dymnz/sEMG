### 7th Experiment

Torque & Gravity Issue, see exp_6. Switch back to "0 degree is defined as palm facing down flat on the table", **WITH** device assisted PRO/SUP.

Target: RMSE < 10 degree

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

### 7th Experiment - LSTM, ICA, RMS @ 100pts, Downsampled @ 10hz - FULL-FULL - self

* ./rnn S2WA_7_SUP_1_ICA_DS10_RMS100_FULL S2WA_7_SUP_1_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0041428347
  * RMSE:  5.08899   2.48280  
* ./rnn S2WA_7_SUP_1_ICA_DS10_RMS100_FULL S2WA_7_SUP_1_ICA_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0019643005
  * RMSE:  3.67913   1.58261  
* ./rnn S2WA_7_SUP_1_ICA_DS10_RMS100_FULL S2WA_7_SUP_1_ICA_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0013348437
  * RMSE:  3.18623   0.81752  

* ./rnn S2WA_7_SUP_2_ICA_DS10_RMS100_FULL S2WA_7_SUP_2_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0027334107
  * RMSE:  4.41189   1.21368  
* ./rnn S2WA_7_SUP_2_ICA_DS10_RMS100_FULL S2WA_7_SUP_2_ICA_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0018472594
  * RMSE:  3.44699   1.85078  
* ./rnn S2WA_7_SUP_2_ICA_DS10_RMS100_FULL S2WA_7_SUP_2_ICA_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0018774074
  * RMSE:  3.51201   1.64122  

* ./rnn S2WA_7_SUP_3_ICA_DS10_RMS100_FULL S2WA_7_SUP_3_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0065703768
  * RMSE:  6.77420   1.89776  
* ./rnn S2WA_7_SUP_3_ICA_DS10_RMS100_FULL S2WA_7_SUP_3_ICA_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0035067930
  * RMSE:  5.24419   1.43734  
* ./rnn S2WA_7_SUP_3_ICA_DS10_RMS100_FULL S2WA_7_SUP_3_ICA_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0021955501
  * RMSE:  4.08368   0.89700  

* ./rnn S2WA_7_SUP_4_ICA_DS10_RMS100_FULL S2WA_7_SUP_4_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0038077568
  * RMSE:  5.32905   1.63421  
* ./rnn S2WA_7_SUP_4_ICA_DS10_RMS100_FULL S2WA_7_SUP_4_ICA_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0039529155
  * RMSE:  5.51393   1.20073  
* ./rnn S2WA_7_SUP_4_ICA_DS10_RMS100_FULL S2WA_7_SUP_4_ICA_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0027225077
  * RMSE:  4.66441   0.78020  

* ./rnn S2WA_7_SUP_5_ICA_DS10_RMS100_FULL S2WA_7_SUP_5_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0050878470
  * RMSE:  6.19349   1.98018  
* ./rnn S2WA_7_SUP_5_ICA_DS10_RMS100_FULL S2WA_7_SUP_5_ICA_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0044637010
  * RMSE:  5.06625   2.03688  
* ./rnn S2WA_7_SUP_5_ICA_DS10_RMS100_FULL S2WA_7_SUP_5_ICA_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0021075455
  * RMSE:  3.70992   1.84095  

---

* ./rnn S2WA_7_PRO_1_ICA_DS10_RMS100_FULL S2WA_7_PRO_1_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0023259730
  * RMSE:  3.91093   1.97272  
* ./rnn S2WA_7_PRO_1_ICA_DS10_RMS100_FULL S2WA_7_PRO_1_ICA_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0018780300
  * RMSE:  3.38211   2.00587  
* ./rnn S2WA_7_PRO_1_ICA_DS10_RMS100_FULL S2WA_7_PRO_1_ICA_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0012515193
  * RMSE:  2.26090   2.22850 

* ./rnn S2WA_7_PRO_2_ICA_DS10_RMS100_FULL S2WA_7_PRO_2_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0014872303
  * RMSE:  3.20051   1.45979  
* ./rnn S2WA_7_PRO_2_ICA_DS10_RMS100_FULL S2WA_7_PRO_2_ICA_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0015608184
  * RMSE:  2.63196   2.32729  
* ./rnn S2WA_7_PRO_2_ICA_DS10_RMS100_FULL S2WA_7_PRO_2_ICA_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0011381422
  * RMSE:  2.64368   1.64910  

* ./rnn S2WA_7_PRO_3_ICA_DS10_RMS100_FULL S2WA_7_PRO_3_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0020936264
  * RMSE:  4.07285   0.87872  
* ./rnn S2WA_7_PRO_3_ICA_DS10_RMS100_FULL S2WA_7_PRO_3_ICA_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0019714525
  * RMSE:  3.75439   1.34886  
* ./rnn S2WA_7_PRO_3_ICA_DS10_RMS100_FULL S2WA_7_PRO_3_ICA_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0015392161
  * RMSE:  2.90938   2.06621  

* ./rnn S2WA_7_PRO_4_ICA_DS10_RMS100_FULL S2WA_7_PRO_4_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0030362392
  * RMSE:  4.63571   1.51606  
* ./rnn S2WA_7_PRO_4_ICA_DS10_RMS100_FULL S2WA_7_PRO_4_ICA_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0016212794
  * RMSE:  3.14819   1.87094  
* ./rnn S2WA_7_PRO_4_ICA_DS10_RMS100_FULL S2WA_7_PRO_4_ICA_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0012291639
  * RMSE:  2.75569   0.99020  

* ./rnn S2WA_7_PRO_5_ICA_DS10_RMS100_FULL S2WA_7_PRO_5_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0014502641
  * RMSE:  3.35310   1.04137  
* ./rnn S2WA_7_PRO_5_ICA_DS10_RMS100_FULL S2WA_7_PRO_5_ICA_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0010644534
  * RMSE:  1.80538   2.29109  
* ./rnn S2WA_7_PRO_5_ICA_DS10_RMS100_FULL S2WA_7_PRO_5_ICA_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0010985352
  * RMSE:  2.33012   1.92665  

---

### 7th Experiment - LSTM, ICA, RMS @ 100pts, Downsampled @ 10hz - FULL-FULL - Cross

* ./rnn S2WA_7_SUP_1_SUP_2_ICA_DS10_RMS100_FULL S2WA_7_SUP_3_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0023674113
  * RMSE:  6.85421   1.89072  
* ./rnn S2WA_7_SUP_1_SUP_2_ICA_DS10_RMS100_FULL S2WA_7_SUP_3_ICA_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0016632599
  * RMSE:  7.70614   1.58363  
* ./rnn S2WA_7_SUP_1_SUP_2_ICA_DS10_RMS100_FULL S2WA_7_SUP_3_ICA_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0068000949
  * RMSE:  8.73413   2.02729  

* ./rnn S2WA_7_SUP_1_SUP_2_SUP_3_ICA_DS10_RMS100_FULL S2WA_7_SUP_4_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0038598293
  * RMSE:  7.74103   2.36076  
* ./rnn S2WA_7_SUP_1_SUP_2_SUP_3_ICA_DS10_RMS100_FULL S2WA_7_SUP_4_ICA_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0029004984
  * RMSE:  9.08365   1.50653  
* ./rnn S2WA_7_SUP_1_SUP_2_SUP_3_ICA_DS10_RMS100_FULL S2WA_7_SUP_4_ICA_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0027765033
  * RMSE:  7.84770   1.54223  

* ./rnn S2WA_7_SUP_1_SUP_2_SUP_3_ICA_DS10_RMS100_FULL S2WA_7_SUP_5_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0028144342
  * RMSE: 12.17107   1.13675  
* ./rnn S2WA_7_SUP_1_SUP_2_SUP_3_ICA_DS10_RMS100_FULL S2WA_7_SUP_5_ICA_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0028390845
  * RMSE: 10.67608   1.45672  
* ./rnn S2WA_7_SUP_1_SUP_2_SUP_3_ICA_DS10_RMS100_FULL S2WA_7_SUP_5_ICA_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0210820565
  * RMSE: 12.14269   1.42737 

* ./rnn S2WA_7_SUP_1_SUP_2_SUP_3_SUP_4_ICA_DS10_RMS100_FULL S2WA_7_SUP_5_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0306414520
  * RMSE: 10.37279   1.05474  
* ./rnn S2WA_7_SUP_1_SUP_2_SUP_3_SUP_4_ICA_DS10_RMS100_FULL S2WA_7_SUP_5_ICA_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0053461435
  * RMSE:  8.07557   1.23405  
* ./rnn S2WA_7_SUP_1_SUP_2_SUP_3_SUP_4_ICA_DS10_RMS100_FULL S2WA_7_SUP_5_ICA_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0019756069
  * RMSE: 10.95172   1.41545  

---

* ./rnn S2WA_7_PRO_1_PRO_2_ICA_DS10_RMS100_FULL S2WA_7_PRO_3_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0024046262
  * RMSE:  5.40637   0.88708  
* ./rnn S2WA_7_PRO_1_PRO_2_ICA_DS10_RMS100_FULL S2WA_7_PRO_3_ICA_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0014366106
  * RMSE:  5.58819   0.78461  
* ./rnn S2WA_7_PRO_1_PRO_2_ICA_DS10_RMS100_FULL S2WA_7_PRO_3_ICA_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0012836832
  * RMSE:  7.66806   1.40859  

* ./rnn S2WA_7_PRO_1_PRO_2_PRO_3_ICA_DS10_RMS100_FULL S2WA_7_PRO_4_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0020235250
  * RMSE:  4.70786   2.89925  
* ./rnn S2WA_7_PRO_1_PRO_2_PRO_3_ICA_DS10_RMS100_FULL S2WA_7_PRO_4_ICA_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0009143125
  * RMSE: 13.01880  11.94829  
* ./rnn S2WA_7_PRO_1_PRO_2_PRO_3_ICA_DS10_RMS100_FULL S2WA_7_PRO_4_ICA_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0006521432
  * RMSE:  4.15929   1.02198  

* ./rnn S2WA_7_PRO_1_PRO_2_PRO_3_ICA_DS10_RMS100_FULL S2WA_7_PRO_5_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0024221155
  * RMSE:  3.37103   2.24916  
* ./rnn S2WA_7_PRO_1_PRO_2_PRO_3_ICA_DS10_RMS100_FULL S2WA_7_PRO_5_ICA_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0009793796
  * RMSE:  9.64397   4.88104  
* ./rnn S2WA_7_PRO_1_PRO_2_PRO_3_ICA_DS10_RMS100_FULL S2WA_7_PRO_5_ICA_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0008234453
  * RMSE:  9.51016   1.44876  

* ./rnn S2WA_7_PRO_1_PRO_2_PRO_3_PRO_4_ICA_DS10_RMS100_FULL S2WA_7_PRO_5_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0032103432
  * RMSE:  3.00184   2.41055  
* ./rnn S2WA_7_PRO_1_PRO_2_PRO_3_PRO_4_ICA_DS10_RMS100_FULL S2WA_7_PRO_5_ICA_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0009630158
  * RMSE:  4.73609   1.31613  
* ./rnn S2WA_7_PRO_1_PRO_2_PRO_3_PRO_4_ICA_DS10_RMS100_FULL S2WA_7_PRO_5_ICA_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0006613236
  * RMSE:  4.66271   1.09916  

---

### 7th Experiment - LSTM, ICA, RMS @ 100pts, Downsampled @ 10hz - 
                      FULL-FULL - Generalization

* ./rnn S2WA_7_SUP_1_SUP_2_SUP_3_SUP_4_PRO_1_PRO_2_PRO_3_PRO_4_ICA_DS10_RMS100_FULL S2WA_7_SUP_5_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0040592576
  * RMSE:  9.04460   1.36656  
* ./rnn S2WA_7_SUP_1_SUP_2_SUP_3_SUP_4_PRO_1_PRO_2_PRO_3_PRO_4_ICA_DS10_RMS100_FULL S2WA_7_SUP_5_ICA_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0031876761
  * RMSE: 11.47335   1.73839  
* ./rnn S2WA_7_SUP_1_SUP_2_SUP_3_SUP_4_PRO_1_PRO_2_PRO_3_PRO_4_ICA_DS10_RMS100_FULL S2WA_7_SUP_5_ICA_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0023911528
  * RMSE: 16.05255   1.68962  

* ./rnn S2WA_7_SUP_1_SUP_2_SUP_3_SUP_4_PRO_1_PRO_2_PRO_3_PRO_4_ICA_DS10_RMS100_FULL S2WA_7_PRO_5_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0036763686
  * RMSE: 17.64306   2.12164  
* ./rnn S2WA_7_SUP_1_SUP_2_SUP_3_SUP_4_PRO_1_PRO_2_PRO_3_PRO_4_ICA_DS10_RMS100_FULL S2WA_7_PRO_5_ICA_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0026397925
  * RMSE:  3.92200   1.06213  
* ./rnn S2WA_7_SUP_1_SUP_2_SUP_3_SUP_4_PRO_1_PRO_2_PRO_3_PRO_4_ICA_DS10_RMS100_FULL S2WA_7_PRO_5_ICA_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0046555166
  * RMSE:  3.85185   1.45920  

---

### 7th Experiment - LSTM, ICA, RMS @ 100pts, Downsampled @ 10hz - 
                      FULL-FULL

* ./rnn S2WA_7_SUP_1_SUP_2_SUP_3_SUP_4_PRO_1_PRO_2_PRO_3_PRO_4_ICA_DS10_RMS100_FULL S2WA_7_PROSUP_1_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0037498023
  * RMSE: 23.90645   3.71485  
* ./rnn S2WA_7_SUP_1_SUP_2_SUP_3_SUP_4_PRO_1_PRO_2_PRO_3_PRO_4_ICA_DS10_RMS100_FULL S2WA_7_PROSUP_1_ICA_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0052592378
  * RMSE: 16.87706   1.89552  
* ./rnn S2WA_7_SUP_1_SUP_2_SUP_3_SUP_4_PRO_1_PRO_2_PRO_3_PRO_4_ICA_DS10_RMS100_FULL S2WA_7_PROSUP_1_ICA_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0033522171
  * RMSE: 40.23676   4.59334  

* ./rnn S2WA_7_SUP_1_SUP_2_SUP_3_SUP_4_SUP_5_PRO_1_PRO_2_PRO_3_PRO_4_PRO_5_ICA_DS10_RMS100_FULL S2WA_7_PROSUP_1_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0041098271
  * RMSE:  9.78385   2.20936  
* ./rnn S2WA_7_SUP_1_SUP_2_SUP_3_SUP_4_SUP_5_PRO_1_PRO_2_PRO_3_PRO_4_PRO_5_ICA_DS10_RMS100_FULL S2WA_7_PROSUP_1_ICA_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0399147782
  * RMSE: 27.93794   2.58673  
* ./rnn S2WA_7_SUP_1_SUP_2_SUP_3_SUP_4_SUP_5_PRO_1_PRO_2_PRO_3_PRO_4_PRO_5_ICA_DS10_RMS100_FULL S2WA_7_PROSUP_1_ICA_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0027266427
  * RMSE: 22.44490   2.12451  

* ./rnn S2WA_7_SUP_1_SUP_2_SUP_3_SUP_4_PRO_1_PRO_2_PRO_3_PRO_4_ICA_DS10_RMS100_FULL S2WA_7_PROSUP_2_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0045518759
  * RMSE: 35.06629   2.78634  
* ./rnn S2WA_7_SUP_1_SUP_2_SUP_3_SUP_4_PRO_1_PRO_2_PRO_3_PRO_4_ICA_DS10_RMS100_FULL S2WA_7_PROSUP_2_ICA_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0029933059
  * RMSE: 31.74835   3.28841  
* ./rnn S2WA_7_SUP_1_SUP_2_SUP_3_SUP_4_PRO_1_PRO_2_PRO_3_PRO_4_ICA_DS10_RMS100_FULL S2WA_7_PROSUP_2_ICA_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0023252016
  * RMSE: 18.63451   2.38656  

* ./rnn S2WA_7_SUP_1_SUP_2_SUP_3_SUP_4_SUP_5_PRO_1_PRO_2_PRO_3_PRO_4_PRO_5_ICA_DS10_RMS100_FULL S2WA_7_PROSUP_2_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0051521523
  * RMSE: 32.53738   4.09561  
* ./rnn S2WA_7_SUP_1_SUP_2_SUP_3_SUP_4_SUP_5_PRO_1_PRO_2_PRO_3_PRO_4_PRO_5_ICA_DS10_RMS100_FULL S2WA_7_PROSUP_2_ICA_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0032094703
  * RMSE: 22.48102   2.94761  
* ./rnn S2WA_7_SUP_1_SUP_2_SUP_3_SUP_4_SUP_5_PRO_1_PRO_2_PRO_3_PRO_4_PRO_5_ICA_DS10_RMS100_FULL S2WA_7_PROSUP_2_ICA_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0029330680
  * RMSE: 16.99531   2.36372  

* ./rnn S2WA_7_SUP_1_SUP_2_SUP_3_SUP_4_PRO_1_PRO_2_PRO_3_PRO_4_PROSUP_2_ICA_DS10_RMS100_FULL S2WA_7_PROSUP_1_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0056620833
  * RMSE:  7.92151   1.66416  
* ./rnn S2WA_7_SUP_1_SUP_2_SUP_3_SUP_4_PRO_1_PRO_2_PRO_3_PRO_4_PROSUP_2_ICA_DS10_RMS100_FULL S2WA_7_PROSUP_1_ICA_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0108430699
  * RMSE:  8.56467   1.37084  
* ./rnn S2WA_7_SUP_1_SUP_2_SUP_3_SUP_4_PRO_1_PRO_2_PRO_3_PRO_4_PROSUP_2_ICA_DS10_RMS100_FULL S2WA_7_PROSUP_1_ICA_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0081660871
  * RMSE: 43.65935  17.34041  

* ./rnn S2WA_7_SUP_1_SUP_2_SUP_3_SUP_4_SUP_5_PRO_1_PRO_2_PRO_3_PRO_4_PRO_5_PROSUP_1_ICA_DS10_RMS100_FULL S2WA_7_PROSUP_2_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0061058042
  * RMSE: 19.48591   2.85601  
* ./rnn S2WA_7_SUP_1_SUP_2_SUP_3_SUP_4_SUP_5_PRO_1_PRO_2_PRO_3_PRO_4_PRO_5_PROSUP_1_ICA_DS10_RMS100_FULL S2WA_7_PROSUP_2_ICA_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0041812153
  * RMSE: 21.43297   3.04650  
* ./rnn S2WA_7_SUP_1_SUP_2_SUP_3_SUP_4_SUP_5_PRO_1_PRO_2_PRO_3_PRO_4_PRO_5_PROSUP_1_ICA_DS10_RMS100_FULL S2WA_7_PROSUP_2_ICA_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0030696310
  * RMSE: 10.44624   1.68184  
* ./rnn S2WA_7_SUP_1_SUP_2_SUP_3_SUP_4_SUP_5_PRO_1_PRO_2_PRO_3_PRO_4_PRO_5_PROSUP_1_ICA_DS10_RMS100_FULL S2WA_7_PROSUP_2_ICA_DS10_RMS100_FULL 8 8000 10 100000 4
  * average loss at epoch:       7999 = 0.0029137783
  * RMSE: 22.14720   2.89762  


* ./rnn S2WA_7_SUP_1_SUP_2_SUP_3_SUP_4_SUP_5_PRO_1_PRO_2_PRO_3_PRO_4_PRO_5_PROSUP_1_ICA_DS10_RMS100_FULL S2WA_7_PROSUP_2_ICA_DS10_RMS100_FULL 12 1000 10 100000 4
  * average loss at epoch:        999 = 0.0080195558
  * RMSE: 15.59075   2.65175 
* ./rnn S2WA_7_SUP_1_SUP_2_SUP_3_SUP_4_SUP_5_PRO_1_PRO_2_PRO_3_PRO_4_PRO_5_PROSUP_1_ICA_DS10_RMS100_FULL S2WA_7_PROSUP_2_ICA_DS10_RMS100_FULL 12 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0127237767
  * RMSE: 11.90871   3.96421   
* ./rnn S2WA_7_SUP_1_SUP_2_SUP_3_SUP_4_SUP_5_PRO_1_PRO_2_PRO_3_PRO_4_PRO_5_PROSUP_1_ICA_DS10_RMS100_FULL S2WA_7_PROSUP_2_ICA_DS10_RMS100_FULL 12 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0061716559
  * RMSE: 10.60284   3.26605  

* ./rnn S2WA_7_SUP_1_SUP_2_SUP_3_SUP_4_SUP_5_PRO_1_PRO_2_PRO_3_PRO_4_PRO_5_PROSUP_1_ICA_DS10_RMS100_FULL S2WA_7_PROSUP_2_ICA_DS10_RMS100_FULL 16 1000 10 100000 4
  * average loss at epoch:        999 = 0.0062973151
  * RMSE: 15.93996   2.10229  
* ./rnn S2WA_7_SUP_1_SUP_2_SUP_3_SUP_4_SUP_5_PRO_1_PRO_2_PRO_3_PRO_4_PRO_5_PROSUP_1_ICA_DS10_RMS100_FULL S2WA_7_PROSUP_2_ICA_DS10_RMS100_FULL 16 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0033293007
  * RMSE: 11.70457   1.95300  

* ./rnn S2WA_7_SUP_1_SUP_2_SUP_3_SUP_4_SUP_5_PRO_1_PRO_2_PRO_3_PRO_4_PRO_5_PROSUP_1_ICA_DS10_RMS100_FULL S2WA_7_PROSUP_2_ICA_DS10_RMS100_FULL 32 1000 10 100000 4
  * average loss at epoch:        999 = 0.0073968286
  * RMSE: 16.54629   8.12443  
* ./rnn S2WA_7_SUP_1_SUP_2_SUP_3_SUP_4_SUP_5_PRO_1_PRO_2_PRO_3_PRO_4_PRO_5_PROSUP_1_ICA_DS10_RMS100_FULL S2WA_7_PROSUP_2_ICA_DS10_RMS100_FULL 32 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0149955576
  * RMSE: 18.79429   3.17506  


---

### 7th Experiment - Notes

* Supinator Muscle electrode perpendicular to arm gives
  smaller amplitude, comparing to 30d to perpendicular
* Rotation assisting device need to be fixed in place to avoid leaning forward.
  * To produce clear signal

---

### 7th Experiment - Issue

* Pronation performance still worse than Supination due to *Torque and Gravity* issue
