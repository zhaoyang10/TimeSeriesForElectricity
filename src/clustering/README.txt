This folder contains the code for running both experiments: brute force u-shapelet discovery and scalable (fast) version.
We tested the code on Matlab version R2012a. NOTE: Earlier versions of Matlab might not work because of 2 reasons. First, we used "containers.map" objects. Second, "idivide" function works in a different way with uint64 in earlier versions. For Matlab 2010a please use another version of this code presented on the supporting web page. 
How to run the code:
1.	Unzip all code from the current archive 
2.	For brute force algorithm run "RunManyClusters_Best.m", for SUSh run "RunManyClusters_Fast.m"
3.	When you run one of these scripts, for the demonstration purposes you may type "default" and experiments will be running on the default dataset.
4.  For any other dataset answer the questions provided by the program: input the file name, tell if data labels are included and provide a length of u-shapelets.
5.	Program will save the results of execution to the folder "TestResults"
6.	The format of "uShapelets" output parameter of both scripts "RunManyClusters_Best.m" and "RunManyClusters_Fast.m" is the following: 
	Time series number		Position in time series			U-shapelet length		Rand Index (how well each u-shapelet separates the data on each step)