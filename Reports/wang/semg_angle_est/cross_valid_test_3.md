### ICA after downsample, norm w/ training sample, no whitening

H: 8 P: 100
* ./rnn S2WA_7_SUP_1_SUP_2_SUP_3_SUP_4_PRO_1_PRO_2_PRO_3_PRO_4_PROSUP_2_newICA_DS10_RMS100_FULL S2WA_7_PROSUP_1_newICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * train loss at epoch:        896 = 0.0086121997 
  * best cross loss at epoch:        795 = 0.0074810896 
  * RMSE:  8.13160	 2.22147	

H: 16 P: 100
* ./rnn S2WA_7_SUP_1_SUP_2_SUP_3_SUP_4_PRO_1_PRO_2_PRO_3_PRO_4_PROSUP_2_newICA_DS10_RMS100_FULL S2WA_7_PROSUP_1_newICA_DS10_RMS100_FULL 16 1000 10 100000 4
  * train loss at epoch:        649 = 0.0058360142 
  * best cross loss at epoch:        548 = 0.0065205666 
  * RMSE:  7.28735	 1.49042	

H: 32 P: 100
* ./rnn S2WA_7_SUP_1_SUP_2_SUP_3_SUP_4_PRO_1_PRO_2_PRO_3_PRO_4_PROSUP_2_newICA_DS10_RMS100_FULL S2WA_7_PROSUP_1_newICA_DS10_RMS100_FULL 32 1000 10 100000 4
  * train loss at epoch:        506 = 0.0138797567 
  * best cross loss at epoch:        405 = 0.0224211721 
  * RMSE:  9.53805	 4.44785	
