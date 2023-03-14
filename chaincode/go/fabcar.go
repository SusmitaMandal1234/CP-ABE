/*
SPDX-License-Identifier: Apache-2.0
*/

package main

import (
	"encoding/json"
	"fmt"
	//"net/http"

	//"log"
	"bytes"
	"encoding/gob"
	"encoding/hex"
	//"io"

	//"github.com/valyala/fastjson"

	//"encoding/json"
	//"fmt"
	"log"
	"strconv"

	"github.com/hyperledger/fabric-chaincode-go/shim"

	"github.com/hyperledger/fabric-contract-api-go/contractapi"
)

// SmartContract provides functions for managing a car
type SmartContract struct {
	contractapi.Contract
}

const assetCollection = "assetCollection"
const transferAgreementObjectType = "transferAgreement"

// SmartContract of this fabric sample

// Asset describes main asset details that are visible to all organizations
type Asset struct {
	Type  string `json:"objectType"` //Type is used to distinguish the various types of objects in state database
	ID    string `json:"assetID"`
	Color string `json:"color"`
	Size  int    `json:"size"`
	Owner string `json:"owner"`
}

// AssetPrivateDetails describes details that are private to owners
type AssetPrivateDetails struct {
	ID             string `json:"assetID"`
	AppraisedValue int    `json:"appraisedValue"`
}

// TransferAgreement describes the buyer agreement returned by ReadTransferAgreement
type TransferAgreement struct {
	ID      string `json:"assetID"`
	BuyerID string `json:"buyerID"`
}

type Message struct {
	Name  string `json:"Name"`
	Value string `json:"Value"`
	Nonce string `json:"Nonce"`
}

type Transaction struct {
	PatientNumber         string `json:"PatientNumber"`
	Name                  string `json:"Name"`
	Age                   string `json:"Age"`
	Doctor_Specialization string `json:"Doctor_Specialization"`
	Disease               string `json:"Disease"`
	Email                 string `json:"Email"`
	Adhar                 string `json:"Adhar"`
	Organization          string `json:"Organization"`
}

//"Address":"sdhfjsh","Adhar_Number":"sdhfjhsf","Company_Annual_Income":"sdfgshfg","Company_Register_Number":"sdfghsfg","Email":"sdfhjsdfhfsd","Name":"Chinnu","PAN_Number":"sdfhjsdfh","Password":"sdfhjsdfhjsdf","Tender_Amount":"31000"

type ETender struct {
	Address                 string `json:"Address"`
	Adhar_Number            string `json:"Adhar_Number"`
	Company_Annual_Income   string `json:"Company_Annual_Income"`
	Company_Register_Number string `json:"Company_Register_Number"`
	Email                   string `json:"Email"`
	Name                    string `json:"Name"`
	PAN_Number              string `json:"PAN_Number"`
	Password                string `json:"Password"`
	Tender_Amount           int    `json:"Tender_Amount"`
}

// Car describes basic details of what makes up a car
type Car struct {
	Make   string `json:"make"`
	Model  string `json:"model"`
	Colour string `json:"colour"`
	Owner  string `json:"owner"`
}

// QueryResult structure used for handling result of query
type QueryResult struct {
	Key    string `json:"Key"`
	Record *Car
}

// InitLedger adds a base set of cars to the ledger
func (s *SmartContract) InitLedger(ctx contractapi.TransactionContextInterface) error {
	cars := []Car{
		Car{Make: "Toyota", Model: "Prius", Colour: "blue", Owner: "Tomoko"},
		Car{Make: "Ford", Model: "Mustang", Colour: "red", Owner: "Brad"},
		Car{Make: "Hyundai", Model: "Tucson", Colour: "green", Owner: "Jin Soo"},
		Car{Make: "Volkswagen", Model: "Passat", Colour: "yellow", Owner: "Max"},
		Car{Make: "Tesla", Model: "S", Colour: "black", Owner: "Adriana"},
		Car{Make: "Peugeot", Model: "205", Colour: "purple", Owner: "Michel"},
		Car{Make: "Chery", Model: "S22L", Colour: "white", Owner: "Aarav"},
		Car{Make: "Fiat", Model: "Punto", Colour: "violet", Owner: "Pari"},
		Car{Make: "Tata", Model: "Nano", Colour: "indigo", Owner: "Valeria"},
		Car{Make: "Holden", Model: "Barina", Colour: "brown", Owner: "Shotaro"},
	}

	for i, car := range cars {
		carAsBytes, _ := json.Marshal(car)
		err := ctx.GetStub().PutState("CAR"+strconv.Itoa(i), carAsBytes)

		if err != nil {
			return fmt.Errorf("failed to put to world state. %s", err.Error())
		}
		payloadAsBytes := carAsBytes
		err = ctx.GetStub().SetEvent("InitLedger", payloadAsBytes)
		if err != nil {
			return fmt.Errorf("failed to add event for CAR" + strconv.Itoa(i))
		}
	}

	return nil
}

