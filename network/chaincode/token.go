package main

import (
	"fmt"
	"github.com/hyperledger/fabric/core/chaincode/shim"
	pb "github.com/hyperledger/fabric/protos/peer"
)

// Tokentrans type
type Tokentrans struct {
	Name  string `json:"Name"`
	Token string `json:"Token"`
}

func main() {

	err := shim.Start(new(Token))
	if err != nil {
		fmt.Println("Error with chaincode")
	} else {
		fmt.Println("Chaincode installed successfully")
	}
}
//Init Tokentrans  comment
func (t *Tokentrans) Init(stub shim.ChaincodeStubInterface) pb.Response {
	fun, args := stub.GetFunctionAndParameters()
fmt.Println("Arguements ", func)
switch fun {
case "InitMarble":
	//create a new token
	return t.initMarble(stub, args)
case "TransferToken":
	//change owner of a specific marble
	return t.transferToken(stub, args)
case "queryName":
	//find marbles based on an ad hoc rich query
	return t.queryName(stub, args)
}
