#### sEMG - Froce LSTM training test


#### Param
* sEMG recorded @ 1000Hz
* Force recorded @ ?Hz (<10Hz)
* Manual align (pretty bad)
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


### Further training
* sample_rate = 100Hz, segment = 100 sample, better alginment
  1. segmented / segmented `./rnn train_1_ds100_lp_rec_fx train_1_ds100_lp_rec_fx 4 10000 0.001 100 1000 4`
    * Good result with more training round
  2. segmented / full `./rnn train_1_ds100_lp_rec_fx test_1_ds100_lp_rec_fx 4 10000 0.001 100 1000 4`
    * Broken, only first segment is accurate
  3. full / full
    * Trend very clear, still some low amplitude

### Best result, semgented with overlap. (e.g. 250pt w/ 50pt overlap)
  1. segmented / full `./rnn train_2_ds100_lp_rec_fx_ol test_2_ds100_lp_rec_fx_ol 4 10000 0.001 10 100 1000 42`
     * Good result

### Main issue
* Force - semg data alignment
