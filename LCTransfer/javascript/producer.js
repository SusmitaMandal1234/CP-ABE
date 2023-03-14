const { Kafka } = require("kafkajs")
const { mainModule } = require("process")

// the client ID lets kafka know who's producing the messages
const clientId = "my-group"
// we can define the list of brokers in the cluster
const brokers = ["172.16.85.110:9092"]
// this is the topic to which we want to write messages
const topic = "quickstart-events"

// initialize a new kafka client and initialize a producer from it
const kafka = new Kafka({ clientId, brokers })

const producer = kafka.producer({ groupId: clientId })

const produce = async () => {
	await producer.connect()
	let i = 0

	// after the produce has connected, we start an interval timer
	setInterval(async () => {
		try {
			// send a message to the configured topic with
			// the key and value formed from the current value of `i`
			await producer.send({
				topic,
				messages: [
					{
						key: String(i),
						value: "this is message " + i,
					},
				],
			})

			// if the message is written successfully, log it and increment `i`
			console.log("writes: ", i)
			i++
		} catch (err) {
			console.error("could not write message " + err)
		}
	}, 1000)
}

async function main(){
    produce().catch((err) => {
        console.error("error in producer: ", err)
    })
}

main();
module.exports = produce