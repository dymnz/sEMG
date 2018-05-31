 ### Select paper for comparison

See 'paper_sel.xlsx' for comparison table

* Application
* Action
  * Action type
  * Action length
* Electrode
  * \# of electrode
  * Placement
---

* [A new strategy for multifunction myoelectric control(1993)](https://ieeexplore.ieee.org/document/204774/)
  * Movement classification

* [Multichannel surface EMG based estimation of bilateral hand kinematics during movements at multiple degrees of freedom (2010)](https://ieeexplore.ieee.org/document/5627622/)
  * FLX/EXT RU-DEV PRO/SUP. Separate and  FLX/EXT or RU-DEV w/ PRO/SUP
  * Action
    * See list
    * 6s per segment
      * 1s pause at start pos.
      * 1s to final pos.
      * 1s hold
      * 1s to start pos.
      * pause at start pos. til 6s
  * Electrode
    * 16 array x 5 
    * *Four arrays were placed around the circumference of the right forearm at a distance from the elbow of one third of the elbow–wrist distance. The fifth array was placed over the pronator teres.*

      ```
      1 Wrist flexion 
      2 Wrist extension
      3 Radial deviation 
      4 Ulnar deviation 
      5 Forearm pronation 
      6 Forearm supination 
      7 Wrist flexion & Forearm pronation 
      8 Wrist extension & Forearm pronation 
      9 Radial deviation & Forearm pronation 
      10 Ulnar deviation & Forearm pronation 
      11 Wrist flexion & Forearm supination 
      12 Wrist extension & Forearm supination 
      13 Radial deviation & Forearm supination 
      14 Ulnar deviation & Forearm supination
      15 Rest              
      ```
* [Surface EMG pattern recognition for real-time control of a wrist exoskeleton (2010)](https://www.ncbi.nlm.nih.gov/pubmed/20796304)
  * FLX/EXT RU-DEV classification (13 class) w/ 10~50% MVC torque


* [Simultaneous and Proportional Force Estimation for Multifunction Myoelectric Prostheses Using Mirrored Bilateral Training (2010)](https://ieeexplore.ieee.org/document/5551179/)
  * FLX/EXT & RU-DEV
  * Action
    * FLX/EXT
    * RU-DEV
    * V (RU-DEV then FLX/EXT) x2
    * Circular (RU-DEV and FLX/EXT) x2
    * 10 contractions per task, 25s per task
    * *uniform and mirrored bilateral*
  * Electrode
    * 7-ch
    * 3-FLX / 3-EXT / 1-Bicep

* [SVM for Estimation of Wrist Angle from Sonomyography And SEMG Signals (2011)](http://ieeexplore.ieee.org/document/4353415/)
  * Ultrasound

* [Wrist angle estimation based on musculoskeletal systems with EMG (2011)](http://ieeexplore.ieee.org/document/6072755/)
  * FLX/EXT Angle est. w/ phyisical model
  * Action
    * FLX and EXT, mixed
    * 10s(?), not stated
  * Electrode
    - 4-ch
    - 2 FLX, 2 EXT muscle

* [EMG-based simultaneous and proportional estimation of wrist/hand kinematics in uni-lateral trans-radial amputees (2012)](https://jneuroengrehab.biomedcentral.com/articles/10.1186/1743-0003-9-42)
  * FLX/EXT, RU-DEV, PRO/SUP. Separate and mix 
  * Action
    * See list
    * *Each trial lasted approximately 65 s and was separated to the next by resting
periods of 2 − 3 min to avoid fatigue*
  * Electrode
    * 7-ch
    * 
      *placed around the thickest part of the forearm (approximately 1/3 distally from the elbow), equi-spaced in a circle around the forearm, similarly to [11,14]. Equi-spaced electrode placement was used, rather than targeting at specific muscles, because **7 electrode pairs provided necessary coverage of the area of interest*, as shown in previous studies [14,15]**

      ```
      Sinusoidal contractions along a single DoF (freq. ≈ 0.5 − 1 Hz)
      1: flexion/extension (DoF1)
      2: radial/ulnar deviation (DoF2)
      3: pronation/supination (DoF3)
      ---
      Combined activation of two DoFs, in which one DoF was articulated sinousoidally, and the other was fixed at positions close to maximal range of motion
      4: DoF1 + DoF2
      5: DoF2 + DoF1
      6: DoF1 + DoF3
      ---
      Cyclic contractions of unconstrained dynamic wrist movements. (freq. ≈ 0.5 − 1 Hz)
      7: DoF3 + DoF1
      8: DoF2 + DoF3
      9: DoF3 + DoF2
      10: DoF1 + DoF2 + DoF3

      ```

* [Simultaneous and proportional control of 2D wrist movements with myoelectric signals (2012)](http://ieeexplore.ieee.org/document/6349712/)
  * Simultaneous FLX/EXT and RU-DEV
  * Action
    * 18 runs
    * Pattern: 16 lines, 4 ellipses -> 20 patterns
      * Clockwise and counter-clockwise
      * Line trajectory: 16 direction from center and back
      * Elliptical trajectory: Move to the left (FLX) then draw a circle
        * 2 diameter
    * Line: 8s per segment
      * 3s center to final
      * 2s hold at final
      * 3s final to center
    * Elliptical: 10s per segment
  * Electrode
    * 18x24 array (192-ch)
    *
      *The electrode was placed on the proximal portion of the upper forearm, covering a range of 8 cm*

* [Bayesian Filtering of Surface EMG for Accurate Simultaneous and Proportional Prosthetic Control (2014)](http://ieeexplore.ieee.org/document/7332757/)
  * FLX/EXT and PRO/SUP
  * Action
    * 2-DOF, 8 trials each
    * 10s per segment, details unclear
  * Electrode
    * 16-ch
    * 
      *centered approximately 1/3 distal of the forearm*

* [Quantifying Forearm Muscle Activity during Wrist and Finger Movements by Means of Multi-Channel Electromyography (2014)](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4188712/)
  * FLX/EXT RU-DEV @ prone, neutral pos. 
  * Action
    * 20 times (for wrist movement, paper includes finger movement)
    * 2s rest to 1st target
    * 2s 1st target to 2nd target
  * Electrode
    * 14x8 array (112-ch)
    * 
      *placed around the forearm circumference ... approximately 2 cm from the elbow crease*

* [Continuous Motion Decoding from EMG Using Independent Component Analysis and Adaptive Model Training(2014)](https://www.ncbi.nlm.nih.gov/pubmed/25571132)
  * Shoulder and elbow est. No numerical result


* [EMG-based learning approach for estimating wrist motion (2015)](https://www.researchgate.net/publication/283713267_EMG-based_learning_approach_for_estimating_wrist_motion)
  * Based on *EMG-based simultaneous and proportional estimation of wrist/hand kinematics in uni-lateral trans-radial amputees (2012)*
  * Real-time simultaneous FLX/EXT and RU-DEV
  * Action
    * Move arm to 9 pos. on 40x40cm board
    * 30 circular motion
  * Electrode
    * 11-ch
    * Exact placement. 2 each for FLX/EXT (4-ch total for wrist)

* Continuous Estimation of Wrist Angles for Proportional Control Based on Surface Electromyography (2016)
  * Separate FLX/EXT/PRO/SUP angle estimation
  * Action
    * See list
    * 5s per segment, 5 trials
  * Electrode
    * 4-ch
    * Exact placement

    ```
    Wrist supination    (WS)
    Wrist pronation     (WP)
    Wrist supination  + 20% maximum torsion strength  (WST)
    Wrist pronation   + 20% maximum torsion strength  (WPT)
    Wrist supination  + 20% maximum grip strength     (WSG)
    Wrist pronation   + 20% maximum grip strength     (WPG)
    Wrist flexion       (WF)
    Wrist extension     (WE)
    Wrist flexion     + 20% maximum torsion strength  (WFT)
    Wrist extension   + 20% maximum torsion strength  (WET)
    Wrist flexion     + 20% maximum grip strength     (WFG)
    Wrist extension   + 20% maximum grip strength     (WEG)
    ```

* [Continuous estimation of hand's joint angles from sEMG using wavelet-based features and SVR (2016)](https://dl.acm.org/citation.cfm?id=3051498)
  * Nian Pro database, semg/angle database for hand, 22-DOF


* [EMG-Based Continuous and Simultaneous Estimation of Arm Kinematics in Able-Bodied Individuals and Stroke Survivors (2017)](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5575159/)
  * Shoulder, elbow and wrist angle est.
