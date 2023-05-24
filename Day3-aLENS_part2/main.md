# Biophysical Modeling Workshop

## Day 3: aLENS (part 2) 

https://github.com/flatironinstitute/aLENS

https://lamsoa729-alens.readthedocs.io/en/latest/quickstart.html

https://github.com/flatironinstitute/aLENS_analysis/



## Today's Agenda

| Day 3  (Wednesday 6/7) | aLENS (part 2) |
| --- | --- |
| 9:00AM | Variations and current projects (Flexible filaments and transient networks) <br /> Speaker: Adam | 
| 9:30AM | Variations and current projects (Semi-flexible and growing filaments) <br /> Speaker: Dimitrios |
| 10:00AM | Break |
| 10:10AM | Variations and current projects (Bacterial growth) <br /> Speaker: Taeyoon/Bryce|
| 10:40AM | Tutorial: Analysis package for aLENS and free play <br /> Instructor: Adam |
| ~11:10AM | Break|
| ~11:20AM | Tutorial: Analysis package for aLENS and free play <br /> Instructor: Adam |



# ChromaLENS: Long flexible biopolymers
### Adam Lamson
TODO: upload presentation



# Actin, motors, and confinment modeling
## Dimitrios Vavylonis
TODO: upload presentation



# Growing bacteria colonies
## Taeyoon Kim
TODO: upload presentation



# How to analyze aLENS data


## Generate data to analyze

TODO: Pick example file, commands to have students run the simulation


## Data organization file formats
Data is put into `result/result#-#/` directories to prevent surpassing file limit on ceph.

* Ascii data files: SylinderAscii_#.dat, ProteinAscii_###.dat
  * Human readable positions and orientations
* XML VTK files: ConBlock\_r#\_#.vtp, Sylinder\_r#\_#.vtp, Protein\_r#\_#.vtp
  * Binary files containing all information of systems state. Multiple files for different MPI ranks.
* VTK header files: ConBlock_#.pvtp, Sylinder_#.pvtp, Protein_#.pvtp
  * Human readable files of VTK format for XML files

## `aLENS_analysis` package for dealing with data
Often easier to deal with one file than $10^3$ individual time step files.

`aLENS_analysis` provides collection of ascii and vtk data into HDF5 files for easier analysis.

Other functions:
* Fast common post-processing: autocorrelation functions, density functions, stress calculations, etc.
* Graphing helper functions
* Examples of analysis workflows


## Installing `aLENS_analysis` from git

```
TODO set up pip or conda environment
TODO command for installation
TODO install requirement packages
```
<!-- TODO Make sure that this is easy to install and set up -->


## Running data collection routine

```
analens -A collect
```
Should see new directory in simulation folder called `analysis`
<!-- TODO get picture of data -->


## Commandline interface for hdf5 data

TODO: Get basic commands and images to interact through the commandline


## Viewing data with `HDFView`





<!-- Things to also talk about:
Slowness of ceph
Zipping files 
-->


