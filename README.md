# BPM Summer School
Collection of resources for the Biophysical Modeling Software Summer School

## Goal
**Quickly acquaint new personel with compuational tools developed at Flatiron to model biophysical phenomena.**
    1. Understand the strengths and limitations of methods when applied to scientific problems.
    2. Learn how to debug, troubleshoot, and analyze data from simulations.
    3. Be comfortable submitting large jobs to the Flatiron cluster.

## Schedule

| Day 1  (Monday 6/5)   | General Introduction |
|:---|:---|
| 9:00AM | Welcome and Introduction of BPM and CCB <br /> Speaker: **Mike Shelley**|
| 9:20AM | Go around presentation (~5 min/person) <br /> Speaker: **Students** |
| 10:10AM | Break |
| 10:20AM | Intro to resources available to SCC and Cluster <br /> Speaker: **Geraud Krawezik** |
| ~11:00AM | Tutorial: Pre-workshop software installation and cluster setup  <br /> Instructors: **Adam and Reza** |
| **Day 2  (Tuesday 6/6)** | **aLENS (part 1)** |
| 2:00PM | Introduction to aLENS (what can it do?) <br /> Speaker: **Adam** |
| 2:30PM | Computational methods and code structure of aLENS  <br /> Speaker: **Bryce** |
| 3:00PM | Break |
| 3:10PM | Tutorial: Running aLENS for the first time <br /> Instructor: **Adam** |
| ~3:45PM | Tutorial: Paraview and visualizing <br /> Instructor: **Adam/Bryce**|
| ~4:00PM | Break  |
| ~4:10PM | Tutorial: Explanation of parameters and playing with simulations <br /> Instructor: **Adam/Bryce**|
| **Day 3  (Wednesday 6/7)** | **aLENS (part 2)**|
| 9:00AM | Variations and current projects (Flexible filaments and transient networks) <br /> Speaker: **Adam** | 
| 9:30AM | Variations and current projects (Semi-flexible and growing filaments) <br /> Speaker: **Dimitrios** |
| 10:00AM | Break |
| 10:10AM | Variations and current projects (Bacterial growth) <br /> Speaker: **Taeyoon/Bryce**|
| 10:40AM | Analysis package for aLENS and free play <br /> Instructor: **Adam** |
| ~11:10AM | Break|
| ~11:20AM | Analysis package for aLENS and free play <br /> Instructor: **Adam** |
| **Day 4  (Thursday 6/8)** | **SkellySim (part 1)**|
| 9:00AM | Intro to SkellySim <br /> Speaker: **Robert** | 
| 9:30AM | Computational methods and code structure <br /> Speaker: **David**|
| 10:00AM | Break |
| 10:10AM | Tutorial: Running SkellySim for the first time (visualize with matplotlib) <br /> Instructor: **Robert**|
| ~10:40AM | Tutorial: Explanation of parameter files and free play  <br /> Instructor: **Robert** |
| ~11:00AM | Break |
| ~11:10AM | Free play <br /> Speaker: **Coordinators**|
| ~11:40AM | Visualizing with Blender <br /> Speaker: **Reza**|
| **Day 5  (Friday 6/9)** | **SkellySim (part 2)**|
| 9:00AM | Current projects (Oocyte flows) <br />  Speaker: **Reza** | 
| 9:30AM | Current projects (Rotating centrosomes) <br /> Speaker: **David** |
| 10:00AM | Break |
| 10:10AM | Tutorial: Analysis of SkellySim <br /> Instructor: **Reza**|
| ~11:10AM | Break|
| ~11:20AM | Free play <br /> Speaker: **Coordinators**|
| **Day 6  (Monday 6/12)** | **PDE solvers/methods (part 1: Dedalus)**|
| 9:00AM | Intro to Dedalus <br />  Speaker: **Keaton** | 
| 9:30AM | Current projects (Oscillating active dipolar flows) <br /> Speaker: **Brato** |
| 10:00AM | Break |
| 10:10AM | Current projects (Heterochromatin condensation) <br /> Speaker: **Alex**|
| 10:30AM | Tutorial: Running Dedalus<br /> Instructor: **Keaton**|
| ~11:00AM | Break|
| ~11:10AM | Tutorial: Visualizing Dedalus and free play (active fluid simulations) <br /> Instructor: **Keaton**|
| **Day 7  (Tuesday 6/13)** | **PDE solvers/methods (part 2: David’s, Dan’s, and Alex’s method)**|
| 2:00PM | Computation methods (Fast spectral solver) <br />  Speaker: **David** | 
| 2:30PM | Computation methods (Fast spectral solver continued) <br />  Speaker: **Dan** |
| 3:00PM | Break |
| 3:10PM | Current projects (Polarization of cells) <br /> Speaker: **Pearson**|
| 3:40PM | Tutorial: Solving PDEs on curved surfaces<br /> Instructor: **Dan**|
| ~4:10PM | Break|
| ~4:20PM | Tutorial: Solving PDEs on curved surfaces (continued) <br /> Instructor: **David**|
| **Day 8  (Wednesday 6/14)** | **Advanced cluster usage**|
| 9:00AM | Getting programs running/environment management <br />  Speaker: **Robert/Chris**| 
| 10:00AM | Break |
| 10:10AM | Tutorial: Slurm <br /> Speaker: **Chris**|
| 10:30AM | Tutorial: Large batch runs with DisBatch <br /> Instructor: **Nick**|
| ~11:00AM | Break|
| ~11:10AM | Testing code for correctness and efficiency <br /> Speaker: **Vickram**|
| **Day 9  (Thursday 6/15)** | **Free play and/or walkthroughs with instructors to help**|
| 9:00AM | Current projects (Contractile matter) <br />  Speaker: **Shai** | 
| 9:30AM | Tutorials/Free play  <br /> Instructors: **Coordinators/Mentors** |
| **Day 10  (Friday 6/16)** | **Free play and/or walkthroughs with instructors to help**|
| 9:00AM | Current projects (Tissue mechanics) <br />  Speaker: **XinXin** | 
| 9:30AM | Tutorials/Free play  <br /> Instructors: **Coordinators/Mentors** |



## Pre-workshop downloads
- Docker desktop
  - Sign up at docker hub [https://hub.docker.com/](https://hub.docker.com/)
  - Download docker desktop [https://www.docker.com/products/docker-desktop/](https://www.docker.com/products/docker-desktop/)
  - (Optional) Docker engine
    - [Linux](https://www.linux.com/topic/desktop/how-install-and-use-docker-linux/)
    - [Mac](https://medium.com/crowdbotics/a-complete-one-by-one-guide-to-install-docker-on-your-mac-os-using-homebrew-e818eb4cfc3)
- paraview [https://www.paraview.org/download/](https://www.paraview.org/download/)
- HDFview
  - Sign up for service [https://www.hdfgroup.org/register/](https://www.hdfgroup.org/register/)
  - Download at [https://www.hdfgroup.org/downloads/hdfview/#download](https://www.hdfgroup.org/downloads/hdfview/#download)


##
