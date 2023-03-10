#!/bin/bash
#
# Copyright IBM Corp All Rights Reserved
#
# SPDX-License-Identifier: Apache-2.0
#

# This is a collection of bash functions used by different scripts

# imports
. scripts/utils.sh

export CORE_PEER_TLS_ENABLED=true
export ORDERER_CA=${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer1.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
export ORDERER_CA2=${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer2.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
export ORDERER_CA3=${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer3.example.com/msp/tlscacerts/tlsca.example.com-cert.pem


export PEER0_ORG1_CA=${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
export PEER0_ORG2_CA=${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt
export PEER0_ORG3_CA=${PWD}/organizations/peerOrganizations/org3.example.com/peers/peer0.org3.example.com/tls/ca.crt
export PEER0_ORG4_CA=${PWD}/organizations/peerOrganizations/org4.example.com/peers/peer0.org4.example.com/tls/ca.crt

export PEER1_ORG1_CA=${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/tls/ca.crt
export PEER1_ORG2_CA=${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer1.org2.example.com/tls/ca.crt
export PEER1_ORG3_CA=${PWD}/organizations/peerOrganizations/org3.example.com/peers/peer1.org3.example.com/tls/ca.crt
export PEER1_ORG4_CA=${PWD}/organizations/peerOrganizations/org4.example.com/peers/peer1.org4.example.com/tls/ca.crt

export PEER2_ORG1_CA=${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer2.org1.example.com/tls/ca.crt
export PEER2_ORG2_CA=${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer2.org2.example.com/tls/ca.crt
export PEER2_ORG3_CA=${PWD}/organizations/peerOrganizations/org3.example.com/peers/peer2.org3.example.com/tls/ca.crt
export PEER2_ORG4_CA=${PWD}/organizations/peerOrganizations/org4.example.com/peers/peer2.org4.example.com/tls/ca.crt

export PEER3_ORG1_CA=${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer3.org1.example.com/tls/ca.crt
export PEER3_ORG2_CA=${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer3.org2.example.com/tls/ca.crt
export PEER3_ORG3_CA=${PWD}/organizations/peerOrganizations/org3.example.com/peers/peer3.org3.example.com/tls/ca.crt
export PEER3_ORG4_CA=${PWD}/organizations/peerOrganizations/org4.example.com/peers/peer3.org4.example.com/tls/ca.crt

# Set envionment variables for the peer org
setGlobals() {
  local USING_ORG=""
  local PEER=$2
  if [ -z "$OVERRIDE_ORG" ]; then
    USING_ORG=$1
  else
    USING_ORG="${OVERRIDE_ORG}"
  fi
  infoln "Using organization ${USING_ORG}"
  if [ $USING_ORG -eq 1 ] || [ $USING_ORG -eq 2 ] || [ $USING_ORG -eq 3 ] || [ $USING_ORG -eq 4 ]; then
    export CORE_PEER_LOCALMSPID="Org${USING_ORG}MSP"
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org${USING_ORG}.example.com/users/Admin@org${USING_ORG}.example.com/msp
    export CHAINCODE_PLUGIN_PATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/plugin/plugin.so
  fi

  if [ $USING_ORG -eq 1 ]; then
    if [ $2 -eq 0 ]; then
      export CORE_PEER_TLS_ROOTCERT_FILE=${PEER0_ORG1_CA}
      export CORE_PEER_ADDRESS=localhost:7051
    elif [ $2 -eq 1 ]; then
      export CORE_PEER_TLS_ROOTCERT_FILE=${PEER1_ORG1_CA}
      export CORE_PEER_ADDRESS=localhost:8051
    elif [ $2 -eq 2 ]; then
      export CORE_PEER_TLS_ROOTCERT_FILE=${PEER2_ORG1_CA}
      export CORE_PEER_ADDRESS=localhost:8053
    elif [ $2 -eq 3 ]; then
      export CORE_PEER_TLS_ROOTCERT_FILE=${PEER3_ORG1_CA}
      export CORE_PEER_ADDRESS=localhost:8055
    else
      errorln "PEER$2 Unknown"
    fi
  elif [ $USING_ORG -eq 2 ]; then
    if [ $2 -eq 0 ]; then
      export CORE_PEER_TLS_ROOTCERT_FILE=${PEER0_ORG2_CA}
      export CORE_PEER_ADDRESS=localhost:9051
    elif [ $2 -eq 1 ]; then
      export CORE_PEER_TLS_ROOTCERT_FILE=${PEER1_ORG2_CA}
      export CORE_PEER_ADDRESS=localhost:12051
    elif [ $2 -eq 2 ]; then
      export CORE_PEER_TLS_ROOTCERT_FILE=${PEER2_ORG2_CA}
      export CORE_PEER_ADDRESS=localhost:12053
    elif [ $2 -eq 3 ]; then
      export CORE_PEER_TLS_ROOTCERT_FILE=${PEER3_ORG2_CA}
      export CORE_PEER_ADDRESS=localhost:12055
    else
      errorln "PEER$2 Unknown"
    fi
  elif [ $USING_ORG -eq 3 ]; then
    if [ $2 -eq 0 ]; then
      export CORE_PEER_TLS_ROOTCERT_FILE=${PEER0_ORG3_CA}
      export CORE_PEER_ADDRESS=localhost:10051
    elif [ $2 -eq 1 ]; then
      export CORE_PEER_TLS_ROOTCERT_FILE=${PEER1_ORG3_CA}
      export CORE_PEER_ADDRESS=localhost:13051
    elif [ $2 -eq 2 ]; then
      export CORE_PEER_TLS_ROOTCERT_FILE=${PEER2_ORG3_CA}
      export CORE_PEER_ADDRESS=localhost:13053
    elif [ $2 -eq 3 ]; then
      export CORE_PEER_TLS_ROOTCERT_FILE=${PEER3_ORG3_CA}
      export CORE_PEER_ADDRESS=localhost:13055
    else
      errorln "PEER$2 Unknown"
    fi
  elif [ $USING_ORG -eq 4 ]; then
    if [ $2 -eq 0 ]; then
      export CORE_PEER_TLS_ROOTCERT_FILE=${PEER0_ORG4_CA}
      export CORE_PEER_ADDRESS=localhost:11051
    elif [ $2 -eq 1 ]; then
      export CORE_PEER_TLS_ROOTCERT_FILE=${PEER1_ORG4_CA}
      export CORE_PEER_ADDRESS=localhost:14051
    elif [ $2 -eq 2 ]; then
      export CORE_PEER_TLS_ROOTCERT_FILE=${PEER2_ORG4_CA}
      export CORE_PEER_ADDRESS=localhost:14053
    elif [ $2 -eq 3 ]; then
      export CORE_PEER_TLS_ROOTCERT_FILE=${PEER3_ORG4_CA}
      export CORE_PEER_ADDRESS=localhost:14055
    else
      errorln "PEER$2 Unknown"
    fi
  else
    errorln "ORG$USING_ORG Unknown"
  fi

  if [ "$VERBOSE" == "true" ]; then
    env | grep CORE
  fi
}

# Set environment variables for use in the CLI container 
setGlobalsCLI() {
  setGlobals $1 $2

  local USING_ORG=""
  if [ -z "$OVERRIDE_ORG" ]; then
    USING_ORG=$1
  else
    USING_ORG="${OVERRIDE_ORG}"
  fi
  if [ $USING_ORG -eq 1 ]; then
    if [ $2 -eq 0 ]; then
      export CORE_PEER_ADDRESS=peer0.org1.example.com:7051
    elif [ $2 -eq 1 ]; then
      export CORE_PEER_ADDRESS=peer1.org1.example.com:8051
    elif [ $2 -eq 2 ]; then
      export CORE_PEER_ADDRESS=peer2.org1.example.com:8053
    elif [ $2 -eq 3 ]; then
      export CORE_PEER_ADDRESS=peer3.org1.example.com:8055
    else
      errorln "PEER$2 Unknown"
    fi
  elif [ $USING_ORG -eq 2 ]; then
    if [ $2 -eq 0 ]; then
      export CORE_PEER_ADDRESS=peer0.org2.example.com:9051
    elif [ $2 -eq 1 ]; then
      export CORE_PEER_ADDRESS=peer1.org2.example.com:12051
    elif [ $2 -eq 2 ]; then
      export CORE_PEER_ADDRESS=peer2.org2.example.com:12053
    elif [ $2 -eq 3 ]; then
      export CORE_PEER_ADDRESS=peer3.org2.example.com:12055
    else
      errorln "PEER$2 Unknown"
    fi
  elif [ $USING_ORG -eq 3 ]; then
    if [ $2 -eq 0 ]; then
      export CORE_PEER_ADDRESS=peer0.org3.example.com:10051
    elif [ $2 -eq 1 ]; then
      export CORE_PEER_ADDRESS=peer1.org3.example.com:13051
    elif [ $2 -eq 2 ]; then
      export CORE_PEER_ADDRESS=peer2.org3.example.com:13053
    elif [ $2 -eq 3 ]; then
      export CORE_PEER_ADDRESS=peer3.org3.example.com:13055
    else
      errorln "PEER$2 Unknown"
    fi
  elif [ $USING_ORG -eq 4 ]; then
    if [ $2 -eq 0 ]; then
      export CORE_PEER_ADDRESS=peer0.org4.example.com:11051
    elif [ $2 -eq 1 ]; then
      export CORE_PEER_ADDRESS=peer1.org4.example.com:14051
    elif [ $2 -eq 2 ]; then
      export CORE_PEER_ADDRESS=peer2.org4.example.com:14053
    elif [ $2 -eq 3 ]; then
      export CORE_PEER_ADDRESS=peer3.org4.example.com:14055
    else
      errorln "PEER$2 Unknown"
    fi
  else
    errorln "ORG$USING_ORG Unknown"
  fi
}

# parsePeerConnectionParameters $@
# Helper function that sets the peer connection parameters for a chaincode
# operationobal
parsePeerConnectionParameters() {
  PEER_CONN_PARMS=""
  PEERS=""
  while [ "$#" -gt 0 ]; do
    setGlobals $1 0
    PEER="peer0.org$1"
    ## Set peer addresses
    PEERS="$PEERS $PEER"
    PEER_CONN_PARMS="$PEER_CONN_PARMS --peerAddresses $CORE_PEER_ADDRESS"
    ## Set path to TLS certificate
    TLSINFO=$(eval echo "--tlsRootCertFiles \$PEER0_ORG$1_CA")
    PEER_CONN_PARMS="$PEER_CONN_PARMS $TLSINFO"
    
    setGlobals $1 1
    PEER="peer1.org$1"
    # Set peer addresses
    PEERS="$PEERS $PEER"
    PEER_CONN_PARMS="$PEER_CONN_PARMS --peerAddresses $CORE_PEER_ADDRESS"
    # Set path to TLS certificate
    TLSINFO=$(eval echo "--tlsRootCertFiles \$PEER1_ORG$1_CA")
    PEER_CONN_PARMS="$PEER_CONN_PARMS $TLSINFO"

    

    #  if [$1 -eq 1 || $1 -eq 3];
    #  then
    #  {
            # setGlobals $1 2
            # PEER="peer2.org$1"
            # ## Set peer addresses
            # PEERS="$PEERS $PEER"
            # PEER_CONN_PARMS="$PEER_CONN_PARMS --peerAddresses $CORE_PEER_ADDRESS"
            # ## Set path to TLS certificate
            # TLSINFO=$(eval echo "--tlsRootCertFiles \$PEER2_ORG$1_CA")
            # PEER_CONN_PARMS="$PEER_CONN_PARMS $TLSINFO"
      # }
      # fi
    
    # if [!$1 -eq 4]; 
    # then
    # {
        # setGlobals $1 3
        # PEER="peer3.org$1"
        # ## Set peer addresses
        # PEERS="$PEERS $PEER"
        # PEER_CONN_PARMS="$PEER_CONN_PARMS --peerAddresses $CORE_PEER_ADDRESS"
        # ## Set path to TLS certificate
        # TLSINFO=$(eval echo "--tlsRootCertFiles \$PEER3_ORG$1_CA")
        # PEER_CONN_PARMS="$PEER_CONN_PARMS $TLSINFO"
        # shift by one to get to the next organization
    #}
    shift
  done
  # remove leading space for output
  PEERS="$(echo -e "$PEERS" | sed -e 's/^[[:space:]]*//')"
}

verifyResult() {
  if [ $1 -ne 0 ]; then
    fatalln "$2"
  fi
}
