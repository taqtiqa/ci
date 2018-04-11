# apt-get install ...
git clone git://github.com/appc/docker2aci
cd docker2aci
./build.sh
mkdir -p ${HOME}/.local/bin
cp ./bin/docker2aci ${HOME}/.local/bin/docker2aci
chmod +x ${HOME}/.local/bin/docker2aci
