### 10th Experiment

4-ch sEMG FLX/EXT(Pot.) & PRO/SUP(Gyro).

Target: RMSE < 10 degree

* Muscle:
  * PRO/SUP
    * Pronator Teres **(CH1, red)**
    * Supinator Muscle (CH2, light red)  
  * FLX/EXT
    * Flexor Carpi Radialis **(CH3, green)**
    * Extensor Carpi Ulnaris (CH4, light green)
* Protocol
  * Zero-load, palm facing down, making a fist
  * Forearm and Wrist are on the table. Hand should always contact the table, to avoid raising forearm.
  * Constant angular speed
  * 0 degree is defined as palm facing down flat on the table, 
    ~0 degree is defined as palm resting on table w/ thumb pointing up~, >0 as wrist turn right (SUP).
  * **Resting position is palm down, all muscle relaxed, 0  degree**
    * **The bias is removed in the preprocessing process, especially for Roll bias. (same in exp-5)**
  * Ref. electrode moved to wrist, follow the placement of other paper.
  * ~Fixed custom device to assist PRO/SUP motion to avoid Flexion/Extension of wrist~ Free hand to allow FLX/EXT
  * **Supinator Muscle electrode is 30d to perpendicular to arm**
  * Each dataset consists of 5~10 epoch w/ resting interval in between each epoch
  * R^2 error metric should be used to avoid bias for small value estimation
* Movement types
  * Pronation: <0 degree only. From 0d move toward -90d then pause. Start moving toward 0d then stop.
    * S2WA_10_PRO_ 
  * Supination: >0 degree only. From 0d move toward 90d then pause. Start moving toward 0d then stop.
    * S2WA_10_SUP_
  * Extension/Flexion: Full range. From 0d move toward 90d then pause. Start moving toward 0d then pause. From 0d move toward -90d then pause. Start moving toward 0d then stop.
    * S2WA_10_PROSUP_
  * Extension: <0 degree only. From 0d move toward 90d then pause. Start moving toward 0d then stop.
    * S2WA_10_EXT_
  * Flexion: >0 degree only. From 0d move toward -90d then pause. Start moving toward 0d then stop.
    * S2WA_10_FLX_
  * Extension/Flexion: Full range. From 0d move toward 90d then pause. Start moving toward 0d then pause. From 0d move toward -90d then pause. Start moving toward 0d then stop.
    * S2WA_10_FLXEXT_
  * Pattern
    * _1: Fixed_amp Fixed_interval, long pause  (train)
    * _2: Fixed_amp Var_interval, long pause    (train)
    * _3: Var_amp Var_interval, long pause      (train/test)
    * _4: Var_amp Var_interval, long pause      (test)
    * _5: Var_amp Var_interval, brief pause     (test)




---
### Experiment-10 - DoNothing, RMS @ 100pts, Downsampled @ 10hz

* ./rnn S2WA_10_PRO_1_PRO_2_PRO_4_DNO_DS10_RMS100_FULL S2WA_10_PRO_5_DNO_DS10_RMS100_FULL S2WA_10_PRO_3_DNO_DS10_RMS100_FULL 12 1000 10 100000 4
  * train loss at epoch:        797 = 0.0032242833 
  * best cross loss at epoch:        696 = 0.0025966218 
  * RMSE:  1.77276   6.29286  
* ./rnn S2WA_10_SUP_1_SUP_2_SUP_4_DNO_DS10_RMS100_FULL S2WA_10_SUP_5_DNO_DS10_RMS100_FULL S2WA_10_SUP_3_DNO_DS10_RMS100_FULL 12 1000 10 100000 4
  * train loss at epoch:        952 = 0.0062840451 
  * best cross loss at epoch:        851 = 0.0054837620 
  * RMSE:  1.99195  13.74427  
* ./rnn S2WA_10_FLX_1_FLX_2_FLX_4_DNO_DS10_RMS100_FULL S2WA_10_FLX_5_DNO_DS10_RMS100_FULL S2WA_10_FLX_3_DNO_DS10_RMS100_FULL 12 1000 10 100000 4
  * train loss at epoch:        439 = 0.0027210572 
  * best cross loss at epoch:        338 = 0.0039622815 
  * RMSE:  4.57237   2.18061  
* ./rnn S2WA_10_EXT_1_EXT_2_EXT_4_DNO_DS10_RMS100_FULL S2WA_10_EXT_5_DNO_DS10_RMS100_FULL S2WA_10_EXT_3_DNO_DS10_RMS100_FULL 12 1000 10 100000 4
  * train loss at epoch:        532 = 0.0045036908 
  * best cross loss at epoch:        431 = 0.0029560879 
  * RMSE:  7.97599   2.88841  

* ./rnn S2WA_10_PRO_1_PRO_2_PRO_5_DNO_DS10_RMS100_FULL S2WA_10_PRO_4_DNO_DS10_RMS100_FULL S2WA_10_PRO_3_DNO_DS10_RMS100_FULL 12 1000 10 100000 4
  * train loss at epoch:        833 = 0.0029851952 
  * best cross loss at epoch:        732 = 0.0033087627 
  * RMSE:  1.64178   3.90404  
* ./rnn S2WA_10_SUP_1_SUP_2_SUP_5_DNO_DS10_RMS100_FULL S2WA_10_SUP_4_DNO_DS10_RMS100_FULL S2WA_10_SUP_3_DNO_DS10_RMS100_FULL 12 1000 10 100000 4
  * train loss at epoch:        493 = 0.0049531061 
  * best cross loss at epoch:        392 = 0.0063356589 
  * RMSE:  3.35885   7.00614  
* ./rnn S2WA_10_FLX_1_FLX_2_FLX_5_DNO_DS10_RMS100_FULL S2WA_10_FLX_4_DNO_DS10_RMS100_FULL S2WA_10_FLX_3_DNO_DS10_RMS100_FULL 12 1000 10 100000 4
  * train loss at epoch:       1000 = 0.0011339687 
  * best cross loss at epoch:        971 = 0.0022971627 
  * RMSE:  3.87772   1.91251  
* ./rnn S2WA_10_EXT_1_EXT_2_EXT_5_DNO_DS10_RMS100_FULL S2WA_10_EXT_4_DNO_DS10_RMS100_FULL S2WA_10_EXT_3_DNO_DS10_RMS100_FULL 12 1000 10 100000 4
  * train loss at epoch:       1000 = 0.0032003816 
  * best cross loss at epoch:        999 = 0.0075080971 
  * RMSE:  9.11923   3.32811  

