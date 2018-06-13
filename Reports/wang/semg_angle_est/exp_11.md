### 11th Experiment

4-ch sEMG FLX/EXT(Pot.) & PRO/SUP(Gyro).

Target: RMSE < 10 degree

* Muscle:
  * **Equidistant placement of 4-ch sEMG forming a ring**
* Protocol
  * Zero-load, palm facing down, making a fist
  * Forearm and Wrist are on the table. Hand should always contact the table, to avoid raising forearm.
  * Constant angular speed
  * 0 degree is defined as palm facing down flat on the table, 
    ~0 degree is defined as palm resting on table w/ thumb pointing up~, >0 as wrist turn right (SUP).
  * **Resting position is palm down, all muscle relaxed, 0  degree**
    * The bias is removed in the recording process, especially for Roll bias
  * Ref. electrode moved to wrist, follow the placement of other paper.
  * ~Fixed custom device to assist PRO/SUP motion to avoid Flexion/Extension of wrist~ Free hand to allow FLX/EXT
  * **Supinator Muscle electrode is 30d to perpendicular to arm**
  * Each dataset consists of 5~10 epoch w/ resting interval in between each epoch
  * R^2 error metric should be used to avoid bias for small value estimation
* Movement types
  * Pronation: <0 degree only. From 0d move toward -90d then pause. Start moving toward 0d then stop.
    * S2WA_10_PRO_ 
  * Supination: >0 degree only. From 0d move toward 90d then pause. Start moving toward 0d then stop.
    * S2WA_10_SUP_
  * Extension: <0 degree only. From 0d move toward 90d then pause. Start moving toward 0d then stop.
    * S2WA_10_EXT_
  * Flexion: >0 degree only. From 0d move toward -90d then pause. Start moving toward 0d then stop.
    * S2WA_10_FLX_
  * Pattern
    * _1: Fixed_amp Fixed_interval, long pause  (train)
    * _2: Fixed_amp Var_interval, long pause    (train)
    * _3: Var_amp Var_interval, long pause      (train/test)
    * _4: Var_amp Var_interval, long pause      (test)
    * _5: Var_amp Var_interval, brief pause     (test)


---
