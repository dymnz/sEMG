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
    * S2WA_7_SUP_ (S2WA_6_FREE_SUP_ for no device support)
  * Extension/Flexion: Full range. From 0d move toward 90d then pause. Start moving toward 0d then pause. From 0d move toward -90d then pause. Start moving toward 0d then stop.
    * S2WA_7_PROSUP_ (S2WA_6_FREE_PROSUP_ for no device support)
  * Pattern
    * _1: Fixed_amp Fixed_interval, long pause  (train)
    * _2: Fixed_amp Var_interval, long pause    (train)
    * _3: Var_amp Var_interval, long pause      (train/test)
    * _4: Var_amp Var_interval, long pause      (test)
    * _5: Var_amp Var_interval, brief pause     (test)

---  

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

### 7th Experiment - Notes

* Supinator Muscle electrode perpendicular to arm gives
  smaller amplitude, comparing to 30d to perpendicular
* Rotation assisting device need to be fixed in place to avoid leaning forward.
  * To produce clear signal