* ./rnn S2WA_10_PRO_1_PRO_2_PRO_3_PRO_5_SUP_1_SUP_2_SUP_3_SUP_5_PROSUP_2_DNO_DS10_RMS100_FULL S2WA_10_PROSUP_1_DNO_DS10_RMS100_FULL S2WA_10_SUP_4_PRO_4_PROSUP_3_DNO_DS10_RMS100_FULL 12 1000 10 100000 4
  * train loss at epoch:        888 = 0.0120773692 
  * best cross loss at epoch:        787 = 0.0049478196 
  * RMSE:  3.92978  10.89243  
* ./rnn S2WA_10_PRO_1_PRO_2_PRO_3_PRO_5_SUP_1_SUP_2_SUP_3_SUP_5_PROSUP_1_DNO_DS10_RMS100_FULL S2WA_10_PROSUP_2_DNO_DS10_RMS100_FULL S2WA_10_SUP_4_PRO_4_PROSUP_3_DNO_DS10_RMS100_FULL 12 1000 10 100000 4
  * train loss at epoch:        759 = 0.0149246508 
  * best cross loss at epoch:        658 = 0.0107580776 
  * RMSE:  2.88141  12.11810  
* ./rnn S2WA_10_PRO_1_PRO_2_PRO_3_PRO_5_SUP_1_SUP_2_SUP_3_SUP_5_PROSUP_2_DNO_DS10_RMS100_FULL S2WA_10_PROSUP_3_DNO_DS10_RMS100_FULL S2WA_10_SUP_4_PRO_4_PROSUP_1_DNO_DS10_RMS100_FULL 12 1000 10 100000 4
  * train loss at epoch:        276 = 0.0327425892 
  * best cross loss at epoch:        175 = 0.0263133777 
  * RMSE:  2.74851  17.60966 

* ./rnn S2WA_10_FLX_1_FLX_2_FLX_3_FLX_5_EXT_1_EXT_2_EXT_3_EXT_5_FLXEXT_2_DNO_DS10_RMS100_FULL S2WA_10_FLXEXT_1_DNO_DS10_RMS100_FULL S2WA_10_EXT_4_FLX_4_FLXEXT_3_DNO_DS10_RMS100_FULL 12 1000 10 100000 4
  * train loss at epoch:        257 = 0.0047704946 
  * best cross loss at epoch:        156 = 0.0065710628 
  * RMSE:  5.91251   2.48466  
* ./rnn S2WA_10_FLX_1_FLX_2_FLX_3_FLX_5_EXT_1_EXT_2_EXT_3_EXT_5_FLXEXT_1_DNO_DS10_RMS100_FULL S2WA_10_FLXEXT_2_DNO_DS10_RMS100_FULL S2WA_10_EXT_4_FLX_4_FLXEXT_3_DNO_DS10_RMS100_FULL 12 1000 10 100000 4
  * train loss at epoch:        518 = 0.0033089296 
  * best cross loss at epoch:        417 = 0.0058952789 
  * RMSE:  7.20243   1.82333  
* ./rnn S2WA_10_FLX_1_FLX_2_FLX_3_FLX_5_EXT_1_EXT_2_EXT_3_EXT_5_FLXEXT_2_DNO_DS10_RMS100_FULL S2WA_10_FLXEXT_3_DNO_DS10_RMS100_FULL S2WA_10_EXT_4_FLX_4_FLXEXT_1_DNO_DS10_RMS100_FULL 12 1000 10 100000 4
  * train loss at epoch:        246 = 0.0047861331 
  * best cross loss at epoch:        145 = 0.0063652603 
  * RMSE:  6.07855   2.89297 

* ./rnn S2WA_10_FLX_1_FLX_2_FLX_3_FLX_4_FLX_5_TRUNCAT_DNO_DS10_RMS100_FULL S2WA_10_FLXEXTPROSUP_1_DNO_DS10_RMS100_FULL S2WA_10_FLXEXTPROSUP_3_DNO_DS10_RMS100_FULL 12 1000 10 100000 4
  * train loss at epoch:        204 = 0.1235814498 
  * best cross loss at epoch:        103 = 0.2654641480 
  * RMSE:  9.79194  35.76188  
* ./rnn S2WA_10_FLX_1_FLX_2_FLX_3_FLX_4_FLX_5_TRUNCAT_DNO_DS10_RMS100_FULL S2WA_10_FLXEXTPROSUP_2_DNO_DS10_RMS100_FULL S2WA_10_FLXEXTPROSUP_3_DNO_DS10_RMS100_FULL 12 1000 10 100000 4
  * train loss at epoch:        394 = 0.0697394362 
  * best cross loss at epoch:        293 = 0.0286984177 
  * RMSE:  8.78800  39.88806  
* ./rnn S2WA_10_FLX_1_FLX_2_FLX_3_FLX_4_FLX_5_TRUNCAT_DNO_DS10_RMS100_FULL S2WA_10_FLXEXTPROSUP_3_DNO_DS10_RMS100_FULL S2WA_10_FLXEXTPROSUP_1_DNO_DS10_RMS100_FULL 12 1000 10 100000 4
  * train loss at epoch:        205 = 0.1237212041 
  * best cross loss at epoch:        104 = 0.1696764320 
  * RMSE:  8.20061  45.65126  

* ./rnn S2WA_10_FLXEXTPRO_1_FLXEXTSUP_1_FLXEXTPRO_2_FLXEXTSUP_2_FLXEXTPROSUP_2_DNO_DS10_RMS100_FULL S2WA_10_FLXEXTPROSUP_1_DNO_DS10_RMS100_FULL S2WA_10_FLXEXTPROSUP_3_DNO_DS10_RMS100_FULL 12 1000 10 100000 4
  * train loss at epoch:        609 = 0.0463809448 
  * best cross loss at epoch:        508 = 0.0543094077 
  * RMSE: 12.86232  24.12118  
* ./rnn S2WA_10_FLXEXTPRO_1_FLXEXTSUP_1_FLXEXTPRO_2_FLXEXTSUP_2_FLXEXTPROSUP_1_DNO_DS10_RMS100_FULL S2WA_10_FLXEXTPROSUP_2_DNO_DS10_RMS100_FULL S2WA_10_FLXEXTPROSUP_3_DNO_DS10_RMS100_FULL 12 1000 10 100000 4
  * train loss at epoch:        412 = 0.0161660829 
  * best cross loss at epoch:        311 = 0.0510807724 
  * RMSE: 13.58582  67.00192  
* ./rnn S2WA_10_FLXEXTPRO_1_FLXEXTSUP_1_FLXEXTPRO_2_FLXEXTSUP_2_FLXEXTPROSUP_2_DNO_DS10_RMS100_FULL S2WA_10_FLXEXTPROSUP_3_DNO_DS10_RMS100_FULL S2WA_10_FLXEXTPROSUP_1_DNO_DS10_RMS100_FULL 12 1000 10 100000 4
  * train loss at epoch:        257 = 0.0747312298 
  * best cross loss at epoch:        156 = 0.0910721922 
  * RMSE: 16.43597  22.11148  

