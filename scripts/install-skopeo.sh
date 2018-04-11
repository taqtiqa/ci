# sudo apt-get install software-properties-common
# sudo apt-add-repository ppa:projectatomic/ppa 

cat << EOF >> /etc/apt/sources.list
deb http://archive.ubuntu.com/ubuntu/ trusty main restricted universe multiverse  
deb http://archive.ubuntu.com/ubuntu/ trusty-updates main restricted universe multiverse
deb http://archive.ubuntu.com/ubuntu/ trusty-backports main restricted universe multiverse
deb http://security.ubuntu.com/ubuntu trusty-security main restricted universe multiverse  
deb http://archive.canonical.com/ubuntu trusty partner    
deb http://extras.ubuntu.com/ubuntu trusty main   
EOF
apt-key adv --keyserver p80.pool.sks-keyservers.net:80 --recv-keys 6A030B21BA07F4FB
apt-key adv --keyserver p80.pool.sks-keyservers.net:80 --recv-keys 16126D3A3E5C1192
apt-get update
# sudo apt-get install golang 
apt-get install -qq libgpgme11-dev libassuan-dev btrfs-tools libdevmapper-dev
go get github.com/containers/image
git clone https://github.com/projectatomic/skopeo $GOPATH/src/github.com/projectatomic/skopeo
cd $GOPATH/src/github.com/projectatomic/skopeo 
make binary-local
make install