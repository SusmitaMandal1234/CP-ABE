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
        console.log(1)

        // const scriptPath = path.resolve(__dirname,'..','go', 'run_producer.sh');
        // var yourscript = child_process.execFileSync(scriptPath);       
        // console.log(yourscript.toString())

        console.log(2)
        // Create a new file system based wallet for managing identities.
        const walletPath = path.join(process.cwd(), 'wallet');
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
        
        const caURL = ccp.certificateAuthorities['ca.org1.example.com'].url;
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
        let chaincode_id = "LC_Transfer"
        
        const contract = network.getContract(chaincode_id);
        //let filePath = path.join("src", "file.json")
        let i=0
        for (i=1;i<=5;i++){
            let user = "User"+i
            let result = await contract.submitTransaction("ChangeCarOwner", "CAR9", user)  
            console.log(result.toString())   
        }
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
