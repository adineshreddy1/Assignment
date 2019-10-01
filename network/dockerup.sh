export IMAGE_TAG=latest

echo "Bringing up the docker containers"
docker-compose -f icici.yaml -f sbi.yaml -f common.yaml up -d
echo "channel setup "
docker exec cli ./scripts/channel-setup.sh
echo "installing chaincode"
docker exec cli ./scripts/chaincodeinstall.sh
echo "instantiante chaincode"
docker exec cli ./scripts/instantiate-chaincode.sh