* ./rnn S2WA_10_FLX_1_FLX_2_FLX_3_FLX_4_FLX_5_TRUNCAT_DNO_DS10_RMS100_FULL S2WA_10_FLXEXTPROSUP_1_DNO_DS10_RMS100_FULL S2WA_10_FLXEXTPRO_1_FLXEXTSUP_1_FLXEXTPRO_2_FLXEXTSUP_2_DNO_DS10_RMS100_FULL 12 1000 10 100000 4
  * train loss at epoch:        775 = 0.0165788269 
  * best cross loss at epoch:        674 = 0.1267293819 
  * RMSE: 12.18004  40.55109  
* ./rnn S2WA_10_FLX_1_FLX_2_FLX_3_FLX_4_FLX_5_TRUNCAT_DNO_DS10_RMS100_FULL S2WA_10_FLXEXTPROSUP_2_DNO_DS10_RMS100_FULL S2WA_10_FLXEXTPRO_1_FLXEXTSUP_1_FLXEXTPRO_2_FLXEXTSUP_2_DNO_DS10_RMS100_FULL 12 1000 10 100000 4
  * train loss at epoch:        674 = 0.0062305198 
  * best cross loss at epoch:        573 = 0.1663123373 
  * RMSE:  7.53278  40.98695  
* ./rnn S2WA_10_FLX_1_FLX_2_FLX_3_FLX_4_FLX_5_TRUNCAT_DNO_DS10_RMS100_FULL S2WA_10_FLXEXTPROSUP_3_DNO_DS10_RMS100_FULL S2WA_10_FLXEXTPRO_1_FLXEXTSUP_1_FLXEXTPRO_2_FLXEXTSUP_2_DNO_DS10_RMS100_FULL 12 1000 10 100000 4
  * train loss at epoch:        195 = 0.0303455115 
  * best cross loss at epoch:         94 = 0.2097847894 
  * RMSE:  9.83586  19.53255  

### Complex MIX, Reduced Simple Training

* ./rnn S2WA_10_FLXEXTPRO_1_FLXEXTSUP_1_FLXEXTPRO_2_FLXEXTSUP_2_FLXEXTPROSUP_3_TRUNCAT_DNO_DS10_RMS100_FULL S2WA_10_FLXEXTPROSUP_1_DNO_DS10_RMS100_FULL S2WA_10_FLXEXTPROSUP_3_FLXEXTPROSUP_2_DNO_DS10_RMS100_FULL 12 1000 10 100000 4
  * train loss at epoch:       1000 = 0.0249707617 
  * best cross loss at epoch:        904 = 0.0396865722 
  * RMSE:  9.04502  19.74416 
  * {{{
       'FLXEXTPRO_1', 'FLXEXTSUP_1', 'FLXEXTPRO_2', 'FLXEXTSUP_2', ...
       'FLXEXTPROSUP_3', 'FLXEXTPROSUP_2'}, ...
       {'FLXEXTPROSUP_3', 'FLXEXTPROSUP_2'}}, ...
       'FLXEXTPROSUP_1'};  
* ./rnn S2WA_10_FLXEXTPRO_1_FLXEXTSUP_1_FLXEXTPRO_2_FLXEXTSUP_2_FLXEXTPROSUP_1_TRUNCAT_DNO_DS10_RMS100_FULL S2WA_10_FLXEXTPROSUP_2_DNO_DS10_RMS100_FULL S2WA_10_FLXEXTPROSUP_1_FLXEXTPROSUP_3_DNO_DS10_RMS100_FULL 12 1000 10 100000 4
  * train loss at epoch:       1000 = 0.0131119622 
  * best cross loss at epoch:        912 = 0.0156082043 
  * RMSE: 10.72223  61.98601 
  * {{{
       'FLXEXTPRO_1', 'FLXEXTSUP_1', 'FLXEXTPRO_2', 'FLXEXTSUP_2', ...
       'FLXEXTPROSUP_1', 'FLXEXTPROSUP_3'}, ...
       {'FLXEXTPROSUP_1', 'FLXEXTPROSUP_3'}}, ...
       'FLXEXTPROSUP_2'}; 
* ./rnn S2WA_10_FLXEXTPRO_1_FLXEXTSUP_1_FLXEXTPRO_2_FLXEXTSUP_2_FLXEXTPROSUP_1_TRUNCAT_DNO_DS10_RMS100_FULL S2WA_10_FLXEXTPROSUP_3_DNO_DS10_RMS100_FULL S2WA_10_FLXEXTPROSUP_1_FLXEXTPROSUP_2_DNO_DS10_RMS100_FULL 12 1000 10 100000 4
  * train loss at epoch:       1000 = 0.0243958704 
  * best cross loss at epoch:        976 = 0.0322819670 
  * RMSE: 10.47104  18.21075  
  * {{{
       'FLXEXTPRO_1', 'FLXEXTSUP_1', 'FLXEXTPRO_2', 'FLXEXTSUP_2', ...
       'FLXEXTPROSUP_1', 'FLXEXTPROSUP_2'}, ...
       {'FLXEXTPROSUP_1', 'FLXEXTPROSUP_2'}}, ...
       'FLXEXTPROSUP_3'};

### Complex MIX, Reduced Simple/Mix Training

* ./rnn S2WA_10_FLXEXTPROSUP_3_FLXEXTPROSUP_2_DNO_DS10_RMS100_FULL S2WA_10_FLXEXTPROSUP_1_DNO_DS10_RMS100_FULL S2WA_10_FLXEXTPROSUP_3_FLXEXTPROSUP_2_DNO_DS10_RMS100_FULL 12 1000 10 100000 4
  * train loss at epoch:        932 = 0.0276135061 
  * best cross loss at epoch:        831 = 0.0204238643 
  * RMSE: 11.54888  17.70759  
  * {{{
       'FLXEXTPROSUP_3', 'FLXEXTPROSUP_2'}, ...
       {'FLXEXTPROSUP_3', 'FLXEXTPROSUP_2'}}, ...
       'FLXEXTPROSUP_1'};  
* ./rnn S2WA_10_FLXEXTPROSUP_1_FLXEXTPROSUP_3_DNO_DS10_RMS100_FULL S2WA_10_FLXEXTPROSUP_2_DNO_DS10_RMS100_FULL S2WA_10_FLXEXTPROSUP_1_FLXEXTPROSUP_3_DNO_DS10_RMS100_FULL 12 1000 10 100000 4
  * train loss at epoch:       1000 = 0.0436546708 
  * best cross loss at epoch:        958 = 0.0053707527 
  * RMSE: 12.15243  81.82992  
  * {{{
       'FLXEXTPROSUP_1', 'FLXEXTPROSUP_3'}, ...
       {'FLXEXTPROSUP_1', 'FLXEXTPROSUP_3'}}, ...
       'FLXEXTPROSUP_2'}; 
