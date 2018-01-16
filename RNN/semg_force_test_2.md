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
  * DS: 300SPS
  * First-half: OK result for low dynamic part
  * Bottom-half: Spiky instead of smooth
* `./rnn 2_first_half_stream_rect 2_first_half_stream_rect 8 12000 10 100 42`
  * Rectified sEMG at [0, 1]
  * DS: 300SPS
  * Train: frist-half, Test: frist-half
  * Good. Not hitting the required magnitude, but showed trend. Bad at high dynamic part.
* `./rnn 2_first_half_stream_rect_DS100 2_first_half_stream_rect_DS100 8 2000 10 10000 977`
  * Rectified sEMG at [0, 1]
  * DS: 100SPS
  * Train: frist-half, Test: frist-half
  * Good. Bad at high dynamic part.
* `./rnn 2_first_half_stream_rect_DS100_pulse 2_first_half_stream_rect_DS100_pulse 8 8000 10 10000 977`
  * Rectified sEMG at [0, 1]
  * Pulse threshold @ 0.05
  * DS: 100SPS
  * Train: frist-half, Test: frist-half
  * Chunky
* `./rnn 2_first_half_stream_rect_DS300_pulse 2_first_half_stream_rect_DS300_pulse 8 8000 10 10000 977`
  * Rectified sEMG at [0, 1]
  * Pulse threshold @ 0.05
  * DS: 300SPS
  * Train: frist-half, Test: frist-half
  * Good. Not chunky. Bad at high dynamic part


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