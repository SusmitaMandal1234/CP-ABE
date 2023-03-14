#!/bin/bash

function createOrg1() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/org1.example.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/org1.example.com/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:7054 --caname ca-org1 --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-org1.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-org1.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-org1.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-org1.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/peerOrganizations/org1.example.com/msp/config.yaml

  infoln "Registering peer0"
  set -x
  fabric-ca-client register --enrollment.type x509 --id.attrs 'attribute1=Suppliers_Raw_materials:ecert,attribute2=Materials:ecert,attribute3=Electronic_Machinary:ecert,attribute5=Manpower:ecert,attribute9=Sand:ecert,attribute10=Cement:ecert,attribute12=Soils:ecert,attribute13=Cement_concrete:ecert,attribute14=Stone_Aggregates:ecert,attribute15=Bituminous_Materials,attribute16=State_HighWay:ecert,attribute17=Panchayat_Roads:ecert,attribute18=Bridge:ecert' --caname ca-org1 --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering peer1"
  set -x
  fabric-ca-client register --enrollment.type x509 --id.attrs 'attribute1=State_HighWay:ecert,attribute2=Panchayat_Roads:ecert,attribute3=Bridge:ecert,attribute4=Suppliers_Raw_materials:ecert,attribute5=Manpower:ecert,attribute6=Electronic_Machinary:ecert,attribute7=metro:ecert,attribute8=flyover:ecert,attribute9=Sand:ecert,attribute10=Cement:ecert,attribute11=Dust:ecert,attribute12=Soils:ecert,attribute13=Cement_concrete:ecert,attribute14=Stone_Aggregates:ecert,attribute15=Bituminous_Materials' --caname ca-org1 --id.name peer1 --id.secret peer1pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem
  { set +x; } 2>/dev/null

  # infoln "Registering peer2"
  # set -x
  # fabric-ca-client register --enrollment.type x509 --id.attrs 'attribute1=National_Highway:ecert,attribute2=Cement:ecert,attribute3=Cement_concrete:ecert,attribute4=Suppliers_Raw_materials:ecert,attribute5=Electronic_Machinary:ecert,attribute6=Manpower:ecert,attribute9=Sand:ecert,attribute11=Dust:ecert,attribute12=Soils:ecert,attribute14=Stone_Aggregates:ecert,attribute15=Bituminous_Materials:ecert,attribute16=Panchayat_Roads:ecert,attribute17=Bridge:ecert,attr18=State_HighWay:ecert' --caname ca-org1 --id.name peer2 --id.secret peer2pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem
  # { set +x; } 2>/dev/null

  # infoln "Registering peer3"
  # set -x
  # fabric-ca-client register --enrollment.type x509 --id.attrs 'Role=National_Highway:ecert,attribute1=Dust:ecert,attribute2=Soils:ecert,attribute4=State_HighWay:ecert,attribute4=Suppliers_Raw_materials:ecert,attribute5=Manpower:ecert,attribute6=Electronic_Machinary:ecert,attribute9=Sand:ecert,attribute10=Cement:ecert,attribute14=Stone_Aggregates:ecert,attribute15=Bituminous_Materials:ecert' --caname ca-org1 --id.name peer3 --id.secret peer3pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem
  # { set +x; } 2>/dev/nul


  infoln "Registering user"
  set -x
  fabric-ca-client register --caname ca-org1 --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering the org admin"
  set -x
  fabric-ca-client register --caname ca-org1 --id.name org1admin --id.secret org1adminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Generating the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca-org1 -M ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/msp --csr.hosts peer0.org1.example.com --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/org1.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/msp/config.yaml
  #mkdir ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/plugin
  #cp /home/cps16/Documents/New/test-network/config/escc.so ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/plugin/escc.so
  #mkdir ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/config 
  cp "$(find ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/msp/keystore -name "*_sk")" ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/msp/keystore/priv_sk
  #cp /home/cps16/Documents/New/config/core.yaml ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/config/core.yaml


  infoln "Generating the peer1 msp"
  set -x
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:7054 --caname ca-org1 -M ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/msp --csr.hosts peer1.org1.example.com --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/org1.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/msp/config.yaml
  #   mkdir ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/plugin
  # cp /home/cps16/Documents/New/test-network/config/escc.so ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/plugin/escc.so
  #   mkdir ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/config
   
  cp "$(find ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/msp/keystore -name "*_sk")" ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/msp/keystore/priv_sk
  #cp /home/cps16/Documents/New/config/core.yaml ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/config/core.yaml


  # infoln "Generating the peer2 msp"
  # set -x
  # fabric-ca-client enroll -u https://peer2:peer2pw@localhost:7054 --caname ca-org1 -M ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer2.org1.example.com/msp --csr.hosts peer2.org1.example.com --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem
  # { set +x; } 2>/dev/null

  # cp ${PWD}/organizations/peerOrganizations/org1.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer2.org1.example.com/msp/config.yaml
  #   mkdir ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer2.org1.example.com/plugin
  # cp /home/cps16/Documents/New/test-network/config/escc.so ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer2.org1.example.com/plugin/escc.so
  #   mkdir ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer2.org1.example.com/config
   
  # cp "$(find ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer2.org1.example.com/msp/keystore -name "*_sk")" ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer2.org1.example.com/msp/keystore/priv_sk
  # cp /home/cps16/Documents/New/config/core.yaml ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer2.org1.example.com/config/core.yaml

  # infoln "Generating the peer3 msp"
  # set -x
  # fabric-ca-client enroll -u https://peer3:peer3pw@localhost:7054 --caname ca-org1 -M ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer3.org1.example.com/msp --csr.hosts peer3.org1.example.com --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem
  # { set +x; } 2>/dev/null

  # cp ${PWD}/organizations/peerOrganizations/org1.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer3.org1.example.com/msp/config.yaml
  #   mkdir ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer3.org1.example.com/plugin
  # cp /home/cps16/Documents/New/test-network/config/escc.so ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer3.org1.example.com/plugin/escc.so
  #   mkdir ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer3.org1.example.com/config
  # cp "$(find ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer3.org1.example.com/msp/keystore -name "*_sk")" ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer3.org1.example.com/msp/keystore/priv_sk
  # cp /home/cps16/Documents/New/config/core.yaml ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer3.org1.example.com/config/core.yaml

  infoln "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054  --caname ca-org1 -M ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls --enrollment.profile tls --csr.hosts peer0.org1.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/org1.example.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org1.example.com/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/org1.example.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org1.example.com/tlsca/tlsca.org1.example.com-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/org1.example.com/ca
  cp ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/org1.example.com/ca/ca.org1.example.com-cert.pem

  infoln "Generating the peer1-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:7054  --caname ca-org1 -M ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/tls --enrollment.profile tls --csr.hosts peer1.org1.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/org1.example.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org1.example.com/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/org1.example.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org1.example.com/tlsca/tlsca.org1.example.com-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/org1.example.com/ca
  cp ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/org1.example.com/ca/ca.org1.example.com-cert.pem

  # infoln "Generating the peer2-tls certificates"
  # set -x
  # fabric-ca-client enroll -u https://peer2:peer2pw@localhost:7054 --caname ca-org1  -M ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer2.org1.example.com/tls --enrollment.profile tls --csr.hosts peer2.org1.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem
  # { set +x; } 2>/dev/null

  # cp ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer2.org1.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer2.org1.example.com/tls/ca.crt
  # cp ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer2.org1.example.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer2.org1.example.com/tls/server.crt
  # cp ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer2.org1.example.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer2.org1.example.com/tls/server.key

  # mkdir -p ${PWD}/organizations/peerOrganizations/org1.example.com/msp/tlscacerts
  # cp ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer2.org1.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org1.example.com/msp/tlscacerts/ca.crt

  # mkdir -p ${PWD}/organizations/peerOrganizations/org1.example.com/tlsca
  # cp ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer2.org1.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org1.example.com/tlsca/tlsca.org1.example.com-cert.pem

  # mkdir -p ${PWD}/organizations/peerOrganizations/org1.example.com/ca
  # cp ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer2.org1.example.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/org1.example.com/ca/ca.org1.example.com-cert.pem

  # infoln "Generating the peer3-tls certificates"
  # set -x
  # fabric-ca-client enroll -u https://peer3:peer3pw@localhost:7054  --caname ca-org1 -M ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer3.org1.example.com/tls --enrollment.profile tls --csr.hosts peer3.org1.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem
  # { set +x; } 2>/dev/null

  # cp ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer3.org1.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer3.org1.example.com/tls/ca.crt
  # cp ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer3.org1.example.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer3.org1.example.com/tls/server.crt
  # cp ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer3.org1.example.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer3.org1.example.com/tls/server.key

  # mkdir -p ${PWD}/organizations/peerOrganizations/org1.example.com/msp/tlscacerts
  # cp ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer3.org1.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org1.example.com/msp/tlscacerts/ca.crt

  # mkdir -p ${PWD}/organizations/peerOrganizations/org1.example.com/tlsca
  # cp ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer3.org1.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org1.example.com/tlsca/tlsca.org1.example.com-cert.pem

  # mkdir -p ${PWD}/organizations/peerOrganizations/org1.example.com/ca
  # cp ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer3.org1.example.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/org1.example.com/ca/ca.org1.example.com-cert.pem

  infoln "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:7054 --caname ca-org1 -M ${PWD}/organizations/peerOrganizations/org1.example.com/users/User1@org1.example.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/org1.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/org1.example.com/users/User1@org1.example.com/msp/config.yaml

  infoln "Generating the org admin msp"
  set -x
  fabric-ca-client enroll -u https://org1admin:org1adminpw@localhost:7054 --caname ca-org1 -M ${PWD}/organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/org1.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp/config.yaml
  cp "$(find ${PWD}/organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp/keystore -name "*_sk")" ${PWD}/organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp/keystore/priv_sk
}

