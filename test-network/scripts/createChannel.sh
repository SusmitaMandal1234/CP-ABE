#!/bin/bash

# imports  
. scripts/envVar.sh
. scripts/utils.sh

CHANNEL_NAME="$1"
DELAY="$2"
MAX_RETRY="$3"
VERBOSE="$4"
: ${CHANNEL_NAME:="mychannel"}
: ${DELAY:="3"}
: ${MAX_RETRY:="5"}
: ${VERBOSE:="false"}

if [ ! -d "channel-artifacts" ]; then
	mkdir channel-artifacts
fi

createChannelTx() {
	set -x
	configtxgen -profile OrgsChannel1 -outputCreateChannelTx ./channel-artifacts/${CHANNEL_NAME}.tx -channelID $CHANNEL_NAME
	res=$?
	{ set +x; } 2>/dev/null
  	verifyResult $res "Failed to generate channel configuration transaction..."
}

createChannel() {
	setGlobals 1 0
	# Poll in case the raft leader is not set yet
	local rc=1
	local COUNTER=1
	while [ $rc -ne 0 -a $COUNTER -lt $MAX_RETRY ] ; do
		sleep $DELAY
		set -x
		peer channel create -o localhost:7050 localhost:7055 localhost:7056 -c $CHANNEL_NAME --ordererTLSHostnameOverride orderer1.example.com orderer2.example.com orderer3.example.com -f ./channel-artifacts/${CHANNEL_NAME}.tx --outputBlock $BLOCKFILE --tls --cafile $ORDERER_CA >&log.txt
		res=$?
		{ set +x; } 2>/dev/null
		let rc=$res
		COUNTER=$(expr $COUNTER + 1)
	done
	cat log.txt
	verifyResult $res "Channel creation failed"
}

# joinChannel ORG
joinChannel() {
  FABRIC_CFG_PATH=${PWD}/config
  ORG=$1
  PEER=$2
  setGlobals $ORG $PEER
  local rc=1
  local COUNTER=1
	## Sometimes Join takes time, hence retry
  while [ $rc -ne 0 -a $COUNTER -lt $MAX_RETRY ] ; do
    sleep $DELAY
    set -x
    peer channel join -b $BLOCKFILE >&log.txt
    res=$?
    { set +x; } 2>/dev/null
		let rc=$res
		COUNTER=$(expr $COUNTER + 1)
	done
	cat log.txt
	verifyResult $res "After $MAX_RETRY attempts, peer${PEER}.org${ORG} has failed to join channel '$CHANNEL_NAME' "
}

setAnchorPeer() {
  ORG=$1
  PEER=$2
  docker exec cli ./scripts/setAnchorPeer.sh $ORG $PEER $CHANNEL_NAME 
}

export FABRIC_CFG_PATH=${PWD}/configtx
infoln "FABRIC PATH : ${FABRIC_CFG_PATH}"

## Create channeltx
infoln "Generating channel create transaction '${CHANNEL_NAME}.tx'"
createChannelTx

export FABRIC_CFG_PATH=${PWD}/config
#FABRIC_CFG_PATH=${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/config
infoln "FABRIC PATH : ${FABRIC_CFG_PATH}"

BLOCKFILE="./channel-artifacts/${CHANNEL_NAME}.block"

## Create channel
infoln "Creating channel ${CHANNEL_NAME}"
createChannel
successln "Channel '$CHANNEL_NAME' created"

## Join all the peers to the channel
#FABRIC_CFG_PATH=${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/config
infoln "FABRIC PATH : ${FABRIC_CFG_PATH}"

infoln "Joining peer0.org1 to the channel..."
joinChannel 1 0
#FABRIC_CFG_PATH=${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/config
infoln "FABRIC PATH : ${FABRIC_CFG_PATH}"

infoln "Joining peer1.org1 to the channel..."
joinChannel 1 1
#FABRIC_CFG_PATH=${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer2.org1.example.com/config
infoln "FABRIC PATH : ${FABRIC_CFG_PATH}"

# infoln "Joining peer2.org1 to the channel..."
# joinChannel 1 2
# #FABRIC_CFG_PATH=${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer3.org1.example.com/config
# infoln "FABRIC PATH : ${FABRIC_CFG_PATH}"

# infoln "Joining peer3.org1 to the channel..."
# joinChannel 1 3
# #FABRIC_CFG_PATH=${PWD}/../config/
# infoln "FABRIC PATH : ${FABRIC_CFG_PATH}"

infoln "Joining peer0.org2 to the channel..."
joinChannel 2 0
infoln "Joining peer1.org2 to the channel..."
joinChannel 2 1
# infoln "Joining peer2.org2 to the channel..."
# joinChannel 2 2
# infoln "Joining peer3.org2 to the channel..."
# joinChannel 2 3
infoln "Joining peer0.org3 to the channel..."
joinChannel 3 0
infoln "Joining peer1.org3 to the channel..."
joinChannel 3 1
# infoln "Joining peer2.org3 to the channel..."
# joinChannel 3 2
# infoln "Joining peer3.org3 to the channel..."
# joinChannel 3 3
# infoln "Joining peer0.org4 to the channel..."
# joinChannel 4 0
# infoln "Joining peer1.org4 to the channel..."
# joinChannel 4 1
# infoln "Joining peer2.org4 to the channel..."
# joinChannel 4 2
# infoln "Joining peer3.org4 to the channel..."
# joinChannel 4 3


## Set the anchor peers for each org in the channel
#FABRIC_CFG_PATH=${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/config
infoln "FABRIC PATH : ${FABRIC_CFG_PATH}"

infoln "Setting peer0 as anchor peer for org1..."
setAnchorPeer 1 0
#FABRIC_CFG_PATH=${PWD}/../config/
infoln "FABRIC PATH : ${FABRIC_CFG_PATH}"

infoln "Setting peer0 as anchor peer for org2..."
setAnchorPeer 2 0
infoln "Setting peer0 as anchor peer for org3..."
setAnchorPeer 3 0
# infoln "Setting peer0 as anchor peer for org3..."
# setAnchorPeer 4 0

successln "Channel '$CHANNEL_NAME' joined"
