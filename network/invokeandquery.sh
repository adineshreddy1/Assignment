
//working invoke

//open and try this commnds in cli

//docker exec -it cli bash

peer chaincode invoke -o orderer.tokentransfer.com:7050  --tls --cafile  /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/tokentransfer.com/orderers/orderer.tokentransfer.com/msp/tlscacerts/tlsca.tokentransfer.com-cert.pem  -C "token-transfer-channel" -n p2p -c '{"Args":["GenerateToken","{\"Name\":\"Keerthana\",\"ID\":\"1\"}"]}'
//working invoke
peer chaincode invoke -o orderer.tokentransfer.com:7050  --tls --cafile  /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/tokentransfer.com/orderers/orderer.tokentransfer.com/msp/tlscacerts/tlsca.tokentransfer.com-cert.pem  -C "token-transfer-channel" -n p2p -c '{"Args":["GenerateToken","{\"Name\":\"Dinesh\",\"ID\":\"2\"}"]}'

//working query for query all tokens
peer chaincode query -o orderer.tokentransfer.com:7050  --tls --cafile  /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/tokentransfer.com/orderers/orderer.tokentransfer.com/msp/tlscacerts/tlsca.tokentransfer.com-cert.pem  -C "token-transfer-channel" -n p2p -c '{"Args":["GetAllToken"]}'


//transfering token we need to provide token  and sender Name

peer chaincode invoke -o orderer.tokentransfer.com:7050  --tls --cafile  /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/tokentransfer.com/orderers/orderer.tokentransfer.com/msp/tlscacerts/tlsca.tokentransfer.com-cert.pem  -C "token-transfer-channel" -n p2p -c '{"Args":["TransferToken","148726d209d7bbf2ad5019f6ea79469969f1c30ccd8df2437beca7d352fbde62","Dinesh"]}'
//query by name 
peer chaincode invoke -o orderer.tokentransfer.com:7050  --tls --cafile  /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/tokentransfer.com/orderers/orderer.tokentransfer.com/msp/tlscacerts/tlsca.tokentransfer.com-cert.pem  -C "token-transfer-channel" -n p2p -c '{"Args":["QueryName","Keerthana"]}'