func (s *SmartContract) CreateAsset(ctx contractapi.TransactionContextInterface, make string, model string, owner string, color string, carNumber string) error {
	carAsBytes, _ := json.Marshal(Car{Make: make, Model: model, Colour: color, Owner: owner})
	err := ctx.GetStub().PutState(carNumber, carAsBytes)

	if err != nil {
		return fmt.Errorf("failed to put to world state. %s", err.Error())
	}
	return nil
}

// For Old Cp-ABE(But with Message struct added)
// CreateCar adds a new car to the world state with given details
func (s *SmartContract) CreateCar(ctx contractapi.TransactionContextInterface, Msg string, Policy string) error {
	var Message1 Message
	err := json.Unmarshal([]byte(Msg), &Message1)
	if err != nil {
		fmt.Println("Error", err)
	}

	var decoded1 Transaction
	bytes1, _ := hex.DecodeString(string(Message1.Value))
	fmt.Println("bytes", bytes1)
	dec1 := gob.NewDecoder(bytes.NewBuffer(bytes1))
	err = dec1.Decode(&decoded1)
	if err != nil {
		log.Fatal("decode error:", err.Error())
	}

	fmt.Println("tranx", decoded1)
	car := Car{
		Make:   decoded1.PatientNumber,
		Model:  decoded1.Email,
		Colour: decoded1.Adhar,
		Owner:  decoded1.Disease,
	}

	carAsBytes, _ := json.Marshal(car)
	fmt.Println(decoded1.PatientNumber)
	return ctx.GetStub().PutState(decoded1.PatientNumber, carAsBytes)
}

// for Old CP-ABE
func (s *SmartContract) CreateRecord(ctx contractapi.TransactionContextInterface, Msg string, Policy string) error {
	var Message1 map[string]string
	err := json.Unmarshal([]byte(Msg), &Message1)
	if err != nil {
		fmt.Println("Error", err)
	}

	var decoded1 map[string]string
	bytes1, _ := hex.DecodeString(string(Message1["Value"]))
	fmt.Println("bytes", bytes1)
	dec1 := gob.NewDecoder(bytes.NewBuffer(bytes1))
	err = dec1.Decode(&decoded1)
	if err != nil {
		log.Fatal("decode error:", err.Error())
	}

	fmt.Println("tranx", decoded1)

	carAsBytes, _ := json.Marshal(decoded1)
	fmt.Println("Record Data", decoded1)
	fmt.Println(decoded1["Email"])

	return ctx.GetStub().PutState(decoded1["key"], carAsBytes)
}

func (s *SmartContract) MultiChaincodeTest(ctx contractapi.TransactionContextInterface) string {
	return "Org2 Smart Contract invoked"
}

// QueryCar returns the car stored in the world state with given id
func (s *SmartContract) QueryCar(ctx contractapi.TransactionContextInterface, carNumber string) (*Car, error) {
	carAsBytes, err := ctx.GetStub().GetState(carNumber)

	if err != nil {
		return nil, fmt.Errorf("Failed to read from world state. %s", err.Error())
	}

	if carAsBytes == nil {
		return nil, fmt.Errorf("%s does not exist", carNumber)
	}

	car := new(Car)
	_ = json.Unmarshal(carAsBytes, car)

	//extra malicious code added
	car.Owner = "Pranay"
	carAsBytes, _ = json.Marshal(car)

	ctx.GetStub().PutState(carNumber, carAsBytes)
	return car, nil
}

// QueryAllCars returns all cars found in world state
func (s *SmartContract) QueryAllCars(ctx contractapi.TransactionContextInterface) ([]QueryResult, error) {
	startKey := ""
	endKey := ""

	resultsIterator, err := ctx.GetStub().GetStateByRange(startKey, endKey)

	if err != nil {
		return nil, err
	}
	defer resultsIterator.Close()

	results := []QueryResult{}

	for resultsIterator.HasNext() {
		queryResponse, err := resultsIterator.Next()

		if err != nil {
			return nil, err
		}

		car := new(Car)
		_ = json.Unmarshal(queryResponse.Value, car)

		queryResult := QueryResult{Key: queryResponse.Key, Record: car}
		results = append(results, queryResult)
	}

	return results, nil
}

// ChangeCarOwner updates the owner field of car with given id in world state
func (s *SmartContract) ChangeCarOwner(ctx contractapi.TransactionContextInterface, carNumber string, newOwner string) error {
	car, err := s.QueryCar(ctx, carNumber)

	if err != nil {
		return err
	}

	car.Owner = newOwner

	carAsBytes, _ := json.Marshal(car)

	return ctx.GetStub().PutState(carNumber, carAsBytes)
}

// func (s *SmartContract) UpdateStateValidationParameter(ctx contractapi.TransactionContextInterface, carNumber string) error {
// 	// err := ctx.GetStub().SetStateValidationParameter(carNumber, []byte("OutOf(1,'Org1MSP.peer','Org2MSP.peer','Org3MSP.peer')"))
// 	// fmt.Println("Error from state validation is", err)
// 	// result, err2 := ctx.GetStub().GetStateValidationParameter(carNumber)
// 	// fmt.Println("Result from state validation is ", result, "Error from state validation is", err2)

