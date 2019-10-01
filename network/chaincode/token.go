package main

import (
	"bytes"
	"crypto/sha256"
	"encoding/hex"
	"encoding/json"
	"fmt"
	"io"
	"strings"
	"time"

	"github.com/hyperledger/fabric/core/chaincode/shim"
	pb "github.com/hyperledger/fabric/protos/peer"
)

// Tokentrans type
type Tokentrans struct {
	Token string `json:"Token"`
	Name  string `json:"Name"`
	ID    string `json:"ID"`
}

func main() {

	err := shim.Start(new(Tokentrans))
	if err != nil {
		fmt.Println("Error with chaincode")
	} else {
		fmt.Println("Chaincode installed successfully")
	}
}

//Init Tokentrans  comment
func (t *Tokentrans) Init(stub shim.ChaincodeStubInterface) pb.Response {
	fmt.Println("Initiate the chaincode")
	return shim.Success(nil)
}

//Invoke Tokentrans  comment
func (t *Tokentrans) Invoke(stub shim.ChaincodeStubInterface) pb.Response {
	fun, args := stub.GetFunctionAndParameters()
	fmt.Println("Arguements ", fun)

	switch fun {
	case "GenerateToken":
		//create a new token
		return t.GenerateToken(stub, args)
	case "TransferToken":
		return t.TransferToken(stub, args)
	case "GetAllToken":
		return t.GetAllToken(stub, args)
	case "QueryName":
		return t.QueryName(stub, args)

	}

	fmt.Println("Function not found!")
	return shim.Error("Recieved unknown function invocation!")
}

//GenToken for
func GenToken(Name string, ID string) string {

	//Generate Token for
	tokenString := fmt.Sprintf("%s%s%s", Name, ID, time.Now().String())
	input := strings.NewReader(tokenString)
	hash := sha256.New()
	if _, err := io.Copy(hash, input); err != nil {
		fmt.Println("Unable to Generate Token in GenerateToken: ", err)
		return string(err.Error())
	}

	return hex.EncodeToString(hash.Sum(nil))
}

//GenerateToken for user
func (t *Tokentrans) GenerateToken(stub shim.ChaincodeStubInterface, args []string) pb.Response {

	var err error
	var tokenobj Tokentrans

	if len(args) < 1 {
		fmt.Println("Invalid number of arguments")
		return shim.Error(err.Error())
	}

	err = json.Unmarshal([]byte(args[0]), &tokenobj)
	//err = json.Unmarshal(&tokenobj)

	if err != nil {
		fmt.Println("Unable to unmarshal data in Generatetoken : ", err)
		return shim.Error(err.Error())
	}
	tokenobj.Token = GenToken(tokenobj.Name, tokenobj.ID)

	JSONBytes1, err4 := json.Marshal(tokenobj)
	if err4 != nil {
		fmt.Println("Unable to Marshal Generatetoken: ", err4)
		return shim.Error(err4.Error())
	}

	err = stub.PutState(tokenobj.Token, JSONBytes1)
	// End - Put into Couch DB
	if err != nil {
		fmt.Println("Unable to make transaction for Generatetoken: ", err)
		return shim.Error(err.Error())
	}

	return shim.Success(nil)
}

//TransferToken token need to give name to transfer and token generated 1- token and sender name
func (t *Tokentrans) TransferToken(stub shim.ChaincodeStubInterface, args []string) pb.Response {

	if len(args) < 2 {
		return shim.Error("Incorrect number of arguments. Expecting 2")
	}
	//var tokenobj Tokentrans

	tokenBytes, _ := stub.GetState(args[0])
	tokenobj := Tokentrans{}
	json.Unmarshal(tokenBytes, &tokenobj)
	tokenobj.Name = args[1]

	tokenBytes, _ = json.Marshal(tokenobj)
	stub.PutState(args[0], tokenBytes)

	return shim.Success(nil)
}

//GetAllToken func
func (t *Tokentrans) GetAllToken(stub shim.ChaincodeStubInterface, args []string) pb.Response {
	var err error

	queryString := fmt.Sprintf("{\"selector\":{\"Token\":{\"$ne\": \"%s\"}}}", "null")
	queryResults, err := getQueryResultForQueryString(stub, queryString)
	//fetch data from couch db ends here
	if err != nil {
		fmt.Printf("Unable to get All Token details: %s\n", err)
		return shim.Error(err.Error())
	}
	fmt.Printf("Token Details : %v\n", queryResults)

	return shim.Success(queryResults)
}

// getQueryResultForQueryString
func getQueryResultForQueryString(stub shim.ChaincodeStubInterface, queryString string) ([]byte, error) {

	fmt.Printf("***getQueryResultForQueryString queryString:\n%s\n", queryString)

	resultsIterator, err := stub.GetQueryResult(queryString)

	if err != nil {
		fmt.Println("Error from getQueryResultForQueryString:  ", err)
		return nil, err
	}
	defer resultsIterator.Close()

	// buffer is a JSON array containing QueryRecords
	var buffer bytes.Buffer
	buffer.WriteString("[")

	bArrayMemberAlreadyWritten := false

	for resultsIterator.HasNext() {
		queryResponse, err := resultsIterator.Next()
		if err != nil {
			return nil, err
		}
		// Add a comma before array members, suppress it for the first array member
		if bArrayMemberAlreadyWritten == true {
			buffer.WriteString(",")
		}
		buffer.WriteString("{\"Key\":")
		buffer.WriteString("\"")
		buffer.WriteString(queryResponse.Key)
		buffer.WriteString("\"")

		buffer.WriteString(", \"Record\":")
		// Record is a JSON object, so we write as-is
		buffer.WriteString(string(queryResponse.Value))
		buffer.WriteString("}")
		bArrayMemberAlreadyWritten = true
	}
	buffer.WriteString("]")

	fmt.Printf("***getQueryResultForQueryString queryResult:\n%s\n", buffer.String())

	return buffer.Bytes(), nil
} // getQueryResultForQueryString

//QueryName comment
func (t *Tokentrans) QueryName(stub shim.ChaincodeStubInterface, args []string) pb.Response {
	var err error

	if len(args) < 1 {
		fmt.Println("Invalid number of arguments")
		return shim.Error(err.Error())
	}
	//fetch data from couch db starts here
	var Name = args[0]
	queryString := fmt.Sprintf("{\"selector\":{\"Name\":{\"$eq\": \"%s\"}}}", Name)
	queryResults, err := getQueryResultForQueryString(stub, queryString)
	//fetch data from couch db ends here
	if err != nil {
		fmt.Printf("Unable to get Node details: %s\n", err)
		return shim.Error(err.Error())
	}
	fmt.Printf("Details for name    : %v\n", queryResults)

	return shim.Success(queryResults)
}
