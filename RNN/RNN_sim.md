#### RNN sim

#### Vanilla RNN      
* 1 input node
* 2 hidden nodes <-- magic #, faster convergence
* 1 output node
* BPTT truncate steps: 5  (# of steps to unroll)
    
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
* Error in BPTT gradient calculation (Gradient check)
* Current best, under-fit, only 2 training example:
    