function createOrg2() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/org2.example.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/org2.example.com/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:8054 --caname ca-org2 --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-org2.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-org2.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-org2.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-org2.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/peerOrganizations/org2.example.com/msp/config.yaml

  infoln "Registering peer0"
  set -x
  fabric-ca-client register --enrollment.type x509 --id.attrs 'attribute1=Suppliers_Raw_materials:ecert,attribute2=Materials:ecert,attribute3=Electronic_Machinary:ecert,attribute5=Manpower:ecert,attribute9=Sand:ecert,attribute10=Cement:ecert,attribute12=Soils:ecert,attribute13=Cement_concrete:ecert,attribute14=Stone_Aggregates:ecert,attribute15=Bituminous_Materials,attribute16=State_HighWay:ecert,attribute17=Panchayat_Roads:ecert,attribute18=Bridge:ecert' --caname ca-org2 --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering peer1"
  set -x
  fabric-ca-client register --enrollment.type x509 --id.attrs 'attribute1=State_HighWay:ecert,attribute2=Panchayat_Roads:ecert,attribute3=Bridge:ecert,attribute4=Suppliers_Raw_materials:ecert,attribute5=Manpower:ecert,attribute6=Electronic_Machinary:ecert,attribute7=metro:ecert,attribute8=flyover:ecert,attribute9=Sand:ecert,attribute10=Cement:ecert,attribute11=Dust:ecert,attribute12=Soils:ecert,attribute13=Cement_concrete:ecert,attribute14=Stone_Aggregates:ecert,attribute15=Bituminous_Materials' --caname ca-org2 --id.name peer1 --id.secret peer1pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
  { set +x; } 2>/dev/null

  # infoln "Registering peer2"
  # set -x
  # fabric-ca-client register --enrollment.type x509 --id.attrs 'attribute1=National_Highway:ecert,attribute2=Cement:ecert,attribute3=Cement_concrete:ecert,attribute4=Suppliers_Raw_materials:ecert,attribute5=Electronic_Machinary:ecert,attribute6=Manpower:ecert,attribute9=Sand:ecert,attribute11=Dust:ecert,attribute12=Soils:ecert,attribute14=Stone_Aggregates:ecert,attribute15=Bituminous_Materials:ecert,attribute16=Panchayat_Roads:ecert,attribute17=Bridge:ecert,attr18=State_HighWay:ecert' --caname ca-org2 --id.name peer2 --id.secret peer2pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
  # { set +x; } 2>/dev/null

  # infoln "Registering peer3"
  # set -x
  # fabric-ca-client register --enrollment.type x509 --id.attrs 'Role=National_Highway:ecert,attribute1=Dust:ecert,attribute2=Soils:ecert,attribute4=State_HighWay:ecert,attribute4=Suppliers_Raw_materials:ecert,attribute5=Manpower:ecert,attribute6=Electronic_Machinary:ecert,attribute9=Sand:ecert,attribute10=Cement:ecert,attribute14=Stone_Aggregates:ecert,attribute15=Bituminous_Materials:ecert' --caname ca-org2 --id.name peer3 --id.secret peer3pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
  # { set +x; } 2>/dev/nul


  infoln "Registering user"
  set -x
  fabric-ca-client register --caname ca-org2 --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering the org admin"
  set -x
  fabric-ca-client register --caname ca-org2 --id.name org2admin --id.secret org2adminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Generating the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca-org2 -M ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/msp --csr.hosts peer0.org2.example.com --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/org2.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/msp/config.yaml
  # mkdir ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/plugin
  # cp /home/cps16/Documents/New/test-network/config/escc.so ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/plugin/escc.so
   
  cp "$(find ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/msp/keystore -name "*_sk")" ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/msp/keystore/priv_sk


  infoln "Generating the peer1 msp"
  set -x
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:8054 --caname ca-org2 -M ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer1.org2.example.com/msp --csr.hosts peer1.org2.example.com --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/org2.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer1.org2.example.com/msp/config.yaml
  # mkdir ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer1.org2.example.com/plugin
  # cp /home/cps16/Documents/New/test-network/config/escc.so ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer1.org2.example.com/plugin/escc.so
   
  cp "$(find ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer1.org2.example.com/msp/keystore -name "*_sk")" ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer1.org2.example.com/msp/keystore/priv_sk

  # infoln "Generating the peer2 msp"
  # set -x
  # fabric-ca-client enroll -u https://peer2:peer2pw@localhost:8054 --caname ca-org2 -M ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer2.org2.example.com/msp --csr.hosts peer2.org2.example.com --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
  # { set +x; } 2>/dev/null

  # cp ${PWD}/organizations/peerOrganizations/org2.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer2.org2.example.com/msp/config.yaml
  # mkdir ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer2.org2.example.com/plugin
  # cp /home/cps16/Documents/New/test-network/config/escc.so ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer2.org2.example.com/plugin/escc.so
  
  # cp "$(find ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer2.org2.example.com/msp/keystore -name "*_sk")" ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer2.org2.example.com/msp/keystore/priv_sk

  # infoln "Generating the peer3 msp"
  # set -x
  # fabric-ca-client enroll -u https://peer3:peer3pw@localhost:8054 --caname ca-org2 -M ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer3.org2.example.com/msp --csr.hosts peer3.org2.example.com --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
  # { set +x; } 2>/dev/null

  # cp ${PWD}/organizations/peerOrganizations/org2.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer3.org2.example.com/msp/config.yaml
  # mkdir ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer3.org2.example.com/plugin
  # cp /home/cps16/Documents/New/test-network/config/escc.so ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer3.org2.example.com/plugin/escc.so
   
  #cp "$(find ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer3.org2.example.com/msp/keystore -name "*_sk")" ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer3.org2.example.com/msp/keystore/priv_sk

  infoln "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca-org2  -M ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls --enrollment.profile tls --csr.hosts peer0.org2.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/org2.example.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org2.example.com/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/org2.example.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org2.example.com/tlsca/tlsca.org2.example.com-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/org2.example.com/ca
  cp ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/org2.example.com/ca/ca.org2.example.com-cert.pem

  infoln "Generating the peer1-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:8054 --caname ca-org2  -M ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer1.org2.example.com/tls --enrollment.profile tls --csr.hosts peer1.org2.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer1.org2.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer1.org2.example.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer1.org2.example.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer1.org2.example.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer1.org2.example.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer1.org2.example.com/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/org2.example.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer1.org2.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org2.example.com/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/org2.example.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer1.org2.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org2.example.com/tlsca/tlsca.org2.example.com-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/org2.example.com/ca
  cp ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer1.org2.example.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/org2.example.com/ca/ca.org2.example.com-cert.pem

  # infoln "Generating the peer2-tls certificates"
  # set -x
  # fabric-ca-client enroll -u https://peer2:peer2pw@localhost:8054  --caname ca-org2 -M ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer2.org2.example.com/tls --enrollment.profile tls --csr.hosts peer2.org2.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
  # { set +x; } 2>/dev/null

  # cp ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer2.org2.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer2.org2.example.com/tls/ca.crt
  # cp ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer2.org2.example.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer2.org2.example.com/tls/server.crt
  # cp ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer2.org2.example.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer2.org2.example.com/tls/server.key

  # mkdir -p ${PWD}/organizations/peerOrganizations/org2.example.com/msp/tlscacerts
  # cp ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer2.org2.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org2.example.com/msp/tlscacerts/ca.crt

  # mkdir -p ${PWD}/organizations/peerOrganizations/org2.example.com/tlsca
  # cp ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer2.org2.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org2.example.com/tlsca/tlsca.org2.example.com-cert.pem

  # mkdir -p ${PWD}/organizations/peerOrganizations/org2.example.com/ca
  # cp ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer2.org2.example.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/org2.example.com/ca/ca.org2.example.com-cert.pem

  # infoln "Generating the peer3-tls certificates"
  # set -x
  # fabric-ca-client enroll -u https://peer3:peer3pw@localhost:8054 --caname ca-org2  -M ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer3.org2.example.com/tls --enrollment.profile tls --csr.hosts peer3.org2.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
  # { set +x; } 2>/dev/null

  # cp ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer3.org2.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer3.org2.example.com/tls/ca.crt
  # cp ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer3.org2.example.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer3.org2.example.com/tls/server.crt
  # cp ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer3.org2.example.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer3.org2.example.com/tls/server.key

  # mkdir -p ${PWD}/organizations/peerOrganizations/org2.example.com/msp/tlscacerts
  # cp ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer3.org2.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org2.example.com/msp/tlscacerts/ca.crt

  # mkdir -p ${PWD}/organizations/peerOrganizations/org2.example.com/tlsca
  # cp ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer3.org2.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org2.example.com/tlsca/tlsca.org2.example.com-cert.pem

  # mkdir -p ${PWD}/organizations/peerOrganizations/org2.example.com/ca
  # cp ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer3.org2.example.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/org2.example.com/ca/ca.org2.example.com-cert.pem



  infoln "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:8054 --caname ca-org2 -M ${PWD}/organizations/peerOrganizations/org2.example.com/users/User1@org2.example.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/org2.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/org2.example.com/users/User1@org2.example.com/msp/config.yaml

  infoln "Generating the org admin msp"
  set -x
  fabric-ca-client enroll -u https://org2admin:org2adminpw@localhost:8054 --caname ca-org2 -M ${PWD}/organizations/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/org2.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp/config.yaml
  cp "$(find ${PWD}/organizations/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp/keystore -name "*_sk")" ${PWD}/organizations/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp/keystore/priv_sk
}

