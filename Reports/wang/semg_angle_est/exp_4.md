### 4th Experiment

Pronation/Supination. First test, try to locate optimal muscle location and check signal condition.

* Muscle:
  * Biceps Brachii (CH1)
  * Pronator Teres (CH2)
* Protocol
  * Zero-load, palm facing down, making a fist
  * ~Wrist hang free w/ forearm resting on a surface~ Forearm and Wrist are on the table. Hand should always contact the table, to avoid raising forearm.
  * Constant angular speed
  * 0 degree is defined as palm facing down flat on the table, >0 as wrist turn right
  * Each dataset consists of 5~10 epoch w/ resting interval in between each epoch
  * R^2 error metric should be used to avoid bias for small value estimation
* Movement types
  * Pronation: <0 degree only. From 0d move toward -90d then pause. Start moving toward 0d then stop.
    * S2WA_4_TABLE_PRO_
  * Supination: >0 degree only. From 0d move toward 90d then pause. Start moving toward 0d then stop.
    * S2WA_4_TABLE_SUP_
  * Extension/Flexion: Full range. From 0d move toward 90d then pause. Start moving toward 0d then pause. From 0d move toward -90d then pause. Start moving toward 0d then stop.
    * S2WA_4_TABLE_2_PROSUP_

--- 

### 4th Experiment - LSTM, ICA, RMS @ 100pts, Downsampled @ 10hz (SUP_ONLY)

* ./rnn S2WA_TABLE_SUP_1_ICA_DS10_RMS100_SEG S2WA_TABLE_SUP_1_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        990 = 0.0085375278
  * RMSE: 34.637599 13.661832
* ./rnn S2WA_TABLE_SUP_1_ICA_DS10_RMS100_SEG S2WA_TABLE_SUP_1_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        990 = 0.0114669345
  * RMSE: 8.287258 2.922720 
* ./rnn S2WA_TABLE_SUP_1_ICA_DS10_RMS100_SEG S2WA_TABLE_SUP_1_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        990 = 0.0089704025
  * RMSE: 15.577034 4.888048
  
* ./rnn S2WA_TABLE_SUP_1_ICA_DS10_RMS100_SEG S2WA_TABLE_SUP_1_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        990 = 0.0070851333
  * RMSE: 14.140386 4.834714
* ./rnn S2WA_TABLE_SUP_1_ICA_DS10_RMS100_SEG S2WA_TABLE_SUP_1_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        990 = 0.0098689447
  * RMSE: 8.195197 2.922187
* ./rnn S2WA_TABLE_SUP_1_ICA_DS10_RMS100_SEG S2WA_TABLE_SUP_1_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        990 = 0.0108921021
  * RMSE: 8.698493 3.071939
* ./rnn S2WA_TABLE_SUP_1_ICA_DS10_RMS100_SEG S2WA_TABLE_SUP_1_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        990 = 0.0095202743
  * RMSE: 10.902976 3.858131

* **ICA introduce randomness**
  - Training error fluctuates throughout the training process
  - Some result is good, others are bad
    - W/ PCA?

---

### 4th Experiment - LSTM, JOINT_ICA, RMS @ 100pts, Downsampled @ 10hz

ICA info from both SUP & PRO, to address the issue of fluctuating ICA result

* ./rnn S2WA_TABLE_PRO_1_JOINT_ICA_DS10_RMS100_SEG S2WA_TABLE_PRO_1_JOINT_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        990 = 0.0015408543
  * RMSE: 3.284651 1.394244 
* ./rnn S2WA_TABLE_PRO_1_JOINT_ICA_DS10_RMS100_SEG S2WA_TABLE_PRO_1_JOINT_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        990 = 0.0014282644
  * RMSE: 3.374811 1.322625  
* ./rnn S2WA_TABLE_PRO_1_JOINT_ICA_DS10_RMS100_SEG S2WA_TABLE_PRO_1_JOINT_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        990 = 0.0016472031
  * RMSE: 3.670076 1.299148 
* ./rnn S2WA_TABLE_PRO_1_JOINT_ICA_DS10_RMS100_SEG S2WA_TABLE_PRO_1_JOINT_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        990 = 0.0013845845
  * RMSE: 3.291423 1.313208 
