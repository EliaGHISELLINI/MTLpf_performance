# Online Monitoring and Verification of Dynamic System Performance Properties in MTL<sup>F</sup><sub>P</sub>

This is the work by Elia GHISELLINI and Pierre-Loïc GAROCHE on 
Online Monitoring and Verification of Dynamic System Performance Properties in MTL<sup>F</sup><sub>P</sub>.

## Organization of the repository

The repository is organized as follows: 

<b>Formal Verification</b> 
* MATLAB file for Reachability analysis of the system with CORA
* Lustre files with data-flow contracts and used to generate the SMT2 file for CHC, and SMT2 file for CHC
* results of Reach+BMC
With these files, Table 8 cannot be reproduced directly, but the process for each evaluation can be rebuild trivially.

<b>Monitoring</b> 
* MATLAB file for the mathematical model of the system 
* Simulink file containing the model and the monitor, obtained with CoCoSim by the Lustre file in <b>Synchronous Observers</b>

<b>Synchronous Observers</b>
* Lustre files with the nodes of the MTL<sup>F</sup><sub>P</sub> operators
* Lustre files with the nodes of the performance properties monitors

## Dependencies

The framework is dependent on the following tools:

To do monitoring and reachability analysis
* CORA
* MATLAB & Simulink (I used R2025b)

To generate the files from the Lustre files
* LustreC
* CoCoSim

To perform SMT model checking
* KIND2 with Z3 (I used v2.3.0)
* GOLEM (I used v9)