function createOrg3() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/org3.example.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/org3.example.com/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:10054 --caname ca-org3 --tls.certfiles ${PWD}/organizations/fabric-ca/org3/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-10054-ca-org3.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-10054-ca-org3.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-10054-ca-org3.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-10054-ca-org3.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/peerOrganizations/org3.example.com/msp/config.yaml

  infoln "Registering peer0"
  set -x
  fabric-ca-client register --enrollment.type x509 --id.attrs 'Role=Lab_Technician:ecert,Email=peer0.org3.example.com:ecert' --caname ca-org3 --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/org3/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering peer1"
  set -x
  fabric-ca-client register --enrollment.type x509 --id.attrs 'Role=Doctor:ecert,Specialization=Dermatology:ecert,Email=peer1.org3.example.com:ecert' --caname ca-org3 --id.name peer1 --id.secret peer1pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/org3/tls-cert.pem
  { set +x; } 2>/dev/null

  # infoln "Registering peer2"
  # set -x
  # fabric-ca-client register --enrollment.type x509 --id.attrs 'Role=Doctor:ecert,Specialization=Dermatology:ecert,Email=peer2.org3.example.com:ecert' --caname ca-org3 --id.name peer2 --id.secret peer2pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/org3/tls-cert.pem
  # { set +x; } 2>/dev/null

  # infoln "Registering peer3"
  # set -x
  # fabric-ca-client register --enrollment.type x509 --id.attrs 'Role=Doctor:ecert,Specialization=Dermatology:ecert,Email=peer3.org3.example.com:ecert' --caname ca-org3 --id.name peer3 --id.secret peer3pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/org3/tls-cert.pem
  # { set +x; } 2>/dev/null

  infoln "Registering user"
  set -x
  fabric-ca-client register --caname ca-org3 --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/org3/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering the org admin"
  set -x
  fabric-ca-client register --caname ca-org3 --id.name org3admin --id.secret org3adminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/org3/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Generating the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:10054 --caname ca-org3 -M ${PWD}/organizations/peerOrganizations/org3.example.com/peers/peer0.org3.example.com/msp --csr.hosts peer0.org3.example.com --tls.certfiles ${PWD}/organizations/fabric-ca/org3/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/org3.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/org3.example.com/peers/peer0.org3.example.com/msp/config.yaml
    mkdir ${PWD}/organizations/peerOrganizations/org3.example.com/peers/peer0.org3.example.com/plugin
  cp /home/cps16/Documents/New/test-network/config/escc.so ${PWD}/organizations/peerOrganizations/org3.example.com/peers/peer0.org3.example.com/plugin/escc.so
  
  cp "$(find ${PWD}/organizations/peerOrganizations/org3.example.com/peers/peer0.org3.example.com/msp/keystore -name "*_sk")" ${PWD}/organizations/peerOrganizations/org3.example.com/peers/peer0.org3.example.com/msp/keystore/priv_sk

  infoln "Generating the peer1 msp"
  set -x
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:10054 --caname ca-org3 -M ${PWD}/organizations/peerOrganizations/org3.example.com/peers/peer1.org3.example.com/msp --csr.hosts peer1.org3.example.com --tls.certfiles ${PWD}/organizations/fabric-ca/org3/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/org3.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/org3.example.com/peers/peer1.org3.example.com/msp/config.yaml
      mkdir ${PWD}/organizations/peerOrganizations/org3.example.com/peers/peer1.org3.example.com/plugin
  cp /home/cps16/Documents/New/test-network/config/escc.so ${PWD}/organizations/peerOrganizations/org3.example.com/peers/peer1.org3.example.com/plugin/escc.so
 cp $(find ${PWD}/organizations/peerOrganizations/org3.example.com/peers/peer1.org3.example.com/msp/keystore -name "*_sk") ${PWD}/organizations/peerOrganizations/org3.example.com/peers/peer1.org3.example.com/msp/keystore/priv_sk
  
  # infoln "Generating the peer2 msp"
  # set -x
  # fabric-ca-client enroll -u https://peer2:peer2pw@localhost:10054 --caname ca-org3 -M ${PWD}/organizations/peerOrganizations/org3.example.com/peers/peer2.org3.example.com/msp --csr.hosts peer2.org3.example.com --tls.certfiles ${PWD}/organizations/fabric-ca/org3/tls-cert.pem
  # { set +x; } 2>/dev/null

  # cp ${PWD}/organizations/peerOrganizations/org3.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/org3.example.com/peers/peer2.org3.example.com/msp/config.yaml
  #     mkdir ${PWD}/organizations/peerOrganizations/org3.example.com/peers/peer2.org3.example.com/plugin
  # cp /home/cps16/Documents/New/test-network/config/escc.so ${PWD}/organizations/peerOrganizations/org3.example.com/peers/peer2.org3.example.com/plugin/escc.so
  # cp "$(find ${PWD}/organizations/peerOrganizations/org3.example.com/peers/peer2.org3.example.com/msp/keystore -name "*_sk")" ${PWD}/organizations/peerOrganizations/org3.example.com/peers/peer2.org3.example.com/msp/keystore/priv_sk

  # infoln "Generating the peer3 msp"
  # set -x
  # fabric-ca-client enroll -u https://peer3:peer3pw@localhost:10054 --caname ca-org3 -M ${PWD}/organizations/peerOrganizations/org3.example.com/peers/peer3.org3.example.com/msp --csr.hosts peer3.org3.example.com --tls.certfiles ${PWD}/organizations/fabric-ca/org3/tls-cert.pem
  # { set +x; } 2>/dev/null

  # cp ${PWD}/organizations/peerOrganizations/org3.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/org3.example.com/peers/peer3.org3.example.com/msp/config.yaml
  #     mkdir ${PWD}/organizations/peerOrganizations/org3.example.com/peers/peer3.org3.example.com/plugin
  # cp /home/cps16/Documents/New/test-network/config/escc.so ${PWD}/organizations/peerOrganizations/org3.example.com/peers/peer3.org3.example.com/plugin/escc.so
   
  # cp "$(find ${PWD}/organizations/peerOrganizations/org3.example.com/peers/peer3.org3.example.com/msp/keystore -name "*_sk")" ${PWD}/organizations/peerOrganizations/org3.example.com/peers/peer3.org3.example.com/msp/keystore/priv_sk
  
  infoln "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:10054  --caname ca-org3 -M ${PWD}/organizations/peerOrganizations/org3.example.com/peers/peer0.org3.example.com/tls --enrollment.profile tls --csr.hosts peer0.org3.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/org3/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/org3.example.com/peers/peer0.org3.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org3.example.com/peers/peer0.org3.example.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/org3.example.com/peers/peer0.org3.example.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/org3.example.com/peers/peer0.org3.example.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/org3.example.com/peers/peer0.org3.example.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/org3.example.com/peers/peer0.org3.example.com/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/org3.example.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/org3.example.com/peers/peer0.org3.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org3.example.com/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/org3.example.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/org3.example.com/peers/peer0.org3.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org3.example.com/tlsca/tlsca.org3.example.com-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/org3.example.com/ca
  cp ${PWD}/organizations/peerOrganizations/org3.example.com/peers/peer0.org3.example.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/org3.example.com/ca/ca.org3.example.com-cert.pem

  infoln "Generating the peer1-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:10054  --caname ca-org3 -M ${PWD}/organizations/peerOrganizations/org3.example.com/peers/peer1.org3.example.com/tls --enrollment.profile tls --csr.hosts peer1.org3.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/org3/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/org3.example.com/peers/peer1.org3.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org3.example.com/peers/peer1.org3.example.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/org3.example.com/peers/peer1.org3.example.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/org3.example.com/peers/peer1.org3.example.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/org3.example.com/peers/peer1.org3.example.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/org3.example.com/peers/peer1.org3.example.com/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/org3.example.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/org3.example.com/peers/peer1.org3.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org3.example.com/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/org3.example.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/org3.example.com/peers/peer1.org3.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org3.example.com/tlsca/tlsca.org3.example.com-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/org3.example.com/ca
  cp ${PWD}/organizations/peerOrganizations/org3.example.com/peers/peer1.org3.example.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/org3.example.com/ca/ca.org3.example.com-cert.pem

  # infoln "Generating the peer2-tls certificates"
  # set -x
  # fabric-ca-client enroll -u https://peer2:peer2pw@localhost:10054  --caname ca-org3 -M ${PWD}/organizations/peerOrganizations/org3.example.com/peers/peer2.org3.example.com/tls --enrollment.profile tls --csr.hosts peer2.org3.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/org3/tls-cert.pem
  # { set +x; } 2>/dev/null

  # cp ${PWD}/organizations/peerOrganizations/org3.example.com/peers/peer2.org3.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org3.example.com/peers/peer2.org3.example.com/tls/ca.crt
  # cp ${PWD}/organizations/peerOrganizations/org3.example.com/peers/peer2.org3.example.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/org3.example.com/peers/peer2.org3.example.com/tls/server.crt
  # cp ${PWD}/organizations/peerOrganizations/org3.example.com/peers/peer2.org3.example.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/org3.example.com/peers/peer2.org3.example.com/tls/server.key

  # mkdir -p ${PWD}/organizations/peerOrganizations/org3.example.com/msp/tlscacerts
  # cp ${PWD}/organizations/peerOrganizations/org3.example.com/peers/peer2.org3.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org3.example.com/msp/tlscacerts/ca.crt

  # mkdir -p ${PWD}/organizations/peerOrganizations/org3.example.com/tlsca
  # cp ${PWD}/organizations/peerOrganizations/org3.example.com/peers/peer2.org3.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org3.example.com/tlsca/tlsca.org3.example.com-cert.pem

  # mkdir -p ${PWD}/organizations/peerOrganizations/org3.example.com/ca
  # cp ${PWD}/organizations/peerOrganizations/org3.example.com/peers/peer2.org3.example.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/org3.example.com/ca/ca.org3.example.com-cert.pem

  #  infoln "Generating the peer3-tls certificates"
  # set -x
  # fabric-ca-client enroll -u https://peer3:peer3pw@localhost:10054 --caname ca-org3  -M ${PWD}/organizations/peerOrganizations/org3.example.com/peers/peer3.org3.example.com/tls --enrollment.profile tls --csr.hosts peer3.org3.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/org3/tls-cert.pem
  # { set +x; } 2>/dev/null

  # cp ${PWD}/organizations/peerOrganizations/org3.example.com/peers/peer3.org3.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org3.example.com/peers/peer3.org3.example.com/tls/ca.crt
  # cp ${PWD}/organizations/peerOrganizations/org3.example.com/peers/peer3.org3.example.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/org3.example.com/peers/peer3.org3.example.com/tls/server.crt
  # cp ${PWD}/organizations/peerOrganizations/org3.example.com/peers/peer3.org3.example.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/org3.example.com/peers/peer3.org3.example.com/tls/server.key

  # mkdir -p ${PWD}/organizations/peerOrganizations/org3.example.com/msp/tlscacerts
  # cp ${PWD}/organizations/peerOrganizations/org3.example.com/peers/peer3.org3.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org3.example.com/msp/tlscacerts/ca.crt

  # mkdir -p ${PWD}/organizations/peerOrganizations/org3.example.com/tlsca
  # cp ${PWD}/organizations/peerOrganizations/org3.example.com/peers/peer3.org3.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org3.example.com/tlsca/tlsca.org3.example.com-cert.pem

  # mkdir -p ${PWD}/organizations/peerOrganizations/org3.example.com/ca
  # cp ${PWD}/organizations/peerOrganizations/org3.example.com/peers/peer3.org3.example.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/org3.example.com/ca/ca.org3.example.com-cert.pem

  infoln "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:10054 --caname ca-org3 -M ${PWD}/organizations/peerOrganizations/org3.example.com/users/User1@org3.example.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/org3/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/org3.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/org3.example.com/users/User1@org3.example.com/msp/config.yaml

  infoln "Generating the org admin msp"
  set -x
  fabric-ca-client enroll -u https://org3admin:org3adminpw@localhost:10054 --caname ca-org3 -M ${PWD}/organizations/peerOrganizations/org3.example.com/users/Admin@org3.example.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/org3/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/org3.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/org3.example.com/users/Admin@org3.example.com/msp/config.yaml
  cp "$(find ${PWD}/organizations/peerOrganizations/org3.example.com/users/Admin@org3.example.com/msp/keystore -name "*_sk")" ${PWD}/organizations/peerOrganizations/org3.example.com/users/Admin@org3.example.com/msp/keystore/priv_sk
}