* ./rnn S2WA_TABLE_PRO_1_JOINT_ICA_DS10_RMS100_SEG S2WA_TABLE_PRO_1_JOINT_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        990 = 0.0014951096
  * RMSE: 3.247694 1.193535


* ./rnn S2WA_TABLE_SUP_1_JOINT_ICA_DS10_RMS100_SEG S2WA_TABLE_SUP_1_JOINT_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        990 = 0.0167718437
  * RMSE: 11.127434 4.023262
  * Fluctuating training error
 ./rnn S2WA_TABLE_SUP_1_JOINT_ICA_DS10_RMS100_SEG S2WA_TABLE_SUP_1_JOINT_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        990 = 0.0094689879
  * RMSE: 8.651187 3.104887 
  * Stable training error
./rnn S2WA_TABLE_SUP_1_JOINT_ICA_DS10_RMS100_SEG S2WA_TABLE_SUP_1_JOINT_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        990 = 0.0105065337
  * RMSE: 13.248671 4.651663
  * Stable training error
./rnn S2WA_TABLE_SUP_1_JOINT_ICA_DS10_RMS100_SEG S2WA_TABLE_SUP_1_JOINT_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        990 = 0.0082307702
  * RMSE: 10.965078 4.019676
  * Fluctuating training error
./rnn S2WA_TABLE_SUP_1_JOINT_ICA_DS10_RMS100_SEG S2WA_TABLE_SUP_1_JOINT_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        990 = 0.0094685223
  * RMSE: 8.651108 3.104862
  * Stable training error
---

### 4th Experiment - LSTM, ICA, RMS @ 100pts, Downsampled @ 10hz (PRO_ONLY)

* ./rnn S2WA_TABLE_PRO_1_ICA_DS10_RMS100_SEG S2WA_TABLE_PRO_1_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        990 = 0.0016841109
  * RMSE: 3.450346 1.434744 
* ./rnn S2WA_TABLE_PRO_1_ICA_DS10_RMS100_SEG S2WA_TABLE_PRO_1_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        990 = 0.0016063055
  * RMSE: 3.643467 1.367268 
* ./rnn S2WA_TABLE_PRO_1_ICA_DS10_RMS100_SEG S2WA_TABLE_PRO_1_ICA_DS10_RMS100_FULL 8 900 10 100000 4
  * average loss at epoch:        890 = 0.00153219085
  * RMSE: 77.844851 39.931416
* ./rnn S2WA_TABLE_PRO_1_ICA_DS10_RMS100_SEG S2WA_TABLE_PRO_1_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        990 = 0.0016066516
  * RMSE: 3.643851 1.368969
* ./rnn S2WA_TABLE_PRO_1_ICA_DS10_RMS100_SEG S2WA_TABLE_PRO_1_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        990 = 0.0015347331
  * RMSE: 3.669093 1.279207

* **ICA introduce randomness**

---

### 4th Experiment - LSTM, ICA, RMS @ 100pts, Downsampled @ 10hz - Cross (SUP_ONLY)

* ./rnn S2WA_TABLE_SUP_1_ICA_DS10_RMS100_SEG S2WA_TABLE_SUP_2_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        990 = 0.0085375278
  * RMSE: 13.275404 5.148494
  * nusable, large error. RMSE is misleading
* ./rnn S2WA_TABLE_SUP_2_ICA_DS10_RMS100_SEG S2WA_TABLE_SUP_1_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        990 = 0.0085375278
  * RMSE: 17.528135 6.870951
  * Unusable


* ./rnn S2WA_TABLE_SUP_1_ICA_DS10_RMS100_SEG S2WA_TABLE_SUP_2_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        990 = 0.0102477219
  * RMSE: 92.027532 195.570347 
* ./rnn S2WA_TABLE_SUP_1_ICA_DS10_RMS100_SEG S2WA_TABLE_SUP_2_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        990 = 0.0052904072
  * RMSE: 14.856958 5.614477 
* ./rnn S2WA_TABLE_SUP_1_ICA_DS10_RMS100_SEG S2WA_TABLE_SUP_2_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        990 = 0.0073894245
  * RMSE: 13.372225 5.776094
* ./rnn S2WA_TABLE_SUP_1_ICA_DS10_RMS100_SEG S2WA_TABLE_SUP_2_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        990 = 0.0051602242
  * RMSE: 13.595110 4.577793
