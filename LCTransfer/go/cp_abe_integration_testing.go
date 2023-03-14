package main

import (
	"context"
	"crypto/ecdsa"
	"crypto/elliptic"
	"crypto/rand"
	"crypto/sha256"
	"crypto/x509"
	"encoding/hex"
	"encoding/json"
	"encoding/pem"
	"fmt"
	rand1 "math/rand"
	//"plugin"

	//"bytes"
	//"encoding/gob"
	"io/ioutil"
	"log"
	"math/big"
	"os"
	"strconv"
	"time"

	"github.com/fentec-project/gofe/abe"
	"github.com/fentec-project/gofe/data"
	"github.com/joho/godotenv"
	"github.com/pranaychawhan2015/cp_abe"
	"github.com/segmentio/kafka-go"
)

var (
	_              = godotenv.Load()
	topic          = goDotEnvVariable("KAFKA_TOPIC")
	brokerAddress  = goDotEnvVariable("BROKER_ADDRESS")
	contract_topic = goDotEnvVariable("CONTRACT_TOPIC")
	peer_id        = goDotEnvVariable("PEER_ID")
)

func goDotEnvVariable(key string) string {

	// load .env file
	err := godotenv.Load(".env")

	if err != nil {
		log.Fatalf("Error loading .env file")
	}
	return os.Getenv(key)
}

type Handler interface {
	Decrypt([]byte, string) ([]byte, error)
}

func main() {
	dotenv := goDotEnvVariable("STRONGEST_AVENGER")
	fmt.Println("dotenv", dotenv)
	fmt.Println("Topic", topic, brokerAddress, contract_topic)

	var message_to_kafka map[string]string
	var policy_comming_kafka string

	msg_reader, err := ioutil.ReadFile("data.json")
	rand1.Seed(time.Now().UnixNano())
	min := 2
	max := 4
	m := 4
	for m >= 1 {
		m = rand1.Intn(max-min+1) + min
		if m >= 2 {
			break
		}
	}
	mainlist1 := make([]int, 0)
	ls := rand1.Perm(m)

	mainlist1 = append(mainlist1, 0, 1, 2, 3, 4, 5)
	fmt.Println(err)

	fmt.Println("received: ", string(msg_reader))

	_ = json.Unmarshal([]byte(string(msg_reader)), &message_to_kafka)
	fmt.Println("this is message from kafka", message_to_kafka)

	policy_comming_kafka = message_to_kafka["Policy"]
	fmt.Println("this is policy based string data", policy_comming_kafka)
	delete(message_to_kafka, "Policy")

	bytesFromMarhsalling, _ := json.Marshal(message_to_kafka)
	msg := string(bytesFromMarhsalling)
	policy := policy_comming_kafka
	lsss, err := abe.BooleanToMSP(policy, false)
	fmt.Println("Message from Kafka", msg)

	//we declare attribute of public key and attribute of private key

	attrToPrivatMsp, attrToPubKeyMap, _ := cp_abe.GenerateAttributeKeys(lsss)
	//this is vectorArray generator for random vector
	_, _, _, C0, vectorArray, G_value, _ := cp_abe.GenerateHashValues(lsss, msg)

	fmt.Println("this is C0 value", C0)
	PKAA, PID, answerVector, ur_value, ur_into_g, X1, tr_private_key := UtitlizePeerKeysFromMsp(C0, G_value, vectorArray, lsss)

	//now calculate of encryption of
	DK := make(map[string]*big.Int)

	CTjArray := make(map[string]*big.Int)

	DM := make(map[string]*big.Int)

	Summetion := make(map[string]*big.Int)

	CTjArray1 := make(map[string]*big.Int)

	DK1 := make(map[string]*big.Int)

	DM1 := make(map[string]*big.Int)

	Summetion1 := make(map[string]*big.Int)

	//contract_topic = "production6"
	fmt.Println("LS", ls)
	for _, pp := range mainlist1 {
		//fmt.Println(i)
		sendMessage := false
		for _, k := range ls {
			if k == pp {
				sendMessage = true
				break
			}
		}

		if sendMessage {
			Producer_send_data1 := cp_abe.SuccessfulEncryption(lsss, msg, answerVector, attrToPubKeyMap, attrToPrivatMsp, Summetion, PKAA, PID, DK, CTjArray, DM, G_value, ur_value, ur_into_g, tr_private_key, C0, X1)
			partition := pp
			conn, _ := kafka.DialLeader(context.Background(), "tcp", brokerAddress, contract_topic, partition)
			// if slices.Contains(ls, j) {
			conn.SetWriteDeadline(time.Now().Add(10 * time.Second))
			_, err = conn.WriteMessages(
				kafka.Message{
					Key:   []byte("5"),
					Value: Producer_send_data1},
			)
			fmt.Println("error from kafka", err)
			fmt.Println("successful partition", partition, topic, Producer_send_data1)
		} else {
			//we converting that policy to lsss matrix
			//contract_topic := "testing1"
			Producer_send_data2 := cp_abe.UnsuccessfulEncryption(lsss, msg, answerVector, CTjArray1, attrToPrivatMsp, attrToPubKeyMap, DM1, DK1, Summetion1, G_value, PID, PKAA, ur_value, ur_into_g, X1, tr_private_key, C0)
			partition := pp
			conn, _ := kafka.DialLeader(context.Background(), "tcp", brokerAddress, contract_topic, partition)
			// if slices.Contains(ls, j) {
			conn.SetWriteDeadline(time.Now().Add(10 * time.Second))
			_, _ = conn.WriteMessages(
				kafka.Message{
					Key:   []byte("5"),
					Value: Producer_send_data2},
			)
			fmt.Println("unsuccessfult partition", partition, topic, Producer_send_data2)
			fmt.Println(pp)
		}

	}
}
