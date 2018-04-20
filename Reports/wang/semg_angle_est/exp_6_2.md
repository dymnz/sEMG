### 6-2th Experiment

Supination/Pronation part 3. Free hand.

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

### 6-2th Experiment - LSTM, RMS @ 100pts, Downsampled @ 10hz - FULL-FULL - self

* ./rnn S2WA_6_FREE_SUP_1_ICA_DS10_RMS100_FULL S2WA_6_FREE_SUP_1_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0026806760
  * RMSE:  4.13521   1.92828  
* ./rnn S2WA_6_FREE_SUP_1_ICA_DS10_RMS100_FULL S2WA_6_FREE_SUP_1_ICA_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0023008861
  * RMSE:  4.08451   1.13229  
* ./rnn S2WA_6_FREE_SUP_1_ICA_DS10_RMS100_FULL S2WA_6_FREE_SUP_1_ICA_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0019002087
  * RMSE:  3.46167   1.77788  

* ./rnn S2WA_6_FREE_SUP_2_ICA_DS10_RMS100_FULL S2WA_6_FREE_SUP_2_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0034568388
  * RMSE:  5.01316   1.50509  
* ./rnn S2WA_6_FREE_SUP_2_ICA_DS10_RMS100_FULL S2WA_6_FREE_SUP_2_ICA_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0012550693
  * RMSE:  2.90448   1.58561  
* ./rnn S2WA_6_FREE_SUP_2_ICA_DS10_RMS100_FULL S2WA_6_FREE_SUP_2_ICA_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0010864071
  * RMSE:  2.40039   1.77950  
 
* ./rnn S2WA_6_FREE_SUP_3_ICA_DS10_RMS100_FULL S2WA_6_FREE_SUP_3_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0024958835
  * RMSE:  3.12434   1.88283  
* ./rnn S2WA_6_FREE_SUP_3_ICA_DS10_RMS100_FULL S2WA_6_FREE_SUP_3_ICA_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0015116458
  * RMSE:  3.19875   1.49108  
* ./rnn S2WA_6_FREE_SUP_3_ICA_DS10_RMS100_FULL S2WA_6_FREE_SUP_3_ICA_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0012153744
  * RMSE:  2.91056   1.47407  

* ./rnn S2WA_6_FREE_PRO_1_ICA_DS10_RMS100_FULL S2WA_6_FREE_PRO_1_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0031530788
  * RMSE:  4.64574   2.08509  
* ./rnn S2WA_6_FREE_PRO_1_ICA_DS10_RMS100_FULL S2WA_6_FREE_PRO_1_ICA_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0027792295
  * RMSE:  4.35571   1.61012  
* ./rnn S2WA_6_FREE_PRO_1_ICA_DS10_RMS100_FULL S2WA_6_FREE_PRO_1_ICA_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0011771714
  * RMSE:  2.75561   1.36705  

* ./rnn S2WA_6_FREE_PRO_2_ICA_DS10_RMS100_FULL S2WA_6_FREE_PRO_2_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0049948994
  * RMSE:  6.17508   2.39836  
* ./rnn S2WA_6_FREE_PRO_2_ICA_DS10_RMS100_FULL S2WA_6_FREE_PRO_2_ICA_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0026432080
  * RMSE:  4.62728   1.74978  
* ./rnn S2WA_6_FREE_PRO_2_ICA_DS10_RMS100_FULL S2WA_6_FREE_PRO_2_ICA_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0010738363
  * RMSE:  3.10559   1.57465  

* ./rnn S2WA_6_FREE_PRO_3_ICA_DS10_RMS100_FULL S2WA_6_FREE_PRO_3_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0066240685
  * RMSE:  6.46557   3.32145  
* ./rnn S2WA_6_FREE_PRO_3_ICA_DS10_RMS100_FULL S2WA_6_FREE_PRO_3_ICA_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0017291961
  * RMSE:  3.24860   1.78339  
* ./rnn S2WA_6_FREE_PRO_3_ICA_DS10_RMS100_FULL S2WA_6_FREE_PRO_3_ICA_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0010680217
  * RMSE:  2.28831   1.92595  



---

### 6-2th Experiment - LSTM, ICA, RMS @ 100pts, Downsampled @ 10hz - FULL-FULL - cross

* ./rnn S2WA_6_FREE_SUP_1_SUP_2_ICA_DS10_RMS100_FULL S2WA_6_FREE_SUP_3_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0018362843
  * RMSE:  4.94787   1.48518  
* ./rnn S2WA_6_FREE_SUP_1_SUP_2_ICA_DS10_RMS100_FULL S2WA_6_FREE_SUP_3_ICA_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0018458423
  * RMSE:  5.60306   1.76644  
