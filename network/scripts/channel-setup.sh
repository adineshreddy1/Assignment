#!/bin/bash

export FABRIC_CFG_PATH=/etc/hyperledger/fabric
echo $FABRIC_CFG_PATH

CHANNEL_NAME=token-transfer-channel
DELAY=5
COUNTER=1
MAX_RETRY=20

ORDERER_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/tokentransfer.com/orderers/orderer.tokentransfer.com/msp/tlscacerts/tlsca.tokentransfer.com-cert.pem

verifyResult() {
  if [ $1 -ne 0 ]; then
    echo "!!!!!!!!!!!!!!! "$2" !!!!!!!!!!!!!!!!"
    echo "========= ERROR !!! FAILED to execute current Scenario ==========="
    echo
    exit 1
  fi
}

joinChannelWithRetry() {
  PEER=$1
  ORG=$2
  source .config.core.txt

  set -x
  peer channel join -b $CHANNEL_NAME.block >&log.txt
  res=$?
  set +x
  cat log.txt
  if [ $res -ne 0 -a $COUNTER -lt $MAX_RETRY ]; then
    COUNTER=$(expr $COUNTER + 1)
    echo "${PEER}.${ORG}.com failed to join the channel, Retry after $DELAY seconds"
    sleep $DELAY
    joinChannelWithRetry $PEER $ORG
  else
    COUNTER=1
  fi
  verifyResult $res "After $MAX_RETRY attempts, ${PEER}.${ORG}.com has failed to join channel '$CHANNEL_NAME' "
}

# Channel creation
echo "========== Creating channel: "$CHANNEL_NAME" =========="
#sleep 20
peer channel create -o orderer.tokentransfer.com:7050 -c $CHANNEL_NAME -f ./channel-artifacts/channel.tx --tls --cafile $ORDERER_CA

# peer0.icici channel join
echo "========== Joining peer0.icici.com to channel $CHANNEL_NAME =========="
sleep 20
echo "export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/icici.com/users/Admin@icici.com/msp" > .config.core.txt
echo "export CORE_PEER_ADDRESS=peer0.icici.com:7051" >> .config.core.txt
echo "export CORE_PEER_LOCALMSPID=iciciMSP" >> .config.core.txt
echo "export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/icici.com/peers/peer0.icici.com/tls/ca.crt" >> .config.core.txt
joinChannelWithRetry "peer0" "icici" 
peer channel update -o orderer.tokentransfer.com:7050 -c $CHANNEL_NAME -f ./channel-artifacts/${CORE_PEER_LOCALMSPID}anchors.tx --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA

# peer1.icici channel join
echo "========== Joining peer1.icici.com to channel $CHANNEL_NAME =========="
echo "export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/icici.com/users/Admin@icici.com/msp" > .config.core.txt
echo "export CORE_PEER_ADDRESS=peer1.icici.com:8051" >> .config.core.txt
echo "export CORE_PEER_LOCALMSPID=iciciMSP" >> .config.core.txt
echo "export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/icici.com/peers/peer1.icici.com/tls/ca.crt" >> .config.core.txt
joinChannelWithRetry "peer1" "icici"

# peer0.sbi channel join
echo "========== Joining peer0.sbi.com to channel $CHANNEL_NAME =========="
echo "export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/sbi.com/users/Admin@sbi.com/msp" > .config.core.txt
echo "export CORE_PEER_ADDRESS=peer0.sbi.com:7451" >> .config.core.txt
echo "export CORE_PEER_LOCALMSPID=sbiMSP" >> .config.core.txt
echo "export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/sbi.com/peers/peer1.sbi.com/tls/ca.crt" >> .config.core.txt
joinChannelWithRetry "peer0" "sbi"
peer channel update -o orderer.tokentransfer.com:7050 -c $CHANNEL_NAME -f ./channel-artifacts/${CORE_PEER_LOCALMSPID}anchors.tx --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA

# peer1.sbi channel join
echo "========== Joining peer1.sbi.com to channel $CHANNEL_NAME =========="
echo "export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/sbi.com/users/Admin@sbi.com/msp" > .config.core.txt
echo "export CORE_PEER_ADDRESS=peer1.sbi.com:8451" >> .config.core.txt
echo "export CORE_PEER_LOCALMSPID=sbiMSP" >> .config.core.txt
echo "export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/sbi.com/peers/peer1.sbi.com/tls/ca.crt" >> .config.core.txt
joinChannelWithRetry "peer1" "sbi"