* ./rnn S2WA_TABLE_SUP_1_ICA_DS10_RMS100_SEG S2WA_TABLE_SUP_2_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        990 = 0.0081071755
  * RMSE: 15.046800 5.247477 


* ./rnn S2WA_TABLE_SUP_2_ICA_DS10_RMS100_SEG S2WA_TABLE_SUP_1_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        990 = 0.0037598874
  * RMSE: 22.297338 119.346746 
* ./rnn S2WA_TABLE_SUP_2_ICA_DS10_RMS100_SEG S2WA_TABLE_SUP_1_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        990 = 0.0034252726
  * RMSE: 22.314083 119.787434
* ./rnn S2WA_TABLE_SUP_2_ICA_DS10_RMS100_SEG S2WA_TABLE_SUP_1_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        990 = 0.0029277269
  * RMSE: 50.169095 14.773631

---

### 4th Experiment - LSTM, JOINT_ICA, RMS @ 100pts, Downsampled @ 10hz - Cross (SUP_ONLY)

* ./rnn S2WA_TABLE_SUP_1_JOINT_ICA_DS10_RMS100_SEG S2WA_TABLE_SUP_2_JOINT_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        990 = 0.0105078963
  * RMSE: 13.073268 5.802811 
* ./rnn S2WA_TABLE_SUP_1_JOINT_ICA_DS10_RMS100_SEG S2WA_TABLE_SUP_2_JOINT_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        990 = 0.0105077962
  * RMSE: 13.073224 5.802188
* ./rnn S2WA_TABLE_SUP_1_JOINT_ICA_DS10_RMS100_SEG S2WA_TABLE_SUP_2_JOINT_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        990 = 0.0110358269
  * RMSE: 13.430687 5.614950 
---

### 4th Experiment - LSTM, ICA, RMS @ 100pts, Downsampled @ 10hz - Cross (PRO_ONLY)

* ./rnn S2WA_TABLE_PRO_1_ICA_DS10_RMS100_SEG S2WA_TABLE_PRO_2_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        990 = 0.0085375278
  * RMSE: 13.275404 5.148494
  * nusable, large error. RMSE is misleading
* ./rnn S2WA_TABLE_SUP_2_ICA_DS10_RMS100_SEG S2WA_TABLE_SUP_1_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        990 = 0.0085375278
  * RMSE: 17.528135 6.870951
  * Unusable

* ./rnn S2WA_TABLE_PRO_1_ICA_DS10_RMS100_SEG S2WA_TABLE_PRO_2_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        990 = 0.0014563078
  * RMSE: 43.644222 31.428476

* ./rnn S2WA_TABLE_PRO_1_ICA_DS10_RMS100_SEG S2WA_TABLE_PRO_2_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        990 = 0.0014718486
  * RMSE: 9.221658 1.619553 
* ./rnn S2WA_TABLE_PRO_1_ICA_DS10_RMS100_SEG S2WA_TABLE_PRO_2_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        990 = 0.0015348592
  * RMSE: 7.492726 1.594716 
* ./rnn S2WA_TABLE_PRO_1_ICA_DS10_RMS100_SEG S2WA_TABLE_PRO_2_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        990 = 0.0016811064
  * RMSE: 20.675303 2.928961
* ./rnn S2WA_TABLE_PRO_1_ICA_DS10_RMS100_SEG S2WA_TABLE_PRO_2_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        990 = 0.0016066516
  * RMSE: 7.171619 1.354850 
* ./rnn S2WA_TABLE_PRO_1_ICA_DS10_RMS100_SEG S2WA_TABLE_PRO_2_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        990 = 0.0015346701
  * RMSE: 7.490513 1.594915 
---

### 4th Experiment - LSTM, JOINT_ICA, RMS @ 100pts, Downsampled @ 10hz - Cross (PRO_ONLY)

* ./rnn S2WA_TABLE_PRO_1_JOINT_ICA_DS10_RMS100_SEG S2WA_TABLE_PRO_2_JOINT_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        990 = 0.0015383657
  * RMSE: 8.304750 1.339711 
* ./rnn S2WA_TABLE_PRO_1_JOINT_ICA_DS10_RMS100_SEG S2WA_TABLE_PRO_2_JOINT_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        990 = 0.0015007367
  * RMSE: 8.513932 1.386041
