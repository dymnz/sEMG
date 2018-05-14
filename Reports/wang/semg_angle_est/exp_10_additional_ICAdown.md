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


H: 16 P: 100
* ./rnn S2WA_10_PRO_1_PRO_2_PRO_4_ICAdown_DS10_RMS100_FULL S2WA_10_PRO_5_ICAdown_DS10_RMS100_FULL S2WA_10_PRO_3_ICAdown_DS10_RMS100_FULL 16 1000 10 100000 4
  * train loss at epoch:        326 = 0.0047614566 
  * best cross loss at epoch:        225 = 0.0028927540 
  * RMSE:  3.30520	 6.94552	
* ./rnn S2WA_10_SUP_1_SUP_2_SUP_4_ICAdown_DS10_RMS100_FULL S2WA_10_SUP_5_ICAdown_DS10_RMS100_FULL S2WA_10_SUP_3_ICAdown_DS10_RMS100_FULL 16 1000 10 100000 4
  * train loss at epoch:       1000 = 0.0037294653 
  * best cross loss at epoch:        998 = 0.0042046432 
  * RMSE:  2.83162	14.13246	
* ./rnn S2WA_10_FLX_1_FLX_2_FLX_4_ICAdown_DS10_RMS100_FULL S2WA_10_FLX_5_ICAdown_DS10_RMS100_FULL S2WA_10_FLX_3_ICAdown_DS10_RMS100_FULL 16 1000 10 100000 4
  * train loss at epoch:       1000 = 0.0016586083 
  * best cross loss at epoch:        999 = 0.0040785879 
  * RMSE:  4.14522	 1.96698	
* ./rnn S2WA_10_EXT_1_EXT_2_EXT_4_ICAdown_DS10_RMS100_FULL S2WA_10_EXT_5_ICAdown_DS10_RMS100_FULL S2WA_10_EXT_3_ICAdown_DS10_RMS100_FULL 16 1000 10 100000 4
  * train loss at epoch:        293 = 0.0066430194 
  * best cross loss at epoch:        192 = 0.0060643414 
  * RMSE: 10.48434	 5.58546	

* ./rnn S2WA_10_PRO_1_PRO_2_PRO_5_ICAdown_DS10_RMS100_FULL S2WA_10_PRO_4_ICAdown_DS10_RMS100_FULL S2WA_10_PRO_3_ICAdown_DS10_RMS100_FULL 16 1000 10 100000 4
  * train loss at epoch:        351 = 0.0039016665 
  * best cross loss at epoch:        250 = 0.0037975109 
  * RMSE:  1.51725	 4.93969	
* ./rnn S2WA_10_SUP_1_SUP_2_SUP_5_ICAdown_DS10_RMS100_FULL S2WA_10_SUP_4_ICAdown_DS10_RMS100_FULL S2WA_10_SUP_3_ICAdown_DS10_RMS100_FULL 16 1000 10 100000 4
  * train loss at epoch:        505 = 0.0179972663 
  * best cross loss at epoch:        404 = 0.0119195534 
  * RMSE:  2.79474	10.52011	
* ./rnn S2WA_10_FLX_1_FLX_2_FLX_5_ICAdown_DS10_RMS100_FULL S2WA_10_FLX_4_ICAdown_DS10_RMS100_FULL S2WA_10_FLX_3_ICAdown_DS10_RMS100_FULL 16 1000 10 100000 4
  * train loss at epoch:        800 = 0.0018147324 
  * best cross loss at epoch:        699 = 0.0029898749 
  * RMSE:  3.13330	 1.59923	
* ./rnn S2WA_10_EXT_1_EXT_2_EXT_5_ICAdown_DS10_RMS100_FULL S2WA_10_EXT_4_ICAdown_DS10_RMS100_FULL S2WA_10_EXT_3_ICAdown_DS10_RMS100_FULL 16 1000 10 100000 4
  * train loss at epoch:        743 = 0.0039122018 
  * best cross loss at epoch:        642 = 0.0025672940 
  * RMSE:  8.96192	 2.88905	

* ./rnn S2WA_10_PRO_1_PRO_2_PRO_3_PRO_5_SUP_1_SUP_2_SUP_3_SUP_5_PROSUP_2_ICAdown_DS10_RMS100_FULL S2WA_10_PROSUP_1_ICAdown_DS10_RMS100_FULL S2WA_10_SUP_4_PRO_4_PROSUP_3_ICAdown_DS10_RMS100_FULL 16 1000 10 100000 4
  * train loss at epoch:        480 = 0.0143688535 
  * best cross loss at epoch:        379 = 0.0111740868 
  * RMSE:  4.08213	13.18512	
* ./rnn S2WA_10_PRO_1_PRO_2_PRO_3_PRO_5_SUP_1_SUP_2_SUP_3_SUP_5_PROSUP_1_ICAdown_DS10_RMS100_FULL S2WA_10_PROSUP_2_ICAdown_DS10_RMS100_FULL S2WA_10_SUP_4_PRO_4_PROSUP_3_ICAdown_DS10_RMS100_FULL 16 1000 10 100000 4
  * train loss at epoch:        555 = 0.0118760382 
  * best cross loss at epoch:        454 = 0.0295923865 
  * RMSE:  3.53738	13.70397	
