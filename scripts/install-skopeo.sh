# sudo apt-get install software-properties-common
# sudo apt-add-repository ppa:projectatomic/ppa 
# sudo apt-get update
# sudo apt-get install golang 
sudo apt-get install -qq libgpgme-dev libassuan-dev btrfs-tools libdevmapper-dev
 # ostree-devel
go get github.com/containers/image
git clone https://github.com/projectatomic/skopeo $GOPATH/src/github.com/projectatomic/skopeo
cd $GOPATH/src/github.com/projectatomic/skopeo 
make binary-local
sudo make install