* ./rnn S2WA_TABLE_PRO_1_JOINT_ICA_DS10_RMS100_SEG S2WA_TABLE_PRO_2_JOINT_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        990 = 0.0013383015
  * RMSE: 8.083336 1.390036
  
---



### 4th Experiment - LSTM, **PCA**, RMS @ 100pts, Downsampled @ 10hz

* ./rnn S2WA_TABLE_SUP_1_PCA_DS10_RMS100_SEG S2WA_TABLE_SUP_1_PCA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        990 = 0.0123760699
  * RMSE: 12.353960 4.504561
* ./rnn S2WA_TABLE_SUP_1_PCA_DS10_RMS100_SEG S2WA_TABLE_SUP_1_PCA_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1990 = 0.0060869541
  * RMSE: 30.839161 12.192719
* ./rnn S2WA_TABLE_SUP_1_PCA_DS10_RMS100_SEG S2WA_TABLE_SUP_1_PCA_DS10_RMS100_FULL 8 1000 10 100000 4
  * Adjusting the sEMG normalization range manually so the signal is larger
  * average loss at epoch:        990 = 0.0093960309
  * RMSE: 12.256781 4.403200
* ./rnn S2WA_TABLE_SUP_1_PCA_DS10_RMS100_SEG S2WA_TABLE_SUP_1_PCA_DS10_RMS100_FULL 8 2000 10 100000 4
  * Adjusting the sEMG normalization range manually so the signal is larger
  * average loss at epoch:       1990 = 0.0120122196
  * RMSE: 16.472565 5.667921 

* ./rnn S2WA_TABLE_SUP_1_PCA_DS10_RMS100_SEG S2WA_TABLE_SUP_1_PCA_DS10_RMS100_FULL 8 1000 10 100000 3
  * average loss at epoch:       1990 = 0.0015592120
  * RMSE: 17.688528 6.495105
* ./rnn S2WA_TABLE_SUP_1_PCA_DS10_RMS100_SEG S2WA_TABLE_SUP_1_PCA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        990 = 0.0065581697
  * RMSE: 11.703096 4.318129
* ./rnn S2WA_TABLE_SUP_1_PCA_DS10_RMS100_SEG S2WA_TABLE_SUP_1_PCA_DS10_RMS100_FULL 8 1000 10 100000 41
  * average loss at epoch:        990 = 0.0084040636
  * RMSE: 16.001457 6.822536
* ./rnn S2WA_TABLE_SUP_1_PCA_DS10_RMS100_SEG S2WA_TABLE_SUP_1_PCA_DS10_RMS100_FULL 8 1000 10 100000 412
  * average loss at epoch:        990 = 0.0084040636
  * RMSE: 47.276939 15.962457

* ./rnn S2WA_TABLE_PRO_1_PCA_DS10_RMS100_SEG S2WA_TABLE_PRO_1_PCA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        990 = 0.0018904982
  * RMSE: 3.575590 1.658806
* ./rnn S2WA_TABLE_PRO_1_PCA_DS10_RMS100_SEG S2WA_TABLE_PRO_1_PCA_DS10_RMS100_FULL 8 1000 10 100000 41
  * average loss at epoch:        990 = 0.0026537598
  * RMSE: 6.972566 3.670255
* ./rnn S2WA_TABLE_PRO_1_PCA_DS10_RMS100_SEG S2WA_TABLE_PRO_1_PCA_DS10_RMS100_FULL 8 1000 10 100000 3
  * average loss at epoch:        990 = 0.0012897172
  * RMSE: 8.584763 1.851980
* ./rnn S2WA_TABLE_PRO_1_PCA_DS10_RMS100_SEG S2WA_TABLE_PRO_1_PCA_DS10_RMS100_FULL 8 1000 10 100000 5
  * average loss at epoch:        990 = 0.0015430030
  * RMSE: 5.155580 2.358708
---

### 4th Experiment - LSTM, ICA, RMS @ 100pts, Downsampled @ 10hz

* ./rnn S2WA_TABLE_PRO_1_ICA_DS10_RMS100_SEG S2WA_TABLE_PRO_1_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        990 = 0.0011085136
  * RMSE: 1.927238 3.218357
  * 
--- 

### 4th Experiment - LSTM, **NOTHING**, RMS @ 100pts, Downsampled @ 10hz 

