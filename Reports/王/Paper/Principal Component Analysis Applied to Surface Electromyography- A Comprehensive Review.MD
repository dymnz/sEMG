### Principal Component Analysis Applied to Surface Electromyography: A Comprehensive Review

#### Brief introduction of PCA and sEMG signal. Many examples of PCA usage on sEMG

#### 7/10

### Keypoints
* Factor analysis 
    * principal component analysis (PCA), independent component analysis (ICA), singular value decomposition (SVD), and non-negative matrix factorization (NMF) 

* Signal
    * ...the body tissues jointly act as an imperfect insulator with low- pass filter characteristics, and therefore tend to attenuate the high frequency components of the acquired signal 
    * ...the amplitude of the sEMG signal turns out to be pseudo-random, and its probability distribution function resembles a Gaussian function [15], [39], [40].
    * An important sEMG processing is the extraction of multiple muscle activities called *synergy features* that would reveal coordination patterns in the myoelectric signals. These features are proven useful when dealing with multiple DoF as they could explain the coordination among various muscles.
    

* Force
    * As exemplified in [15] and [40], the ampli- tude and spectral information of sEMG provide cues to esti- mate the muscle force and muscle voluntary contractions.

* Fatigue
    *  In a contraction that generates a constant force, namely, the isotonic contraction, the activation pattern switches from one MU to another so that the MU can evade from growing fatigue [37], [38].

* PCA
    *  PCA has been employed to determine the most important factors that contribute to the sources of variation in movement patterns [5], [25].
    *  The PCs account- ing for a large amount of total variance are presumably related to the control signal outputs of spinal pattern generators, which trigger the corresponding muscles to generate move- ment under the influence of commands that are sent to the MUs through the descending pathway [46]. 
    *  the components that explain only a small amount of the total variance are generally deemed as random noise within the system [42]. 
    *   Many studies have successfully demonstrated that the application of PCA to kinematic, kinetic or sEMG data can unveil the underlying coordinative structures in the correlated patterns of variation among joints or body segments [47], [48].

* PCA implementation
    * retain the PCs with the eigenvalues greater than one; however, as cautioned in [54], this naive strategy may lead to loss of valuable information.
    * Traditionally, one can plot the eigen- values in decreasing order, and the resulting plot known as the scree-plot may be visually inspected to track the elbow point, where the slope of the scree-plot undergoes an abrupt transition. 
    * Another popular method is to retain the smallest number of components that capture an appreciable percentage γ of the total variance; in practice, γ is determined to be 80% or 90%.
    * 

* PCA+
    *  a few other sEMG decomposition techniques have been deemed more suitable than the PCA as argued in [51] 
    *  By treating the sEMG signals as complex convolutive mixtures, the deconvolution has been achieved with partial success with wavelets, neural network classifiers, and the time-frequency decomposition. 

### Word, AKA vocabulary

### General, misc

### Spinoff, interesting referenced papers