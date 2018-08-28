### Experiment 2-3

4-ch sEMG FLX/EXT/PRO/SUP, using teensy3.2 MPU9250 as ground truth

Goal: Check the effect of nICA w/ ringed placement **and different electrode placement configuration**

---

#### Electrode location
* Equal distance placement w/ 4-ch sEMG
* Forming a ring around the thickest part of the forearm (~4.5cm from elbow)
  * Circumference 27.5cm, divided by 4 --> 6.9cm lateral inter-electrode distance
  * Placing clockwise, labelled 1-4
  * **Start placing 45 degree from the top of the arm, perpendicular to the table**
* Exact placement
  * Baseline test: Ring starting from the top of the forearm w/ palm facing down
  * "Random" test: Ring starting from the top of the forearm w/ palm facing down, then rotate 45d
* Reference electrode placed near the bony area near wrist

---

#### Recording
* Separate PRO/SUP/FLX/EXT
* 20 iteration in each session w/ 3 session per gesture (60 segments per gesture)
  * 6 secs per segment
    * 0: Hold at init
    * 1: Hold at init
    * 2: Move to final
    * 3: Hold at final
    * 4: Move to init
    * 5: Hold at init
    * 6: Hold at init
* Segments are separated in post-processing


---

#### Cross-validation
* Segments from different sessions are mixed
* 5-fold cross validation (48 - 12 in this case) | [source](https://stackoverflow.com/questions/13610074/is-there-a-rule-of-thumb-for-how-to-divide-a-dataset-into-training-and-validatio)
  * Training - 36
  * Cross-validation - 12
  * Testing - 12
* Separate FLX/EXT and PRO/SUP training for now (1, 3)

---

#### File
  * Pronation: <0 degree only. From 0d move toward -90d then pause. Start moving toward 0d then stop.
    * S2WA_23_PRO_ 
  * Supination: >0 degree only. From 0d move toward 90d then pause. Start moving toward 0d then stop.
    * S2WA_23_SUP_
  * Extension: <0 degree only. From 0d move toward 90d then pause. Start moving toward 0d then stop.
    * S2WA_23_EXT_
  * Flexion: >0 degree only. From 0d move toward -90d then pause. Start moving toward 0d then stop.
    * S2WA_23_FLX_
  * ICA
    * 1: FEPS
    * 2: FEPS
    * 3: Random continuous Wrist movement (short)
    * 4: Random continuous Wrist movement (short)

---

#### Preprocess
* `data_preprocess_splice.m`: Interpolate and splice PRO/SUP/FLX/EXT
  * Segmented data stored in `.mat` file
* `data_preprocess.m`: Interpolate ICAs 
  * Full data stored in `.mat` file

#### Finding
* nICA_2 has bad accuracy performance, the result is no better than no processing
* PRO/SUP RMSE is significantly higher than S2WA_22
  * ~8/7 to ~20/16 degree 
  * FLX/EXT RMSE remains the same
