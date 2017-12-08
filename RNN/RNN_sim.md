#### RNN sim

#### Vanilla RNN (Regression)     
* 1 input node
* 1 hidden layer, 2/3 hidden nodes <-- magic #, faster convergence
* 1 output node
* BPTT truncate steps: 4/5  (# of steps to unroll)
    * To avoid exploding gradient
    * To not waste processing time for vanishing gradient
    
#### Data Generation
* Generate random **pulse vector** (Tx1)
* Generate **twitch force prototype**, 
    the force of which a single pulse will produce
    * Form: exp(1 - t/T), adjust T to adjust length
* Generate **force vector**, conv(random_pulse, twitch_force_proto)

#### RNN I/O
* Input: Tx1 **Pulse vector**
* Output: Tx1 **Force vector** 


#### Test parameter
* length(**twitch force prototype**) = 5T = 25 (samples)
* legnth(**pulse vector**) = length(**force vector**) = 100 (samples)


#### Note
* ~~Error in BPTT gradient calculation (Gradient check)~~
    * Fixed
* Reasonable preformace, 5~10% error

#### Next
* LSTM
* Sliding window input structure: Expend the input to a small window, see if performence is improved, as the BPTT truncation issue can be mitigated
* Momentum input: A new set of input simulating muscle momvement, the output force vector is attenuated by the slope of the movement
    * Does not reflect the real-world situation, but can test the performence of the RNN in differential operation
* Angle input: A new set of input simulating the compound effect of wrist anglge(mucsle length/electrode position change)
    * Reflects the real-world situation


#### ?????
* length(**twitch force prototype**)/legnth(**pulse vector**) does not reflect real-world scenario, theoratically longer length(**twitch force prototype**) leads to worse RNN perforamce
    * In test
        * T = 2: average loss: 0.057152    (prototype length = 10 samples)
            * file_name = 'demo/res10_CT2.txt';
        * T = 5: average loss: 0.073225    (prototype length = 25 samples)
            * file_name = 'demo/res10_t10.txt';
    * Signal power is different ??????
    

#### Misc
* [Implementation (regression)](https://github.com/dymnz/ParallelProgramming/tree/master/RNN)
* [Implementation notes (regression)](https://github.com/dymnz/ParallelProgramming/blob/master/RNN/C/ReadMe.md)
