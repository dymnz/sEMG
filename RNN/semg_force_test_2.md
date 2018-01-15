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

### Streaming test
* `./rnn 2_first_half_stream 2_full_stream 8 12000 0.001 10 100 1000 42`
  * Train: frist-half, Test: full
  * First-half: OK result for low dynamic part
  * Bottom-half: Spiky instead of smooth


### Chunk test
* `./rnn 2_first_half_chunk500_overlap50 2_first_half_chunk500_overlap50 8 1000 0.001 10 100 1000 42`
  * Train: frist-half(chunk), Test: full(stream)
  * Chunk: length:500pt overlap:50pt
  * First-half: 
  * Bottom-half: 