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

---

### Notes

* Ch-1 for EXT_1~5 SUP_1~5 PROSUP_1~3 FLXEXT_12 'FLXEXTPROSUP_1', 'FLXEXTPROSUP_2', 'FLXEXTPROSUP_3', 'FLXEXTPROSUP_4',...
    'FLXEXTPRO_1', 'FLXEXTSUP_1' have nothing but noise, need to retest
  * Check signal error w/ 'plot_multi_semg.m' in the future
  * Remeasured
* Currently "Full motion" involves, moving to a fixed PRO/SUP angle then FLX/EXT

---

### TODO
- [x] 4-ch sEMG hardware
- [ ] Finish Pot. angle est.
- [ ] AED_1 molex solder