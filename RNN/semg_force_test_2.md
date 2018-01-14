#### sEMG - Froce LSTM training test


#### Param
* sEMG recorded @ 1000Hz
* Force recorded @ 11.2Hz or 12Hz (10Hz stated)
* Manual align
* Truncated froce - semg signal
* Train with first half of the signal, test with all
* Other
  * recitified sEMG
  * low-pass and downsample 300Hz

### Best result, semgented with overlap. (e.g. 250pt w/ 50pt overlap)
  1. first-half / full `./rnn train_2_ds100_lp_rec_fx_ol test_2_ds100_lp_rec_fx_ol 4 10000 0.001 10 100 1000 42`
     * Good result

### semgented with overlap. (e.g. 250pt w/ 50pt overlap) with pulse gen
  1. sample_rate:300Hz len:300pt overlap:100pt pul_threshold:0.3

### Main issue
* Force - semg data alignment
