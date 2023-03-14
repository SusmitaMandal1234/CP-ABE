/*
 * Copyright IBM Corp. All Rights Reserved.
 *
 * SPDX-License-Identifier: Apache-2.0
 */

'use strict';

const { Gateway, Wallets, HsmX509Provider, Transaction,QueryHandlerFactory, DefaultQueryHandlerStrategies } = require('fabric-network');
const {DiscoveryService, IdentityContext, Client, Discoverer} = require('fabric-common');
const path = require('path');
const fs = require('fs');
const FabricCAServices = require('fabric-ca-client');
const { networkInterfaces } = require('os');
// const crypto = require('crypto');
const { query } = require('express');
const { channel } = require('diagnostics_channel');
const { fail } = require('assert');
const { decode } = require('querystring');
const { TextDecoder } = require('util');
const openssl = require('openssl');
const { StringDecoder } = require('string_decoder');
const Endorser = require('fabric-common');
const crypto = require("crypto")
const { syncBuiltinESMExports } = require('module');
const child_process = require('child_process');
const { count, time } = require('console');

//const { json } = require('stream/consumers');
//const { json } = require('node:stream/consumers');
//const { json } = require('stream/consumers');

//const ClientIdentity = require('fabric-shim').ClientIdentity;

async function main() {
    try {

        // load the network configuration
        const ccpPath = path.resolve(__dirname, '..', '..', 'test-network', 'organizations', 'peerOrganizations', 'org2.example.com', 'connection-org2.json');
        const ccp = JSON.parse(fs.readFileSync(ccpPath, 'utf8'));
        console.log(1)

        console.log(2)
        // Create a new file system based wallet for managing identities.
        const walletPath = path.join(process.cwd(), 'wallet','Org2');
        const wallet = await Wallets.newFileSystemWallet(walletPath);
        console.log(`Wallet path: ${walletPath}`);
        console.log(3)
        // Check to see if we've already enrolled the user.
        const identity = await wallet.get('admin');
        if (!identity) {
            console.log('An identity for the user "appUser" does not exist in the wallet');
            console.log('Run the registerUser.js application before retrying');
            return;
        }

        // Create a new gateway for connecting to our peer node.
        const gateway = new Gateway();
        await gateway.connect(ccp, { wallet, identity: 'admin', discovery: { enabled: true, asLocalhost: true } });
        console.log(4)
        // Get the network (channel) our contract is deployed to.
        const network = await gateway.getNetwork('mychannel');
        
        const caURL = ccp.certificateAuthorities['ca.org2.example.com'].url;
        const ca = new FabricCAServices(caURL);
        console.log(5)
        const provider = wallet.getProviderRegistry().getProvider('X.509');
        const adminIdentity = await wallet.get('admin');

        const adminUser = await provider.getUserContext(adminIdentity, 'admin');
        const appUserIdentity = await wallet.get('appUser2');
        console.log(6)

        const newAppUser = await provider.getUserContext(appUserIdentity, 'appUser2');
        const identityService = ca.newIdentityService();
            
        // Get the contract from the network.
        let channel = network.getChannel();
        let chaincode_id = "LC-Transfer"
        const contract = network.getContract(chaincode_id);

        const id = crypto.randomBytes(16).toString("hex")
        
        const discovery = new DiscoveryService(chaincode_id, network.getChannel());
        //discovery.targets = endorsers;
        const userContext = await provider.getUserContext(appUserIdentity, "appUser");
        
        const discoverer = new Discoverer("appUser", network.getChannel().client, 'Org1MSP');
        //console.log("endorser", endorsers[0].name)
        await discoverer.connect(channel.getEndorsers()[0].endpoint);
       
        let endorsement = channel.newEndorsement(chaincode_id);

        discovery.build(new IdentityContext(userContext, network.getChannel().client), {endorsement: endorsement});
        discovery.sign(new IdentityContext(userContext, network.getChannel().client));
        
        //discovery results will be based on the chaincode of the endorsement
        
        const discovery_results = await discovery.send({targets: [discoverer], asLocalhost: true});
        console.log('\nDiscovery test 1 results :: ' + JSON.stringify(discovery_results));
        let map = new Map()

        let successCount = 0;
        let timeDifference = 0;
        let org1Majority = 0;
        let org2Majority = 0;
        let org3Majority = 0;

        for(let i=0;i<100;i++){
            const start = Date.now()

            const scriptPath = path.resolve(__dirname,'..','go', 'run_producer.sh');
            var yourscript = child_process.execFileSync(scriptPath);       
            console.log(yourscript.toString())

            // input to the build a proposal request
              let build_proposal_request = {
                fcn:"DecryptMessage", 
                args: [id]
                // fcn:"InitLedger",
                // args:[]
                // transientMap: {
                // 	'marblename': Buffer.from('marble1'), // string <-> byte[]
                // 	'color': Buffer.from('red'), // string <-> byte[]
                // 	'owner': Buffer.from('John'), // string <-> byte[]
                // 	'size': Buffer.from('85'), // string <-> byte[]
                // 	'price': Buffer.from('99') // string <-> byte[]
                }
                endorsement.build(new IdentityContext(userContext, network.getChannel().client), build_proposal_request);
                endorsement.sign(new IdentityContext(userContext, network.getChannel().client));
            
                const handler = discovery.newHandler();
                console.log("signed proposal", discovery.getSignedProposal());
    
                // do not specify 'targets', use a handler instead
                const  endorse_request = {
                    //handler: handler,
                    targets:channel.getEndorsers(),
                    requestTimeout: 1000000
                };
            
                let endorse_results = await endorsement.send(endorse_request);
                console.log(endorse_results);
                console.log(endorse_results.errors);
                let loopCatch = false
                endorse_results.responses.forEach(result=>{
                    console.log("Old",result.response);
                    console.log(result.endorsement);
                    console.log("Payload",result.payload.toString('hex'));
                    if (result.connection.name.startsWith("peer0.org1.example.com") || result.connection.name.startsWith("peer1.org1.example.com")){
                        if (map.has(i)){
                            let value = map.get(i)
                            value.Org1 += 1
                            map.set(i, value)
                        }
                        else{
                            map.set(i, {Org1: 1, Org2: 0, Org3: 0})
                        }
                    }
                    if (result.connection.name.startsWith("peer0.org2.example.com") || result.connection.name.startsWith("peer1.org2.example.com")){
                        if (map.has(i)){
                            let value = map.get(i)
                            value.Org2 += 1
                            map.set(i, value)
                        }   
                        else{
                            map.set(i, {Org1: 0, Org2: 1, Org3: 0})
                        }
                    }
                    if (result.connection.name.startsWith("peer0.org3.example.com") || result.connection.name.startsWith("peer1.org3.example.com")){
                        if (!loopCatch) {
                            loopCatch = true
                            ++successCount

                            if (map.has(i)){
                                let value = map.get(i)
                                value.Org3 += 1
                                map.set(i, value)
                            }
                            else{
                                map.set(i, {Org1: 0, Org2: 0, Org3: 1})
                            }
                        }
                    }

                })


                let value = map.get(i)
                let org1Count = value.Org1
                let org2Count = value.Org2
                let org3Count = value.Org3
                if (org1Count > org2Count && org1Count > org3Count){
                    org1Majority += 1
                }
                else if (org2Count > org1Count && org2Count > org3Count){
                    org2Majority += 1
                }
                else if (org3Count > org1Count && org3Count > org2Count){
                    org3Majority += 1
                }

                let newEndorse_results = endorse_results;
                let new_responses = endorse_results.responses.filter(x=> x.response.status == 200);  
                endorse_results.responses = new_responses;
                endorse_results.responses.forEach(result=>{
                    console.log("New", result.response);
                })
    
    
                //console.log(endorse_results.responses)
                const commit = endorsement.newCommit();
                //let isEndorsement = endorsement.compareProposalResponseResults(endorse_results.responses);
                console.log("Committers", channel.getCommitters());
                const  commit_request = {
                  handler: handler,
                  //targets:channel.getCommitters(),
                  requestTimeout: 1000000
                  };
                
                console.log("commit_request", commit_request)
                commit.chaincodeId = chaincode_id;
                commit.build(new IdentityContext(userContext, network.getChannel().client), build_proposal_request);
                commit.sign(new IdentityContext(userContext, network.getChannel().client));
                let committedResults = await commit.send(commit_request); 
                const stop = Date.now()

                console.log(`Time Taken to execute = ${(stop - start)/1000} seconds`);
                timeDifference += (stop - start)/1000
                sleep(30000)
                console.log("Committed results", committedResults)  
        }
        
        console.log("Map for txns", map)
        console.log("Org1 Majority", org1Majority, "Org2 Majority", org2Majority, "Org3 Majoriity", org3Majority)
        console.log("Success count", successCount)
        console.log("Avg transaction time", timeDifference/100, "seconds")
        
        gateway.disconnect();
    } catch (error) {
        console.error(`Failed to evaluate transaction: ${error}`);
        process.exit(1);
    }
}

function runTest(map){

}


function serializeBytes(sty) {
	const string = JSON.stringify({ data: sty })
	const input = Array.from(string)
	const ouput = input.map((_, i) => string.charCodeAt(i))
	return new Uint8Array(ouput)
}

function sleep(ms) {
    return new Promise((resolve) => {
      setTimeout(resolve, ms);
    });
  }
main();

//module.exports.main = main;
