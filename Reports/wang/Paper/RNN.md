### RNN

#### Source
    * https://colah.github.io/posts/2015-08-Understanding-LSTMs/
    * A Critical Review of Recurrent Neural Networks for Sequence Learning (2015)

---
#### A Critical Review of Recurrent Neural Networks for Sequence Learning (2015)

1. HMM
    * Explicit state
    * State only depends on previous state
    * Large state transition probability table

2. NN
    * Feedforward
    * Backpropagation (BPT)
    
3. RNN
    * Connectionist model
    * Feedforward
    * Backpropagation through time (BPTT)
    * Unfloding
![BPTT](https://colah.github.io/posts/2015-08-Understanding-LSTMs/img/RNN-unrolled.png)

4. Early RNN
    * Exploding/Vanishing gradient (BPTT)
        * Cannot retain long-range(time) information
        * "Hard to train"

5. Modern RNN - Long short-term memory (LSTM)
    * Structure
        * Input node    <- NN
        * Input gate
        * Memory cell
        * Forget gate
        * Output gate   <- NN
    * Hidden layer contains **memory cell**
        * Can retain information indefinitely
    * Hidden layer contains **forget gate**
        * Can unlearn information in memory cell
    * Variants
        * Peephole connection: Memory cell not regulated by output gate
    * BPTT still works

6. Modern RNN - Bidirectional recurrent neural networks (BRNN)
    * Stacked RNN containing two hidden layer with
        * Forward layer:  Node_t-1 -> Node_t    <---- normal
        * Backward layer: Node_t+1 -> Node_t
    * Not suitable for online(streaming)

7. Moder RNN - Neural Turing machine (NTM)
    * Addressable memory cell
    * Turing complete
    * Still differentiable (gradient descent works)

8. Application
    * LSTM
        * Online testing
        * When long term information is important
            * Voico recognition
    * BRNN
        * When future context is also important
            * Video captioning
            * Hand writing
    * NTM
        * Arbitrary programming
            * Sorting

---




