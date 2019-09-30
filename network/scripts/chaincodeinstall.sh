#!/bin/bash

export FABRIC_CFG_PATH=/etc/hyperledger/fabric
echo $FABRIC_CFG_PATH

CC_NAME=p2p
VER=1
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

# peer0.icici Installing chaincode in
echo "========== Installing chaincode in peer0.icici.com to channel $CHANNEL_NAME =========="
sleep 20
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/icici.com/users/Admin@icici.com/msp
CORE_PEER_ADDRESS=peer0.icici.com:7051
CORE_PEER_LOCALMSPID=iciciMSP
CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/icici.com/peers/peer0.icici.com/tls/ca.crt
echo "CORE_PEER_ADDRESS=$CORE_PEER_ADDRESS"
peer chaincode install -n $CC_NAME -v $VER -l golang -p github.com/chaincode 

# peer1.icici Installing chaincode in
echo "========== Installing chaincode in peer1.icici.com to channel $CHANNEL_NAME =========="
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/icici.com/users/Admin@icici.com/msp
CORE_PEER_ADDRESS=peer1.icici.com:8051
CORE_PEER_LOCALMSPID=iciciMSP
CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/icici.com/peers/peer1.icici.com/tls/ca.crt
echo "CORE_PEER_ADDRESS=$CORE_PEER_ADDRESS"
peer chaincode install -n $CC_NAME -v $VER -l golang -p github.com/chaincode

# peer0.sbi Installing chaincode in
echo "========== Installing chaincode in peer0.sbi.com to channel $CHANNEL_NAME =========="
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/sbi.com/users/Admin@sbi.com/msp
CORE_PEER_ADDRESS=peer0.sbi.com:7451
CORE_PEER_LOCALMSPID=sbiMSP
CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/sbi.com/peers/peer1.sbi.com/tls/ca.crt
echo "CORE_PEER_ADDRESS=$CORE_PEER_ADDRESS"
peer chaincode install -n $CC_NAME -v $VER -l golang -p github.com/chaincode 

# peer1.sbi Installing chaincode in
echo "========== Installing chaincode in peer1.sbi.com to channel $CHANNEL_NAME =========="
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/sbi.com/users/Admin@sbi.com/msp
CORE_PEER_ADDRESS=peer1.sbi.com:8451
CORE_PEER_LOCALMSPID=sbiMSP
CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/sbi.com/peers/peer1.sbi.com/tls/ca.crt
echo "CORE_PEER_ADDRESS=$CORE_PEER_ADDRESS"
peer chaincode install -n $CC_NAME -v $VER -l golang -p github.com/chaincode 

echo""
echo "==================================== DONE ======================================"
echo""

