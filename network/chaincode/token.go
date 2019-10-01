package main

import (
	"fmt"
	"github.com/hyperledger/fabric/core/chaincode/shim"
	pb "github.com/hyperledger/fabric/protos/peer"
)

// Tokentrans type
type Tokentrans struct {
	Name  string `json:"Name"`
	Id string `json:"Id"`
	Company string `json:"Company"`
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

func GenerateToken(Name string, Id string, Company string) string {
	
	//Generate Token for shared License
	tokenString := fmt.Sprintf("%s%s%d%s", Name, Id, Company, time.Now().String())
	input := strings.NewReader(tokenString)
	hash := sha256.New()
	if _, err := io.Copy(hash, input); err != nil {
		fmt.Println("Unable to Generate Token in GenerateToken: ", err)
		return string(err.Error())
	}

	return hex.EncodeToString(hash.Sum(nil))
}

//Init Tokentrans  comment
func (t *Tokentrans) Init(stub shim.ChaincodeStubInterface) pb.Response {
	fun, args := stub.GetFunctionAndParameters()
fmt.Println("Arguements ", func)

switch fun {
case "GenerateToken":
	//create a new token
	return t.GenerateToken(stub, args)
case "TransferToken":
	//change owner of a specific marble
	return t.TransferToken(stub, args)
case "queryName":
	//find marbles based on an ad hoc rich query
	return t.queryName(stub, args)

	}
}
