#!/bin/bash

export FABRIC_CFG_PATH=/etc/hyperledger/fabric


CC_NAME=p2p
VER=1
CHANNEL_NAME=token-transfer-channel

ORDERER_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/tokentransfer.com/orderers/orderer.tokentransfer.com/msp/tlscacerts/tlsca.tokentransfer.com-cert.pem

echo "========== Instantiating chaincode v$VER =========="
peer chaincode instantiate -o orderer.tokentransfer.com:7050  \
                           --tls $CORE_PEER_TLS_ENABLED     \
                           --cafile $ORDERER_CA             \
                           -C $CHANNEL_NAME                 \
                           -n $CC_NAME                      \
                           -c '{"Args": ["Init"]}'          \
                           -v $VER                          \
			               -l golang                        \
                           -P "OR ('iciciMSP.member', 'sbiMSP.member')" 
