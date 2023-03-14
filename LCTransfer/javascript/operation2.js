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
        let chaincode_id = "LC-Transfer"
        const contract = network.getContract(chaincode_id);

        let makeArray = ["Toyota","Ford", "Hyundai","Volkswagen", "Tesla"]
        let modelArray = ["Prius","Mustang", "Tucson","Passat"]
        let colorArray = ["blue", "red", "green", "yellow"]
        let OwnerArray = ["Tomoko","Brad", "Jin Soo", "Max", "Adriana","Michel","Aarav","Pari","Valeria","Shotaro"]

        // Car{Make: , Model: , Colour: , Owner: },
		// Car{Make: , Model: , Colour: , Owner: },
		// Car{Make: , Model: , Colour: , Owner: },
		// Car{Make: , Model: , Colour: , Owner: },
		// Car{Make: ", Model: "S", Colour: "black", Owner: },
		// Car{Make: "Peugeot", Model: "205", Colour: "purple", Owner: },
		// Car{Make: "Chery", Model: "S22L", Colour: "white", Owner: },
		// Car{Make: "Fiat", Model: "Punto", Colour: "violet", Owner: },
		// Car{Make: "Tata", Model: "Nano", Colour: "indigo", Owner: },
		// Car{Make: "Holden", Model: "Barina", Colour: "brown", Owner: },
        
        for(let i=0;i<OwnerArray.length;i++){
            let number = randomRange(0,3)
            let error = await contract.submitTransaction('CreateAsset', makeArray[number], modelArray[number], OwnerArray[i], colorArray[number], "NewCar"+i)
            console.log('Error from submit txn', error.toString())
        }
        const id = crypto.randomBytes(16).toString("hex")
        
        //await sleep(9000)
        const discovery = new DiscoveryService(chaincode_id, network.getChannel());
        //discovery.targets = endorsers;
        const userContext = await provider.getUserContext(appUserIdentity, "appUser");
        
            
        gateway.disconnect();
    } catch (error) {
        console.error(`Failed to evaluate transaction: ${error}`);
        process.exit(1);
    }
}

function randomRange(min, max) {

	return Math.floor(Math.random() * (max - min + 1)) + min;

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
