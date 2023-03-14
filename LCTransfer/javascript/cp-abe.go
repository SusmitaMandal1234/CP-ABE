package main

//import "c"
import (
	"bytes"

	//"context"
	"encoding/gob"
	//"encoding/pem"
	//"errors"
	//"io/ioutil"
	//"log"
	//"path/filepath"
	//"reflect"
	"os"
	"time"

	"github.com/google/uuid"
	//"github.com/valyala/fastjson"

	//"github.com/bxcodec/faker/v3"
	"github.com/fentec-project/gofe/abe"
	"github.com/fentec-project/gofe/data"

	//"github.com/segmentio/kafka-go"

	//"github.com/hyperledger/fabric-protos-go/msp"

	// "github.com/hyperledger/fabric-protos-go/msp"
	// "github.com/hyperledger/fabric-sdk-go/pkg/common/providers/context"

	//"github.com/hyperledger/fabric-sdk-go/pkg/common/providers/context"

	//"github.com/hyperledger/fabric-sdk-go/pkg/gateway"

	"crypto/aes"
	"crypto/cipher"
	"crypto/rand"
	"encoding/hex"
	"encoding/json"
	"fmt"
	"io"
	"math/big"
	rand1 "math/rand"
	"strings"
)

// const (
// 	topic         = "quickstart-events"
// 	brokerAddress = "172.16.85.128:9092"
// )

// type Policy struct {
// 	Name   string   `json:"policyname"`
// 	Lambda *big.Int `json:lambda`
// }

// type Message struct {
// 	Name  string `json:"Name"`
// 	Value string `json:Value`
// 	Nonce string `json:Nonce`
// }

// type Transaction struct {
// 	PatientNumber         string `json:PatientNumber`
// 	Name                  string `json:Name`
// 	Age                   string `json:Age`
// 	Doctor_Specialization string `json:Doctor_Specialization`
// 	Disease               string `json:Disease`
// 	Email                 string `json:Email`
// 	Adhar                 string `json:Adhar`
// 	Organization          string `json:Organization`
// }

// type Employee struct {
// 	Name   string `json:"empname"`
// 	Number int    `json:"empid"`
// }

// type PolicyList struct {
// 	Name   string
// 	Policy []Policy
// }

// const (
// 	topic         = "quickstart-events"
// 	brokerAddress = "172.16.85.208:9092"
// )

func main() {
	msg1 := ""
	msg2 := ""

	msg1, msg2 = ConvertMessage()
	fmt.Println(msg1, msg2)
}

func GetPolicy(matrix data.Matrix, rowAttributes []string) map[string]*big.Int {

	RowToAttrib := make(map[string][]string, 0)

	for i := 0; i < len(matrix); i++ {
		//newString := matrix[i][0].String() + matrix[i][1].String() + matrix[i][2].String()
		newString := ""
		for j := 0; j < len(matrix[i]); j++ {
			newString += matrix[i][j].String()
		}
		valueFromMap := RowToAttrib[newString]
		valueFromMap = append(valueFromMap, rowAttributes[i])
		//fmt.Println("Row to Attr", valueFromMap)
		for j := i + 1; j < len(matrix); j++ {
			newString1 := ""

			for k := 0; k < len(matrix[j]); k++ {
				newString1 += matrix[j][k].String()
			}
			if newString1 == newString {
				valueFromMap = append(valueFromMap, rowAttributes[j])
			}
		}
		RowToAttrib[newString] = valueFromMap
	}
	totalMap := make(map[string]*big.Int, 0)

	//fmt.Println("RowToAttr", RowToAttrib)
	count := 1
	for _, value := range RowToAttrib {
		index := 0
		if len(value) > 1 {
			rand1.Seed(time.Now().UnixNano())
			min := 0
			max := len(value) - 1
			index = rand1.Intn(max-min+1) + min
			//fmt.Println("index", index)
		} else {
			index = 0
		}
		totalMap[value[index]] = big.NewInt(int64(count))
		count++
	}

	return totalMap
}

// func randNew() bool {
// 	return rand1.Float32() < 0.5
// }

// func remove(slice []string, s int) []string {
// 	return append(slice[:s], slice[s+1:]...)
// }

// func getAttr(obj interface{}, fieldName string) reflect.Value {
// 	pointToStruct := reflect.ValueOf(obj) // addressable
// 	curStruct := pointToStruct.Elem()
// 	if curStruct.Kind() != reflect.Struct {
// 		panic("not struct")
// 	}
// 	curField := curStruct.FieldByName(fieldName) // type: reflect.Value
// 	if !curField.IsValid() {
// 		panic("not found:" + fieldName)
// 	}
// 	return curField
// }

