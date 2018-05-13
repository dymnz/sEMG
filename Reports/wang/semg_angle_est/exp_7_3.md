### 7-3th Experiment

Torque & Gravity Issue, see exp_7. New ICA normalization, ICA after downsample.

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

### 7-3th Experiment - LSTM, ICA, RMS @ 100pts, Downsampled @ 10hz - FULL-FULL - self

* ./rnn S2WA_7_SUP_1_newICA_DS10_RMS100_FULL S2WA_7_SUP_1_newICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0027053002
  * RMSE:  4.23440   1.80253  
* ./rnn S2WA_7_SUP_1_newICA_DS10_RMS100_FULL S2WA_7_SUP_1_newICA_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0017979969
  * RMSE:  3.40372   1.78972  
* ./rnn S2WA_7_SUP_1_newICA_DS10_RMS100_FULL S2WA_7_SUP_1_newICA_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0016042431
  * RMSE:  3.18995   1.67697  

* ./rnn S2WA_7_SUP_2_newICA_DS10_RMS100_FULL S2WA_7_SUP_2_newICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0045396428
  * RMSE:  5.47699   2.99505  
* ./rnn S2WA_7_SUP_2_newICA_DS10_RMS100_FULL S2WA_7_SUP_2_newICA_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0022389513
  * RMSE:  4.03316   1.65339  
* ./rnn S2WA_7_SUP_2_newICA_DS10_RMS100_FULL S2WA_7_SUP_2_newICA_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0025912038
  * RMSE:  4.14913   2.17051  

* ./rnn S2WA_7_SUP_3_newICA_DS10_RMS100_FULL S2WA_7_SUP_3_newICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0037423914
  * RMSE:  5.13911   1.49316  
* ./rnn S2WA_7_SUP_3_newICA_DS10_RMS100_FULL S2WA_7_SUP_3_newICA_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0037634955
  * RMSE:  5.13292   1.23605  
* ./rnn S2WA_7_SUP_3_newICA_DS10_RMS100_FULL S2WA_7_SUP_3_newICA_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0012861687
  * RMSE:  2.75648   1.55472  

* ./rnn S2WA_7_SUP_4_newICA_DS10_RMS100_FULL S2WA_7_SUP_4_newICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0100059356
  * RMSE:  8.62332   3.36675  
* ./rnn S2WA_7_SUP_4_newICA_DS10_RMS100_FULL S2WA_7_SUP_4_newICA_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0036247983
  * RMSE:  5.33446   0.98439  
* ./rnn S2WA_7_SUP_4_newICA_DS10_RMS100_FULL S2WA_7_SUP_4_newICA_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0027064197
  * RMSE:  4.59739   1.08453  

* ./rnn S2WA_7_SUP_5_newICA_DS10_RMS100_FULL S2WA_7_SUP_5_newICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0046617459
  * RMSE:  5.82961   1.83758  
* ./rnn S2WA_7_SUP_5_newICA_DS10_RMS100_FULL S2WA_7_SUP_5_newICA_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0032580474
  * RMSE:  4.77682   1.79739  
* ./rnn S2WA_7_SUP_5_newICA_DS10_RMS100_FULL S2WA_7_SUP_5_newICA_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0012131011
  * RMSE:  2.98632   1.07174  

---


* ./rnn S2WA_7_PRO_1_newICA_DS10_RMS100_FULL S2WA_7_PRO_1_newICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0025903513
  * RMSE:  3.89942   2.43592  
* ./rnn S2WA_7_PRO_1_newICA_DS10_RMS100_FULL S2WA_7_PRO_1_newICA_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0011975309
  * RMSE:  2.57296   1.92871  
* ./rnn S2WA_7_PRO_1_newICA_DS10_RMS100_FULL S2WA_7_PRO_1_newICA_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0008975609
  * RMSE:  2.07296   1.70388  

* ./rnn S2WA_7_PRO_2_newICA_DS10_RMS100_FULL S2WA_7_PRO_2_newICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0024343355
  * RMSE:  3.22166   3.08127  
* ./rnn S2WA_7_PRO_2_newICA_DS10_RMS100_FULL S2WA_7_PRO_2_newICA_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0016537558
  * RMSE:  2.94985   2.13126  