function createOrg4() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/org4.example.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/org4.example.com/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:11054 --caname ca-org4 --tls.certfiles ${PWD}/organizations/fabric-ca/org4/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-11054-ca-org4.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-11054-ca-org4.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-11054-ca-org4.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-11054-ca-org4.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/peerOrganizations/org4.example.com/msp/config.yaml

  infoln "Registering peer0"
  set -x
  fabric-ca-client register --enrollment.type x509 --id.attrs 'Role=Admin:ecert,Email=peer0.org4.example.com:ecert' --caname ca-org4 --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/org4/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering peer1"
  set -x
  fabric-ca-client register --enrollment.type x509  --id.attrs 'Role=Doctor:ecert,Specialization=Pediatrics:ecert,Email=peer1.org4.example.com:ecert' --caname ca-org4 --id.name peer1 --id.secret peer1pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/org4/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering peer2"
  set -x
  fabric-ca-client register --enrollment.type x509 --id.attrs 'Role=Admin:ecert,Email=peer2.org4.example.com:ecert' --caname ca-org4 --id.name peer2 --id.secret peer2pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/org4/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering peer3"
  set -x
  fabric-ca-client register --enrollment.type x509  --id.attrs 'Role=Doctor:ecert,Specialization=Pediatrics:ecert,Email=peer3.org4.example.com:ecert' --caname ca-org4 --id.name peer3 --id.secret peer3pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/org4/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering user"
  set -x
  fabric-ca-client register --caname ca-org4 --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/org4/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering the org admin"
  set -x
  fabric-ca-client register --caname ca-org4 --id.name org4admin --id.secret org4adminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/org4/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Generating the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:11054 --caname ca-org4 -M ${PWD}/organizations/peerOrganizations/org4.example.com/peers/peer0.org4.example.com/msp --csr.hosts peer0.org4.example.com --tls.certfiles ${PWD}/organizations/fabric-ca/org4/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/org4.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/org4.example.com/peers/peer0.org4.example.com/msp/config.yaml
      mkdir ${PWD}/organizations/peerOrganizations/org4.example.com/peers/peer0.org4.example.com/plugin
  cp /home/cps16/Documents/New/test-network/config/escc.so ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org4.example.com/plugin/escc.so
  cp "$(find ${PWD}/organizations/peerOrganizations/org4.example.com/peers/peer0.org4.example.com/msp/keystore -name "*_sk")" ${PWD}/organizations/peerOrganizations/org4.example.com/peers/peer0.org4.example.com/msp/keystore/priv_sk

  infoln "Generating the peer1 msp"
  set -x
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:11054 --caname ca-org4 -M ${PWD}/organizations/peerOrganizations/org4.example.com/peers/peer1.org4.example.com/msp --csr.hosts peer1.org4.example.com --tls.certfiles ${PWD}/organizations/fabric-ca/org4/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/org4.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/org4.example.com/peers/peer1.org4.example.com/msp/config.yaml
        mkdir ${PWD}/organizations/peerOrganizations/org4.example.com/peers/peer1.org4.example.com/plugin
  cp /home/cps16/Documents/New/test-network/config/escc.so ${PWD}/organizations/peerOrganizations/org4.example.com/peers/peer1.org4.example.com/plugin/escc.so

  cp "$(find ${PWD}/organizations/peerOrganizations/org4.example.com/peers/peer1.org4.example.com/msp/keystore -name "*_sk")" ${PWD}/organizations/peerOrganizations/org4.example.com/peers/peer1.org4.example.com/msp/keystore/priv_sk
  
  infoln "Generating the peer2 msp"
  set -x
  fabric-ca-client enroll -u https://peer2:peer2pw@localhost:11054 --caname ca-org4 -M ${PWD}/organizations/peerOrganizations/org4.example.com/peers/peer2.org4.example.com/msp --csr.hosts peer2.org4.example.com --tls.certfiles ${PWD}/organizations/fabric-ca/org4/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/org4.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/org4.example.com/peers/peer2.org4.example.com/msp/config.yaml
        mkdir ${PWD}/organizations/peerOrganizations/org4.example.com/peers/peer2.org4.example.com/plugin
  cp /home/cps16/Documents/New/test-network/config/escc.so ${PWD}/organizations/peerOrganizations/org4.example.com/peers/peer2.org4.example.com/plugin/escc.so
  cp "$(find ${PWD}/organizations/peerOrganizations/org4.example.com/peers/peer2.org4.example.com/msp/keystore -name "*_sk")" ${PWD}/organizations/peerOrganizations/org4.example.com/peers/peer2.org4.example.com/msp/keystore/priv_sk

  infoln "Generating the peer3 msp"
  set -x
  fabric-ca-client enroll -u https://peer3:peer3pw@localhost:11054 --caname ca-org4 -M ${PWD}/organizations/peerOrganizations/org4.example.com/peers/peer3.org4.example.com/msp --csr.hosts peer3.org4.example.com --tls.certfiles ${PWD}/organizations/fabric-ca/org4/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/org4.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/org4.example.com/peers/peer3.org4.example.com/msp/config.yaml
  mkdir ${PWD}/organizations/peerOrganizations/org4.example.com/peers/peer3.org4.example.com/plugin
  cp /home/cps16/Documents/New/test-network/config/escc.so ${PWD}/organizations/peerOrganizations/org4.example.com/peers/peer3.org4.example.com/plugin/escc.so
  cp "$(find ${PWD}/organizations/peerOrganizations/org4.example.com/peers/peer3.org4.example.com/msp/keystore -name "*_sk")" ${PWD}/organizations/peerOrganizations/org4.example.com/peers/peer3.org4.example.com/msp/keystore/priv_sk

  infoln "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:11054  --caname ca-org4 -M ${PWD}/organizations/peerOrganizations/org4.example.com/peers/peer0.org4.example.com/tls --enrollment.profile tls --csr.hosts peer0.org4.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/org4/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/org4.example.com/peers/peer0.org4.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org4.example.com/peers/peer0.org4.example.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/org4.example.com/peers/peer0.org4.example.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/org4.example.com/peers/peer0.org4.example.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/org4.example.com/peers/peer0.org4.example.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/org4.example.com/peers/peer0.org4.example.com/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/org4.example.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/org4.example.com/peers/peer0.org4.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org4.example.com/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/org4.example.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/org4.example.com/peers/peer0.org4.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org4.example.com/tlsca/tlsca.org4.example.com-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/org4.example.com/ca
  cp ${PWD}/organizations/peerOrganizations/org4.example.com/peers/peer0.org4.example.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/org4.example.com/ca/ca.org4.example.com-cert.pem

  infoln "Generating the peer1-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:11054 --caname ca-org4  -M ${PWD}/organizations/peerOrganizations/org4.example.com/peers/peer1.org4.example.com/tls --enrollment.profile tls --csr.hosts peer1.org4.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/org4/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/org4.example.com/peers/peer1.org4.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org4.example.com/peers/peer1.org4.example.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/org4.example.com/peers/peer1.org4.example.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/org4.example.com/peers/peer1.org4.example.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/org4.example.com/peers/peer1.org4.example.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/org4.example.com/peers/peer1.org4.example.com/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/org4.example.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/org4.example.com/peers/peer1.org4.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org4.example.com/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/org4.example.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/org4.example.com/peers/peer1.org4.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org4.example.com/tlsca/tlsca.org4.example.com-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/org4.example.com/ca
  cp ${PWD}/organizations/peerOrganizations/org4.example.com/peers/peer1.org4.example.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/org4.example.com/ca/ca.org4.example.com-cert.pem

  infoln "Generating the peer2-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer2:peer2pw@localhost:11054  --caname ca-org4 -M ${PWD}/organizations/peerOrganizations/org4.example.com/peers/peer2.org4.example.com/tls --enrollment.profile tls --csr.hosts peer2.org4.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/org4/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/org4.example.com/peers/peer2.org4.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org4.example.com/peers/peer2.org4.example.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/org4.example.com/peers/peer2.org4.example.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/org4.example.com/peers/peer2.org4.example.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/org4.example.com/peers/peer2.org4.example.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/org4.example.com/peers/peer2.org4.example.com/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/org4.example.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/org4.example.com/peers/peer2.org4.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org4.example.com/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/org4.example.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/org4.example.com/peers/peer2.org4.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org4.example.com/tlsca/tlsca.org4.example.com-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/org4.example.com/ca
  cp ${PWD}/organizations/peerOrganizations/org4.example.com/peers/peer2.org4.example.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/org4.example.com/ca/ca.org4.example.com-cert.pem

  infoln "Generating the peer3-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer3:peer3pw@localhost:11054 --caname ca-org4  -M ${PWD}/organizations/peerOrganizations/org4.example.com/peers/peer3.org4.example.com/tls --enrollment.profile tls --csr.hosts peer3.org4.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/org4/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/org4.example.com/peers/peer3.org4.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org4.example.com/peers/peer3.org4.example.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/org4.example.com/peers/peer3.org4.example.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/org4.example.com/peers/peer3.org4.example.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/org4.example.com/peers/peer3.org4.example.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/org4.example.com/peers/peer3.org4.example.com/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/org4.example.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/org4.example.com/peers/peer3.org4.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org4.example.com/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/org4.example.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/org4.example.com/peers/peer3.org4.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org4.example.com/tlsca/tlsca.org4.example.com-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/org4.example.com/ca
  cp ${PWD}/organizations/peerOrganizations/org4.example.com/peers/peer3.org4.example.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/org4.example.com/ca/ca.org4.example.com-cert.pem

  infoln "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:11054 --caname ca-org4 -M ${PWD}/organizations/peerOrganizations/org4.example.com/users/User1@org4.example.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/org4/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/org4.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/org4.example.com/users/User1@org4.example.com/msp/config.yaml

  infoln "Generating the org admin msp"
  set -x
  fabric-ca-client enroll -u https://org4admin:org4adminpw@localhost:11054 --caname ca-org4 -M ${PWD}/organizations/peerOrganizations/org4.example.com/users/Admin@org4.example.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/org4/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/org4.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/org4.example.com/users/Admin@org4.example.com/msp/config.yaml
  cp "$(find ${PWD}/organizations/peerOrganizations/org4.example.com/users/Admin@org4.example.com/msp/keystore -name "*_sk")" ${PWD}/organizations/peerOrganizations/org4.example.com/users/Admin@org4.example.com/msp/keystore/priv_sk
}

