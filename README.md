# Simulating the QAOA in MATLAB
---
## Version 1.1

The MATLAB code consists of five files.
1. problem.m
2. qaoa.m
3. expval.m
4. state.m
5. BruteForce.m

I'll go through them one by one, and give a brief overview what each files does.

Each file contain very few lines of code so there should not be a big problem of understanding it.

### problem.m

This is the **Main** file and it's from this file that we execute the code. The code is pretty self explanatory. You start by loading the mps file containing the optimization problem that you want to solve. Then select the number of iterations that you want the QAOA to run, i.e. the variable `p`. You have the option to specify the angles `gamma` and `beta` or simply leave them as empty arrays, see picture down below. If you specify `gamma` and `beta` as arrays, the QAOA will use these angles to construct the state $|\vec{\gamma},\vec{\beta}\rangle$. Otherwise if the angles are given by empty arrays the code, when executed, will try to find the optimal ones using MATLAB´s [GlobalSearch](https://se.mathworks.com/help/gads/globalsearch.html) algorithm.

![Imgur](https://i.imgur.com/qQ4OnLV.png)

This file also constructs the cost function $C$. Since we work in the standard (or computational) $\sigma_z$ basis the cost function $C=\sum_{i<j}J_{ij}\sigma^z_i\sigma^z_j+\sum_ih_i\sigma^z_i$ is a diagonal matrix and can thus be stored as a vector to save memory and improve simulation speed.

When you run the file, it will call on the QAOA algorithm (**qaoa.m**) using the function `qaoa` that uses four input variables which are **1**. The cost function `cost` **2**. The number of iterations `p` **3**. The angles `gamma` **4**. The angles `beta`. The qaoa function will then return the binary string corresponding the solution with the highest probability. This string will then be evaluated to see if it corresponds to the optimal solution or not.

### qaoa.m

This files executes the QAOA algorithm and there are two main things you need yo know about it. The first thing is that if `gamma` and `beta` are empty arrays the code will try to find the $2p$ angles that minimises the expectation value $\langle\vec{\gamma},\vec{\beta}|C|\vec{\gamma},\vec{\beta}\rangle$. As a standard procedure to do this we use MATLAB´s GlobalSearch function, but you can also choose to use a Brute force method instead. To do so simply *uncomment* the **BRUTE FORCE METHOD** code and *comment* the **GLOBAL SEARCH METHOD** code in the file. See example picture below. Although I recommend using the global search method since it's much faster.

If `gamma` and `beta` are given by non empty arrays the code will skip this step.

![Imgur](https://i.imgur.com/Dcm9JD3.png)

The second thing to know is that when the optimal angles are found or if the angles where predefined already the code will call on the file **state.m** using the `state` function. This function is responsible for constructing the state $|\vec{\gamma},\vec{\beta}\rangle$. After constructing the state and returning it as an array the code squares each element of the array and selects the index of the array with the largest element. The array index is then converted to a binary string and is returned as output.

Since it can sometimes happen that the string with the highest probability does not correspond the optimal solution, you can choose to print the probability of obtaining the optimal solution if you know it in advance. You can do this at the end of the file, see picture below.

![Imgur](https://i.imgur.com/hlzlvDQ.png)

### expval.m

This file calculates the expectation value $\langle\vec{\gamma},\vec{\beta}|C|\vec{\gamma},\vec{\beta}\rangle$.

But also the gradient of the expectation value. Let $F_p=\langle\vec{\gamma},\vec{\beta}|C|\vec{\gamma},\vec{\beta}\rangle_p$ denote the expectation value, then the gradient is outputed as a vector $[\partial F_p/\partial\gamma_1,\ldots,\partial F_p/\partial\gamma_p,\partial F_p/\partial\beta_1,\ldots,\partial F_p/\partial\beta_p]$;

It can be shown that the analytical gradient of the expectation value is given by
$$
\frac{\partial F_p}{\partial \gamma_n} = -2\mathrm{Im}(\langle\vec{\gamma},\vec{\beta}|W^p_n C(W^p_n)^\dagger C|\vec{\gamma},\vec{\beta}\rangle)  
$$

where
$$
W^p_n = U(B,\beta_p)U(C,\gamma_p)\ldots U(B,\beta_n)U(C,\gamma_n)
$$

### state.m

This file constructs the state vector $|\vec{\gamma},\vec{\beta}\rangle$. For QAOA, the dynamics can be implemented more efficiently due to the special form of the operators $C$ and $B$. We work in the standard (or computational) $\sigma_z$ basis. As already mentioned $C=\sum_{i<j}J_{ij}\sigma^z_i\sigma^z_j+\sum_ih_i\sigma^z_i$ can be written as a diagonal matrix and the action of $e^{-i\gamma C}$ can thus be implemented as vector operations. For $B=\sum_{j=1}^n\sigma^x_j$ the rotation operator $e^{-i\beta B}$ can be simplified as,

$$
e^{-i\beta B}=\prod_{j=1}^ne^{-i\beta\sigma^x_j}=\prod_{j=1}^n\left(\mathbf{1}\cos\beta-i\sigma^x_j\sin\beta\right).
$$

Therefore, the action of $e^{-i\beta B}$ can also be implemented as $n$ sequential vector operations without explicitly forming the sparse matrix $B$, which both improves simulation speed and saves memory.

### BruteForce.m

Brute force algorithm to find the optimal angles, i.e. computes the expectation value $\langle\vec{\gamma},\vec{\beta}|C|\vec{\gamma},\vec{\beta}\rangle$ from a multidimensional grid of angles, in order to find the global minimum of the expectation value.

## Table with optimal angles

Tables with the found optimal angles for different values of $p$ together with the optimal solution for the some of the data sets. The optimal solution is the probability of obtaining the best solution to the problem.

####$\boxed{p=1}$  
Instance | $\gamma$ | $\beta$ | Opt. %
------------ | :-------------: | :------------: | :----------:
instance_8_0 | 0.0821 | 2.7439 | 9.10
instance_8_1 | 0.0628 | 2.7489 | 6.38
instance_8_2 | 0.0628 | 2.7018 | 8.09  
instance_15_0 | 6.2622 | 0.4739 | 0.20  
instance_15_1 | 0.0170 | 2.6224 | 0.19
instance_15_2 | 0.0203 | 2.6613 | 0.21  
instance_25_0 | 0.1105 | 2.5146 | 0.63

####$\boxed{p=2}$
Instance | $\gamma_1$ | $\gamma_2$ | $\beta_1$ | $\beta_2$ | Opt. %
------------ | :-------------: | :------------: | :----------: | :----------: | :----------:
instance_8_0 | 0.0553 | 0.1070 | 2.5742 | 2.7603 | 29.07
instance_8_1 | 0.0424 | 6.1820 | 2.6018 | 0.3605 | 23.08
instance_8_2 | 6.2389 | 0.0938 | 0.5746 | 2.7239 | 28.35
instance_15_0 | 0.0184 | 6.2666 | 2.2619 | 0.3525 | 0.56
instance_15_1 | 6.2687 | 0.0126 | 0.9582 | 2.7524 | 0.50
instance_15_2 | 0.0203 | 2.6613 | 2.6432 | 0.1913 | 0.49

####$\boxed{p=3}$
Instance | $\gamma_1$ | $\gamma_2$ | $\gamma_3$ | $\beta_1$ | $\beta_2$ | $\beta_3$ | Opt. %
------------ | :-------------: | :------------: | :----------: | :----------: | :----------: | :----------: | :----------:
instance_8_0 | 6.2346 | 6.1998 | 6.1679 | 0.6610 | 0.5757 | 0.3465 | 48.52
instance_8_1 | 0.0397 | 6.2094 | 0.1021 | 2.5360 | 0.5277 | 2.8036 | 46.74
instance_8_2 | 6.2360 | 0.0553 | 0.1166 | 0.7855 | 2.8573 | 2.7794 | 42.39
instance_15_0 | 6.2691 | 6.2442 | 6.1768 | 0.5467 | 0.2662 | 0.1761 | 2.36
instance_15_1 | 0.0136 | 6.2396 | 6.2304 | 2.8116 | 0.2287 | 0.1879 | 2.34
instance_15_2 | 6.2700 | 6.2466 | 6.1773 | 0.5659 | 0.2769 | 0.1688 | 2.35
