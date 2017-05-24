### Transradial Amputee Gesture Classification Using an Optimal Number of sEMG Sensors: An Approach Using ICA Clustering

#### thoughts


#### My understanding of Icasso
1. Gather 20 demix matrices with different initial condition
2. Calculate the mutual correlation of estimated sources to form similarity matrix
3. Clustering of demix matrices with similarity
4. Reduce the number of sensor required by eliminating closely related sensor cluster
 
* R-index automatically determine the optimal cluster

#### ?/10

### Keypoint 
* Sensor reduction
    * ... **sequential forward selec- tion (SFS)** method [16]. The method selects the best single sensor for classification and then adds one sensor at a time that can maximize classification performance in combination with the selected sensors.
    * **SFS** algorithm cannot remove the already selected features that may become obsolete after the addition of other candidate features (or sensors). 


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
