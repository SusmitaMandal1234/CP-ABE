#!/bin/bash

function one_line_pem {
    echo "`awk 'NF {sub(/\\n/, ""); printf "%s\\\\\\\n",$0;}' $1`"
}



function one_line_priv {
    echo "`awk 'NF {printf $0;}' $1`"
}

function json_ccp {
    local PP=$(one_line_pem $5)
    local CP=$(one_line_pem $6)
    local CERT0=$(one_line_pem $7)
    local CERT1=$(one_line_pem $8)
    local KEY0=$(one_line_pem $9)
    local KEY1=$(one_line_pem ${10})
    # local CERT2=$(one_line_pem ${11})
    # local CERT3=$(one_line_pem ${12})
    # local KEY2=$(one_line_pem ${13})
    # local KEY3=$(one_line_pem ${14})
    sed -e "s/\${ORG}/$1/" \
        -e "s/\${P0PORT}/$2/" \
        -e "s/\${P1PORT}/$3/" \
        -e "s/\${CAPORT}/$4/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        -e "s#\${CERT0}#$CERT0#" \
        -e "s#\${CERT1}#$CERT1#" \
        -e "s#\${KEY0}#$KEY0#" \
        -e "s#\${KEY1}#$KEY1#" \
        # -e "s#\${CERT2}#$CERT2#" \
        # -e "s#\${CERT3}#$CERT3#" \
        # -e "s#\${KEY2}#$KEY2#" \
        # -e "s#\${KEY3}#$KEY3#" \
        # -e "s#\${P2PORT}#${15}#" \
        # -e "s#\${P3PORT}#${16}#" \
        /home/cps16/Documents/New/test-network/organizations/ccp-template.json
}

function yaml_ccp {
    local PP=$(one_line_pem $5)
    local CP=$(one_line_pem $6)
    local CERT0=$(one_line_pem $7)
    local CERT1=$(one_line_pem $8)
    local KEY0=$(one_line_pem $9)
    local KEY1=$(one_line_pem ${10})
    # local CERT2=$(one_line_pem ${11})
    # local CERT3=$(one_line_pem ${12})
    # local KEY2=$(one_line_pem ${13})
    # local KEY3=$(one_line_pem ${14})
    sed -e "s/\${ORG}/$1/" \
        -e "s/\${P0PORT}/$2/" \
        -e "s/\${P1PORT}/$3/" \
        -e "s/\${CAPORT}/$4/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        -e "s#\${CERT0}#$CERT0#" \
        -e "s#\${CERT1}#$CERT1#" \
        -e "s#\${KEY0}#$KEY0#" \
        -e "s#\${KEY1}#$KEY1#" \
        # -e "s#\${CERT2}#$CERT2#" \
        # -e "s#\${CERT3}#$CERT3#" \
        # -e "s#\${KEY2}#$KEY2#" \
        # -e "s#\${KEY3}#$KEY3#" \
        # -e "s#\${P2PORT}#${15}#" \
        # -e "s#\${P3PORT}#${16}#" \
        /home/cps16/Documents/New/test-network/organizations/ccp-template.yaml | sed -e $'s/\\\\n/\\\n          /g'
}

ORG=1
P0PORT=7051
P1PORT=8051
P2PORT=8053
P3PORT=8055
CAPORT=7054
PEERPEM=/home/cps16/Documents/New/test-network/organizations/peerOrganizations/org1.example.com/tlsca/tlsca.org1.example.com-cert.pem
CAPEM=/home/cps16/Documents/New/test-network/organizations/peerOrganizations/org1.example.com/ca/ca.org1.example.com-cert.pem
CERT0=/home/cps16/Documents/New/test-network/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/msp/signcerts/cert.pem
CERT1=/home/cps16/Documents/New/test-network/organizations/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/msp/signcerts/cert.pem
#CERT2=/home/cps16/Documents/New/test-network/organizations/peerOrganizations/org1.example.com/peers/peer2.org1.example.com/msp/signcerts/cert.pem
#CERT3=/home/cps16/Documents/New/test-network/organizations/peerOrganizations/org1.example.com/peers/peer3.org1.example.com/msp/signcerts/cert.pem
KEY0=/home/cps16/Documents/New/test-network/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/msp/keystore/priv_sk
KEY1=/home/cps16/Documents/New/test-network/organizations/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/msp/keystore/priv_sk
# KEY2=/home/cps16/Documents/New/test-network/organizations/peerOrganizations/org1.example.com/peers/peer2.org1.example.com/msp/keystore/priv_sk
# KEY3=/home/cps16/Documents/New/test-network/organizations/peerOrganizations/org1.example.com/peers/peer3.org1.example.com/msp/keystore/priv_sk


echo "$(json_ccp $ORG $P0PORT $P1PORT $CAPORT $PEERPEM $CAPEM $CERT0 $CERT1 $KEY0 $KEY1)" > /home/cps16/Documents/New/test-network/organizations/peerOrganizations/org1.example.com/connection-org1.json
echo "$(yaml_ccp $ORG $P0PORT $P1PORT $CAPORT $PEERPEM $CAPEM $CERT0 $CERT1 $KEY0 $KEY1)" > /home/cps16/Documents/New/test-network/organizations/peerOrganizations/org1.example.com/connection-org1.yaml

