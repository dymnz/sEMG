### Transradial Amputee Gesture Classification Using an Optimal Number of sEMG Sensors: An Approach Using ICA Clustering

#### Sensor reduction using ICA Clustering (Icasso package): "The main aim of this study is to propose a novel myoelec- tric classification scheme using a minimum number of EMG sensors."

### !!Sensor reduction is not achieved, the paper use the top four significant ICA source estimate as the classification source. No electrode is removed, nor can any of them be removed without the sacrifice in performance. Data dimension indeed is reduced, but not sensor count!!

#### My understanding of Icasso
1. Gather 20 demix matrices with different initial condition
2. Calculate the mutual correlation of estimated sources to form similarity matrix
3. Clustering of estimated sources with similarity
4. Reduce the number of sensor required by choosing a prototype in each cluster ???


A natural measure of similarity between the estimated independent components is the absolute value of their mutual correlation coefficients rij, i, j = 1,...,K. Straightforward calculations show that they can be efficiently computed by simple matrix multipli- cation. In fact, each correlation is given by one element of the matrix **R = WC(WˆT)** where C is the covariance matrix of the original data X (this is exactly true in the case of different initial points;



 
* R-index automatically determine the optimal cluster

#### Two strategies are used in this study: 
1) usage of Icasso [24] to cluster the number of similar muscle activities (sensors) as groups and 2) a maximum number of times the sensors appeared in the cluster. The features extracted from the reduced sEMG sensors are then classified using **linear discriminant analysis (LDA)** to identify movements associated with the different finger gestures for five transradial amputees.


#### ?/10

### Keypoint 
* Sensor reduction
    * ... **sequential forward selection (SFS)** method [16]. The method selects the best single sensor for classification and then adds one sensor at a time that can maximize classification performance in combination with the selected sensors.
    * **SFS** algorithm cannot remove the already selected features that may become obsolete after the addition of other candidate features (or sensors). 
    * **Multiclass common spatial pattern (MCCSP)**
    * **Fisher-Markov selector (FMS)**
* ICA
    * Extracting most reliable information from the ICA algorithms is always a challenging task, because they (most algorithms) have random (stochastic) elements [23]. 
    * ICA Clustering: t a tight cluster of estimates is considered to be a candidate for including a “good” estimate. A centroid of such a cluster is considered a more reliable estimate than any estimate from an arbitrary run [24].w
    * Icasso is being used to find the underlying sEMG sources and to find a subset of useful elec- trodes contributing to those sources.

* Icasso
    * Icasso algorithm was utilized to select the best four EMG sensors responsible for amputee finger gestures.
    * Each estimated IC is one point in the space. If an IC is reliable, (almost) every run of the algorithm should produce a point that is very close to the ideal component corresponding to the cluster center. Thus, reli- able independent components correspond to tight clusters, and unreliable ones correspond to points which do not belong to any cluster. 
    * Icasso collects the ICs estimated from all runs and then **matches components across runs by clustering components based on the absolute value of the correlation between squared source estimates**. 
    *  The number of clusters in the data was automatically selected with the **R-index [24]**.
    *  Each cluster was uniquely represented by a single centrotype ICA-estimate, which is just **an estimate in the cluster that has the maximum sum of similarities to other points in the cluster**.

* Gesture
    *  Thumb adduction was discarded in the data recording, because the muscles responsible for thumb adduction lie in the hand itself and it cannot be decoded from the upper forearm.


### Word
* Hierarchical clustering: 
    * Agglomerative: This is a "bottom up" approach: each observation starts in its own cluster, and pairs of clusters are merged as one moves up the hierarchy.
    * Divisive: This is a "top down" approach: all observations start in one cluster, and splits are performed recursively as one moves down the hierarchy.



### General

* Related paper: Identification of Hand and Finger Movements Using **Multi Run ICA** of Surface Electromyogram
* 

### Spinoff
1. Validating the independent components of neuroimaging time series via clustering and visualization
2. 
