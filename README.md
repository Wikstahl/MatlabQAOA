# MatlabQAOA
Simulating the quantum approximate optimization algorithm with Matlab

# Table of contents
2. [Installation](#installation)
3. [Usage](#usage)

## Installation <a name="installation"></a>
Installation requires Matlab version 2018b or newer.

## Usage <a name="usage"></a>

The code consists of several scripts and functions. 

1. problem.m (**main file**)
2. qaoa.m
3. expval.m
4. variational_state.m

We will go through them one by one, and give a brief overview what each files does.

### problem.m

This is the **Main** file and it's from this file that we execute the code. You start by specifing the cost Hamiltonian of which you want to find the ground state of as an 1-D array (column vector) with all of its energy eigenvalues. Then you choose the number of iterations that you want the QAOA to run, i.e. the variable `p`. You have the option to specify the angles `gamma` and `beta` or simply leave them as empty arrays. If you specify `gamma` and `beta` as arrays, the QAOA will use these angles to construct the variational state. Otherwise if the angles are given by empty arrays the code, when executed, will try to find the optimal ones using MATLAB´s [GlobalSearch](https://se.mathworks.com/help/gads/globalsearch.html) classical optimizer as default. You can change which classical optimizer that you want to use. There are seven ones in total to choose from.

1. `GlobalSearch` (Default)
2. `MultiStart`
3. `Bayesian`
4. `BayesianHybridNelderMead`
5. `NelderMead`
6. `ParticleSwarm`
7. `BruteForce`

When you run the `problem.m` script file, it will call on the QAOA algorithm (**qaoa.m**) file using the `qaoa` function. This function can have up to six input variables, of which two are required! The required ones are: **1**. The eigenvalues of the cost Hamiltonian `cost` and **2**. The number of iterations or depth `p` of the QAOA algorithm. The optional ones are  **3**. The `gamma` angles; **4**. The `beta` angles; **5.** The classical optimizer and **6** potential starting points for the classical optimizer to use. The qaoa function will return the final variational state |γ,β⟩ (using either the given input angles or the best found angles by the classical optimizer) and the result from the classical optimizer as a struct data type.

### qaoa.m