ORG=2
P0PORT=9051
P1PORT=12051
#P2PORT=12053
#P3PORT=12055
CAPORT=8054
PEERPEM=/home/cps16/Documents/New/test-network/organizations/peerOrganizations/org2.example.com/tlsca/tlsca.org2.example.com-cert.pem
CAPEM=/home/cps16/Documents/New/test-network/organizations/peerOrganizations/org2.example.com/ca/ca.org2.example.com-cert.pem
CERT0=/home/cps16/Documents/New/test-network/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/msp/signcerts/cert.pem
CERT1=/home/cps16/Documents/New/test-network/organizations/peerOrganizations/org2.example.com/peers/peer1.org2.example.com/msp/signcerts/cert.pem
#CERT2=/home/cps16/Documents/New/test-network/organizations/peerOrganizations/org2.example.com/peers/peer2.org2.example.com/msp/signcerts/cert.pem
#CERT3=/home/cps16/Documents/New/test-network/organizations/peerOrganizations/org2.example.com/peers/peer3.org2.example.com/msp/signcerts/cert.pem
KEY0=/home/cps16/Documents/New/test-network/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/msp/keystore/priv_sk
KEY1=/home/cps16/Documents/New/test-network/organizations/peerOrganizations/org2.example.com/peers/peer1.org2.example.com/msp/keystore/priv_sk
#KEY2=/home/cps16/Documents/New/test-network/organizations/peerOrganizations/org2.example.com/peers/peer2.org2.example.com/msp/keystore/priv_sk
#KEY3=/home/cps16/Documents/New/test-network/organizations/peerOrganizations/org2.example.com/peers/peer3.org2.example.com/msp/keystore/priv_sk

echo "Ravi Kath"
echo "$(json_ccp $ORG $P0PORT $P1PORT $CAPORT $PEERPEM $CAPEM $CERT0 $CERT1 $KEY0 $KEY1)" > /home/cps16/Documents/New/test-network/organizations/peerOrganizations/org2.example.com/connection-org2.json
echo "$(yaml_ccp $ORG $P0PORT $P1PORT $CAPORT $PEERPEM $CAPEM $CERT0 $CERT1 $KEY0 $KEY1)" > /home/cps16/Documents/New/test-network/organizations/peerOrganizations/org2.example.com/connection-org2.yaml

# ORG=3
# P0PORT=10051
# P1PORT=13051
# CAPORT=10054
# PEERPEM=organizations/peerOrganizations/org3.example.com/tlsca/tlsca.org3.example.com-cert.pem
# CAPEM=organizations/peerOrganizations/org3.example.com/ca/ca.org3.example.com-cert.pem
# CERT0=organizations/peerOrganizations/org3.example.com/peers/peer0.org3.example.com/msp/signcerts/cert.pem
# CERT1=organizations/peerOrganizations/org3.example.com/peers/peer1.org3.example.com/msp/signcerts/cert.pem
# KEY0=organizations/peerOrganizations/org3.example.com/peers/peer0.org3.example.com/msp/keystore/priv_sk
# KEY1=organizations/peerOrganizations/org3.example.com/peers/peer1.org3.example.com/msp/keystore/priv_sk

# echo "$(json_ccp $ORG $P0PORT $P1PORT $CAPORT $PEERPEM $CAPEM $CERT0 $CERT1 $KEY0 $KEY1 )" > organizations/peerOrganizations/org3.example.com/connection-org3.json
# echo "$(yaml_ccp $ORG $P0PORT $P1PORT $CAPORT $PEERPEM $CAPEM $CERT0 $CERT1 $KEY0 $KEY1)" > organizations/peerOrganizations/org3.example.com/connection-org3.yaml

# ORG=4
# P0PORT=11051
# P1PORT=14051
# CAPORT=11054
# PEERPEM=organizations/peerOrganizations/org4.example.com/tlsca/tlsca.org4.example.com-cert.pem
# CAPEM=organizations/peerOrganizations/org4.example.com/ca/ca.org4.example.com-cert.pem
# CERT0=organizations/peerOrganizations/org4.example.com/peers/peer0.org4.example.com/msp/signcerts/cert.pem
# CERT1=organizations/peerOrganizations/org4.example.com/peers/peer1.org4.example.com/msp/signcerts/cert.pem
# KEY0=organizations/peerOrganizations/org4.example.com/peers/peer0.org4.example.com/msp/keystore/priv_sk
# KEY1=organizations/peerOrganizations/org4.example.com/peers/peer1.org4.example.com/msp/keystore/priv_sk

# echo "$(json_ccp $ORG $P0PORT $P1PORT $CAPORT $PEERPEM $CAPEM $CERT0 $CERT1 $KEY0 $KEY1)" > organizations/peerOrganizations/org4.example.com/connection-org4.json
# echo "$(yaml_ccp $ORG $P0PORT $P1PORT $CAPORT $PEERPEM $CAPEM $CERT0 $CERT1 $KEY0 $KEY1)" > organizations/peerOrganizations/org4.example.com/connection-org4.yaml
