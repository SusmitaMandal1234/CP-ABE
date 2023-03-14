/*
SPDX-License-Identifier: Apache-2.0
*/

package main

import (
	"bytes"
	"context"
	"crypto/elliptic"
	"crypto/sha256"
	"encoding/gob"
	"encoding/hex"
	"encoding/json"
	"errors"
	"fmt"
	"io/ioutil"
	"log"
	"math/big"
	"os"
	"path/filepath"
	"plugin"
	"strconv"

	"github.com/pranaychawhan2015/cp_abe"

	"github.com/joho/godotenv"
	kafka "github.com/segmentio/kafka-go"

	"github.com/hyperledger/fabric-contract-api-go/contractapi"
)

// SmartContract provides functions for managing a car
type SmartContract struct {
	contractapi.Contract
}

func goDotEnvVariable(key string) string {

	// load .env file
	err := godotenv.Load(".env")

	if err != nil {
		log.Fatalf("Error loading .env file")
	}

	return os.Getenv(key)
}

var envMap map[string]string
var plug *plugin.Plugin

// var topic string
// var brokerAddress string
// var peer_id string
// var group_id string

var (
	ctx1 = context.Background()
	//consume(ctx)
	//return
	l = log.New(os.Stdout, "kafka reader: ", 2)

	// pwd, _        = os.Getwd()
	// envData, err  = ioutil.ReadFile(pwd + "environment.json")
	// _             = json.Unmarshal([]byte(string(envData)), &envMap)
	// _, _          = fmt.Println("envMap", envMap, "err", err, "pwd", pwd)
	// topic         = envMap["TOPIC"]
	// brokerAddress = envMap["BROKER_ADDRESS"]
	// peer_id       = envMap["PEER_ID"]
	// group_id      = envMap["GROUP_ID"]

	topic, brokerAddress, peer_id, group_id = GetConfigurationConstants()
	//initialize a new reader with the brokers and topic
	//the groupID identifies the consumer and prevents
	//it from receiving duplicate messages
	r = kafka.NewReader(kafka.ReaderConfig{
		Brokers: []string{brokerAddress},
		Topic:   topic,
		GroupID: group_id,
		// assign the logger to the reader
		Logger: l,
	})
)

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
			return fmt.Errorf("Failed to put to world state. %s", err.Error())
		}
	}

	return nil
}

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

type Handler interface {
	Decrypt([]byte, string) ([]byte, error)
}

func (s *SmartContract) GetPath(path string) string {
	jsonBytes, err := ioutil.ReadFile(path)
	if err != nil {
		return "Error from getpath" + err.Error()
	}
	var jsonMap map[string]string
	json.Unmarshal(jsonBytes, &jsonMap)
	return jsonMap["key"]
}

func (s *SmartContract) DecryptMessage(ctx contractapi.TransactionContextInterface, transactionID string) error {
	fmt.Println("Stmt1")
	r.SetOffset(-1)
	msg, err := r.ReadMessage(ctx1)
	fmt.Println("Read msg Stmt3")
	if err != nil {
		panic("could not read message " + err.Error())
	}
	fmt.Println("received: ", msg.Value)
	fmt.Println("received key: ", msg.Key)
	//path, err := os.Getwd()
	// fmt.Println("Current Directory", path, "error from path", err)
	// plug, err := plugin.Open("/etc/hyperledger/fabric/plugin/plugin.so")
	// fmt.Println("err from plugin", err, "plug", plug)
	// if plug == nil {
	// 	plug, err = plugin.Open("/etc/hyperledger/fabric/plugin/plugin.so")
	// 	fmt.Println("err from plugin", err, "plug", plug)
	// }
	// files, err := ioutil.ReadDir("/etc/hyperledger/fabric/plugin")
	// if err != nil {
	// 	log.Fatal(err)
	// }
	// if len(files) == 0 {
	// 	fmt.Println("No files for path1", path)
	// }
	// for _, file := range files {
	// 	fmt.Printf("name: %s\n", file)
	// }
	// handlerSymbol, _ := plug.Lookup("Handler")

	//var handler Handler
	//binary.Read(bytes.NewBuffer(msg.Key[:]), binary.LittleEndian, &handler)
	// handler, _ = handlerSymbol.(Handler)
	// fmt.Println("Handler is ", handler)

	//transactionData, _ := handler.Decrypt(msg.Value, peer_id)
	transactionData, _ := cp_abe.Decrypt(msg.Value, peer_id)
	if transactionData != nil {
		fmt.Println("success encryption and decryption")
		result := ctx.GetStub().PutState(transactionID, transactionData)
		fmt.Println("Result from putting state", result)
		return nil
	}
	return errors.New("not able to decrypt")
}

