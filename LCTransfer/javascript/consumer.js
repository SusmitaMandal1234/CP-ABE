const { Kafka } = require("kafkajs")

// the client ID lets kafka know who's producing the messages
const clientId = "my-group"
// we can define the list of brokers in the cluster
const brokers = ["172.16.85.143:9092"]
// this is the topic to which we want to write messages
const topic = "quickstart-events"

// initialize a new kafka client and initialize a producer from it
const kafka = new Kafka({ clientId, brokers })

const consumer = kafka.consumer({ groupId: clientId })

const consume = async () => {
	// first, we wait for the client to connect and subscribe to the given topic
	await consumer.connect()
	await consumer.subscribe({ topic })
	await consumer.run({
		// this function is called every time the consumer gets a new message
		eachMessage: ({ message }) => {
			// here, we just log the message to the standard output
			console.log(`received message: ${message.value}`)
		},
	})
}

module.exports = consume