#### sEMG - Froce LSTM training test
* Truncated froce - semg signal
* Test and train are the same signal


#### Tests
* sample_rate = 1000Hz, segment = 1000 sample
  1. segmented / full
    * output stuck at constant
  2. full / full
    * output stuck at constant
* sample_rate = 100Hz, segment = 1000 sample 
  1. segmented / full
    * output stuck at constant
  2. segmented / segmented
    * output stuck at constant    
  3. full / full
    * output stuck at constant    
* sample_rate = 100Hz, segment = 100 sample 
  * output stuck at constant

* Other
  * recitify
  * low-pass and downsample
  * better alignment
  * **ALL output stuck at constant**
