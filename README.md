# MatlabQAOA
Simulating the quantum approximate optimization algorithm with Matlab

# Table of contents
1. [Introduction](#introduction)
2. [Installation](#installation)
3. [Usage](#usage)

## This is the introduction <a name="introduction"></a>
Some introduction text, formatted in heading 2 style

## Installation <a name="installation"></a>
Installation requires Matlab version 2018b or newer. 

## Usage <a name="usage"></a>
The second paragraph text

### problem.m

This is the **Main** file and it's from this file that we execute the code. You start by loading the mps file containing the optimization problem that you want to solve. Then select the number of iterations that you want the QAOA to run, i.e. the variable `p`. You have the option to specify the angles `gamma` and `beta` or simply leave them as empty arrays, see picture down below. If you specify `gamma` and `beta` as arrays, the QAOA will use these angles to construct the variational state. Otherwise if the angles are given by empty arrays the code, when executed, will try to find the optimal ones using MATLAB´s [GlobalSearch](https://se.mathworks.com/help/gads/globalsearch.html) algorithm as default.

![Imgur](https://i.imgur.com/qQ4OnLV.png)

This file also constructs the cost function $C$. Since we work in the standard (or computational) $\sigma_z$ basis the cost function $C=\sum_{i<j}J_{ij}\sigma^z_i\sigma^z_j+\sum_ih_i\sigma^z_i$ is a diagonal matrix and can thus be stored as a vector to save memory and improve simulation speed.

When you run the file, it will call on the QAOA algorithm (**qaoa.m**) using the function `qaoa` that uses four input variables which are **1**. The cost function `cost` **2**. The number of iterations or depth `p` of the QAOA algorithm  **3**. The angles `gamma` **4**. The angles `beta`. The qaoa function will then return the binary string corresponding the solution with the highest probability. 