* ./rnn S2WA_6_FREE_SUP_1_SUP_2_ICA_DS10_RMS100_FULL S2WA_6_FREE_SUP_3_ICA_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0009988378
  * RMSE:  4.53947   1.34103  

* ./rnn S2WA_6_FREE_PRO_1_PRO_2_ICA_DS10_RMS100_FULL S2WA_6_FREE_PRO_3_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0026337295
  * RMSE: 15.36171   1.22700  
* ./rnn S2WA_6_FREE_PRO_1_PRO_2_ICA_DS10_RMS100_FULL S2WA_6_FREE_PRO_3_ICA_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0035105309
  * RMSE: 13.40465   1.47163  
* ./rnn S2WA_6_FREE_PRO_1_PRO_2_ICA_DS10_RMS100_FULL S2WA_6_FREE_PRO_3_ICA_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0010231649
  * RMSE: 16.76472   1.33769  
 

---

### 6-2th Experiment - LSTM, JOINT_ICA, RMS @ 100pts, Downsampled @ 10hz - FULL-FULL - cross


* ./rnn S2WA_6_FREE_PRO_1_PRO_2_SUP_1_SUP_2_ICA_DS10_RMS100_FULL S2WA_6_FREE_SUP_3_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0033199470
  * RMSE:  5.81210   1.52979  
* ./rnn S2WA_6_FREE_PRO_1_PRO_2_SUP_1_SUP_2_ICA_DS10_RMS100_FULL S2WA_6_FREE_SUP_3_ICA_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0025412299
  * RMSE:  6.85130   0.98416  
* ./rnn S2WA_6_FREE_PRO_1_PRO_2_SUP_1_SUP_2_ICA_DS10_RMS100_FULL S2WA_6_FREE_SUP_3_ICA_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0014318836
  * RMSE:  4.73069   0.77196  

* ./rnn S2WA_6_FREE_PRO_1_PRO_2_SUP_1_SUP_2_ICA_DS10_RMS100_FULL S2WA_6_FREE_PRO_3_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0040407539
  * RMSE: 15.18353   1.58474  
* ./rnn S2WA_6_FREE_PRO_1_PRO_2_SUP_1_SUP_2_ICA_DS10_RMS100_FULL S2WA_6_FREE_PRO_3_ICA_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0025487172
  * RMSE: 10.86932   1.14094  
* ./rnn S2WA_6_FREE_PRO_1_PRO_2_SUP_1_SUP_2_ICA_DS10_RMS100_FULL S2WA_6_FREE_PRO_3_ICA_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0015145862
  * RMSE: 13.03111   1.44912  

---

### 6-2th Experiment - LSTM, JOINT_ICA, RMS @ 100pts, Downsampled @ 10hz - FULL-FULL - PROSUP

From the validation above, epoch = 4000 should give the best result

* ./rnn S2WA_6_FREE_PRO_1_PRO_2_SUP_1_SUP_2_ICA_DS10_RMS100_FULL S2WA_6_FREE_PROSUP_1_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0037650290
  * RMSE: 30.90237   2.59211  
* ./rnn S2WA_6_FREE_PRO_1_PRO_2_SUP_1_SUP_2_ICA_DS10_RMS100_FULL S2WA_6_FREE_PROSUP_1_ICA_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0028303423
  * RMSE: 24.91441   2.36234  
* ./rnn S2WA_6_FREE_PRO_1_PRO_2_SUP_1_SUP_2_ICA_DS10_RMS100_FULL S2WA_6_FREE_PROSUP_1_ICA_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0011727611
  * RMSE: 34.28769   2.38791  
 
 

* ./rnn S2WA_6_FREE_PRO_1_PRO_2_PRO_3_SUP_1_SUP_2_SUP_3_ICA_DS10_RMS100_FULL S2WA_6_FREE_PROSUP_1_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0037458850
  * RMSE: 21.11593   2.22921  
* ./rnn S2WA_6_FREE_PRO_1_PRO_2_PRO_3_SUP_1_SUP_2_SUP_3_ICA_DS10_RMS100_FULL S2WA_6_FREE_PROSUP_1_ICA_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0021911377
  * RMSE: 28.50292   2.15521  
* ./rnn S2WA_6_FREE_PRO_1_PRO_2_PRO_3_SUP_1_SUP_2_SUP_3_ICA_DS10_RMS100_FULL S2WA_6_FREE_PROSUP_1_ICA_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0017752722
  * RMSE: 25.39881   1.53477  

### 6-2th Experiment - Notes

* PRO 12-cross-3 is bad
* PROSUP_1
  * Miss-classified supination, otherwise good result
  * May be fixed with more training example
* TBC exp_8  