* ./rnn S2WA_10_FLXEXTPROSUP_1_FLXEXTPROSUP_2_DNO_DS10_RMS100_FULL S2WA_10_FLXEXTPROSUP_3_DNO_DS10_RMS100_FULL S2WA_10_FLXEXTPROSUP_1_FLXEXTPROSUP_2_DNO_DS10_RMS100_FULL 12 1000 10 100000 4
  * train loss at epoch:        527 = 0.1109553231 
  * best cross loss at epoch:        426 = 0.0818264645 
  * RMSE: 14.03253  47.57367  
  * {{{
       'FLXEXTPROSUP_1', 'FLXEXTPROSUP_2'}, ...
       {'FLXEXTPROSUP_1', 'FLXEXTPROSUP_2'}}, ...
       'FLXEXTPROSUP_3'};


---

### Experiment-10 - downICA, RMS @ 100pts, Downsampled @ 10hz


Read more on FastICA and whitening

---

### Experiment-10 - downPCA, RMS @ 100pts, Downsampled @ 10hz

---

### Experiment-10 - ICAdown, RMS @ 100pts, Downsampled @ 10hz

H: 12 P: 100
* ./rnn S2WA_10_PRO_1_PRO_2_PRO_4_ICAdown_DS10_RMS100_FULL S2WA_10_PRO_5_ICAdown_DS10_RMS100_FULL S2WA_10_PRO_3_ICAdown_DS10_RMS100_FULL 12 1000 10 100000 4
  * train loss at epoch:        355 = 0.0069072755 
  * best cross loss at epoch:        254 = 0.0043477939 
  * RMSE:  3.38441	 7.63798	
* ./rnn S2WA_10_SUP_1_SUP_2_SUP_4_ICAdown_DS10_RMS100_FULL S2WA_10_SUP_5_ICAdown_DS10_RMS100_FULL S2WA_10_SUP_3_ICAdown_DS10_RMS100_FULL 12 1000 10 100000 4
  * train loss at epoch:        370 = 0.0088129844 
  * best cross loss at epoch:        269 = 0.0043832614 
  * RMSE:  2.42204	13.53714	
* ./rnn S2WA_10_FLX_1_FLX_2_FLX_4_ICAdown_DS10_RMS100_FULL S2WA_10_FLX_5_ICAdown_DS10_RMS100_FULL S2WA_10_FLX_3_ICAdown_DS10_RMS100_FULL 12 1000 10 100000 4
  * train loss at epoch:       1000 = 0.0024934431 
  * best cross loss at epoch:        998 = 0.0040368158 
  * RMSE:  3.83482	 1.94403	
* ./rnn S2WA_10_EXT_1_EXT_2_EXT_4_ICAdown_DS10_RMS100_FULL S2WA_10_EXT_5_ICAdown_DS10_RMS100_FULL S2WA_10_EXT_3_ICAdown_DS10_RMS100_FULL 12 1000 10 100000 4
  * train loss at epoch:        732 = 0.0044252459 
  * best cross loss at epoch:        631 = 0.0024868646 
  * RMSE:  7.36222	 2.73028	

* ./rnn S2WA_10_PRO_1_PRO_2_PRO_5_ICAdown_DS10_RMS100_FULL S2WA_10_PRO_4_ICAdown_DS10_RMS100_FULL S2WA_10_PRO_3_ICAdown_DS10_RMS100_FULL 12 1000 10 100000 4
  * train loss at epoch:        292 = 0.0070828259 
  * best cross loss at epoch:        191 = 0.0077041130 
  * RMSE:  2.55647	 6.66040	
* ./rnn S2WA_10_SUP_1_SUP_2_SUP_5_ICAdown_DS10_RMS100_FULL S2WA_10_SUP_4_ICAdown_DS10_RMS100_FULL S2WA_10_SUP_3_ICAdown_DS10_RMS100_FULL 12 1000 10 100000 4
  * train loss at epoch:        329 = 0.0059622942 
  * best cross loss at epoch:        228 = 0.0123627173 
  * RMSE:  3.04218	 9.11034	
* ./rnn S2WA_10_FLX_1_FLX_2_FLX_5_ICAdown_DS10_RMS100_FULL S2WA_10_FLX_4_ICAdown_DS10_RMS100_FULL S2WA_10_FLX_3_ICAdown_DS10_RMS100_FULL 12 1000 10 100000 4
  * train loss at epoch:        281 = 0.0031442574 
  * best cross loss at epoch:        180 = 0.0054735979 
  * RMSE:  5.09121	 1.89687	
* ./rnn S2WA_10_EXT_1_EXT_2_EXT_5_ICAdown_DS10_RMS100_FULL S2WA_10_EXT_4_ICAdown_DS10_RMS100_FULL S2WA_10_EXT_3_ICAdown_DS10_RMS100_FULL 12 1000 10 100000 4
  * train loss at epoch:        437 = 0.0022465561 
  * best cross loss at epoch:        336 = 0.0047282415 
  * RMSE:  8.91123	 4.19621	

* ./rnn S2WA_10_PRO_1_PRO_2_PRO_3_PRO_5_SUP_1_SUP_2_SUP_3_SUP_5_PROSUP_2_ICAdown_DS10_RMS100_FULL S2WA_10_PROSUP_1_ICAdown_DS10_RMS100_FULL S2WA_10_SUP_4_PRO_4_PROSUP_3_ICAdown_DS10_RMS100_FULL 12 1000 10 100000 4
  * train loss at epoch:        509 = 0.0101226753 
  * best cross loss at epoch:        408 = 0.0104284251 
  * RMSE:  3.65444	10.75320	
* ./rnn S2WA_10_PRO_1_PRO_2_PRO_3_PRO_5_SUP_1_SUP_2_SUP_3_SUP_5_PROSUP_1_ICAdown_DS10_RMS100_FULL S2WA_10_PROSUP_2_ICAdown_DS10_RMS100_FULL S2WA_10_SUP_4_PRO_4_PROSUP_3_ICAdown_DS10_RMS100_FULL 12 1000 10 100000 4
  * train loss at epoch:       1000 = 0.0036868322 
  * best cross loss at epoch:        913 = 0.0062611432 
  * RMSE:  4.38842	13.00638	
* ./rnn S2WA_10_PRO_1_PRO_2_PRO_3_PRO_5_SUP_1_SUP_2_SUP_3_SUP_5_PROSUP_2_ICAdown_DS10_RMS100_FULL S2WA_10_PROSUP_3_ICAdown_DS10_RMS100_FULL S2WA_10_SUP_4_PRO_4_PROSUP_1_ICAdown_DS10_RMS100_FULL 12 1000 10 100000 4
  * train loss at epoch:        839 = 0.0064743469 
  * best cross loss at epoch:        738 = 0.0067614440 
  * RMSE:  1.70840	10.97111	