function createOrderer() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/ordererOrganizations/example.com

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/ordererOrganizations/example.com

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:9054 --caname ca-orderer --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/ordererOrganizations/example.com/msp/config.yaml

  infoln "Registering orderer 1"
  set -x
  fabric-ca-client register --id.attrs 'Role=Admin:ecert'  --caname ca-orderer --id.name orderer1 --id.secret orderer1pw --id.type orderer --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering orderer 2"
  set -x
  fabric-ca-client register --id.attrs 'Role=Admin:ecert'  --caname ca-orderer --id.name orderer2 --id.secret orderer2pw --id.type orderer --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering orderer 3"
  set -x
  fabric-ca-client register --id.attrs 'Role=Admin:ecert'  --caname ca-orderer --id.name orderer3 --id.secret orderer3pw --id.type orderer --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  # infoln "Registering orderer 4"
  # set -x
  # fabric-ca-client register --id.attrs 'Role=Admin:ecert'  --caname ca-orderer --id.name orderer4 --id.secret orderer4pw --id.type orderer --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  # { set +x; } 2>/dev/null

  # infoln "Registering orderer 5"
  # set -x
  # fabric-ca-client register --id.attrs 'Role=Admin:ecert'  --caname ca-orderer --id.name orderer5 --id.secret orderer5pw --id.type orderer --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  # { set +x; } 2>/dev/null


  infoln "Registering the orderer admin"
  set -x
  fabric-ca-client register --caname ca-orderer --id.name ordererAdmin --id.secret ordererAdminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Generating the orderer 1 msp"
  set -x
  fabric-ca-client enroll -u https://orderer1:orderer1pw@localhost:9054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer1.example.com/msp --csr.hosts orderer1.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Generating the orderer 2 msp"
  set -x
  fabric-ca-client enroll -u https://orderer2:orderer2pw@localhost:9054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer2.example.com/msp --csr.hosts orderer2.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Generating the orderer 3 msp"
  set -x
  fabric-ca-client enroll -u https://orderer3:orderer3pw@localhost:9054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer3.example.com/msp --csr.hosts orderer3.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  #  infoln "Generating the orderer 4 msp"
  # set -x
  # fabric-ca-client enroll -u https://orderer4:orderer4pw@localhost:9054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer4.example.com/msp --csr.hosts orderer4.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  # { set +x; } 2>/dev/null

  #  infoln "Generating the orderer 5 msp"
  # set -x
  # fabric-ca-client enroll -u https://orderer5:orderer5pw@localhost:9054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer5.example.com/msp --csr.hosts orderer5.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  # { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/example.com/msp/config.yaml ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer1.example.com/msp/config.yaml
  cp ${PWD}/organizations/ordererOrganizations/example.com/msp/config.yaml ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer2.example.com/msp/config.yaml
  cp ${PWD}/organizations/ordererOrganizations/example.com/msp/config.yaml ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer3.example.com/msp/config.yaml
  # cp ${PWD}/organizations/ordererOrganizations/example.com/msp/config.yaml ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer4.example.com/msp/config.yaml
  # cp ${PWD}/organizations/ordererOrganizations/example.com/msp/config.yaml ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer5.example.com/msp/config.yaml

  infoln "Generating the orderer1-tls certificates"
  set -x
  fabric-ca-client enroll -u https://orderer1:orderer1pw@localhost:9054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer1.example.com/tls --enrollment.profile tls --csr.hosts orderer1.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer1.example.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer1.example.com/tls/ca.crt
  cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer1.example.com/tls/signcerts/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer1.example.com/tls/server.crt
  cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer1.example.com/tls/keystore/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer1.example.com/tls/server.key

  mkdir -p ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer1.example.com/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer1.example.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer1.example.com/msp/tlscacerts/tlsca.example.com-cert.pem

  mkdir -p ${PWD}/organizations/ordererOrganizations/example.com/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer1.example.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/example.com/msp/tlscacerts/tlsca.example.com-cert.pem

  infoln "Generating the orderer2-tls certificates"
  set -x
  fabric-ca-client enroll -u https://orderer2:orderer2pw@localhost:9054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer2.example.com/tls --enrollment.profile tls --csr.hosts orderer2.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer2.example.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer2.example.com/tls/ca.crt
  cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer2.example.com/tls/signcerts/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer2.example.com/tls/server.crt
  cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer2.example.com/tls/keystore/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer2.example.com/tls/server.key

  mkdir -p ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer2.example.com/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer2.example.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer2.example.com/msp/tlscacerts/tlsca.example.com-cert.pem

  mkdir -p ${PWD}/organizations/ordererOrganizations/example.com/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer2.example.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/example.com/msp/tlscacerts/tlsca.example.com-cert.pem

  infoln "Generating the orderer3-tls certificates"
  set -x
  fabric-ca-client enroll -u https://orderer3:orderer3pw@localhost:9054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer3.example.com/tls --enrollment.profile tls --csr.hosts orderer3.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer3.example.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer3.example.com/tls/ca.crt
  cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer3.example.com/tls/signcerts/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer3.example.com/tls/server.crt
  cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer3.example.com/tls/keystore/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer3.example.com/tls/server.key

  mkdir -p ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer3.example.com/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer3.example.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer3.example.com/msp/tlscacerts/tlsca.example.com-cert.pem

  mkdir -p ${PWD}/organizations/ordererOrganizations/example.com/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer3.example.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/example.com/msp/tlscacerts/tlsca.example.com-cert.pem


  # infoln "Generating the orderer4-tls certificates"
  # set -x
  # fabric-ca-client enroll -u https://orderer4:orderer4pw@localhost:9054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer4.example.com/tls --enrollment.profile tls --csr.hosts orderer4.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  # { set +x; } 2>/dev/null

  # cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer4.example.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer4.example.com/tls/ca.crt
  # cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer4.example.com/tls/signcerts/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer4.example.com/tls/server.crt
  # cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer4.example.com/tls/keystore/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer4.example.com/tls/server.key

  # mkdir -p ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer4.example.com/msp/tlscacerts
  # cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer4.example.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer4.example.com/msp/tlscacerts/tlsca.example.com-cert.pem

  # mkdir -p ${PWD}/organizations/ordererOrganizations/example.com/msp/tlscacerts
  # cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer4.example.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/example.com/msp/tlscacerts/tlsca.example.com-cert.pem


  # infoln "Generating the orderer5-tls certificates"
  # set -x
  # fabric-ca-client enroll -u https://orderer5:orderer5pw@localhost:9054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer5.example.com/tls --enrollment.profile tls --csr.hosts orderer5.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  # { set +x; } 2>/dev/null

  # cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer5.example.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer5.example.com/tls/ca.crt
  # cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer5.example.com/tls/signcerts/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer5.example.com/tls/server.crt
  # cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer5.example.com/tls/keystore/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer5.example.com/tls/server.key

  # mkdir -p ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer5.example.com/msp/tlscacerts
  # cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer5.example.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer5.example.com/msp/tlscacerts/tlsca.example.com-cert.pem

  # mkdir -p ${PWD}/organizations/ordererOrganizations/example.com/msp/tlscacerts
  # cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer5.example.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/example.com/msp/tlscacerts/tlsca.example.com-cert.pem

  infoln "Generating the admin msp"
  set -x
  fabric-ca-client enroll -u https://ordererAdmin:ordererAdminpw@localhost:9054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/example.com/users/Admin@example.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/example.com/msp/config.yaml ${PWD}/organizations/ordererOrganizations/example.com/users/Admin@example.com/msp/config.yaml
}
