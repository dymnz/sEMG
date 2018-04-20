### 7th Experiment

Torque & Gravity Issue, see exp_6. Switch back to "0 degree is defined as palm facing down flat on the table", **WITH** device assisted PRO/SUP.

Target: RMSE < 10 degree

* Muscle:
  * Pronator Teres (CH1, red)
  * Supinator Muscle (CH2, green)  
* Protocol
  * Zero-load, palm facing down, making a fist
  * Forearm and Wrist are on the table. Hand should always contact the table, to avoid raising forearm.
  * Constant angular speed
  * 0 degree is defined as palm facing down flat on the table, 
    ~0 degree is defined as palm resting on table w/ thumb pointing up~, >0 as wrist turn right (SUP).
  * **Resting position is palm down, all muscle relaxed, 0 degree**
    * **The bias is removed in the preprocessing process, especially for Roll bias. (same in exp-5)**
  * **Ref. electrode moved to wrist**, follow the placement of other paper.
  * **Fixed custom device to assist PRO/SUP motion to avoid Flexion/Extension of wrist**
  * **Supinator Muscle electrode is 30d to perpendicular to arm**
  * Each dataset consists of 5~10 epoch w/ resting interval in between each epoch
  * R^2 error metric should be used to avoid bias for small value estimation
* Movement types
  * Pronation: <0 degree only. From 0d move toward -90d then pause. Start moving toward 0d then stop.
    * S2WA_7_PRO_ 
  * Supination: >0 degree only. From 0d move toward 90d then pause. Start moving toward 0d then stop.
    * S2WA_7_SUP_ (S2WA_6_FREE_SUP_ for no device support)
  * Extension/Flexion: Full range. From 0d move toward 90d then pause. Start moving toward 0d then pause. From 0d move toward -90d then pause. Start moving toward 0d then stop.
    * S2WA_7_PROSUP_ (S2WA_6_FREE_PROSUP_ for no device support)
  * Pattern
    * _1: Fixed_amp Fixed_interval, long pause  (train)
    * _2: Fixed_amp Var_interval, long pause    (train)
    * _3: Var_amp Var_interval, long pause      (train/test)
    * _4: Var_amp Var_interval, long pause      (test)
    * _5: Var_amp Var_interval, brief pause     (test)

---  



---

### 7th Experiment - Notes

* Supinator Muscle electrode perpendicular to arm gives
  smaller amplitude, comparing to 30d to perpendicular
* Rotation assisting device need to be fixed in place to avoid leaning forward.
  * To produce clear signal