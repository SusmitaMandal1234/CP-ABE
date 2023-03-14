const express = require('express')
const app = express()
const fs = require('fs')
const crypto = require('crypto')

const { FileSystemWallet, Gateway, Wallets, DefaultQueryHandlerStrategies  } = require('fabric-network');
const {QueryHandler, QueryHandlerFactory, Query, QueryResults, ServiceHandler} = require('fabric-network');
//const {libuv} = require('libuv');

const path = require('path');
const FabricCAServices = require('fabric-ca-client');
const { json, query } = require('express');
const {endorser} = require('fabric-common');
//const { createQueryHandler }  = require('../javascript/MyQueryHandler');
const { channel, Channel } = require('diagnostics_channel');
const { QueryImpl } = require('fabric-network/lib/impl/query/query');
const { transcode } = require('buffer');
const { TransactionEventHandler } = require('fabric-network/lib/impl/event/transactioneventhandler');
const { TransactionEventStrategy } = require('fabric-network/lib/impl/event/transactioneventstrategy');

const {Network} = require('fabric-network');
const {DiscoveryService, IdentityContext, Client, Discoverer} = require('fabric-common');
//const {couchdb} = require('couchdb');
const { publicEncrypt } = require('crypto');

//const ccpPath = path.resolve(__dirname, '..', '..', 'first-network', 'connection-org1.json');
//const ccpPath = path.resolve(__dirname, '..', '..', 'first-network', 'connection-org1.json');
const ccpPath = path.resolve(__dirname, '..', '..', 'test-network','organizations', 'peerOrganizations', 'org1.example.com','connection-org1.json');
const ccp = JSON.parse(fs.readFileSync(ccpPath, 'utf8'));
const caInfo = ccp.certificateAuthorities['ca.org1.example.com'];
const mspId = ccp.organizations['Org1'].mspid;
const ca = new FabricCAServices(caInfo.url, { trustedRoots: caInfo.tlsCACerts.pem, verify: false }, caInfo.caName);

const ccpPath2 = path.resolve(__dirname, '..', '..', 'test-network','organizations', 'peerOrganizations', 'org2.example.com','connection-org2.json');
const ccp2 = JSON.parse(fs.readFileSync(ccpPath2, 'utf8'));
const caInfo2 = ccp2.certificateAuthorities['ca.org2.example.com'];
const mspId2 = ccp2.organizations['Org2'].mspid;
const ca2 = new FabricCAServices(caInfo2.url, { trustedRoots: caInfo2.tlsCACerts.pem, verify: false }, caInfo2.caName);

// const ccpPath3 = path.resolve(__dirname, '..', '..', 'test-network','organizations', 'peerOrganizations', 'org3.example.com','connection-org3.json');
// const ccp3 = JSON.parse(fs.readFileSync(ccpPath3, 'utf8'));
// const caInfo3 = ccp3.certificateAuthorities['ca.org3.example.com'];
// const mspId3 = ccp3.organizations['Org3'].mspid;
// const ca3 = new FabricCAServices(caInfo3.url, { trustedRoots: caInfo3.tlsCACerts.pem, verify: false }, caInfo3.caName);

// const ccpPath4 = path.resolve(__dirname, '..', '..', 'test-network','organizations', 'peerOrganizations', 'org4.example.com','connection-org4.json');
// const ccp4 = JSON.parse(fs.readFileSync(ccpPath4, 'utf8'));
// const caInfo4 = ccp4.certificateAuthorities['ca.org4.example.com'];
// const mspId4 = ccp4.organizations['Org4'].mspid;
// const ca4 = new FabricCAServices(caInfo4.url, { trustedRoots: caInfo4.tlsCACerts.pem, verify: false }, caInfo4.caName);

class SampleQueryHandler  {
  peers = [];

  constructor(peers) {
     this.peers = peers;
 }

   async evaluate(query) {
     const errorMessages = [];
     
      this.peers.forEach(peer =>  {
      //const results = await query.evaluate([peer]);
      //const result = results[peer.name];
      // if (result.status == 500) {
      //     errorMessages.push(result.toString());
      // } 
      // else {
          //if (result.isEndorsed) {
              return result.payload;
          //}
          //throw new Error(result.message);
      //}
      //console.log("this is working");
     })
     
     const message = util.format('Query failed. Errors: %j', errorMessages);
     throw new Error(message);
 }
}

// function createQueryHandler(network) {
//  //const mspId = network.getGateway().getIdentity().mspId;
//  const channel = network.getChannel('mychannel');
//  const orgPeers = channel.getEndorsers('Org1MSP');
//  //const otherPeers = channel.getEndorsers().filter((peer) => !orgPeers.includes(peer));
//  //const allPeers = orgPeers.concat(otherPeers);
//  return new SampleQueryHandler(orgPeers);
// };


// const connectOptions =  {
//   query: {
//       timeout: 3, // timeout in seconds (optional will default to 3)
//       strategy: createQueryHandler
//   }
// }




let caName = null;
// CORS Origin
app.use(function (req, res, next) {
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE');
  res.setHeader('Access-Control-Allow-Headers', 'Origin, X-Requested-With, Content-Type, Accept, Authorization');
  //res.setHeader("Origin", "Content-Type", "Accept", "Authorization", "Access-Control-Request-Allow-Origin", "Access-Control-Allow-Credentials");
  res.setHeader('Access-Control-Allow-Credentials', true);
  next();
});


app.use(express.json());


app.get('/cars/:carNumber', async (req, res) => {
  try {
    const walletPath = path.join(process.cwd(), 'wallet');
    const wallet = await Wallets.newFileSystemWallet(walletPath);
    const userExists = await wallet.get('appUser2');
    if (!userExists) {
      res.json({status: false, error: {message: 'User not exist in the wallet'}});
      return;
    }
      const gateway = new Gateway();
      await gateway.connect(ccp, { wallet, identity: 'appUser2', discovery: { enabled: true, asLocalhost: true } });
      const network = await gateway.getNetwork('mychannel');
      
      const contract = network.getContract('LC-Transfer');
      const result = await contract.evaluateTransaction('QueryCar',req.params.carNumber);
      console.log(result.toString());

      //const contract2 = network.getContract('connectionLayer4');
      //const result2 = await contract2.submitTransaction('Invoke', 'healthwork', req.params.email);
      console.log('result:' + result.toString());

      res.json({status: true, patient: JSON.parse(result.toString())});
    }catch (err) {
    res.json({status: false, error: err});
  }
});






app.listen(3000, () => {
  console.log('REST Server listening on port 3000');
});