* ./rnn S2WA_10_FLX_1_FLX_2_FLX_3_FLX_5_EXT_1_EXT_2_EXT_3_EXT_5_FLXEXT_2_ICAdown_DS10_RMS100_FULL S2WA_10_FLXEXT_1_ICAdown_DS10_RMS100_FULL S2WA_10_EXT_4_FLX_4_FLXEXT_3_ICAdown_DS10_RMS100_FULL 12 1000 10 100000 4
  * train loss at epoch:       1000 = 0.0041898768 
  * best cross loss at epoch:        989 = 0.0057012479 
  * RMSE:  4.48282	 2.41440	
* ./rnn S2WA_10_FLX_1_FLX_2_FLX_3_FLX_5_EXT_1_EXT_2_EXT_3_EXT_5_FLXEXT_1_ICAdown_DS10_RMS100_FULL S2WA_10_FLXEXT_2_ICAdown_DS10_RMS100_FULL S2WA_10_EXT_4_FLX_4_FLXEXT_3_ICAdown_DS10_RMS100_FULL 12 1000 10 100000 4
  * train loss at epoch:        636 = 0.0021136461 
  * best cross loss at epoch:        535 = 0.0049619603 
  * RMSE:  5.29767	 1.71839	
* ./rnn S2WA_10_FLX_1_FLX_2_FLX_3_FLX_5_EXT_1_EXT_2_EXT_3_EXT_5_FLXEXT_2_ICAdown_DS10_RMS100_FULL S2WA_10_FLXEXT_3_ICAdown_DS10_RMS100_FULL S2WA_10_EXT_4_FLX_4_FLXEXT_1_ICAdown_DS10_RMS100_FULL 12 1000 10 100000 4
  * train loss at epoch:        618 = 0.0025390177 
  * best cross loss at epoch:        517 = 0.0050889060 
  * RMSE:  4.57027	 1.93124

#### Complex MIX, Full training


* ./rnn S2WA_10_FLX_1_FLX_2_FLX_3_FLX_4_FLX_5_TRUNCAT_ICAdown_DS10_RMS100_FULL S2WA_10_FLXEXTPROSUP_1_ICAdown_DS10_RMS100_FULL S2WA_10_FLXEXTPROSUP_3_ICAdown_DS10_RMS100_FULL 12 1000 10 100000 4
  * train loss at epoch:        322 = 0.0630714678 
  * best cross loss at epoch:        221 = 0.0295945891 
  * RMSE:  8.59591	15.00669	
  * {{{'FLX_1', 'FLX_2', 'FLX_3', 'FLX_4', 'FLX_5', ...
       'EXT_1', 'EXT_2', 'EXT_3', 'EXT_4', 'EXT_5', ...
       'FLXEXT_1', 'FLXEXT_2', 'FLXEXT_3', ...
       'PROSUP_1', 'PROSUP_2', 'PROSUP_3', ...
       'FLXEXTPRO_1', 'FLXEXTSUP_1', 'FLXEXTPRO_2', 'FLXEXTSUP_2', ...
       'FLXEXTPROSUP_2'}, ...
       {'FLXEXTPROSUP_3'}}, ...
       'FLXEXTPROSUP_1'};
* ./rnn S2WA_10_FLX_1_FLX_2_FLX_3_FLX_4_FLX_5_TRUNCAT_ICAdown_DS10_RMS100_FULL S2WA_10_FLXEXTPROSUP_2_ICAdown_DS10_RMS100_FULL S2WA_10_FLXEXTPROSUP_3_ICAdown_DS10_RMS100_FULL 12 1000 10 100000 4
  * train loss at epoch:        277 = 0.0613269871 
  * best cross loss at epoch:        176 = 0.0310130131 
  * RMSE: 10.25037	40.18395	
  * {{{'FLX_1', 'FLX_2', 'FLX_3', 'FLX_4', 'FLX_5', ...
       'EXT_1', 'EXT_2', 'EXT_3', 'EXT_4', 'EXT_5', ...
       'FLXEXT_1', 'FLXEXT_2', 'FLXEXT_3', ...
       'PROSUP_1', 'PROSUP_2', 'PROSUP_3', ...
       'FLXEXTPRO_1', 'FLXEXTSUP_1', 'FLXEXTPRO_2', 'FLXEXTSUP_2', ...
       'FLXEXTPROSUP_1'}, ...
       {'FLXEXTPROSUP_3'}}, ...
       'FLXEXTPROSUP_2'}; 
* ./rnn S2WA_10_FLX_1_FLX_2_FLX_3_FLX_4_FLX_5_TRUNCAT_ICAdown_DS10_RMS100_FULL S2WA_10_FLXEXTPROSUP_3_ICAdown_DS10_RMS100_FULL S2WA_10_FLXEXTPROSUP_1_ICAdown_DS10_RMS100_FULL 12 1000 10 100000 4
  * train loss at epoch:        300 = 0.0878361904 
  * best cross loss at epoch:        199 = 0.0701269509 
  * RMSE:  9.17862	41.85655	
  * {{{'FLX_1', 'FLX_2', 'FLX_3', 'FLX_4', 'FLX_5', ...
       'EXT_1', 'EXT_2', 'EXT_3', 'EXT_4', 'EXT_5', ...
       'FLXEXT_1', 'FLXEXT_2', 'FLXEXT_3', ...
       'PROSUP_1', 'PROSUP_2', 'PROSUP_3', ...
       'FLXEXTPRO_1', 'FLXEXTSUP_1', 'FLXEXTPRO_2', 'FLXEXTSUP_2', ...
       'FLXEXTPROSUP_2'}, ...
       {'FLXEXTPROSUP_1'}}, ...
       'FLXEXTPROSUP_3'}; 

#### Complex MIX, Reduced training

* ./rnn S2WA_10_FLXEXTPRO_1_FLXEXTSUP_1_FLXEXTPRO_2_FLXEXTSUP_2_FLXEXTPROSUP_2_ICAdown_DS10_RMS100_FULL S2WA_10_FLXEXTPROSUP_1_ICAdown_DS10_RMS100_FULL S2WA_10_FLXEXTPROSUP_3_ICAdown_DS10_RMS100_FULL 12 1000 10 100000 4
  * train loss at epoch:        391 = 0.0310805559 
  * best cross loss at epoch:        290 = 0.0523178622 
  * RMSE: 13.06325	42.92336	
  * {{{'FLXEXTPRO_1', 'FLXEXTSUP_1', 'FLXEXTPRO_2', 'FLXEXTSUP_2', ...
       'FLXEXTPROSUP_2'}, ...
       {'FLXEXTPROSUP_3'}}, ...
       'FLXEXTPROSUP_1'};
