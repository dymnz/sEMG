###

ICA, Impulse extraction,

### Wrist Movements
* DOF - 1 (Pitch):
  * Flexion: Palm facing down, moving **downward**
  * Extension: Palm facing down, moving **upward**
* DOF - 2 (Roll):
  * Pronation: Forearm turning **counter-clockwise**
    * ["pronation involves placing the palms into the prone (**face-down**) position, like someone would do when looking at the backs of their hands"](http://www.innerbody.com/image/musc03.html)
  * Supination: Forearm turning **clockwise**
    * ["The motion of supination turns the palms anteriorly or superiorly to the supine (**face-up**) position."](http://www.innerbody.com/image/musc03.html)
    * *In the anatomical position, with the arms extended to the sides of the trunk and palms facing forward, the arms are already in the supinated position.*
* DOF - 3 (Yaw):
  * Radial Deviation: Palm moving **counter-clockwise** on the **horizontal plane**
  * Ulnar Deviation: Palm moving **clockwise** on the **horizontal plane**

---

### Paper

* [A new strategy for multifunction myoelectric control(1993)](https://ieeexplore.ieee.org/document/204774/)
  * ANN chosen for fast training time

* [Simultaneous and Proportional Force Estimation for Multifunction Myoelectric Prostheses Using Mirrored Bilateral Training (2010)](https://ieeexplore.ieee.org/document/5551179/)
  * Wrist (2-DOF) FLX/EXT & RU-DEV
  * 7-ch sEMG
  * Multilayer Perceptron
  * Feature set performance: MSV(?) < TD = TD+6AR = TD+5 wavelet marginal(TDWV)(?)
  * 7-ch semg -> TD feature -> PCA -> MLP

* [SVM for Estimation of Wrist Angle from Sonomyography And SEMG Signals (2011)](http://ieeexplore.ieee.org/document/4353415/)
  * Flexion/Extension

* [Wrist angle estimation based on musculoskeletal systems with EMG (2011)](http://ieeexplore.ieee.org/document/6072755/)
  * 4-ch, physical model
    * extensor carpi radialis longus
    * extensor carpi ulnaris
    * flexor carpi radialis
    * flexor carpi ulnaris

* [EMG-based simultaneous and proportional estimation of wrist/hand kinematics in uni-lateral trans-radial amputees (2012)](https://jneuroengrehab.biomedcentral.com/articles/10.1186/1743-0003-9-42)
  * Wrist (3-DOF), 7-ch sEMG, TDAR feature set, MLP
  * Intact-limbed: 
    * (3-DOF)72.8 +- 8.29% accuracy
    * ~DoF-12 90.6% ± 3.68% (CG group, motion 1/2/4/5, accounting PROSUP/FLXEXT)~ DOF2 is R/U deviation

* [Multichannel surface EMG based estimation of bilateral hand kinematics during movements at multiple degrees of freedom (2010)](https://ieeexplore.ieee.org/document/5627622/)
  * Previous work of above
  * Intact bodied, 5 grid w/ 16-ch each (80-ch)
  * Fullwave rectified sEMG
  * 3-DOF, w/ 6 separate MLP. MLP output filted w/ LPF 1Hz(?)
  * Coefficient of determination (variability explained by estimated values)
    * FLX/EXT: 82.7 +- 2.9%
    * PRO/SUP: 76.6 +- 11.8%

* [Simultaneous and proportional control of 2D wrist movements with myoelectric signals (2012)](http://ieeexplore.ieee.org/document/6349712/)
  * 192-ch sEMG array, nonlinear transformations, Flexion/Extension/RU-Deviation

* [Bayesian Filtering of Surface EMG for Accurate Simultaneous and Proportional Prosthetic Control (2014)](http://ieeexplore.ieee.org/document/7332757/)
  * 16-ch sEMG, Flexion/Extension or Pronation/Supination and simultaneously.
  * Feature extraction (amplitude summarizing) for NMF regressor, compare MAV and BAY summarizing performance

* [Quantifying Forearm Muscle Activity during Wrist and Finger Movements by Means of Multi-Channel Electromyography (2014)](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4188712/)
  * 112-ch sEMG array

* [EMG-based learning approach for estimating wrist motion (2015)](https://www.researchgate.net/publication/283713267_EMG-based_learning_approach_for_estimating_wrist_motion)
  * Based on *EMG-based simultaneous and proportional estimation of wrist/hand kinematics in uni-lateral trans-radial amputees (2012)*
  * 11-ch sEMG, SVR
  * Wrist angle @ different arm position
  * Circular motion of FLX/EXT & RU-Deviation
  * Same day Same pose: 78% | Same day Across pose: 63% | Different day: 50 ~ 0%

* Continuous Estimation of Wrist Angles for Proportional Control Based on Surface Electromyography (2016)
  * 4-ch sEMG, BPNN w/ fixed windowed RMS pre-processing has the best result
  * Separate tests for Flexion/Extension/Pronation/Supination
  * RMSE | WF: 10.42 | WE: 8.23 | WS: 16.53 | WP: 13.09
  * Accuracy decrease in the presence of grip force

* [Continuous estimation of hand's joint angles from sEMG using wavelet-based features and SVR (2016)](https://dl.acm.org/citation.cfm?id=3051498)
  * SVR, DWT
  
* [EMG-Based Continuous and Simultaneous Estimation of Arm Kinematics in Able-Bodied Individuals and Stroke Survivors (2017)](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5575159/)
  * NARX model (Recurrent NN), 3-DOF shoulder/Elbow/Wrist(FLX/EXT), 6-ch sEMG
  * LPF @ 4Hz, 99%+ accuracy

* [Continuous Motion Decoding from EMG Using Independent Component Analysis and Adaptive Model Training(2014)](https://www.ncbi.nlm.nih.gov/pubmed/25571132)
  * Mentioned Gaussian characteristic but used ICA???

#### May Be Relevant: 
* *[Neural network committees for finger joint angle estimation from surface EMG signals](https://biomedical-engineering-online.biomedcentral.com/articles/10.1186/1475-925X-8-2)*
* *[Real-time simultaneous and proportional myoelectric control using intramuscular EMG (2014)](http://iopscience.iop.org/article/10.1088/1741-2560/11/6/066013/pdf)*
* *[Estimation of finger joint angles from sEMG using a recurrent neural network with time-delayed input vectors (2009)](https://www.researchgate.net/publication/224580490_Estimation_of_finger_joint_angles_from_sEMG_using_a_recurrent_neural_network_with_time-delayed_input_vectors)*
* *[Extracting Simultaneous and Proportional Neural
Control Information for Multiple-DOF Prostheses
From the Surface Electromyographic Signal](https://ieeexplore.ieee.org/document/4663628/)
---

### Wrist movement muscle:
* Extension | *Should find which muscle other experiments are focusing on*
  * [Source](http://www.sportsinjuryclinic.net/anatomy/human-muscles/wrist-hand-joint-actions/wrist-extension) | **Highlighted** because used in [other paper](http://ieeexplore.ieee.org/document/6072755/)
    * Extensor Digitorum <- testing
    * **[Extensor Carpi Radialis Longus](https://en.wikipedia.org/wiki/Extensor_carpi_radialis_longus_muscle)**
    * **[Extensor Carpi Ulnaris](https://en.wikipedia.org/wiki/Extensor_carpi_ulnaris_muscle)** <-- Chosen
    * Extensor Pollicis Longus 

* Flexion | *Should find which muscle other experiments are focusing on*
  * [Source](http://www.sportsinjuryclinic.net/anatomy/human-muscles/wrist-hand-joint-actions/wrist-flexion) | **Highlighted** because used in [other paper](http://ieeexplore.ieee.org/document/6072755/)
    * **[Flexor Carpi Radialis](https://en.wikipedia.org/wiki/Flexor_carpi_radialis_muscle)** <-- Chosen
    * **[Flexor Carpi Ulnaris](https://en.wikipedia.org/wiki/Flexor_carpi_ulnaris_muscle)**
    * Flexor Digitorum Superficialis <- testing
    * Flexor Pollicis Longus (Thumb movement)

* Pronation | [Source](http://www.innerbody.com/image/musc03.html) | **Highlighted** = chosen
  * **[Pronator Teres](https://en.wikipedia.org/wiki/Pronator_teres_muscle)**: Near elbow
  * Pronator Quadratus: Near wrist (Hard to locate)
* Supination | [Source](http://www.innerbody.com/image/musc03.html) | **Highlighted** = chosen
  * **Supinator Muscle** : Near elbow (Hard to locate)
  * Biceps Brachii (Tried and failed)