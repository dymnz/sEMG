### ICA after downsample, H:8, patience = 10

* ./rnn S2WA_7_SUP_1_SUP_2_SUP_3_SUP_4_SUP_5_PRO_1_PRO_2_PRO_3_PRO_4_PRO_5_newICA_DS10_RMS100_FULL S2WA_7_PROSUP_1_newICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * train loss at epoch:        106 = 1.6281282155 
  * best cross loss at epoch:         95 = 0.0139601518 
  * RMSE: 10.15402   3.54031  

* ./rnn S2WA_7_SUP_1_SUP_2_SUP_3_SUP_4_SUP_5_PRO_1_PRO_2_PRO_3_PRO_4_PRO_5_newICA_DS10_RMS100_FULL S2WA_7_PROSUP_2_newICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * train loss at epoch:        150 = 0.0145365860 
  * best cross loss at epoch:        139 = 0.0174245085 
  * RMSE: 18.48214   4.10576  

---

### ICA after downsample, H:16, patience = 10

---

### ICA after downsample, H:16, patience = 50

* ./rnn S2WA_7_SUP_1_SUP_2_SUP_3_SUP_4_SUP_5_PRO_1_PRO_2_PRO_3_PRO_4_PRO_5_newICA_DS10_RMS100_FULL S2WA_7_PROSUP_1_newICA_DS10_RMS100_FULL 16 1000 10 100000 4
  * train loss at epoch:        709 = 0.0061127916 
  * best cross loss at epoch:        658 = 0.0039755786 
  * RMSE: 22.84019   4.89473  


* ./rnn S2WA_7_SUP_1_SUP_2_SUP_3_SUP_4_SUP_5_PRO_1_PRO_2_PRO_3_PRO_4_PRO_5_newICA_DS10_RMS100_FULL S2WA_7_PROSUP_2_newICA_DS10_RMS100_FULL 16 1000 10 100000 4
  * train loss at epoch:        438 = 0.0049573172 
  * best cross loss at epoch:        387 = 0.0058232812 
  * RMSE: 23.97274   3.20115  

---

### PCA, H:8, patience = 10

* ./rnn S2WA_7_SUP_1_SUP_2_SUP_3_SUP_4_SUP_5_PRO_1_PRO_2_PRO_3_PRO_4_PRO_5_PCA_DS10_RMS100_FULL S2WA_7_PROSUP_1_PCA_DS10_RMS100_FULL 8 1000 10 100000 4
  * train loss at epoch:         62 = 0.0193642713 
  * best cross loss at epoch:         51 = 0.0224717230 
  * RMSE: 12.48236	 5.25520	


* ./rnn S2WA_7_SUP_1_SUP_2_SUP_3_SUP_4_SUP_5_PRO_1_PRO_2_PRO_3_PRO_4_PRO_5_PCA_DS10_RMS100_FULL S2WA_7_PROSUP_2_PCA_DS10_RMS100_FULL 8 1000 10 100000 4
  * train loss at epoch:         79 = 2.8525085047 
  * best cross loss at epoch:         68 = 0.0152212123 
  * RMSE: 14.20625	 4.75463	

---