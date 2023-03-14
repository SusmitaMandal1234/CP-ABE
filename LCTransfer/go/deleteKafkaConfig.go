package main

import (
	"context"
	"fmt"
	//"plugin"

	//"bytes"
	//"encoding/gob"
	"github.com/joho/godotenv"
	"github.com/segmentio/kafka-go"
	"log"
	"os"
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

	// var message_to_kafka map[string]string
	// var policy_comming_kafka string

	// ctx := context.Background()
	// l := log.New(os.Stdout, "kafka reader: ", 2)
	// fmt.Printf("Starting consumer...")
	// c := kafka.NewReader(kafka.ReaderConfig{
	// 	Brokers: []string{brokerAddress},
	// 	Topic:   topic,
	// 	//GroupID: "my-group",
	// 	// assign the logger to the reader
	// 	Logger: l,
	// })
	// c.SetOffset(-1)

	// connection1, err := c.ReadMessage(1000)
	// fmt.Println(string(connection1.Value))

	conn, _ := kafka.DialLeader(context.Background(), "tcp", brokerAddress, topic, 0)
	// if slices.Contains(ls, j) {
	// conn.SetWriteDeadline(time.Now().Add(10 * time.Second))
	// _, err = conn.WriteMessages(
	// 	kafka.Message{
	// 		Key:   []byte("5"),
	// 		Value: Producer_send_data1},
	// )
	conn.DeleteTopics(topic)

}
