#### Spec
* Vdc: 5~12V
* Output res.: 1k ohm
* Rated output: 1mV/V
    * TODO: Read this up

#### Wire
* red = E+
* green = O+
* black = E-
* white = O-

#### Connection on Hx711
* To loadcell
    - red = E+
    - green = O+
    - black = E-
    - white = O-
    - yellow = GND, for EMI protection
* To MCU
    - VDD = Logic level (3.3/5V, 5V for convenience)
    - VCC = Power to loadcell (5~12 according to spec)


#### Status
* Loadcell + Amp working
* ~~To be calibrated~~
* Hx711 report rate adjustable: 10/80 sample per second
   * PCB fixed at 10 SPS
   * Measured @ 12 SPS with 1 sec window
   * MEASURED @ 112 SPS with 10 sec window ????
   


#### Source
* http://www.icshop.com.tw/product_info.php/products_id/16571
* https://learn.sparkfun.com/tutorials/load-cell-amplifier-hx711-breakout-hookup-guide
* https://learn.sparkfun.com/tutorials/getting-started-with-load-cells
* [Useful codes](https://github.com/sparkfun/HX711-Load-Cell-Amplifier/tree/master/firmware)
