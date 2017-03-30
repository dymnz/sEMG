## sEMG Force/Gesture Detection & Application

### [TODO list](https://github.com/dymnz/sEMG/issues)

#### Feature
* Forearm band with sEMG active electrode(s)
* Arduino for signal processing and communication with PC
* Application using sEMG signal

## Plan
#### Work for 彭/陳
 1. Repeat previous work: [Single-channel sEMG acquisition circuit](https://docs.google.com/presentation/d/11IYvfBDf9Gm5g4vkAGl6tNFws104Yh6MHr-Pdmbg2KI/edit?usp=sharing)
 2. Arduino ADC usage
    1. Sample rate?    
 2. Arduino <--> PC communication
    1. Serial port communication (Easy) or Bluetooth (Hard)

#### Work for 王
1. Armband/dry electrode test
2. Arduino ADC usage

## Specification
#### Arm Band
* Elastic material
* Electrode placement similar to MYO, 6 channels surronding 360d
* AgCl electrode extracted from generic electrode
* Electrodes are fixed in place by hot melting glue

#### Active Electrode
* Follow previous design:
[Active electrode design](https://docs.google.com/presentation/d/1o4o_Otk5q0jGyL7rctB4WYEOh_Rm1VMepdIzW7R5j3A/edit?usp=sharing)

#### Additional Circuit (LPF+HPF, Amp, Level-Shifter)
* Follow previous design:
[Additional circuit design](https://docs.google.com/presentation/d/1GJvZu7B9UVg2i4G1NfTHZUsHolxvhOIAVFU5KP-jUp8/edit?usp=sharing)


## Other
#### Application
* Force detection
    - Remote "Tug of war", two player force competiton
* Gesture detection
    - Woah

#### Readings 
* [sEMG signal property](https://docs.google.com/presentation/d/1j7N44gfdRZYDZp8JlrIv_mfGXxhfv925Nk_ETe5trDQ/edit?usp=sharing)
* [Active electrode design](https://docs.google.com/presentation/d/1o4o_Otk5q0jGyL7rctB4WYEOh_Rm1VMepdIzW7R5j3A/edit?usp=sharing)
* [Additional circuit design](https://docs.google.com/presentation/d/1GJvZu7B9UVg2i4G1NfTHZUsHolxvhOIAVFU5KP-jUp8/edit?usp=sharing)