* ./rnn S2WA_10_PRO_1_PRO_2_PRO_3_PRO_5_SUP_1_SUP_2_SUP_3_SUP_5_PROSUP_2_ICAdown_DS10_RMS100_FULL S2WA_10_PROSUP_3_ICAdown_DS10_RMS100_FULL S2WA_10_SUP_4_PRO_4_PROSUP_1_ICAdown_DS10_RMS100_FULL 16 1000 10 100000 4
  * train loss at epoch:        359 = 0.0587815277 
  * best cross loss at epoch:        258 = 0.0330376780 
  * RMSE:  2.98529	37.26580	

* ./rnn S2WA_10_FLX_1_FLX_2_FLX_3_FLX_5_EXT_1_EXT_2_EXT_3_EXT_5_FLXEXT_2_ICAdown_DS10_RMS100_FULL S2WA_10_FLXEXT_1_ICAdown_DS10_RMS100_FULL S2WA_10_EXT_4_FLX_4_FLXEXT_3_ICAdown_DS10_RMS100_FULL 16 1000 10 100000 4
  * train loss at epoch:        400 = 0.0034992126 
  * best cross loss at epoch:        299 = 0.0063262543 
  * RMSE:  5.16088	 2.29983	
* ./rnn S2WA_10_FLX_1_FLX_2_FLX_3_FLX_5_EXT_1_EXT_2_EXT_3_EXT_5_FLXEXT_1_ICAdown_DS10_RMS100_FULL S2WA_10_FLXEXT_2_ICAdown_DS10_RMS100_FULL S2WA_10_EXT_4_FLX_4_FLXEXT_3_ICAdown_DS10_RMS100_FULL 16 1000 10 100000 4
  * train loss at epoch:        760 = 0.0017800183 
  * best cross loss at epoch:        659 = 0.0049794912 
  * RMSE:  5.14539	 1.63276	
* ./rnn S2WA_10_FLX_1_FLX_2_FLX_3_FLX_5_EXT_1_EXT_2_EXT_3_EXT_5_FLXEXT_2_ICAdown_DS10_RMS100_FULL S2WA_10_FLXEXT_3_ICAdown_DS10_RMS100_FULL S2WA_10_EXT_4_FLX_4_FLXEXT_1_ICAdown_DS10_RMS100_FULL 16 1000 10 100000 4
  * train loss at epoch:       1000 = 0.0025984670 
  * best cross loss at epoch:        981 = 0.0044213837 
  * RMSE:  3.84648	 2.65503	

H: 24 P: 100
* ./rnn S2WA_10_PRO_1_PRO_2_PRO_4_ICAdown_DS10_RMS100_FULL S2WA_10_PRO_5_ICAdown_DS10_RMS100_FULL S2WA_10_PRO_3_ICAdown_DS10_RMS100_FULL 24 1000 10 100000 4
  * train loss at epoch:        531 = 0.0119049611 
  * best cross loss at epoch:        430 = 0.0047075305 
  * RMSE:  1.81377	 7.91880	
* ./rnn S2WA_10_SUP_1_SUP_2_SUP_4_ICAdown_DS10_RMS100_FULL S2WA_10_SUP_5_ICAdown_DS10_RMS100_FULL S2WA_10_SUP_3_ICAdown_DS10_RMS100_FULL 24 1000 10 100000 4
  * train loss at epoch:        265 = 0.0223911937 
  * best cross loss at epoch:        164 = 0.0134187160 
  * RMSE:  6.63437	20.93510	
* ./rnn S2WA_10_FLX_1_FLX_2_FLX_4_ICAdown_DS10_RMS100_FULL S2WA_10_FLX_5_ICAdown_DS10_RMS100_FULL S2WA_10_FLX_3_ICAdown_DS10_RMS100_FULL 24 1000 10 100000 4
  * train loss at epoch:        495 = 0.0077524852 
  * best cross loss at epoch:        394 = 0.0057821750 
  * RMSE:  5.59157	 3.71448	
* ./rnn S2WA_10_EXT_1_EXT_2_EXT_4_ICAdown_DS10_RMS100_FULL S2WA_10_EXT_5_ICAdown_DS10_RMS100_FULL S2WA_10_EXT_3_ICAdown_DS10_RMS100_FULL 24 1000 10 100000 4
  * train loss at epoch:        299 = 0.0212385342 
  * best cross loss at epoch:        198 = 0.0107032265 
  * RMSE:  8.08297	 6.13522	

* ./rnn S2WA_10_PRO_1_PRO_2_PRO_5_ICAdown_DS10_RMS100_FULL S2WA_10_PRO_4_ICAdown_DS10_RMS100_FULL S2WA_10_PRO_3_ICAdown_DS10_RMS100_FULL 24 1000 10 100000 4
  * train loss at epoch:        373 = 0.0066935013 
  * best cross loss at epoch:        272 = 0.0055034391 
  * RMSE:  1.38701	 5.31909	
