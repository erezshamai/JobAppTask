
wsl -d Ubuntu
wsl --list --verbose
./extract.sh -v ErezShamaiZip.zip
wsl -d Ubuntu --user root
su erez

pollSCMTest2


prerequisite using extract.sh :
- make sure all needed linux application/packs are unstalled (like zip/unzip)
- JobAppTaskJenkins  gitHub personal access token created