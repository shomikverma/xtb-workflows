## xtb version 6.3.3

Maintenance and bugfix release.

- ALPB solvation model has internal parameters now (new default)
- `--alpb`/`--gbsa` `gas`/`vac` will not enable the solvation model
- MTD can now use a static ensemble for RMSD bias as well
- MTD time constant can be adjusted from input
- MOPAC interface can now read dipole moments
- new `--bhess` runtype to get hessians on non-equilibrium structures
- Allow adjusting the imag. cutoff for thermo (`$thermo/imagthr=real`)
- Allow scaling of frequencies in thermo (`$thermo/scale=real`)
- Allow scaling of complete hessian (`$hess/scale=real`)
- `--json` flag to enable dumping `xtbout.json`
- Bugfix: Several workarounds for the NVIDIA compilers (former PGI)
- Bugfix: Workaround GCC crashing on empty environment variables
- Bugfix: Fixed non-deterministic failure of GFN-FF with GCC compilers
- Bugfix: Charges are now handled correctly in PDB case
- Bugfix: MOPAC interface reads total energy now from HEAT_OF_FORMATION
- Bugfix: Fix error in GFN-FF torsion potential (new GFN-FF 1.0.2 version)
- Bugfix: SDF input did not work with total charge in GFN-FF