* ./rnn S2WA_10_FLXEXTPRO_1_FLXEXTSUP_1_FLXEXTPRO_2_FLXEXTSUP_2_FLXEXTPROSUP_1_ICAdown_DS10_RMS100_FULL S2WA_10_FLXEXTPROSUP_2_ICAdown_DS10_RMS100_FULL S2WA_10_FLXEXTPROSUP_3_ICAdown_DS10_RMS100_FULL 12 1000 10 100000 4
  * train loss at epoch:        441 = 0.0176253399 
  * best cross loss at epoch:        340 = 0.0428158394 
  * RMSE: 15.49034	32.07056	
  * {{{'FLXEXTPRO_1', 'FLXEXTSUP_1', 'FLXEXTPRO_2', 'FLXEXTSUP_2', ...
       'FLXEXTPROSUP_1'}, ...
       {'FLXEXTPROSUP_3'}}, ...
       'FLXEXTPROSUP_2'}; 
* ./rnn S2WA_10_FLXEXTPRO_1_FLXEXTSUP_1_FLXEXTPRO_2_FLXEXTSUP_2_FLXEXTPROSUP_2_ICAdown_DS10_RMS100_FULL S2WA_10_FLXEXTPROSUP_3_ICAdown_DS10_RMS100_FULL S2WA_10_FLXEXTPROSUP_1_ICAdown_DS10_RMS100_FULL 12 1000 10 100000 4
  * train loss at epoch:        301 = 0.0525629490 
  * best cross loss at epoch:        200 = 0.1379058188 
  * RMSE: 14.85720	88.75639
  * {{{'FLXEXTPRO_1', 'FLXEXTSUP_1', 'FLXEXTPRO_2', 'FLXEXTSUP_2', ...
       'FLXEXTPROSUP_2'}, ...
       {'FLXEXTPROSUP_1'}}, ...
       'FLXEXTPROSUP_3'};   	

#### Complex MIX, Partial CV

         

* ./rnn S2WA_10_FLX_1_FLX_2_FLX_3_FLX_4_FLX_5_TRUNCAT_ICAdown_DS10_RMS100_FULL S2WA_10_FLXEXTPROSUP_1_ICAdown_DS10_RMS100_FULL S2WA_10_FLXEXTPRO_1_FLXEXTSUP_1_FLXEXTPRO_2_FLXEXTSUP_2_ICAdown_DS10_RMS100_FULL 12 1000 10 100000 4
  * train loss at epoch:        457 = 0.0438124570 
  * best cross loss at epoch:        356 = 0.1694988674 
  * RMSE: 11.55080	20.73036	
  * {{{'FLX_1', 'FLX_2', 'FLX_3', 'FLX_4', 'FLX_5', ...
       'EXT_1', 'EXT_2', 'EXT_3', 'EXT_4', 'EXT_5', ...
       'FLXEXT_1', 'FLXEXT_2', 'FLXEXT_3', ...
       'PROSUP_1', 'PROSUP_2', 'PROSUP_3', ...
       'FLXEXTPROSUP_3', 'FLXEXTPROSUP_2' }, ...
       {'FLXEXTPRO_1', 'FLXEXTSUP_1', 'FLXEXTPRO_2', 'FLXEXTSUP_2'}}, ...
       'FLXEXTPROSUP_1'}; 
* ./rnn S2WA_10_FLX_1_FLX_2_FLX_3_FLX_4_FLX_5_TRUNCAT_ICAdown_DS10_RMS100_FULL S2WA_10_FLXEXTPROSUP_2_ICAdown_DS10_RMS100_FULL S2WA_10_FLXEXTPRO_1_FLXEXTSUP_1_FLXEXTPRO_2_FLXEXTSUP_2_ICAdown_DS10_RMS100_FULL 12 1000 10 100000 4
  * train loss at epoch:        132 = 0.0338421462 
  * best cross loss at epoch:         31 = 0.3376109345 
  * RMSE: 10.20584	52.92713	
  * {{{'FLX_1', 'FLX_2', 'FLX_3', 'FLX_4', 'FLX_5', ...
       'EXT_1', 'EXT_2', 'EXT_3', 'EXT_4', 'EXT_5', ...
       'FLXEXT_1', 'FLXEXT_2', 'FLXEXT_3', ...
       'PROSUP_1', 'PROSUP_2', 'PROSUP_3', ...
       'FLXEXTPROSUP_1', 'FLXEXTPROSUP_3' }, ...
       {'FLXEXTPRO_1', 'FLXEXTSUP_1', 'FLXEXTPRO_2', 'FLXEXTSUP_2'}}, ...
       'FLXEXTPROSUP_2'}; 
* ./rnn S2WA_10_FLX_1_FLX_2_FLX_3_FLX_4_FLX_5_TRUNCAT_ICAdown_DS10_RMS100_FULL S2WA_10_FLXEXTPROSUP_3_ICAdown_DS10_RMS100_FULL S2WA_10_FLXEXTPRO_1_FLXEXTSUP_1_FLXEXTPRO_2_FLXEXTSUP_2_ICAdown_DS10_RMS100_FULL 12 1000 10 100000 4
  * train loss at epoch:        258 = 0.0459320322 
  * best cross loss at epoch:        157 = 0.2008345364 
  * RMSE:  8.10824	14.93777	
  * {{{'FLX_1', 'FLX_2', 'FLX_3', 'FLX_4', 'FLX_5', ...
       'EXT_1', 'EXT_2', 'EXT_3', 'EXT_4', 'EXT_5', ...
       'FLXEXT_1', 'FLXEXT_2', 'FLXEXT_3', ...
       'PROSUP_1', 'PROSUP_2', 'PROSUP_3', ...
       'FLXEXTPROSUP_1', 'FLXEXTPROSUP_2' }, ...
       {'FLXEXTPRO_1', 'FLXEXTSUP_1', 'FLXEXTPRO_2', 'FLXEXTSUP_2'}}, ...
       'FLXEXTPROSUP_3'};  



---

### Experiment-10 - PCAdown, RMS @ 100pts, Downsampled @ 10hz

H: 12 P: 100

* ./rnn S2WA_10_PRO_1_PRO_2_PRO_4_PCAdown_DS10_RMS100_FULL S2WA_10_PRO_5_PCAdown_DS10_RMS100_FULL S2WA_10_PRO_3_PCAdown_DS10_RMS100_FULL 12 1000 10 100000 4
  * train loss at epoch:        959 = 0.0044626731 
  * best cross loss at epoch:        858 = 0.0035905729 
  * RMSE:  2.23418	 6.61828	