* ./rnn S2WA_7_PRO_2_newICA_DS10_RMS100_FULL S2WA_7_PRO_2_newICA_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0014701709
  * RMSE:  2.78236   2.05767  

* ./rnn S2WA_7_PRO_3_newICA_DS10_RMS100_FULL S2WA_7_PRO_3_newICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0022737830
  * RMSE:  3.49386   2.44598  
* ./rnn S2WA_7_PRO_3_newICA_DS10_RMS100_FULL S2WA_7_PRO_3_newICA_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0017423383
  * RMSE:  2.86538   2.42426  
* ./rnn S2WA_7_PRO_3_newICA_DS10_RMS100_FULL S2WA_7_PRO_3_newICA_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0008625912
  * RMSE:  2.51626   0.99500  

* ./rnn S2WA_7_PRO_4_newICA_DS10_RMS100_FULL S2WA_7_PRO_4_newICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0021915896
  * RMSE:  4.02552   1.10007  
* ./rnn S2WA_7_PRO_4_newICA_DS10_RMS100_FULL S2WA_7_PRO_4_newICA_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0017160927
  * RMSE:  2.73614   2.57495  
* ./rnn S2WA_7_PRO_4_newICA_DS10_RMS100_FULL S2WA_7_PRO_4_newICA_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0015409008
  * RMSE:  2.73919   2.19140  

* ./rnn S2WA_7_PRO_5_newICA_DS10_RMS100_FULL S2WA_7_PRO_5_newICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0020652715
  * RMSE:  3.66640   2.00366  
* ./rnn S2WA_7_PRO_5_newICA_DS10_RMS100_FULL S2WA_7_PRO_5_newICA_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0012809029
  * RMSE:  2.39453   2.09519  
* ./rnn S2WA_7_PRO_5_newICA_DS10_RMS100_FULL S2WA_7_PRO_5_newICA_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0011422103
  * RMSE:  2.27629   1.98277  

---

### 7-3th Experiment - LSTM, ICA, RMS @ 100pts, Downsampled @ 10hz - FULL-FULL - Cross



* ./rnn S2WA_7_SUP_1_SUP_2_newICA_DS10_RMS100_FULL S2WA_7_SUP_3_newICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0035830896
  * RMSE:  7.52689   1.90293  
* ./rnn S2WA_7_SUP_1_SUP_2_newICA_DS10_RMS100_FULL S2WA_7_SUP_3_newICA_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0024246784
  * RMSE:  6.78380   1.58317  
* ./rnn S2WA_7_SUP_1_SUP_2_newICA_DS10_RMS100_FULL S2WA_7_SUP_3_newICA_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0007308644
  * RMSE:  7.26973   1.92824  

* ./rnn S2WA_7_SUP_1_SUP_2_SUP_3_newICA_DS10_RMS100_FULL S2WA_7_SUP_4_newICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0032850234
  * RMSE:  8.70493   1.94755  
* ./rnn S2WA_7_SUP_1_SUP_2_SUP_3_newICA_DS10_RMS100_FULL S2WA_7_SUP_4_newICA_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0034497159
  * RMSE:  6.07161   2.22028  
* ./rnn S2WA_7_SUP_1_SUP_2_SUP_3_newICA_DS10_RMS100_FULL S2WA_7_SUP_4_newICA_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0047173270
  * RMSE:  7.55486   1.50320  

* ./rnn S2WA_7_SUP_1_SUP_2_SUP_3_newICA_DS10_RMS100_FULL S2WA_7_SUP_5_newICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0029876837
  * RMSE: 10.09532   2.90551  
* ./rnn S2WA_7_SUP_1_SUP_2_SUP_3_newICA_DS10_RMS100_FULL S2WA_7_SUP_5_newICA_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0017657974
  * RMSE: 11.28202   1.86904  
* ./rnn S2WA_7_SUP_1_SUP_2_SUP_3_newICA_DS10_RMS100_FULL S2WA_7_SUP_5_newICA_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3999 = 0.1384775495
  * RMSE: 12.91146   1.01904  

* ./rnn S2WA_7_SUP_1_SUP_2_SUP_3_SUP_4_newICA_DS10_RMS100_FULL S2WA_7_SUP_5_newICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0030741075
  * RMSE:  9.05716   1.16951  
