### 4th Experiment

Pronation/Supination. First test, try to locate optimal muscle location and check signal condition.

* Muscle:
  * Biceps Brachii (CH1)
  * Pronator Teres (CH2)
* Protocol
  * Zero-load, palm facing down, making a fist
  * ~Wrist hang free w/ forearm resting on a surface~ Forearm and Wrist are on the table. Hand should always contact the table, to avoid raising forearm.
  * Constant angular speed
  * 0 degree is defined as palm facing down flat on the table, >0 as wrist turn right
  * Each dataset consists of 5~10 epoch w/ resting interval in between each epoch
  * R^2 error metric should be used to avoid bias for small value estimation
* Movement types
  * Pronation: <0 degree only. From 0d move toward -90d then pause. Start moving toward 0d then stop.
    * S2WA_TABLE_PRO_
  * Supination: >0 degree only. From 0d move toward 90d then pause. Start moving toward 0d then stop.
    * S2WA_TABLE_SUP_
  * Extension/Flexion: Full range. From 0d move toward 90d then pause. Start moving toward 0d then pause. From 0d move toward -90d then pause. Start moving toward 0d then stop.
    * S2WA_TABLE_2_FULL_

--- 

### 4th Experiment - Notes
* Can't locate *Supinator muscle*, no significant signal measured. Use *Biceps Brachii* instead.
* *Flexor Carpi Radialis* is right next to *Pronator Teres*
* *Biceps Brachii* has significant response for Supination, but raising the forearm also trigger *Biceps Brachii*. Have to avoid such movement when test.
