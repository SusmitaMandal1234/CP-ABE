#!/bin/bash

function one_line_pem {
    echo "`awk 'NF {sub(/\\n/, ""); printf "%s\\\\\\\n",$0;}' $1`"
}



function one_line_priv {
    echo "`awk 'NF {printf $0;}' $1`"
}

function sample {
    #echo "stm5"
    local PP=$(one_line_pem $5)
    #echo "stm6"
    local CP=$(one_line_pem $6)
    #echo "stm7"
    local CERT0=$(one_line_pem $7)
    #echo "stm8"
    local CERT1=$(one_line_pem $8)
    #echo "stm9"
    local KEY0=$(one_line_pem $9)
    #echo "stm10"
    local KEY1=$(one_line_pem ${10})
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
        ccp-template.json
}
# function json_ccp {
#     echo "stm5"
#     local PP=$(one_line_pem $5)
#     echo "stm6"
#     local CP=$(one_line_pem $6)
#     echo "stm7"
#     local CERT0=$(one_line_pem $7)
#     echo "stm8"
#     local CERT1=$(one_line_pem $8)
#     echo "stm9"
#     local KEY0=$(one_line_pem $9)
#     echo "stm10"
#     local KEY1=$(one_line_pem ${10})
#     sed -e "s/\${ORG}/$1/" \
#         -e "s/\${P0PORT}/$2/" \
#         -e "s/\${P1PORT}/$3/" \
#         -e "s/\${CAPORT}/$4/" \
#         -e "s#\${PEERPEM}#$PP#" \
#         -e "s#\${CAPEM}#$CP#" \
#         -e "s#\${CERT0}#$CERT0#" \
#         -e "s#\${CERT1}#$CERT1#" \
#         -e "s#\${KEY0}#$KEY0#" \
#         -e "s#\${KEY1}#$KEY1#" \
#         test-network/organizations/ccp-template.json
# }

function y_ccp {
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
        ccp-template.yaml | sed -e $'s/\\\\n/\\\n          /g'
}

# function yaml_ccp {
#     local PP=$(one_line_pem $5)
#     local CP=$(one_line_pem $6)
#     local CERT0=$(one_line_pem $7)
#     local CERT1=$(one_line_pem $8)
#     local KEY0=$(one_line_pem $9)
#     local KEY1=$(one_line_pem ${10})
#     # local CERT2=$(one_line_pem ${11})
#     # local CERT3=$(one_line_pem ${12})
#     # local KEY2=$(one_line_pem ${13})
#     # local KEY3=$(one_line_pem ${14})
#     sed -e "s/\${ORG}/$1/" \
#         -e "s/\${P0PORT}/$2/" \
#         -e "s/\${P1PORT}/$3/" \
#         -e "s/\${CAPORT}/$4/" \
#         -e "s#\${PEERPEM}#$PP#" \
#         -e "s#\${CAPEM}#$CP#" \
#         -e "s#\${CERT0}#$CERT0#" \
#         -e "s#\${CERT1}#$CERT1#" \
#         -e "s#\${KEY0}#$KEY0#" \
#         -e "s#\${KEY1}#$KEY1#" \
#         test-network/organizations/ccp-template.yaml | sed -e $'s/\\\\n/\\\n          /g'
# }

ORG=1
P0PORT=7051
P1PORT=8051
P2PORT=8053
P3PORT=8055
CAPORT=7054
PEERPEM=peerOrganizations/org1.example.com/tlsca/tlsca.org1.example.com-cert.pem
CAPEM=peerOrganizations/org1.example.com/ca/ca.org1.example.com-cert.pem
CERT0=peerOrganizations/org1.example.com/peers/peer0.org1.example.com/msp/signcerts/cert.pem
CERT1=peerOrganizations/org1.example.com/peers/peer1.org1.example.com/msp/signcerts/cert.pem
#CERT2=test-network/organizations/peerOrganizations/org1.example.com/peers/peer2.org1.example.com/msp/signcerts/cert.pem
#CERT3=test-network/organizations/peerOrganizations/org1.example.com/peers/peer3.org1.example.com/msp/signcerts/cert.pem
KEY0=peerOrganizations/org1.example.com/peers/peer0.org1.example.com/msp/keystore/priv_sk
KEY1=peerOrganizations/org1.example.com/peers/peer1.org1.example.com/msp/keystore/priv_sk
# KEY2=test-network/organizations/peerOrganizations/org1.example.com/peers/peer2.org1.example.com/msp/keystore/priv_sk
# KEY3=test-network/organizations/peerOrganizations/org1.example.com/peers/peer3.org1.example.com/msp/keystore/priv_sk

#echo "$(sample)"
#echo "$(json_ccp)"
echo "$(sample $ORG $P0PORT $P1PORT $CAPORT $PEERPEM $CAPEM $CERT0 $CERT1 $KEY0 $KEY1)" > peerOrganizations/org1.example.com/connection-org1.json
echo "$(y_ccp $ORG $P0PORT $P1PORT $CAPORT $PEERPEM $CAPEM $CERT0 $CERT1 $KEY0 $KEY1)" > peerOrganizations/org1.example.com/connection-org1.yaml
# echo "$(yaml_ccp $ORG $P0PORT $P1PORT $CAPORT $PEERPEM $CAPEM $CERT0 $CERT1 $KEY0 $KEY1)" > test-network/organizations/peerOrganizations/org1.example.com/connection-org1.yaml

ORG=2
P0PORT=9051
P1PORT=12051
#P2PORT=12053
#P3PORT=12055
CAPORT=8054
PEERPEM=peerOrganizations/org2.example.com/tlsca/tlsca.org2.example.com-cert.pem
CAPEM=peerOrganizations/org2.example.com/ca/ca.org2.example.com-cert.pem
CERT0=peerOrganizations/org2.example.com/peers/peer0.org2.example.com/msp/signcerts/cert.pem
CERT1=peerOrganizations/org2.example.com/peers/peer1.org2.example.com/msp/signcerts/cert.pem
 #CERT2=test-network/organizations/peerOrganizations/org2.example.com/peers/peer2.org2.example.com/msp/signcerts/cert.pem
#CERT3=test-network/organizations/peerOrganizations/org2.example.com/peers/peer3.org2.example.com/msp/signcerts/cert.pem
KEY0=peerOrganizations/org2.example.com/peers/peer0.org2.example.com/msp/keystore/priv_sk
KEY1=peerOrganizations/org2.example.com/peers/peer1.org2.example.com/msp/keystore/priv_sk
# #KEY2=test-network/organizations/peerOrganizations/org2.example.com/peers/peer2.org2.example.com/msp/keystore/priv_sk
# #KEY3=test-network/organizations/peerOrganizations/org2.example.com/peers/peer3.org2.example.com/msp/keystore/priv_sk

# echo "Ravi Kath"
echo "$(sample $ORG $P0PORT $P1PORT $CAPORT $PEERPEM $CAPEM $CERT0 $CERT1 $KEY0 $KEY1)" > peerOrganizations/org2.example.com/connection-org2.json
echo "$(y_ccp $ORG $P0PORT $P1PORT $CAPORT $PEERPEM $CAPEM $CERT0 $CERT1 $KEY0 $KEY1)" > peerOrganizations/org2.example.com/connection-org2.yaml

