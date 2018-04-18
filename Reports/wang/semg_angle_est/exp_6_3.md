### 6-3 Experiment

Supination/Pronation part 3. Custom device to assist rotation. NO ICA

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

### 6th Experiment - LSTM, RMS @ 100pts, Downsampled @ 10hz - FULL-FULL - self

* ./rnn S2WA_6_SUP_1_DS10_RMS100_FULL S2WA_6_SUP_1_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0120586259
  * RMSE:  9.63882	 2.37195	
* ./rnn S2WA_6_SUP_1_DS10_RMS100_FULL S2WA_6_SUP_1_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0039227957
  * RMSE:  5.30285	 2.11082	
* ./rnn S2WA_6_SUP_1_DS10_RMS100_FULL S2WA_6_SUP_1_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0039981705
  * RMSE:  5.28122	 1.69413	
 
* ./rnn S2WA_6_SUP_2_DS10_RMS100_FULL S2WA_6_SUP_2_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0039298734
  * RMSE:  5.38020	 1.78949	
* ./rnn S2WA_6_SUP_2_DS10_RMS100_FULL S2WA_6_SUP_2_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0034587046
  * RMSE:  5.08325	 1.28027	
* ./rnn S2WA_6_SUP_2_DS10_RMS100_FULL S2WA_6_SUP_2_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0020736674
  * RMSE:  3.45845	 2.32862	 

* ./rnn S2WA_6_SUP_3_DS10_RMS100_FULL S2WA_6_SUP_3_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0042383119
  * RMSE:  5.67183	 1.79054	
* ./rnn S2WA_6_SUP_3_DS10_RMS100_FULL S2WA_6_SUP_3_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0030042326
  * RMSE:  4.50368	 1.83670	
* ./rnn S2WA_6_SUP_3_DS10_RMS100_FULL S2WA_6_SUP_3_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0019764212
  * RMSE:  3.72109	 1.01452	


* ./rnn S2WA_6_PRO_1_DS10_RMS100_FULL S2WA_6_PRO_1_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0031684317
  * RMSE:  4.16767	 2.82956	
* ./rnn S2WA_6_PRO_1_DS10_RMS100_FULL S2WA_6_PRO_1_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0024817709
  * RMSE:  3.56318	 2.74454	
* ./rnn S2WA_6_PRO_1_DS10_RMS100_FULL S2WA_6_PRO_1_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0019631552
  * RMSE:  3.59966	 1.65080	

* ./rnn S2WA_6_PRO_2_DS10_RMS100_FULL S2WA_6_PRO_2_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0072794260
  * RMSE:  7.11921	 2.36746	
* ./rnn S2WA_6_PRO_2_DS10_RMS100_FULL S2WA_6_PRO_2_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0033768638
  * RMSE:  4.81058	 1.25234	
* ./rnn S2WA_6_PRO_2_DS10_RMS100_FULL S2WA_6_PRO_2_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0016810084
  * RMSE:  3.60954	 0.85308	

* ./rnn S2WA_6_PRO_3_DS10_RMS100_FULL S2WA_6_PRO_3_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0059110437
  * RMSE:  6.11228	 3.42373	
* ./rnn S2WA_6_PRO_3_DS10_RMS100_FULL S2WA_6_PRO_3_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0031684487
  * RMSE:  4.72995	 1.52940	
* ./rnn S2WA_6_PRO_3_DS10_RMS100_FULL S2WA_6_PRO_3_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0021778309
  * RMSE:  3.93544	 1.40791	


---

### 6th Experiment - LSTM, ICA, RMS @ 100pts, Downsampled @ 10hz - FULL-FULL - cross

* ./rnn S2WA_6_SUP_1_SUP_2_DS10_RMS100_FULL S2WA_6_SUP_3_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0043998457
  * RMSE:  6.00009	 2.02449	
* ./rnn S2WA_6_SUP_1_SUP_2_DS10_RMS100_FULL S2WA_6_SUP_3_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0023466696
  * RMSE:  6.32396	 1.52043	
* ./rnn S2WA_6_SUP_1_SUP_2_DS10_RMS100_FULL S2WA_6_SUP_3_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0014521266
  * RMSE:  8.44502	 1.25477	


* ./rnn S2WA_6_PRO_1_PRO_2_DS10_RMS100_FULL S2WA_6_PRO_3_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0032574121
  * RMSE:  7.03811	 3.08717	
* ./rnn S2WA_6_PRO_1_PRO_2_DS10_RMS100_FULL S2WA_6_PRO_3_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0054458753
  * RMSE:  6.50586	 1.91884	
* ./rnn S2WA_6_PRO_1_PRO_2_DS10_RMS100_FULL S2WA_6_PRO_3_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0023258014
  * RMSE:  8.28340	 3.43738	

---

### 6th Experiment - LSTM, JOINT_ICA, RMS @ 100pts, Downsampled @ 10hz - FULL-FULL - cross


* ./rnn S2WA_6_PRO_1_PRO_2_SUP_1_SUP_2_DS10_RMS100_FULL S2WA_6_PRO_3_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0162230805
  * RMSE: 13.03734	 3.10902	
