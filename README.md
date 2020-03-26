# R-FORCE
## Introduction
This repository contains the python and matlab code of implementing R-FORCE

## Abstract
We present a new initialization method for First Order Reduced and Controlled
Error [(FORCE)](https://www.sciencedirect.com/science/article/pii/S0896627309005479) to
achieve more robust performance to chaos. FORCE learning performs well only in a narrow
range of chaos, but we want to explore whether there exists alternative initialization
method which can make FORCE more robust. In this paper, we demonstrate how to generate 
R-FORCE specifically and show the comparison results of R-FORCE, FORCE and Full-FORCE() on
target-learning and multi-dimension body modeling tasks. This results imply R-FORCE outperforms 
other state-of-art methods in terms of mean absolute error and confidence interval simultaneously. 

## Predicted Modeling Video
![Predicted Modeling Video](deepSquat.gif)

## Training Instructions for One-dimension target funcion
* Run main.m for training, testing and plotting

## Training Instruction for multi-dimension body modeling
* Run mainRFORCEMovementSimulation.m
* We posted the original movement data(xxx.mat) and augement data(xxxPeriod.mat) under the data folder
* The training result is saved as Simulation_skel
* We also included the trained model and simulation results under result folder
* You can visualize those results using bodyMovementVisualization.m

## Citation

## License