* ./rnn S2WA_TABLE_SUP_1_DS10_RMS100_SEG S2WA_TABLE_SUP_1_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        990 = 0.0106686685
  * RMSE: 81.963142 78.038293 
  * Stuck at high constant level after few sample.
* ./rnn S2WA_TABLE_PRO_1_DS10_RMS100_SEG S2WA_TABLE_PRO_1_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        990 = 0.0011085136
  * RMSE: 1.927238 3.218357

* ./rnn S2WA_TABLE_SUP_1_DS10_RMS100_SEG S2WA_TABLE_SUP_1_DS10_RMS100_FULL 8 1000 10 100000 41321
  * average loss at epoch:        990 = 0.0121753582
  * RMSE: 29.809516 16.944489
* ./rnn S2WA_TABLE_SUP_1_DS10_RMS100_SEG S2WA_TABLE_SUP_1_DS10_RMS100_FULL 8 1000 10 100000 41321
  * average loss at epoch:        990 = 0.0089208984
  * RMSE: 12.099417 4.205916 

* For SUP
  - SEG testing performance is good
  - FULL testing performance sometimes bad
  - Training error is Fluctuating throughout the testing process

--- 

### 4th Experiment - LSTM, sEMG_AMP_x10, RMS @ 100pts, Downsampled @ 10hz 
* ./rnn S2WA_TABLE_SUP_1_DS10_RMS100_SEG S2WA_TABLE_SUP_1_DS10_RMS100_FULL 8 1000 10 100000 44
  * average loss at epoch:        990 = 0.0068571496
  * RMSE: 15.212336 5.684756
* ./rnn S2WA_TABLE_SUP_1_DS10_RMS100_SEG S2WA_TABLE_SUP_1_DS10_RMS100_FULL 8 1000 10 100000 442
  * average loss at epoch:        990 = 0.0084798356
  * RMSE: 14.770839 5.173258 
 * ./rnn S2WA_TABLE_SUP_1_DS10_RMS100_SEG S2WA_TABLE_SUP_1_DS10_RMS100_FULL 8 1000 10 100000 41321
  * average loss at epoch:        990 = 0.0047974314
  * RMSE: 25.506991 7.817149

---

### 4th Experiment - LSTM, **NOTHING**, RMS @ 100pts, Downsampled @ 10hz - Cross (SUP_ONLY)

* ./rnn S2WA_TABLE_SUP_2_DS10_RMS100_SEG S2WA_TABLE_SUP_1_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        990 = 0.0038349367
  * RMSE: 17.268312 6.621938 
* ./rnn S2WA_TABLE_SUP_2_DS10_RMS100_SEG S2WA_TABLE_SUP_1_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1990 = 0.0018851091
  * RMSE: 15.257292 5.452943
* ./rnn S2WA_TABLE_SUP_2_DS10_RMS100_SEG S2WA_TABLE_SUP_1_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:       3990 = 0.0042445681
  * RMSE: 16.642261 5.533643 

---

### 4th Experiment - LSTM, ICA, RMS @ 100pts, Downsampled @ 10hz - Joined dataset SUP12_PRO12 test PROSUP-1

* ./rnn S2WA_TABLE_SUP_12_PRO_12_ICA_DS10_RMS100_SEG S2WA_TABLE_PROSUP_1_ICA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        990 = 0.0077108711
  * RMSE: 14.759914 5.177474
  * PRO part perfect fit / SUP part very bad
* ./rnn S2WA_TABLE_SUP_12_PRO_12_ICA_DS10_RMS100_SEG S2WA_TABLE_PROSUP_1_ICA_DS10_RMS100_FULL 8 2000 10 100000 4
  * average loss at epoch:       1990 = 0.0063176690
  * RMSE: 20.637874 5.396740
  * PRO part perfect fit / SUP part very bad
* ./rnn S2WA_TABLE_SUP_12_PRO_12_ICA_DS10_RMS100_SEG S2WA_TABLE_PROSUP_1_ICA_DS10_RMS100_FULL 16 900 10 100000 4
  * average loss at epoch:        890 = 0.0079449112
  * RMSE: 18.460693 6.075701
  * PRO part OK / SUP part very bad
