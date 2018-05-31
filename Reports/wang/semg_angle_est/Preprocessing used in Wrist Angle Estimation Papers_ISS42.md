### Preprocessing used in Wrist Angle Estimation Papers 

---
#### From #40 


* [Surface EMG pattern recognition for real-time control of a wrist exoskeleton (2010)](https://www.ncbi.nlm.nih.gov/pubmed/20796304)


* [Simultaneous and Proportional Force Estimation for Multifunction Myoelectric Prostheses Using Mirrored Bilateral Training (2010)](https://ieeexplore.ieee.org/document/5551179/)
  * Feature set performance: MSV(?) < TD = TD+6AR = TD+5 wavelet marginal(TDWV)(?)
  * 7-ch semg -> TD feature -> PCA -> MLP
  
* [Comparison of regression models for estimation of isometric wrist joint torques using surface electromyography (2011)](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3198911/)


* [SVM for Estimation of Wrist Angle from Sonomyography And SEMG Signals (2011)](http://ieeexplore.ieee.org/document/4353415/)
  * RMS for amplitude
  * then wavelet to remove fluctuation

* [EMG-based simultaneous and proportional estimation of wrist/hand kinematics in uni-lateral trans-radial amputees (2012)](https://jneuroengrehab.biomedcentral.com/articles/10.1186/1743-0003-9-42)
  * TD feature set + 6 AR, not suitable for RNN. See [A new strategy for multifunction myoelectric control(1993)](https://ieeexplore.ieee.org/document/204774/)
    * MAV / MAV-slope / Zero-crossing / Slope sign change / Wave length
  * Window = 100 ms long, w/ 60 ms overlap

* [Multichannel surface EMG based estimation of bilateral hand kinematics during movements at multiple degrees of freedom (2010)](https://ieeexplore.ieee.org/document/5627622/)
  * Full-wave rectified, LPF-16Hz

* [Simultaneous and proportional control of 2D wrist movements with myoelectric signals (2012)](http://ieeexplore.ieee.org/document/6349712/)
  * 200mS of POWER/RMS/LOG-VAR. See [Spatial Filtering for Robust Myoelectric Control](https://ieeexplore.ieee.org/document/6156755/)
  * Characteristic
      * POWER: Linear transform of EMG
      * RMS: sqrt(POWER), non-linear
      * LOG-VAR: log(POWER), non-linear
  * Use non-linear transform to linearize relationship between Feature and Joint angle
    * Linear regression performance better w/ RMS, LOG-VAR
    * MLP is better w/ POWER
    * Linear regreesion w/ LOG-VAR has best performance


* [Bayesian Filtering of Surface EMG for Accurate Simultaneous and Proportional Prosthetic Control (2014)](http://ieeexplore.ieee.org/document/7332757/)
  * 140 ms long, w/ 100 ms overlap: MAV v.s. Bayesian filter for sEMG amplitude 

* [Quantifying Forearm Muscle Activity during Wrist and Finger Movements by Means of Multi-Channel Electromyography (2014)](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4188712/)
  * Rectified + LPF-1Hz
  * 112-ch sEMG array -> Non Negative Matrix Factorization (NNMF) for dimension reduction

* [EMG-based learning approach for estimating wrist motion (2015)](https://www.researchgate.net/publication/283713267_EMG-based_learning_approach_for_estimating_wrist_motion)
  * Rectified + LPF-20Hz then normalized

* Continuous Estimation of Wrist Angles for Proportional Control Based on Surface Electromyography (2016)
  * 250 ms RMS

* [Continuous estimation of hand's joint angles from sEMG using wavelet-based features and SVR (2016)](https://dl.acm.org/citation.cfm?id=3051498)
  * W: 256ms O: 100ms. A set of feature per window
  * Time-Frequency feature of DWT-sEMG. 5th level 8th order Daubechies. Feature calculted w/ Sub-band: D1-5 & A5
    * MAV
    * SD
    * Autoregressive coefficients
    * Entropy
    * Energy

* [EMG-Based Continuous and Simultaneous Estimation of Arm Kinematics in Able-Bodied Individuals and Stroke Survivors (2017)](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5575159/)
  * Rectified, LPF-4Hz
  * then downsampled to 20Hz

* [Continuous Motion Decoding from EMG Using Independent Component Analysis and Adaptive Model Training(2014)](https://www.ncbi.nlm.nih.gov/pubmed/25571132)
  * LPF-300Hz, PCA, fastICA
  * MAV W: 15ms O: 5ms

#### May Be Relevant: 
* *[Neural network committees for finger joint angle estimation from surface EMG signals](https://biomedical-engineering-online.biomedcentral.com/articles/10.1186/1475-925X-8-2)*
* *[Real-time simultaneous and proportional myoelectric control using intramuscular EMG (2014)](http://iopscience.iop.org/article/10.1088/1741-2560/11/6/066013/pdf)*
* *[Estimation of finger joint angles from sEMG using a recurrent neural network with time-delayed input vectors (2009)](https://www.researchgate.net/publication/224580490_Estimation_of_finger_joint_angles_from_sEMG_using_a_recurrent_neural_network_with_time-delayed_input_vectors)*

#### Misc

* [Electromyogram Whitening for Improved Classification Accuracy in Upper Limb Prosthesis Control(2013)](https://ieeexplore.ieee.org/document/6471832/)