func (s *SmartContract) DecryptMessageOld(ctx contractapi.TransactionContextInterface, transactionID string) error {
	fmt.Println("Stmt1")
	s1 := []byte(strconv.Itoa(5))

	x3, y4 := elliptic.P256().ScalarBaseMult(s1)
	fmt.Println("Stmt2")
	SGProduct := elliptic.Marshal(elliptic.P256(), x3, y4)

	G_value := new(big.Int)

	G_value.SetBytes(SGProduct)

	//r.SetOffset(-1)
	//for {
	// the `ReadMessage` method blocks until we receive the next event
	msg, err := r.ReadMessage(ctx1)
	fmt.Println("Read msg Stmt3")
	if err != nil {
		panic("could not read message " + err.Error())
	}
	// after receiving the message, log its value
	fmt.Println("received: ", msg.Value)

	if string(msg.Value) == "Invalid Message" {
		fmt.Println("Not able to decrypt")
		return errors.New("not able to decrypt")
		//break
	} else {
		DecryptionInput := make(map[string][]byte)

		json.Unmarshal(msg.Value, &DecryptionInput)
		fmt.Println("Successful value", DecryptionInput)

		//map[string]*big.Int
		CTjArray := make(map[string]*big.Int)
		json.Unmarshal(DecryptionInput["CT_value"], &CTjArray)

		//big int
		C0 := big.NewInt(0)
		json.Unmarshal(DecryptionInput["hash_value"], &C0)
		fmt.Println("Stmt4 ")

		PS := big.NewInt(0)
		json.Unmarshal(DecryptionInput["PS"], &PS)

		DK := make(map[string]*big.Int)
		json.Unmarshal(DecryptionInput["DK_value"], &DK)

		DM := make(map[string]*big.Int)
		fmt.Println("Stmt5 ")
		fmt.Println("PS ", PS)
		fmt.Println("Stmt6 ")
		for i, x := range DK {
			new5 := new(big.Int)

			new5 = new5.Mul(x, PS)

			DM[i] = new5
		}
		fmt.Println("Stmt7 ")
		Sum_CTJ_DM := make(map[string]*big.Int)
		for i, _ := range DM {
			new6 := new(big.Int)
			new6 = new6.Add(CTjArray[i], DM[i])
			Sum_CTJ_DM[i] = new6
		}
		fmt.Println("Stmt8 ")
		fmt.Println(Sum_CTJ_DM)
		occurred3 := map[string]struct{}{}
		occurred2 := make(map[*big.Int]string)
		fmt.Println("Stmt9 ")
		Checking_data := make(map[string]string)
		occurred6 := make([]*big.Int, 0)
		occurred1 := make([]*big.Int, 0)
		fmt.Println("Stmt10 ")
		total := new(big.Int)
		for i, j := range Sum_CTJ_DM {
			// fmt.Println(i, j)
			k := big.NewInt(0)
			k = k.Add(k, j)
			occurred3[j.String()] = struct{}{}
			Checking_data[j.String()] = i
			occurred2[j] = i
			occurred1 = append(occurred1, j)
			total = total.Add(total, k)
		}
		fmt.Println("Stmt11 ")
		fmt.Println("this is total data", total)
		//fmt.Println("this is vector data", vectorArray)
		for _, i2 := range Checking_data {
			i3, t := Sum_CTJ_DM[i2]
			if t {
				occurred6 = append(occurred6, i3)
			}
		}
		new2 := new(big.Int)
		new4 := new(big.Int)
		new9 := new(big.Int)
		for _, k := range occurred6 {
			new3 := k.Sign()
			fmt.Println(new3)
			if new3 < 0 {
				new2 = new2.Add(new2, k)
			} else {
				new4 = new4.Add(new4, k)
			}

			new9 = new9.Add(new4, new2)
		}
		fmt.Println("Stmt12 ")
		secrete_value := new(big.Int)

		secrete_value = secrete_value.Div(new9, G_value)

		fmt.Println(secrete_value)
		//msg decryption
		s5 := secrete_value.String()
		s4 := []byte(s5)
		x5, y6 := elliptic.P256().ScalarBaseMult(s4)
		SGProduct5 := elliptic.Marshal(elliptic.P256(), x5, y6)
		hash2 := sha256.New()

		hash2.Write(SGProduct5)

		hashstr2 := hex.EncodeToString(hash2.Sum(nil))

		hashInValue2, _ := new(big.Int).SetString(hashstr2, 16)

		C02 := C0

		new7 := new(big.Int)

		new7 = new7.Xor(hashInValue2, C02)

		msg2 := new7.Bytes()

		myString := string(msg2[:])

		//fmt.Println("success encryption and decryption")
		fmt.Println("this is decryption data::", string(myString))
		transactionData, _ := json.Marshal(string(myString))
		result := ctx.GetStub().PutState(transactionID, transactionData)
		fmt.Println("Result from putting state", result)

		return nil
		//break
	}

}

func main() {

	path, err := os.Getwd()
	fmt.Println("Current Directory", path, "error from path", err)
	plug, err := plugin.Open(path + "src/plugin.so")
	fmt.Println("err from plugin", err, "plug", plug)
	plug, err = plugin.Open("opt/gopath/src/github.com/hyperledger/fabric/plugin.so")
	fmt.Println("err from plugin", err, "plug", plug)
	err = filepath.Walk("/", func(path string, info os.FileInfo, err error) error {
		if err != nil {
			fmt.Println(err)
			return err
		}
		fmt.Printf("dir: %v: name: %s\n", info.IsDir(), path)

		if info.IsDir() {
			files, err := ioutil.ReadDir(path)
			if err != nil {
				log.Fatal(err)
			}
			if len(files) == 0 {
				fmt.Println("No files for path1", path)
			}
			for _, file := range files {
				fmt.Printf("dir: %v: name: %s\n", info.IsDir(), file)
			}
		}
		return nil
	})
	if err != nil {
		fmt.Println(err)
	}

	chaincode, err := contractapi.NewChaincode(new(SmartContract))

	if err != nil {
		fmt.Printf("Error create fabcar chaincode: %s", err.Error())
		return
	}

	if err := chaincode.Start(); err != nil {
		fmt.Printf("Error starting fabcar chaincode: %s", err.Error())
	}
}