* ./rnn S2WA_7_SUP_1_SUP_2_SUP_3_SUP_4_newICA_DS10_RMS100_FULL S2WA_7_SUP_5_newICA_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0165261405
  * RMSE: 11.83008   1.64021  
* ./rnn S2WA_7_SUP_1_SUP_2_SUP_3_SUP_4_newICA_DS10_RMS100_FULL S2WA_7_SUP_5_newICA_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0027567322
  * RMSE:  8.62576   0.90483  

---

* ./rnn S2WA_7_PRO_1_PRO_2_newICA_DS10_RMS100_FULL S2WA_7_PRO_3_newICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0023329065
  * RMSE:  7.72447   2.89600  
* ./rnn S2WA_7_PRO_1_PRO_2_newICA_DS10_RMS100_FULL S2WA_7_PRO_3_newICA_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0016844300
  * RMSE:  5.75682   1.87407  
* ./rnn S2WA_7_PRO_1_PRO_2_newICA_DS10_RMS100_FULL S2WA_7_PRO_3_newICA_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0007389958
  * RMSE:  7.39724   1.62868  

* ./rnn S2WA_7_PRO_1_PRO_2_PRO_3_newICA_DS10_RMS100_FULL S2WA_7_PRO_4_newICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0026597304
  * RMSE:  8.10562  17.10577  
* ./rnn S2WA_7_PRO_1_PRO_2_PRO_3_newICA_DS10_RMS100_FULL S2WA_7_PRO_4_newICA_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0018569282
  * RMSE:  4.53104   2.13805  
* ./rnn S2WA_7_PRO_1_PRO_2_PRO_3_newICA_DS10_RMS100_FULL S2WA_7_PRO_4_newICA_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0008958847
  * RMSE:  3.99056   1.16314  

* ./rnn S2WA_7_PRO_1_PRO_2_PRO_3_newICA_DS10_RMS100_FULL S2WA_7_PRO_5_newICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0026651375
  * RMSE:  3.92047   1.54668  
* ./rnn S2WA_7_PRO_1_PRO_2_PRO_3_newICA_DS10_RMS100_FULL S2WA_7_PRO_5_newICA_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0015836767
  * RMSE:  5.12636   1.34922  
* ./rnn S2WA_7_PRO_1_PRO_2_PRO_3_newICA_DS10_RMS100_FULL S2WA_7_PRO_5_newICA_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0010783774
  * RMSE:  6.54319   1.84349  

* ./rnn S2WA_7_PRO_1_PRO_2_PRO_3_PRO_4_newICA_DS10_RMS100_FULL S2WA_7_PRO_5_newICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0024700261
  * RMSE:  3.19338   1.71812  
* ./rnn S2WA_7_PRO_1_PRO_2_PRO_3_PRO_4_newICA_DS10_RMS100_FULL S2WA_7_PRO_5_newICA_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0014533594
  * RMSE:  3.36637   1.51860  
* ./rnn S2WA_7_PRO_1_PRO_2_PRO_3_PRO_4_newICA_DS10_RMS100_FULL S2WA_7_PRO_5_newICA_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0010124173
  * RMSE:  5.31284   1.22917  

---

### 7-3th Experiment - LSTM, ICA, RMS @ 100pts, Downsampled @ 10hz - 
                      FULL-FULL - Generalization


* ./rnn S2WA_7_SUP_1_SUP_2_SUP_3_SUP_4_PRO_1_PRO_2_PRO_3_PRO_4_newICA_DS10_RMS100_FULL S2WA_7_SUP_5_newICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0040602451
  * RMSE:  7.65764   2.48838  
* ./rnn S2WA_7_SUP_1_SUP_2_SUP_3_SUP_4_PRO_1_PRO_2_PRO_3_PRO_4_newICA_DS10_RMS100_FULL S2WA_7_SUP_5_newICA_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0037104612
  * RMSE: 10.82831   1.92428  
* ./rnn S2WA_7_SUP_1_SUP_2_SUP_3_SUP_4_PRO_1_PRO_2_PRO_3_PRO_4_newICA_DS10_RMS100_FULL S2WA_7_SUP_5_newICA_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0015595765
  * RMSE: 10.87710   1.64176  

