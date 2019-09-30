#!/bin/bash


export IMAGE_TAG=latest
export PATH=${PWD}/../bin:${PWD}:$PATH

echo "************************Generating of Crypto-config certificates***"
./bin/cryptogen generate --config=./crypto-config.yaml

echo "************************Generation of channel-artifacts*************"

mkdir channel-artifacts

./bin/configtxgen -profile TwoOrgsOrdererGenesis -outputBlock ./channel-artifacts/genesis.block 
./bin/configtxgen -profile TwoOrgsChannel -outputCreateChannelTx ./channel-artifacts/channel.tx -channelID token-transfer-channel 
./bin/configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/iciciMSPanchors.tx -channelID  token-transfer-channel -asOrg iciciMSP
./bin/configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/sbiMSPanchors.tx -channelID  token-transfer-channel -asOrg sbiMSP


for Org  in icici sbi ;
do
cp $Org.yaml.tmp $Org.yaml 
done


ARCH=$(uname -s | grep Darwin)
if [ "$ARCH" == "Darwin" ]; then
  OPTS="-it"
  rm -rf *.yamlt
else
  OPTS="-i"
fi


CURRENT_DIR=$PWD
cd crypto-config/peerOrganizations/icici.com/ca/
PRIV_KEY=$(ls *_sk)
cd "$CURRENT_DIR"
sed $OPTS "s/CA_ICICI_KEY/${PRIV_KEY}/g" icici.yaml

CURRENT_DIR=$PWD
cd crypto-config/peerOrganizations/sbi.com/ca/
PRIV_KEY=$(ls *_sk)
cd "$CURRENT_DIR"
sed $OPTS "s/CA_SBI_KEY/${PRIV_KEY}/g" sbi.yaml