* ./rnn S2WA_TABLE_SUP_12_PRO_12_ICA_DS10_RMS100_SEG S2WA_TABLE_PROSUP_1_ICA_DS10_RMS100_FULL 16 2000 10 100000 4
  * average loss at epoch:       1990 = 0.0104984861
  * RMSE: 13.204034 4.898671 
  * PRO part perfect fit / SUP part not good
* ./rnn S2WA_TABLE_SUP_12_PRO_12_ICA_DS10_RMS100_SEG S2WA_TABLE_PROSUP_1_ICA_DS10_RMS100_FULL 16 4000 10 100000 4
  * average loss at epoch:       1990 = 0.0104984861
  * RMSE: 23.616124 6.315788
  * PRO part OK / SUP part OK. 2nd half signal messy

---

### 4th Experiment - LSTM, **PCA**, RMS @ 100pts, Downsampled @ 10hz - Joined dataset SUP12_PRO12 test PROSUP-1

* ./rnn S2WA_TABLE_SUP_12_PRO_12_PCA_DS10_RMS100_SEG S2WA_TABLE_PROSUP_1_PCA_DS10_RMS100_FULL 8 1000 10 100000 4
  * average loss at epoch:        990 = 0.0053518857
  * RMSE: 12.946920 4.888396
  * PRO part OK / SUP part OK
* ./rnn S2WA_TABLE_SUP_12_PRO_12_PCA_DS10_RMS100_SEG S2WA_TABLE_PROSUP_1_PCA_DS10_RMS100_FULL 8 1000 10 100000 41
  * average loss at epoch:        990 = 0.0084148590
  * RMSE: 19.795033 7.780471
  * PRO part good / SUP part bad
* ./rnn S2WA_TABLE_SUP_12_PRO_12_PCA_DS10_RMS100_SEG S2WA_TABLE_PROSUP_1_PCA_DS10_RMS100_FULL 8 1000 10 100000 413
  * average loss at epoch:        990 = 0.0065133144
  * RMSE: 16.283975 6.319441
  * PRO part good / SUP part bad
* ./rnn S2WA_TABLE_SUP_12_PRO_12_PCA_DS10_RMS100_SEG S2WA_TABLE_PROSUP_1_PCA_DS10_RMS100_FULL 8 1000 10 100000 2
  * average loss at epoch:        990 = 0.0103300997
  * RMSE: 18.371851 6.697468
  * PRO part good / SUP part bad


* ./rnn S2WA_TABLE_SUP_12_PRO_12_PCA_DS10_RMS100_SEG S2WA_TABLE_PROSUP_1_PCA_DS10_RMS100_FULL 8 2000 10 100000 41
  * average loss at epoch:       1990 = 0.0035212027
  * RMSE: 11.220426 4.080842 
  * PRO part OK / SUP part OK

* ./rnn S2WA_TABLE_SUP_12_PRO_12_PCA_DS10_RMS100_SEG S2WA_TABLE_PROSUP_1_PCA_DS10_RMS100_FULL 8 2000 10 100000 41
  * average loss at epoch:       1990 = 0.0051846359
  * RMSE: 28.523094 7.885760 
  * Near constant output
---

### 4th Experiment - Notes
* Can't locate *Supinator muscle*, no significant signal measured. Use *Biceps Brachii* instead.
* *Flexor Carpi Radialis* is right next to *Pronator Teres*
* *Biceps Brachii* has significant response for Supination, but raising the forearm also trigger *Biceps Brachii*. Have to avoid such movement when test.
* Can't tell the performance difference between PCA/ICA, varaince within NN is too large

### ISSUE
* For *Supination*, the training error fluctuates
  * Possible Reason
    * SUP_1 may be too complex w/ some *Pitch* movement
      * Using SUP_2 training yields some comparable result
    * The value for sEMG channel is too small
      * No, x10 test yield no better result
    * **Signal charateristic for SUP is different than PRO, may need another amplitude summarizing method**
      * Confirmed by looking at raw sEMG. Bicep has no "ramp" when the angle is changing
      * **Bicep may not be used!**
* For *Supination*, SEG result is good, FULL result may bad
  * Possible Reason
    * ????
  * Worst case: Short-term sEMG->Angle estimation w/ sEMG activity segmentation
* Network can be Fluctuating if the dataset isn't "clean"
* **FOR FUTURE TEST**: For *Supination*, *Pitch* channel has high value, should avoid such movement