* ./rnn S2WA_7_SUP_1_SUP_2_SUP_3_SUP_4_PRO_1_PRO_2_PRO_3_PRO_4_newICA_DS10_RMS100_FULL S2WA_7_PRO_5_newICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0032695614
  * RMSE:  4.93615   1.28605  
* ./rnn S2WA_7_SUP_1_SUP_2_SUP_3_SUP_4_PRO_1_PRO_2_PRO_3_PRO_4_newICA_DS10_RMS100_FULL S2WA_7_PRO_5_newICA_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0027715831
  * RMSE:  4.83063   1.20913  
* ./rnn S2WA_7_SUP_1_SUP_2_SUP_3_SUP_4_PRO_1_PRO_2_PRO_3_PRO_4_newICA_DS10_RMS100_FULL S2WA_7_PRO_5_newICA_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0023813085
  * RMSE:  5.72353   1.58618  

---

### 7-3th Experiment - LSTM, ICA, RMS @ 100pts, Downsampled @ 10hz - 
                      FULL-FULL




* ./rnn S2WA_7_SUP_1_SUP_2_SUP_3_SUP_4_PRO_1_PRO_2_PRO_3_PRO_4_newICA_DS10_RMS100_FULL S2WA_7_PROSUP_1_newICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0029819753
  * RMSE:  9.65721   2.84589  
* ./rnn S2WA_7_SUP_1_SUP_2_SUP_3_SUP_4_PRO_1_PRO_2_PRO_3_PRO_4_newICA_DS10_RMS100_FULL S2WA_7_PROSUP_1_newICA_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0028974094
  * RMSE: 13.51000   3.02387  
* ./rnn S2WA_7_SUP_1_SUP_2_SUP_3_SUP_4_PRO_1_PRO_2_PRO_3_PRO_4_newICA_DS10_RMS100_FULL S2WA_7_PROSUP_1_newICA_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0046745693
  * RMSE: 10.62471   1.77629  


* ./rnn S2WA_7_SUP_1_SUP_2_SUP_3_SUP_4_SUP_5_PRO_1_PRO_2_PRO_3_PRO_4_PRO_5_newICA_DS10_RMS100_FULL S2WA_7_PROSUP_1_newICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0037420461
  * RMSE: 12.56935   1.38308  
* ./rnn S2WA_7_SUP_1_SUP_2_SUP_3_SUP_4_SUP_5_PRO_1_PRO_2_PRO_3_PRO_4_PRO_5_newICA_DS10_RMS100_FULL S2WA_7_PROSUP_1_newICA_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0034926509
  * RMSE:  9.35446   1.42566  
* ./rnn S2WA_7_SUP_1_SUP_2_SUP_3_SUP_4_SUP_5_PRO_1_PRO_2_PRO_3_PRO_4_PRO_5_newICA_DS10_RMS100_FULL S2WA_7_PROSUP_1_newICA_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0027618528
  * RMSE: 25.61320   4.51063  

* ./rnn S2WA_7_SUP_1_SUP_2_SUP_3_SUP_4_PRO_1_PRO_2_PRO_3_PRO_4_newICA_DS10_RMS100_FULL S2WA_7_PROSUP_2_newICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0030866378
  * RMSE: 25.54162   6.35714  
* ./rnn S2WA_7_SUP_1_SUP_2_SUP_3_SUP_4_PRO_1_PRO_2_PRO_3_PRO_4_newICA_DS10_RMS100_FULL S2WA_7_PROSUP_2_newICA_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0026267622
  * RMSE: 227.82104 180.27153 
* ./rnn S2WA_7_SUP_1_SUP_2_SUP_3_SUP_4_PRO_1_PRO_2_PRO_3_PRO_4_newICA_DS10_RMS100_FULL S2WA_7_PROSUP_2_newICA_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0020328047
  * RMSE: 21.62861   1.95403  

* ./rnn S2WA_7_SUP_1_SUP_2_SUP_3_SUP_4_SUP_5_PRO_1_PRO_2_PRO_3_PRO_4_PRO_5_newICA_DS10_RMS100_FULL S2WA_7_PROSUP_2_newICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0043105980
  * RMSE: 22.57154  13.22695  