* ./rnn S2WA_10_SUP_1_SUP_2_SUP_4_PCAdown_DS10_RMS100_FULL S2WA_10_SUP_5_PCAdown_DS10_RMS100_FULL S2WA_10_SUP_3_PCAdown_DS10_RMS100_FULL 12 1000 10 100000 4
  * train loss at epoch:        619 = 0.0070236657 
  * best cross loss at epoch:        518 = 0.0078049412 
  * RMSE:  2.73364	15.66998	
* ./rnn S2WA_10_FLX_1_FLX_2_FLX_4_PCAdown_DS10_RMS100_FULL S2WA_10_FLX_5_PCAdown_DS10_RMS100_FULL S2WA_10_FLX_3_PCAdown_DS10_RMS100_FULL 12 1000 10 100000 4
  * train loss at epoch:        431 = 0.0048062603 
  * best cross loss at epoch:        330 = 0.0050388288 
  * RMSE:  5.73943	 2.12438	
* ./rnn S2WA_10_EXT_1_EXT_2_EXT_4_PCAdown_DS10_RMS100_FULL S2WA_10_EXT_5_PCAdown_DS10_RMS100_FULL S2WA_10_EXT_3_PCAdown_DS10_RMS100_FULL 12 1000 10 100000 4
  * train loss at epoch:        474 = 0.0038704239 
  * best cross loss at epoch:        373 = 0.0024847666 
  * RMSE:  7.58387	 2.49743	

* ./rnn S2WA_10_PRO_1_PRO_2_PRO_5_PCAdown_DS10_RMS100_FULL S2WA_10_PRO_4_PCAdown_DS10_RMS100_FULL S2WA_10_PRO_3_PCAdown_DS10_RMS100_FULL 12 1000 10 100000 4
  * train loss at epoch:       1000 = 0.0019442721 
  * best cross loss at epoch:        942 = 0.0038931623 
  * RMSE:  1.38962	 4.57936	
* ./rnn S2WA_10_SUP_1_SUP_2_SUP_5_PCAdown_DS10_RMS100_FULL S2WA_10_SUP_4_PCAdown_DS10_RMS100_FULL S2WA_10_SUP_3_PCAdown_DS10_RMS100_FULL 12 1000 10 100000 4
  * train loss at epoch:       1000 = 0.0035641710 
  * best cross loss at epoch:        947 = 0.0115890191 
  * RMSE:  2.82881	10.08413	
* ./rnn S2WA_10_FLX_1_FLX_2_FLX_5_PCAdown_DS10_RMS100_FULL S2WA_10_FLX_4_PCAdown_DS10_RMS100_FULL S2WA_10_FLX_3_PCAdown_DS10_RMS100_FULL 12 1000 10 100000 4
  * train loss at epoch:       1000 = 0.0014207144 
  * best cross loss at epoch:        999 = 0.0034424872 
  * RMSE:  4.58288	 1.76953	
* ./rnn S2WA_10_EXT_1_EXT_2_EXT_5_PCAdown_DS10_RMS100_FULL S2WA_10_EXT_4_PCAdown_DS10_RMS100_FULL S2WA_10_EXT_3_PCAdown_DS10_RMS100_FULL 12 1000 10 100000 4
  * train loss at epoch:        751 = 0.0023084526 
  * best cross loss at epoch:        650 = 0.0018244965 
  * RMSE:  8.04037	 2.40904	

* ./rnn S2WA_10_PRO_1_PRO_2_PRO_3_PRO_5_SUP_1_SUP_2_SUP_3_SUP_5_PROSUP_2_PCAdown_DS10_RMS100_FULL S2WA_10_PROSUP_1_PCAdown_DS10_RMS100_FULL S2WA_10_SUP_4_PRO_4_PROSUP_3_PCAdown_DS10_RMS100_FULL 12 1000 10 100000 4
  * train loss at epoch:       1000 = 0.0870775498 
  * best cross loss at epoch:        919 = 0.0385208857 
  * RMSE:  6.53106	48.66299	
* ./rnn S2WA_10_PRO_1_PRO_2_PRO_3_PRO_5_SUP_1_SUP_2_SUP_3_SUP_5_PROSUP_1_PCAdown_DS10_RMS100_FULL S2WA_10_PROSUP_2_PCAdown_DS10_RMS100_FULL S2WA_10_SUP_4_PRO_4_PROSUP_3_PCAdown_DS10_RMS100_FULL 12 1000 10 100000 4
  * train loss at epoch:        882 = 0.0104268676 
  * best cross loss at epoch:        781 = 0.0123925849 
  * RMSE:  4.22096	16.68582	
* ./rnn S2WA_10_PRO_1_PRO_2_PRO_3_PRO_5_SUP_1_SUP_2_SUP_3_SUP_5_PROSUP_2_PCAdown_DS10_RMS100_FULL S2WA_10_PROSUP_3_PCAdown_DS10_RMS100_FULL S2WA_10_SUP_4_PRO_4_PROSUP_1_PCAdown_DS10_RMS100_FULL 12 1000 10 100000 4
  * train loss at epoch:        279 = 0.0827984359 
  * best cross loss at epoch:        178 = 0.0876095014 
  * RMSE:  5.12346	33.53987

* ./rnn S2WA_10_FLX_1_FLX_2_FLX_3_FLX_5_EXT_1_EXT_2_EXT_3_EXT_5_FLXEXT_2_PCAdown_DS10_RMS100_FULL S2WA_10_FLXEXT_1_PCAdown_DS10_RMS100_FULL S2WA_10_EXT_4_FLX_4_FLXEXT_3_PCAdown_DS10_RMS100_FULL 12 1000 10 100000 4
  * train loss at epoch:       1000 = 0.0031475642 
  * best cross loss at epoch:        933 = 0.0050896779 
  * RMSE:  6.50244	 2.04444	
* ./rnn S2WA_10_FLX_1_FLX_2_FLX_3_FLX_5_EXT_1_EXT_2_EXT_3_EXT_5_FLXEXT_1_PCAdown_DS10_RMS100_FULL S2WA_10_FLXEXT_2_PCAdown_DS10_RMS100_FULL S2WA_10_EXT_4_FLX_4_FLXEXT_3_PCAdown_DS10_RMS100_FULL 12 1000 10 100000 4
  * train loss at epoch:        565 = 0.0031306572 
  * best cross loss at epoch:        464 = 0.0064351297 
  * RMSE:  7.12704	 2.25644	
* ./rnn S2WA_10_FLX_1_FLX_2_FLX_3_FLX_5_EXT_1_EXT_2_EXT_3_EXT_5_FLXEXT_2_PCAdown_DS10_RMS100_FULL S2WA_10_FLXEXT_3_PCAdown_DS10_RMS100_FULL S2WA_10_EXT_4_FLX_4_FLXEXT_1_PCAdown_DS10_RMS100_FULL 12 1000 10 100000 4
  * train loss at epoch:        195 = 0.0084749816 
  * best cross loss at epoch:         94 = 0.0099895008 
  * RMSE:  9.22779	 2.70282	