* ./rnn S2WA_6_PRO_1_PRO_2_SUP_1_SUP_2_DS10_RMS100_FULL S2WA_6_PRO_3_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0056536728
  * RMSE: 23.77072	 3.55651	
* ./rnn S2WA_6_PRO_1_PRO_2_SUP_1_SUP_2_DS10_RMS100_FULL S2WA_6_PRO_3_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0044427993
  * RMSE:  7.57947	 3.83164	
* ./rnn S2WA_6_PRO_1_PRO_2_SUP_1_SUP_2_DS10_RMS100_FULL S2WA_6_PRO_3_DS10_RMS100_FULL 8 8000 10 100000 4
  * average loss at epoch:       7999 = 0.0204741149
  * RMSE:  9.03810	 3.29326	
* ./rnn S2WA_6_PRO_1_PRO_2_SUP_1_SUP_2_DS10_RMS100_FULL S2WA_6_PRO_3_DS10_RMS100_FULL 8 12000 10 100000 4
  * average loss at epoch:      11999 = 0.0100593159
  * RMSE: 10.98928	 3.23305	

* ./rnn S2WA_6_PRO_1_PRO_2_SUP_1_SUP_2_DS10_RMS100_FULL S2WA_6_PRO_3_DS10_RMS100_FULL 16 1000 10 100000 4
  * average loss at epoch:        999 = 0.0214140912
  * RMSE: 16.61689	 3.83099	
* ./rnn S2WA_6_PRO_1_PRO_2_SUP_1_SUP_2_DS10_RMS100_FULL S2WA_6_PRO_3_DS10_RMS100_FULL 16 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0140161749
  * RMSE: 15.73037	 3.69578	
* ./rnn S2WA_6_PRO_1_PRO_2_SUP_1_SUP_2_DS10_RMS100_FULL S2WA_6_PRO_3_DS10_RMS100_FULL 16 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0051393801
  * RMSE:  7.28086	 4.06423	


---

### 6th Experiment - LSTM, JOINT_ICA, RMS @ 100pts, Downsampled @ 10hz - FULL-FULL - PROSUP

#### PROSUP_1

From the validation above, epoch = 4000 should give the best result

* ./rnn S2WA_6_PRO_1_PRO_2_SUP_1_SUP_2_DS10_RMS100_FULL S2WA_6_PROSUP_1_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0162230805
  * RMSE: 20.51659	 2.36710	
* ./rnn S2WA_6_PRO_1_PRO_2_SUP_1_SUP_2_DS10_RMS100_FULL S2WA_6_PROSUP_1_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0056536728
  * RMSE: 21.29521	 2.38647	
* ./rnn S2WA_6_PRO_1_PRO_2_SUP_1_SUP_2_DS10_RMS100_FULL S2WA_6_PROSUP_1_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0044427993
  * RMSE: 35.06863	 2.32083	
 

* ./rnn S2WA_6_PRO_1_PRO_2_PRO_3_SUP_1_SUP_2_SUP_3_DS10_RMS100_FULL S2WA_6_PROSUP_1_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0177118158
  * RMSE: 25.46395	 2.86638	
* ./rnn S2WA_6_PRO_1_PRO_2_PRO_3_SUP_1_SUP_2_SUP_3_DS10_RMS100_FULL S2WA_6_PROSUP_1_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0613867231
  * RMSE: 11.73656	 2.08380	
* ./rnn S2WA_6_PRO_1_PRO_2_PRO_3_SUP_1_SUP_2_SUP_3_DS10_RMS100_FULL S2WA_6_PROSUP_1_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0097422229
  * RMSE: 19.19111	 2.48849	


* ./rnn S2WA_6_PRO_1_PRO_2_PRO_3_SUP_1_SUP_2_SUP_3_DS10_RMS100_FULL S2WA_6_PROSUP_2_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0177118158
  * RMSE: 15.50791	 2.37371	
* ./rnn S2WA_6_PRO_1_PRO_2_PRO_3_SUP_1_SUP_2_SUP_3_DS10_RMS100_FULL S2WA_6_PROSUP_2_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0613867231
  * RMSE: 10.71091	 1.85864	
* ./rnn S2WA_6_PRO_1_PRO_2_PRO_3_SUP_1_SUP_2_SUP_3_DS10_RMS100_FULL S2WA_6_PROSUP_2_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0097422229
  * RMSE: 20.94776	 2.68542	

* ./rnn S2WA_6_PRO_1_PRO_2_PRO_3_SUP_1_SUP_2_SUP_3_PROSUP_1_DS10_RMS100_FULL S2WA_6_PROSUP_2_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0136191681
  * RMSE: 11.37474	 1.71688	
* ./rnn S2WA_6_PRO_1_PRO_2_PRO_3_SUP_1_SUP_2_SUP_3_PROSUP_1_DS10_RMS100_FULL S2WA_6_PROSUP_2_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0080948319
  * RMSE: 11.11106	 1.77466	
* ./rnn S2WA_6_PRO_1_PRO_2_PRO_3_SUP_1_SUP_2_SUP_3_PROSUP_1_DS10_RMS100_FULL S2WA_6_PROSUP_2_DS10_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0055168896
  * RMSE: 10.11074	 1.72827	



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
- [ ] 6-2 Free hand results