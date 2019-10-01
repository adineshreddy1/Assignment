peer chaincode invoke -o orderer.tokentransfer.com:7050 --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/tokentransfer.com/orderers/orderer.tokentransfer.com/msp/tlscacerts/tlsca.tokentransfer.com-cert.pem -C "token-transfer-channel" -n p2p -c '{ "Args": ["GenerateToken", "Name", "dinesh", "ID", "1","Company", "SBI" ]}'
Name, ID, Company,  
