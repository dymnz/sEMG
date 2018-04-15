### 3rd Experiment

Flexion/Extension, better posture for cleaner signal, better muscle selection.

* Muscle:
  * ~Extensor Digitorum~ Extensor Carpi Ulnaris 
  * ~Flexor Digitorum Superficialis~ Flexor Carpi Radialis
* Protocol
  * Zero-load, palm facing down, making a fist
  * ~Wrist hang free w/ forearm resting on a surface~ Forearm and Wrist are on the table. For Flexion, knuckles are supposed to touch the table; for Extension, the bottom of the wrist is supposed to touch the table.
  * Constant angular speed
  * 0 degree is defined as palm facing down flat on the table, <0 degree as finger moving up
  * Each dataset consists of 5~10 epoch w/ resting interval in between each epoch
  * R^2 error metric should be used to avoid bias for small value estimation
* Movement types
  * Extension: <0 degree only. From 0d move toward 90d then pause. Start moving toward 0d then stop.
    * S2WA_3_TABLE_2_EXT_
  * Flexion: >0 degree only. From 0d move toward -90d then pause. Start moving toward 0d then stop.
    * S2WA_3_TABLE_2_FLX_
  * Extension/Flexion: Full range. From 0d move toward 90d then pause. Start moving toward 0d then pause. From 0d move toward -90d then pause. Start moving toward 0d then stop.
    * S2WA_3_TABLE_2_FULL_

--- 

### 3rd Experiment - LSTM, ICA, RMS @ 100pts, Downsampled @ 10hz 

* ./rnn S2WA_TABLE_2_EXT_1_ICA_DS10_RMS100_SEG S2WA_TABLE_2_EXT_1_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        990 = 0.0017609517
  * RMSE: 1.814486 3.488483 

* ./rnn S2WA_TABLE_2_FLX_1_ICA_DS10_RMS100_SEG S2WA_TABLE_2_FLX_1_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        990 = 0.0011085136
  * RMSE: 1.927238 3.218357


### 3rd Experiment - LSTM, ICA, RMS @ 100pts, Downsampled @ 10hz - Joined dataset EXT_FLX test FULL-1

* ./rnn S2WA_TABLE_2_EXT_1_FLX_1_ICA_DS10_RMS100_SEG S2WA_TABLE_2_FULL_1_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        990 = 0.0100609062
  * RMSE: 2.822374 6.575323
  * Error spiked at the end, should be lower (average loss at epoch:        790 = 0.0020096474)

* ./rnn S2WA_TABLE_2_EXT_1_FLX_1_ICA_DS10_RMS100_SEG S2WA_TABLE_2_FULL_1_ICA_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1990 = 0.0014588203
  * RMSE: 2.740609 7.410742 

### 3rd Experiment - LSTM, **NO ICA**, RMS @ 100pts, Downsampled @ 10hz - Joined dataset EXT_FLX test FULL-1

* ./rnn S2WA_TABLE_2_EXT_1_FLX_1_DS10_RMS100_SEG S2WA_TABLE_2_FULL_1_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        990 = 0.0021264038
  * RMSE: 2.636967 6.700681

* ./rnn S2WA_TABLE_2_EXT_1_FLX_1_DS10_RMS100_SEG S2WA_TABLE_2_FULL_1_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1990 = 0.0013902089
  * RMSE: 3.157627 16.031830 