func ConvertMessage() (output1 string, output2 string) {
	//var message string
	//message = `{"Name":"Pranay","Email":"PranayChawhan2015@gmail.com","Policy":"(Cement_concrete AND Suppliers_Raw_materials AND (Electronic_Machinary OR Sand OR Cement) )"}`
	//ConvertMessage := fmt.Sprintf(`{"FirstName":%s,"LastName":%s,"Email":%s,"UserName":%s,"Phone":%s,"Gender":%s,"Address":%s,"Policy":"(Cement_concrete AND Suppliers_Raw_materials AND (Electronic_Machinary OR Sand OR Cement) )"}`, faker.FirstName(), faker.LastName(), faker.Email(), faker.Username(), faker.Phonenumber(), faker.Gender(), faker.Paragraph())
	//ConvertMessage := `{"FirstName":` + faker.FirstName() + "," + `"LastName":` + faker.LastName() + "," + `"Email":` + faker.Email() + "," + `"UserName":` + faker.Username() + "," + `"Gender":` + faker.Gender() + "," + `"Phone":` + faker.Phonenumber() + "," + `"Address":` + faker.Paragraph() + "," + `"Policy":` + `"(Cement_concrete AND Suppliers_Raw_materials AND (Electronic_Machinary OR Sand OR Cement) )"}`

	contents, err := os.ReadFile("data.json")
	fmt.Println("contents", contents, "error", err)
	// after receiving the message, log its value
	message := string(contents)
	fmt.Println("msg: ", string(contents))

	var msg1 map[string]string
	json.Unmarshal([]byte(message), &msg1)

	fmt.Println("map", msg1)
	uuidWithHyphen := uuid.New()
	//fmt.Println(uuidWithHyphen)
	msg1["key"] = uuidWithHyphen.String()

	// if err != nil {
	// 	fmt.Println("Error marshalling the json", err)
	// } else {
	policy := msg1["Policy"]
	if policy == "" {
		var network1 bytes.Buffer        // Stand-in for a network connection
		enc := gob.NewEncoder(&network1) // Will write to network.
		enc.Encode(msg1)

		plaintext := hex.EncodeToString(network1.Bytes())
		//var MessageMap map[string]string
		var MessageMap = make(map[string]string, 0)
		MessageMap["Value"] = plaintext
		res2, _ := json.Marshal(MessageMap)

		//_, err := contract.SubmitTransaction("CreateRecord", string(res2), "")
		//fmt.Println("Error", err)
		return string(res2), ""
	}
	delete(msg1, "Policy")
	msg := msg1

	//fmt.Printf("Message Before Encoding %s", msg)

	var network1 bytes.Buffer        // Stand-in for a network connection
	enc := gob.NewEncoder(&network1) // Will write to network.

	enc.Encode(msg)
	msp1, _ := abe.BooleanToMSP(policy, false)
	// if err != nil {
	// 	//fmt.Println("Err", err)
	// }

	vectorArray := make([]data.Vector, 0)

	for i := 0; i < len(msp1.Mat[0]); i++ {
		newBigInt, _ := rand.Prime(rand.Reader, 212)
		for len(newBigInt.String()) != 64 {
			newBigInt, _ = rand.Prime(rand.Reader, 212)
		}

		bigArray := make([]*big.Int, 1)
		bigArray[0] = newBigInt
		vector := data.NewVector(bigArray)

		vectorArray = append(vectorArray, vector)
	}

	policyMap := GetPolicy(msp1.Mat, msp1.RowToAttrib)
	matrix2, _ := data.NewMatrix(vectorArray)
	// if err != nil {
	// 	fmt.Println(err)
	// }

	//fmt.Printf("LSSS Matrix: %v \n", msp1)

	//fmt.Println("randomized matrix", matrix2)
	answerVector, _ := msp1.Mat.Mul(matrix2)
	// if err != nil {
	// 	//fmt.Println(err)
	// }

	//fmt.Println("Multipled matrix", answerVector)

	for i := 0; i < len(msp1.RowToAttrib); i++ {
		answer := answerVector[i]
		value := policyMap[msp1.RowToAttrib[i]]
		if value != nil {
			policyMap[msp1.RowToAttrib[i]] = answer[0]
		}
	}

	//fmt.Println("key", vectorArray[0].String())
	array := strings.Split(vectorArray[0].String(), " ")
	key, _ := hex.DecodeString(array[1])
	// if err != nil {
	// 	fmt.Println(err)
	// }
	plaintext := hex.EncodeToString(network1.Bytes())
	block, _ := aes.NewCipher(key)
	// if err != nil {
	// 	panic(err.Error())
	// }

	nonce := make([]byte, 12)

	if _, err := io.ReadFull(rand.Reader, nonce); err != nil {
		panic(err.Error())
	}

	aesgcm, err := cipher.NewGCM(block)
	if err != nil {
		panic(err.Error())
	}

	ciphertext := aesgcm.Seal(nil, nonce, []byte(plaintext), nil)

	// if err != nil {
	// 	fmt.Printf("Error in policy\n", err)
	// }

	policyList := make(map[string]map[string]*big.Int)
	//fmt.Println("Policy", policyMap)
	policyList["policy"] = policyMap

	res, _ := json.Marshal(policyList)
	// if err != nil {
	// 	fmt.Println(err)
	// }

	//fmt.Println("Policy", string(res))

	var resData map[string]map[string]*big.Int
	json.Unmarshal(res, &resData)

	res1 := hex.EncodeToString(ciphertext)

	//var messageMap map[string]string
	var messageMap = make(map[string]string, 0)
	messageMap["Value"] = res1
	messageMap["Nonce"] = hex.EncodeToString(nonce)

	res2, _ := json.Marshal(messageMap)

	//fmt.Println("attributes", policyMap)

	// if len(endorsers) == 0 {
	// 	fmt.Println("No Endorsers from the required Policy")
	// } else {

	// 	start := time.Now()
	// 	_, err = txn.Submit(string(res2), string(res))
	// 	end := time.Now()
	// 	elapsed := end.Sub(start)
	// 	if err != nil {
	// 		fmt.Println(err)
	// 	} else {
	// 		fmt.Printf("Transaction time is %f seconds", elapsed.Seconds())
	// 	}
	// }

	return string(res2), string(res)
	//return "", ""
}
