# Day 8: Advanced Cluster Usage
- June 14 2023
- 9:00am-12:00pm
- Flatiron 7th floor classroom

## Prerequisites for Mac OS X (for disBatch session)
- git
- `ping -c 1 $(hostname)` should work. If it reports "Unknown host", try:
```bash
sudo bash
cp -p /etc/hosts /etc/hosts.BACK
# Note the double ">>". This will _append_ the new entry to the hosts file. 
echo '127.0.0.1       '$(hostname) >> /etc/hosts
exit
```
- Case sensitive file system
```bash
touch TestingCase testingcase ; ls | grep -i testingcase
```
should list two files. If not, try:
```bash
hdiutil create -type SPARSE -fs 'Case-sensitive Journaled HFS+' -size 100m -volname BPMDay8 ~/BPMDay8image
hdiutil attach ~/BPMDay8image.sparseimage
cd /Volumes/BPMDay8
# Run first example
bash ~/path/to/BPMSS_git_clone/Day8-AdvancedClusterUsage/disBatch_examples/ex1_setup.sh
# ... run more examples ...
```

- [slides](https://lamsoa729.github.io/BPMSummerSchool/Day8-AdvancedClusterUsage/slides.html) ([source](main.md))