// 	err := setAssetStateBasedEndorsement(ctx, carNumber, "Org1MSP")
// 	if err != nil {
// 		return fmt.Errorf("failed setting state based endorsement for owner: %v", err)
// 	}
// 	return nil
// }

// func setAssetStateBasedEndorsement(ctx contractapi.TransactionContextInterface, assetID string, orgToEndorse string) error {
// 	endorsementPolicy, err := statebased.NewStateEP(nil)
// 	if err != nil {
// 		return err
// 	}
// 	err = endorsementPolicy.AddOrgs(statebased.RoleTypePeer, orgToEndorse)
// 	if err != nil {
// 		return fmt.Errorf("failed to add org to endorsement policy: %v", err)
// 	}
// 	policy, err := endorsementPolicy.Policy()
// 	if err != nil {
// 		return fmt.Errorf("failed to create endorsement policy bytes from org: %v", err)
// 	}
// 	err = ctx.GetStub().SetStateValidationParameter(assetID, policy)
// 	if err != nil {
// 		return fmt.Errorf("failed to set validation parameter on asset: %v", err)
// 	}

// 	return nil
// }

// ReadAsset reads the information from collection
func (s *SmartContract) ReadAsset(ctx contractapi.TransactionContextInterface, assetID string) (*Asset, error) {

	log.Printf("ReadAsset: collection %v, ID %v", assetCollection, assetID)
	assetJSON, err := ctx.GetStub().GetPrivateData(assetCollection, assetID) //get the asset from chaincode state
	if err != nil {
		return nil, fmt.Errorf("failed to read asset: %v", err)
	}

	//No Asset found, return empty response
	if assetJSON == nil {
		log.Printf("%v does not exist in collection %v", assetID, assetCollection)
		return nil, nil
	}

	var asset *Asset
	err = json.Unmarshal(assetJSON, &asset)
	if err != nil {
		return nil, fmt.Errorf("failed to unmarshal JSON: %v", err)
	}
	return asset, nil
}

func (s *SmartContract) ReadAssetByRange(ctx contractapi.TransactionContextInterface) ([]string, error) {
	keysIter, err := ctx.GetStub().GetStateByRange("", "")
	if err != nil {
		return nil, fmt.Errorf(fmt.Sprintf("keys operation failed. Error accessing state: %s", err))
	}
	defer keysIter.Close()
	var keys []string

	for keysIter.HasNext() {
		key, iterErr := keysIter.Next()
		if iterErr != nil {
			return nil, fmt.Errorf(fmt.Sprintf("keys operation failed. Error accessing state: %s", err))
		}
		keys = append(keys, key.Key)
	}

	return keys, nil
}

func (s *SmartContract) ReadAssetByQuery(ctx contractapi.TransactionContextInterface, query string) (string, error) {
	//queryString := fmt.Sprintf("{\"selector\":{\"docType\":\"marble\",\"owner\":\"%s\"}}", owner)
	//queryString := "{\"selector\":{\"docType\":{\"$eq\":\"car\"}},\"fields\":[\"docType\",\"price\"],\"sort\":[{\"price\":\"desc\"}"
	//queryString := "{\"selector\":{\"_id\": {\"$gt\": null}},\"sort\":[{\"price\": \"desc\"}],\"use_index\":[\"_design/indexPriceDoc\",\"indexPrice\"]}"
	queryString := query
	fmt.Println(1)
	queryResults, err := getQueryResultForQueryString(ctx.GetStub(), queryString)
	if err != nil {
		return "", err
	}
	return string(queryResults), nil
}

func getQueryResultForQueryString(stub shim.ChaincodeStubInterface, queryString string) ([]byte, error) {

	fmt.Printf("- getQueryResultForQueryString queryString:\n%s\n", queryString)

	resultsIterator, err := stub.GetQueryResult(queryString)
	if err != nil {
		return nil, err
	}
	defer resultsIterator.Close()

	buffer, err := constructQueryResponseFromIterator(resultsIterator)
	if err != nil {
		return nil, err
	}

	fmt.Printf("- getQueryResultForQueryString queryResult:\n%s\n", buffer.String())

	return buffer.Bytes(), nil
}

func constructQueryResponseFromIterator(resultsIterator shim.StateQueryIteratorInterface) (*bytes.Buffer, error) {
	// buffer is a JSON array containing QueryResults
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

	return &buffer, nil
}

func main() {
	chaincode, err := contractapi.NewChaincode(new(SmartContract))

	if err != nil {
		fmt.Printf("Error create fabcar chaincode: %s", err.Error())
		return
	}

	if err := chaincode.Start(); err != nil {
		fmt.Printf("Error starting fabcar chaincode: %s", err.Error())
	}
}
