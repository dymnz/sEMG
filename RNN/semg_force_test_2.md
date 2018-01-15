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
* `./rnn 2_first_half_stream 2_full_stream 8 12000 10 1000 42`
  * Train: frist-half, Test: full
  * First-half: OK result for low dynamic part
  * Bottom-half: Spiky instead of smooth
* `./rnn 2_first_half_stream_rect 2_first_half_stream_rect 8 12000 10 100 42`
  * Rectified sEMG at [0, 1]
  * Train: frist-half, Test: frist-half
  * Not hitting the required magnitude, but showed trend

### Chunk test
* `./rnn 2_first_half_chunk500_overlap50 2_first_half_chunk500_overlap50 8 1000 10 1000 42`
  * Train: frist-half(chunk), Test: frist-half(chunk)
  * Chunk: length:500pt overlap:50pt DS:300SPS
  * Trend good, fast dynamic bad
* `./rnn 2_first_half_chunk500_overlap50 2_first_half_stream 8 2000 10 1000 42`
  * Train: frist-half(chunk), Test: frist-half(stream)
  * Chunk: length:500pt overlap:50pt DS:300SPS
  * Bad result, 2nd ramp mismatch, no high dynamic part



### TODO
* Overlap Chunk State Retention