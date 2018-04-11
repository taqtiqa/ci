# sudo apt-get install software-properties-common
# sudo apt-add-repository ppa:projectatomic/ppa 

apt-key adv --keyserver p80.pool.sks-keyservers.net:80 --recv-keys 6A030B21BA07F4FB
apt-key adv --keyserver p80.pool.sks-keyservers.net:80 --recv-keys 16126D3A3E5C1192
apt-get update
apt-get install -qq go-md2man libgtk2.0-dev libglib2.0-dev libgpgme11-dev libassuan-dev btrfs-tools libdevmapper-dev
go get github.com/containers/image
git clone https://github.com/projectatomic/skopeo $GOPATH/src/github.com/projectatomic/skopeo
cd $GOPATH/src/github.com/projectatomic/skopeo 

make binary-local BUILDTAGS=containers_image_ostree_stub
make install