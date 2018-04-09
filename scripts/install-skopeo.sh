sudo apt-get install software-properties-common
sudo apt-add-repository ppa:projectatomic/ppa 
sudo apt-get update
# sudo apt-get install skopeo 
git clone https://github.com/projectatomic/skopeo $GOPATH/src/github.com/projectatomic/skopeo
cd $GOPATH/src/github.com/projectatomic/skopeo 
make binary-local
