/*
SPDX-License-Identifier: Apache-2.0
*/

package main

func GetConfigurationConstants() (string, string, string, string) {
	topic := "production27"
	brokerAddress := "172.16.85.10:9092"
	peer_id := "peer1.org2.example.com"
	group_id := "peer0"

	return topic, brokerAddress, peer_id, group_id
}