#### Complex MIX, Full training

* ./rnn S2WA_10_FLX_1_FLX_2_FLX_3_FLX_4_FLX_5_TRUNCAT_PCAdown_DS10_RMS100_FULL S2WA_10_FLXEXTPROSUP_1_PCAdown_DS10_RMS100_FULL S2WA_10_FLXEXTPROSUP_3_PCAdown_DS10_RMS100_FULL 12 1000 10 100000 4
  * train loss at epoch:        507 = 0.0995465340 
  * best cross loss at epoch:        406 = 0.0464722832 
  * RMSE: 19.52495  22.95766  
* ./rnn S2WA_10_FLX_1_FLX_2_FLX_3_FLX_4_FLX_5_TRUNCAT_PCAdown_DS10_RMS100_FULL S2WA_10_FLXEXTPROSUP_2_PCAdown_DS10_RMS100_FULL S2WA_10_FLXEXTPROSUP_3_PCAdown_DS10_RMS100_FULL 12 1000 10 100000 4
  * train loss at epoch:        808 = 0.0391904884 
  * best cross loss at epoch:        707 = 0.0241586511 
  * RMSE:  7.90075  45.34866  
* ./rnn S2WA_10_FLX_1_FLX_2_FLX_3_FLX_4_FLX_5_TRUNCAT_PCAdown_DS10_RMS100_FULL S2WA_10_FLXEXTPROSUP_3_PCAdown_DS10_RMS100_FULL S2WA_10_FLXEXTPROSUP_1_PCAdown_DS10_RMS100_FULL 12 1000 10 100000 4
  * train loss at epoch:        412 = 0.0727435234 
  * best cross loss at epoch:        311 = 0.0489656803 
  * RMSE:  8.73882  27.95249  

#### Complex MIX, Reduced training
  
* ./rnn S2WA_10_FLXEXTPRO_1_FLXEXTSUP_1_FLXEXTPRO_2_FLXEXTSUP_2_FLXEXTPROSUP_2_PCAdown_DS10_RMS100_FULL S2WA_10_FLXEXTPROSUP_1_PCAdown_DS10_RMS100_FULL S2WA_10_FLXEXTPROSUP_3_PCAdown_DS10_RMS100_FULL 12 1000 10 100000 4
  * train loss at epoch:        366 = 0.0339787441 
  * best cross loss at epoch:        265 = 0.0390792589 
  * RMSE: 10.30574  21.99181  
* ./rnn S2WA_10_FLXEXTPRO_1_FLXEXTSUP_1_FLXEXTPRO_2_FLXEXTSUP_2_FLXEXTPROSUP_1_PCAdown_DS10_RMS100_FULL S2WA_10_FLXEXTPROSUP_2_PCAdown_DS10_RMS100_FULL S2WA_10_FLXEXTPROSUP_3_PCAdown_DS10_RMS100_FULL 12 1000 10 100000 4
  * train loss at epoch:        366 = 0.0317124500 
  * best cross loss at epoch:        265 = 0.0789258553 
  * RMSE: 11.25954  74.26858  
* ./rnn S2WA_10_FLXEXTPRO_1_FLXEXTSUP_1_FLXEXTPRO_2_FLXEXTSUP_2_FLXEXTPROSUP_2_PCAdown_DS10_RMS100_FULL S2WA_10_FLXEXTPROSUP_3_PCAdown_DS10_RMS100_FULL S2WA_10_FLXEXTPROSUP_1_PCAdown_DS10_RMS100_FULL 12 1000 10 100000 4
  * train loss at epoch:        339 = 0.1091599586 
  * best cross loss at epoch:        238 = 0.0677488959 
  * RMSE: 12.45441  55.33043  

#### Complex MIX, Partial CV

* ./rnn S2WA_10_FLX_1_FLX_2_FLX_3_FLX_4_FLX_5_TRUNCAT_PCAdown_DS10_RMS100_FULL S2WA_10_FLXEXTPROSUP_1_PCAdown_DS10_RMS100_FULL S2WA_10_FLXEXTPRO_1_FLXEXTSUP_1_FLXEXTPRO_2_FLXEXTSUP_2_PCAdown_DS10_RMS100_FULL 12 1000 10 100000 4
  * train loss at epoch:        692 = 0.0338225316 
  * best cross loss at epoch:        591 = 0.2331989337 
  * RMSE: 10.64351  19.66348  
* ./rnn S2WA_10_FLX_1_FLX_2_FLX_3_FLX_4_FLX_5_TRUNCAT_PCAdown_DS10_RMS100_FULL S2WA_10_FLXEXTPROSUP_2_PCAdown_DS10_RMS100_FULL S2WA_10_FLXEXTPRO_1_FLXEXTSUP_1_FLXEXTPRO_2_FLXEXTSUP_2_PCAdown_DS10_RMS100_FULL 12 1000 10 100000 4
  * train loss at epoch:        374 = 0.0115061492 
  * best cross loss at epoch:        273 = 0.2050202980 
  * RMSE: 10.35889  50.87453  
* ./rnn S2WA_10_FLX_1_FLX_2_FLX_3_FLX_4_FLX_5_TRUNCAT_PCAdown_DS10_RMS100_FULL S2WA_10_FLXEXTPROSUP_3_PCAdown_DS10_RMS100_FULL S2WA_10_FLXEXTPRO_1_FLXEXTSUP_1_FLXEXTPRO_2_FLXEXTSUP_2_PCAdown_DS10_RMS100_FULL 12 1000 10 100000 4
  * train loss at epoch:        429 = 0.0617855374 
  * best cross loss at epoch:        328 = 0.1856328978 
  * RMSE:  9.24525  24.27937  

---

### Notes

* Ch-1 for EXT_1~5 SUP_1~5 PROSUP_1~3 FLXEXT_12 'FLXEXTPROSUP_1', 'FLXEXTPROSUP_2', 'FLXEXTPROSUP_3', 'FLXEXTPROSUP_4',...
    'FLXEXTPRO_1', 'FLXEXTSUP_1' have nothing but noise, need to retest
  * Check signal error w/ 'plot_multi_semg.m' in the future
  * Remeasured
* Currently "Full motion" involves, moving to a fixed PRO/SUP angle then FLX/EXT
  * Lack samples for fixed PRO/SUP, record in future
* Full motion FLX/EXT can have good(<10 RMSE), but PRO/SUP estimation often stuck at constant level
* Training sample can be reduced for "Full motion", though with slightly worse performance (~20%) see
  * Complex MIX, Reduced Simple/Mix Training
  * Complex MIX, Reduced Simple Training


---

### TODO
- [x] 4-ch sEMG hardware
- [ ] Finish Pot. angle est.
- [ ] AED_1 molex solder