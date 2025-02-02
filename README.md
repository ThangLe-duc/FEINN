# FEINN
In this study, we propose a novel deep learning model named as the Finite-element-informed neural network (FEI-NN), inspired from finite element method (FEM) for parametric simulation of static problems in structural mechanics. The approach trains neural networks in the supervised manner, in which parametric variables of structures are considered as input features of network and spatial ones are implicitly embedded into the loss function based on a soft constraint called by finite element analysis (FEA) loss. The training process simultaneously minimizes the empirical risk function and partially respects the mechanical behaviors via the FEA loss defined as a residual calculated from the weak form of the surrogate system scaled from the actual corresponding structure. Besides, a technique developed from batch matrix multiplication is proposed to significantly reduce the time complexity for estimating the FEA loss. The method applies to some typical systems in structural mechanics including truss, beam and plate structures. Through several experiments we statistically demonstrate the superiority of the approach in terms of faster convergence and producing better DNN models in comparison to the traditional data-driven approach concerning both generalization and extrapolation performance.

The source codes are written by Matlab version 2020a. Folder “FEINN Main Functions” contains main file and functions to specify the problems and neural network configuration. Folders “FEINN Training Package” and “FEINN Functions” respectively contain functions for training FEINN model and calculating FEA residuals. It is suggested that the users should read thoroughly our paper presented in the reference below before using the codes.

# Programmer
Thang Le-Duc, Deep Learning Architecture Research Center, Sejong University, email: le.duc.thang0312@gmail.com; thangld@sju.ac.kr

# Reference
Le-Duc, T., Nguyen-Xuan, H., & Lee, J. (2023). A finite-element-informed neural network for parametric simulation in structural mechanics. Finite Elements in Analysis and Design, 217, 103904.
https://www.sciencedirect.com/science/article/pii/S0168874X22001779
