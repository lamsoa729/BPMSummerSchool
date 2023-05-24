# Day 8: Advanced Cluster Usage
- June 14 2023
- 9:00am-12:00pm
- Flatiron 7th floor classroom

## Prerequisites for Mac OS X
- git
- `ping -c 1 $(hostname)` should work (it should not report "Unknown host"). If it does:
```bash
sudo bash
cp -p /etc/hosts /etc/hosts.BACK
echo '127.0.0.1       '$(hostname) >> /etc/hosts
exit
```
- Case sensitive file system.
```bash
touch TestingCase testingcase ; ls | grep -i testingcase
```
should list two files. If not, follow this [guidance](https://coderwall.com/p/mgi8ja/case-sensitive-git-in-mac-os-x-like-a-pro)

- [slides](https://lamsoa729.github.io/BPMSummerSchool/Day8-AdvancedClusterUsage/slides.html) ([source](main.md))
