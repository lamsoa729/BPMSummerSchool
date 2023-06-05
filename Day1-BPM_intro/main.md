# Biophysical Modeling Workshop

## Day 1: Welcome and Introduction to resources


## Today's Agenda

| Day 1  (Monday 6/5) | General Introduction |
| --- | --- |
| 9:00AM | Welcome and Introduction of BPM and CCB <br /> Speaker: **Mike Shelley**|
| 9:20AM | Go around presentation (~5 min/person) <br /> Speaker: **Students** |
| 10:10AM | Break |
| 10:20AM | Intro to resources available to SCC and Cluster <br /> Speaker: **Geraud Krawezik** |
| ~11:00AM | Tutorial: Pre-workshop software installation and cluster setup  <br /> Instructors: **Adam and Reza** |



# Introduction

### Speaker: Mike Shelley



# Go around presentations (~5 min/person)

### Speakers: All of you


## Nikhil Agrawal
### [presentation (click me)](images/CCBIntro_NikhilRAgrawal.pdf)


## Staci Bell
### [presentation (click me)](images/slide_stacibell.pdf)


## Sidney Holden
### [presentation (click me)](images/ccb_intro_slide_Sidney_Holden.pdf)


##  Geoffrey Woollard
### [presentation (click me)](images/ccb_intro_slide_Sidney_Holden.pdf)



# Intro to resources available from SCC to the Cluster

### Speaker: Geraud Krawezik



# Tutorial: Pre-workshop software installation and cluster setup 

### Instructors: Adam and Reza


## Git and github
TODO


## Conda
```bash
mkdir -p ~/miniconda3
# If Linux
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda3/miniconda.sh
# If Mac
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh -O ~/miniconda3/miniconda.sh

bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3
rm -rf ~/miniconda3/miniconda.sh
~/miniconda3/bin/conda init bash
~/miniconda3/bin/conda init zsh
```


# Pre-software installation (_aLENS_)

## Docker 
- Sign up at docker hub [https://hub.docker.com/](https://hub.docker.com/)
- Download docker desktop [https://www.docker.com/products/docker-desktop/](https://www.docker.com/products/docker-desktop/)
- (Optional) Docker engine
   - Linux [https://www.linux.com/topic/desktop/how-install-and-use-docker-linux/](https://www.linux.com/topic/desktop/how-install-and-use-docker-linux/)
   - Mac [https://medium.com/crowdbotics/a-complete-one-by-one-guide-to-install-docker-on-your-mac-os-using-homebrew-e818eb4cfc3](https://medium.com/crowdbotics/a-complete-one-by-one-guide-to-install-docker-on-your-mac-os-using-homebrew-e818eb4cfc3)


## Paraview 
Paraview is
* Download paraview [https://www.paraview.org/download/](https://www.paraview.org/download/)
* Follow instructions


## HDF5view

- Sign up for service [https://www.hdfgroup.org/register/](https://www.hdfgroup.org/register/)
- Download at [https://www.hdfgroup.org/downloads/hdfview/#download](https://www.hdfgroup.org/downloads/hdfview/#download)


## VSCode installation (optional)
*Instructions to get your laptop set up before the session*

- Windows
   - See next slide
- Mac
  - Install xcode: open a terminal and run `xcode-select --install`
  - Install VS Code: https://code.visualstudio.com/docs/setup/mac
- Linux
   - Install VS Code: https://code.visualstudio.com/docs/setup/linux


## Windows Instructions
- Follow the three steps at this link to install WSL, VS Code, and the WSL extension for VS Code: https://code.visualstudio.com/docs/remote/wsl#_installation
- Check if your installation worked: follow these instructions to open VS Code and connect to WSL: https://code.visualstudio.com/docs/remote/wsl#_open-a-remote-folder-or-workspace
- If you see "WSL" in the bottom left of your VS Code window, your installation is working


## Cluster setup
Taken from 


<!-- ### Implicit Fields -->

<!-- <img src="assets/physics_table.png" width="350" style="border:0;box-shadow:none"> -->

<!-- ```csv
#  t,         x,         v_x
   0.00000,   0.00000,   0.15915
   0.33333,   0.86603,  -0.07958
   0.66667,  -0.86603,  -0.07958
   1.00000,  -0.00000,   0.15915
``` -->