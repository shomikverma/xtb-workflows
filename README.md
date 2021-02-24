# xtb-workflows
Python workflows automating energy level calculations of molecules using the xTB family of methods

## Installation and Setup

This is the most difficult part. The xtb, xtb4stda, and stda packages all need to be installed before you can run this automated workflow. I found xTB and sTDA to be relatively easy to install on Mac, but xtb4stda was quite difficult. I'd recommend installing on Linux using the pre-compiled binaries if possible. Details below:

### xtb

Statically linked binaries can be found at the [latest release page](https://github.com/grimme-lab/xtb/releases/latest). Once you unzip the targz file you'll need to add `xtb-X.X.X/bin` to `PATH` in order to make xtb accessible.

You can also install with conda using

    conda config --add channels conda-forge
    conda install xtb
    
I've personally found the statically linked binary to be much more stable, but MacOS doesn't support statically linked binaries so conda is your best bet here.

Once you have xTB installed, you need to set up some environment variables. I've found using the following works well:

    ulimit -s unlimited
    export OMP_STACKSIZE=5G
    export OMP_NUM_THREADS=<ncores>,1
    export OMP_MAX_ACTIVE_LEVELS=1
    export MKL_NUM_THREADS=<ncores>
    
You can find the number of cores on your computer using `lscpu` on Linux or `sysctl -n machdep.cpu.core_count` on Mac. Note that xTB uses single-node computation, which is good to keep in mind if using HPC.

### stda

Statically linked binaries can be found at the [latest release page](https://github.com/grimme-lab/xtb4stda/releases/latest). That page also contains the xtb4stda binary. Remember to add the directory where you put the binaries to `PATH` to make stda and xtb4stda accessible.

If you're on Mac, there unfortunately isn't a conda package for stda. If you still want to install it on Mac, you need to build from source, following the instructions on the [stda GitHub](https://github.com/grimme-lab/stda). 

### xtb4stda

The statically linked binary for xtb4stda can be found at the stda release page. Once you have the xtb4stda binary installed you also need to download the parameter files from the [xtb4stda GitHub](https://github.com/grimme-lab/xtb4stda) and set the `XTB4STDAHOME` environment variable to the directory you downloaded the files.

It currently isn't possible to build xtb4stda from source in the same way as stda, I have an [issue](https://github.com/grimme-lab/xtb4stda/issues/9) open to request this feature. You can try to follow the procedure I outline in the issue or take a look at my [fork](https://github.com/shomikverma/xtb4stda) to make it run, but I can't guarantee it will work since it was pretty hacky. Don't forget to add to path and set the `XTB4STDAHOME` environment variable.

## Inputs

You can put .xyz files for molecules you want to run in the `molxyzfiles` folder. The folder has an .xyz file already available for testing to make sure everything is set up correctly.

Default inputs for xTB are as follows:
* Calculates with GFN2-xTB unless this fails, in which case will try GFN1-xTB
* Optimizes geometry using the tight formulation of xTB
* Attempts to detect the charge of the mol file automatically
* Uses acetonitrile as the solvent

Inputs for sTDA are as follows:
* Uses the xtb4stda package to generate input for sTDA
* Automatically calculates with both sTDA and sTD-DFT

You can change these values in `xtb_run.py` if you want.

## Running

Fairly simple, just navigate to this directory and type `python xtb_run.py` in terminal. This will automatically move all .xyz files into their own directories and start running xTB and sTDA on the molecules to calculate T1 and S1 energies. Note that this program runs sequentially.

## Outputs

In the home directory, the program will create 2 text files with calculation results. **`exData.txt` will have the first excited triplet state (T1) and first excited singlet state (S1) energies in eV.** `exData_errs.txt` will have names of the molecules for which the calculation failed. There will also be 2 text files starting with `startInd_`, showing the index of the last file that was calculated, this is useful in case any files throw errors, so you know where to look to start troubleshooting.

Within the directory for each molecule, there will also be several output files. `output_xtb.out` and `output_xtb_trip.out` will have the log files for ground state and triplet state xTB calculations, respectively. `output_xtb4stda.out` will have the log file for the xtb4stda program (not too important). `output_stda.out` and `output_stddft.out` will have the log files for the sTDA or sTD-DFT calculations, respectively, for the excited singlet state calculation. There will also be several .dat files that have the relevant energy data extracted from the .out files. Finally, there will be a file called `xtb_opt.xyz` which contains the xTB-optimized ground state molecular structure.