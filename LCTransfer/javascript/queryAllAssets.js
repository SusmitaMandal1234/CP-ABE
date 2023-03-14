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

//const { json } = require('stream/consumers');
//const { json } = require('node:stream/consumers');
//const { json } = require('stream/consumers');

//const ClientIdentity = require('fabric-shim').ClientIdentity;

async function main() {
    try {
        // load the network configuration
        const ccpPath = path.resolve(__dirname, '..', '..', 'test-network', 'organizations', 'peerOrganizations', 'org1.example.com', 'connection-org1.json');
        const ccp = JSON.parse(fs.readFileSync(ccpPath, 'utf8'));

        // Create a new file system based wallet for managing identities.
        const walletPath = path.join(process.cwd(), 'wallet');
        const wallet = await Wallets.newFileSystemWallet(walletPath);
        console.log(`Wallet path: ${walletPath}`);

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

        // Get the network (channel) our contract is deployed to.
        const network = await gateway.getNetwork('mychannel');
        
        const caURL = ccp.certificateAuthorities['ca.org1.example.com'].url;
        const ca = new FabricCAServices(caURL);
        
        const provider = wallet.getProviderRegistry().getProvider('X.509');
        const adminIdentity = await wallet.get('admin');

        const adminUser = await provider.getUserContext(adminIdentity, 'admin');
        const appUserIdentity = await wallet.get('appUser2');

        const newAppUser = await provider.getUserContext(appUserIdentity, 'appUser2');
        const identityService = ca.newIdentityService();
            
        // Get the contract from the network.
        let channel = network.getChannel();
        let chaincode_id = "LC-Transfer14"
        const contract = network.getContract(chaincode_id);
        //const query = "{\"selector\":{\"_id\": {\"$gt\": null}},\"sort\":[{\"price\": \"desc\"}],\"index\": {\"fields\": [\"price\"]},\"use_index\":[\"_design/indexPriceDoc\",\"indexPrice\"]}"
        const query = `{\"selector\":{\"_id\": {\"$gt\": null}},\"sort\":[{\"Tender_Amount\": \"asc\"}]}`
        //const query = "{\"selector\":{\"_id\": {\"$gt\": null}},\"sort\":[{\"price\": \"desc\"}]}"
        //const query = "{\"index\":{\"fields\":[\"price\"]},\"name\": \"indexPrice\",\"selector\":{\"_id\": {\"$gt\": null}},\"sort\":[{\"price\": \"desc\"}]}"         
        console.time("dbsave"); 
        let result = await contract.submitTransaction('ReadAssetByQuery', query);
        console.timeEnd("dbsave")
        console.log("result", JSON.parse(result.toString())[0]);

        console.time("dbsave2"); 
        let result2 = await contract.evaluateTransaction('ReadAssetByRange');
        console.timeEnd("dbsave2"); 
        console.log("result", JSON.parse(result2.toString()))

        gateway.disconnect();
    } catch (error) {
        console.error(`Failed to evaluate transaction: ${error}`);
        process.exit(1);
    }
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
