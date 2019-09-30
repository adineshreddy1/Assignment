./bin/cryptogen generate --config=./crypto-config.yaml



mkdir channel-artifacts

./bin/configtxgen -profile TwoOrgsOrdererGenesis -outputBlock ./channel-artifacts/genesis.block 
./bin/configtxgen -profile TwoOrgsChannel -outputCreateChannelTx ./channel-artifacts/channel.tx -channelID token-transfer-channel 
./bin/configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/iciciMSPanchors.tx -channelID  token-transfer-channel -asOrg iciciMSP
./bin/configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/sbiMSPanchors.tx -channelID  token-transfer-channel -asOrg sbiMSP
