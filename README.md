# xtb-workflows
Python workflows automating energy level calculations of molecules using the xTB family of methods

## Installation and Setup

This is likely the most difficult part. The xtb, xtb4stda, and stda packages all need to be installed before you can run this automated workflow. I found xTB and sTDA to be relatively easy to install on Mac, but xtb4stda was quite difficult. I'd recommend installing on Linux using the pre-compiled binaries if possible. Details below:



## Inputs

Need to put .xyz files for molecules you want to run in the `molxyzfiles` folder. The folder has an .xyz file already available for testing to make sure everything is set up correctly.

Default inputs for xTB are as follows:
* Calculates with GFN2-xTB unless this fails, in which case will try GFN1-xTB
* Optimizes geometry using the tight formulation of xTB
* Attempts to detect the charge of the mol file automatically
* Uses acetonitrile as the solvent

Inputs for sTDA are as follows:
* Uses the xtb4stda package to generate input for sTDA
* Automatically calculates with both sTDA and sTD-DFT

## Running

Fairly simple, just type `python xtb_run.py` in terminal. This will move all .xyz files into their own directories for xTB computation.

## Outputs

In the home directory, the program will create 2 text files with calculation results. exData.txt will have the first excited triplet state (T1) and first excited singlet state (S1) energies in eV. exData_errs.txt will have names of the molecules for which the calculation failed. There will also be 2 text files starting with startInd, showing the index of the last file that was calculated, this is useful in case any files throw errors, so you know where to look to start troubleshooting.

Within the directory for each molecule, there will also be several output files. output_xtb.out and output_xtb_trip.out will have the log files for ground state and triplet state xTB calculations, respectively. output_xtb4stda.out will have the log file for the xtb4stda program (not too important). output_stda.out and output_stddft.out will have the log files for the sTDA or sTD-DFT calculations, respectively, for the excited singlet state calculation. There will also be several .dat files that have the relevant energy data extracted from the .out files. Finally, there will be a file called xtb_opt.xyz which contains the xTB-optimized ground state molecular structure.