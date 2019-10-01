

cd network
./dockerup.sh

cd -
cd app

npm install

rm -rf key-store-icici key-store-sbi

echo "********************************************Enroll admin for icici********************************************"
node enrollicici.js



echo "********************************************Enroll admin for sbi********************************************"
node enrollsbi.js

echo "********************************************register admin for icici********************************************"
node registerUsericici.js

echo "********************************************register admin for sbi********************************************"
node registerUsersbi.js


echo "********************************************Server starting on port:********************************************"
node server.js

cd -