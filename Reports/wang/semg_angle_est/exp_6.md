### 6th Experiment

Supination/Pronation part 3. 

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

* ./rnn S2WA_6_SUP_1_ICA_DS4_RMS100_FULL S2WA_6_SUP_1_ICA_DS4_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0092484671
  * RMSE:  8.38753   1.89661  
* ./rnn S2WA_6_SUP_1_ICA_DS4_RMS100_FULL S2WA_6_SUP_1_ICA_DS4_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0063440724
  * RMSE:  6.85468   2.62160  
* ./rnn S2WA_6_SUP_1_ICA_DS4_RMS100_FULL S2WA_6_SUP_1_ICA_DS4_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0033877191
  * RMSE:  4.94890   1.72566  

* ./rnn S2WA_6_SUP_2_ICA_DS4_RMS100_FULL S2WA_6_SUP_2_ICA_DS4_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0054591409
  * RMSE:  6.57386   1.47211  
* ./rnn S2WA_6_SUP_2_ICA_DS4_RMS100_FULL S2WA_6_SUP_2_ICA_DS4_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0023053195
  * RMSE:  3.95235   1.54808  
* ./rnn S2WA_6_SUP_2_ICA_DS4_RMS100_FULL S2WA_6_SUP_2_ICA_DS4_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0011408151
  * RMSE:  2.59244   1.57428  
* ./rnn S2WA_6_SUP_3_ICA_DS4_RMS100_FULL S2WA_6_SUP_3_ICA_DS4_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0040135489
  * RMSE:  5.54915   0.98745  




* ./rnn S2WA_6_PRO_1_ICA_DS4_RMS100_FULL S2WA_6_PRO_1_ICA_DS4_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0029381033
  * RMSE:  4.74422   1.27910 

* ./rnn S2WA_6_PRO_2_ICA_DS4_RMS100_FULL S2WA_6_PRO_2_ICA_DS4_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0048632067
  * RMSE:  6.02300   1.74490  

* ./rnn S2WA_6_PRO_3_ICA_DS4_RMS100_FULL S2WA_6_PRO_3_ICA_DS4_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0032996644
  * RMSE:  4.26563   2.89215  



---



### 6th Experiment - LSTM, ICA, RMS @ 100pts, Downsampled @ 10hz - FULL-FULL - cross
* ./rnn S2WA_6_SUP_12_ICA_DS4_RMS100_FULL S2WA_6_SUP_3_ICA_DS4_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0076245389
  * RMSE:  4.48864   1.07493  
* ./rnn S2WA_6_SUP_12_ICA_DS4_RMS100_FULL S2WA_6_SUP_3_ICA_DS4_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0021120593
  * RMSE:  5.53554   0.88629    
* ./rnn S2WA_6_SUP_12_ICA_DS4_RMS100_FULL S2WA_6_SUP_3_ICA_DS4_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0010786694
  * RMSE:  7.36406   1.08493 

* ./rnn S2WA_6_PRO_12_ICA_DS4_RMS100_FULL S2WA_6_PRO_3_ICA_DS4_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        999 = 0.0029634879
  * RMSE:  8.81023   2.68081  
* ./rnn S2WA_6_PRO_12_ICA_DS4_RMS100_FULL S2WA_6_PRO_3_ICA_DS4_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1999 = 0.0030042516
  * RMSE:  8.83145   2.92031  
* ./rnn S2WA_6_PRO_12_ICA_DS4_RMS100_FULL S2WA_6_PRO_3_ICA_DS4_RMS100_FULL 8 4000 10 100000 4
  * average loss at epoch:       3999 = 0.0010654473
  * RMSE:  8.47311   2.68773  



---

### 6th Experiment - Notes

  * Pronator electrode location seems to be bad
    * sEMG response:
      * Pronation: Pro(2) + Sup(1), in equal magnitude <-
      * Supination: Mostly Sup(1) 
  * Small amplitude in both Pro&Sup, the force required to rotate forearm is too small
    * Torque may be needed, like in other paper
      * Heavier forearm?
      * Heavy load for hand?

   