* ./rnn S2WA_7_SUP_1_SUP_2_SUP_3_SUP_4_SUP_5_PRO_1_PRO_2_PRO_3_PRO_4_PRO_5_newICA_DS10_RMS100_FULL S2WA_7_PROSUP_2_newICA_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0030785861
  * RMSE: 35.76889   4.59915
* ./rnn S2WA_7_SUP_1_SUP_2_SUP_3_SUP_4_SUP_5_PRO_1_PRO_2_PRO_3_PRO_4_PRO_5_newICA_DS10_RMS100_FULL S2WA_7_PROSUP_2_newICA_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0022838931
  * RMSE: 13.98147   4.16899  

* ./rnn S2WA_7_SUP_1_SUP_2_SUP_3_SUP_4_PRO_1_PRO_2_PRO_3_PRO_4_PROSUP_2_newICA_DS10_RMS100_FULL S2WA_7_PROSUP_1_newICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0049711716
  * RMSE: 19.62561   1.79711  
* ./rnn S2WA_7_SUP_1_SUP_2_SUP_3_SUP_4_PRO_1_PRO_2_PRO_3_PRO_4_PROSUP_2_newICA_DS10_RMS100_FULL S2WA_7_PROSUP_1_newICA_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0039538466
  * RMSE: 24.96805   2.49457  
* ./rnn S2WA_7_SUP_1_SUP_2_SUP_3_SUP_4_PRO_1_PRO_2_PRO_3_PRO_4_PROSUP_2_newICA_DS10_RMS100_FULL S2WA_7_PROSUP_1_newICA_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0040966508
  * RMSE:  8.26529   1.49581  

* ./rnn S2WA_7_SUP_1_SUP_2_SUP_3_SUP_4_SUP_5_PRO_1_PRO_2_PRO_3_PRO_4_PRO_5_PROSUP_1_newICA_DS10_RMS100_FULL S2WA_7_PROSUP_2_newICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.3712128487
  * RMSE: 19.15357   3.86181  
* ./rnn S2WA_7_SUP_1_SUP_2_SUP_3_SUP_4_SUP_5_PRO_1_PRO_2_PRO_3_PRO_4_PRO_5_PROSUP_1_newICA_DS10_RMS100_FULL S2WA_7_PROSUP_2_newICA_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0051391586
  * RMSE: 24.49663   4.16300  
* ./rnn S2WA_7_SUP_1_SUP_2_SUP_3_SUP_4_SUP_5_PRO_1_PRO_2_PRO_3_PRO_4_PRO_5_PROSUP_1_newICA_DS10_RMS100_FULL S2WA_7_PROSUP_2_newICA_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0030978520
  * RMSE: 13.68340   2.14823  

* ./rnn S2WA_7_SUP_1_SUP_2_SUP_3_SUP_4_SUP_5_PRO_1_PRO_2_PRO_3_PRO_4_PRO_5_PROSUP_1_newICA_DS10_RMS100_FULL S2WA_7_PROSUP_2_newICA_DS10_RMS100_FULL 16 1000 10 100000 4
  * average loss at epoch:        999 = 0.0040549845
  * RMSE: 19.36229   3.13434  
* ./rnn S2WA_7_SUP_1_SUP_2_SUP_3_SUP_4_SUP_5_PRO_1_PRO_2_PRO_3_PRO_4_PRO_5_PROSUP_1_newICA_DS10_RMS100_FULL S2WA_7_PROSUP_2_newICA_DS10_RMS100_FULL 16 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0036534204
  * RMSE: 21.91563   4.78248  
* ./rnn S2WA_7_SUP_1_SUP_2_SUP_3_SUP_4_SUP_5_PRO_1_PRO_2_PRO_3_PRO_4_PRO_5_PROSUP_1_newICA_DS10_RMS100_FULL S2WA_7_PROSUP_2_newICA_DS10_RMS100_FULL 16 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0130199864
  * RMSE: 13.07450   3.05717  
* ./rnn S2WA_7_SUP_1_SUP_2_SUP_3_SUP_4_SUP_5_PRO_1_PRO_2_PRO_3_PRO_4_PRO_5_PROSUP_1_newICA_DS10_RMS100_FULL S2WA_7_PROSUP_2_newICA_DS10_RMS100_FULL 16 8000 10 100000 4
  * average loss at epoch:       7999 = 0.0082041571
  * RMSE: 10.94577   3.67498  