* ./rnn S2WA_10_SUP_1_SUP_2_SUP_5_ICAdown_DS10_RMS100_FULL S2WA_10_SUP_4_ICAdown_DS10_RMS100_FULL S2WA_10_SUP_3_ICAdown_DS10_RMS100_FULL 24 1000 10 100000 4
  * train loss at epoch:        295 = 0.0183953010 
  * best cross loss at epoch:        194 = 0.0167050176 
  * RMSE:  3.26454	12.05818	
* ./rnn S2WA_10_FLX_1_FLX_2_FLX_5_ICAdown_DS10_RMS100_FULL S2WA_10_FLX_4_ICAdown_DS10_RMS100_FULL S2WA_10_FLX_3_ICAdown_DS10_RMS100_FULL 24 1000 10 100000 4
  * train loss at epoch:        502 = 0.0086334224 
  * best cross loss at epoch:        401 = 0.0066382860 
  * RMSE:  6.20856	 2.11401	
* ./rnn S2WA_10_EXT_1_EXT_2_EXT_5_ICAdown_DS10_RMS100_FULL S2WA_10_EXT_4_ICAdown_DS10_RMS100_FULL S2WA_10_EXT_3_ICAdown_DS10_RMS100_FULL 24 1000 10 100000 4
  * train loss at epoch:        327 = 0.0094779743 
  * best cross loss at epoch:        226 = 0.0055171839 
  * RMSE: 10.20570	 2.21743	

* ./rnn S2WA_10_PRO_1_PRO_2_PRO_3_PRO_5_SUP_1_SUP_2_SUP_3_SUP_5_PROSUP_2_ICAdown_DS10_RMS100_FULL S2WA_10_PROSUP_1_ICAdown_DS10_RMS100_FULL S2WA_10_SUP_4_PRO_4_PROSUP_3_ICAdown_DS10_RMS100_FULL 24 1000 10 100000 4
  * train loss at epoch:        633 = 0.0380285047 
  * best cross loss at epoch:        532 = 0.0342903124 
  * RMSE:  6.88204	21.13562	
* ./rnn S2WA_10_PRO_1_PRO_2_PRO_3_PRO_5_SUP_1_SUP_2_SUP_3_SUP_5_PROSUP_1_ICAdown_DS10_RMS100_FULL S2WA_10_PROSUP_2_ICAdown_DS10_RMS100_FULL S2WA_10_SUP_4_PRO_4_PROSUP_3_ICAdown_DS10_RMS100_FULL 24 1000 10 100000 4
  * train loss at epoch:        533 = 0.0091163755 
  * best cross loss at epoch:        432 = 0.0119992177 
  * RMSE:  4.03452	11.56736	
* ./rnn S2WA_10_PRO_1_PRO_2_PRO_3_PRO_5_SUP_1_SUP_2_SUP_3_SUP_5_PROSUP_2_ICAdown_DS10_RMS100_FULL S2WA_10_PROSUP_3_ICAdown_DS10_RMS100_FULL S2WA_10_SUP_4_PRO_4_PROSUP_1_ICAdown_DS10_RMS100_FULL 24 1000 10 100000 4
  * train loss at epoch:        925 = 0.0073711844 
  * best cross loss at epoch:        824 = 0.0126414753 
  * RMSE:  5.83771	14.78228	

* ./rnn S2WA_10_FLX_1_FLX_2_FLX_3_FLX_5_EXT_1_EXT_2_EXT_3_EXT_5_FLXEXT_2_ICAdown_DS10_RMS100_FULL S2WA_10_FLXEXT_1_ICAdown_DS10_RMS100_FULL S2WA_10_EXT_4_FLX_4_FLXEXT_3_ICAdown_DS10_RMS100_FULL 24 1000 10 100000 4
  * train loss at epoch:        154 = 0.0237559161 
  * best cross loss at epoch:         53 = 0.0228125184 
  * RMSE: 11.07096	 6.02347	
* ./rnn S2WA_10_FLX_1_FLX_2_FLX_3_FLX_5_EXT_1_EXT_2_EXT_3_EXT_5_FLXEXT_1_ICAdown_DS10_RMS100_FULL S2WA_10_FLXEXT_2_ICAdown_DS10_RMS100_FULL S2WA_10_EXT_4_FLX_4_FLXEXT_3_ICAdown_DS10_RMS100_FULL 24 1000 10 100000 4
  * train loss at epoch:        222 = 0.0178574776 
  * best cross loss at epoch:        121 = 0.0139876644 
  * RMSE:  9.19656	 2.96109	
* ./rnn S2WA_10_FLX_1_FLX_2_FLX_3_FLX_5_EXT_1_EXT_2_EXT_3_EXT_5_FLXEXT_2_ICAdown_DS10_RMS100_FULL S2WA_10_FLXEXT_3_ICAdown_DS10_RMS100_FULL S2WA_10_EXT_4_FLX_4_FLXEXT_1_ICAdown_DS10_RMS100_FULL 24 1000 10 100000 4
  * train loss at epoch:        189 = 0.0253699324 
  * best cross loss at epoch:         88 = 0.0249185776 
  * RMSE: 12.36692	 8.03181	



---