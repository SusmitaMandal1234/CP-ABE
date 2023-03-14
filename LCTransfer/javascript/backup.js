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
        let chaincode_id = "assetTransfer5"
        const contract = network.getContract(chaincode_id);

        const id = crypto.randomBytes(16).toString("hex")
        
        //let data = await contract.createTransaction('DecryptMessage').setEndorsingPeers(channel.getEndorsers()).submit(id);
        //let cid = new ClientIdentity()
        //let answer = 0;
        // for (let i=0;i<10000;i++){
        //     let date1 = new Date();
            
        //     let difference = new Date().getTime() - date1.getTime();
        //     answer += difference;
        // }
        //console.log(`The avg. transaction time is ${(answer/10000)/1000} seconds`);
        // console.log(2);
        // console.log(`added student1: pranaychawhan@gmail.com`);
        // let student2 = {email: 'kishore@gmail.com', mobile: '8890245672', firstName:'kishor', lastName: 'gawte', address:'nagpur, mahal'}; 
        // await contract.submitTransaction('addStudent','kishore@gmail.com', 'nagpur, mahal', 'kishor', 'gawte', '8890245672', 'nagpur');
        // console.log(`added student2: kishore@gmail.com`);
        // let result3 = await contract.submitTransaction('queryStudent','pranaychawhan@gmail.com');
        // console.log(`Data Found for :pranaychawhan@gmail.com ${result3}`);
        // let result4 = await contract.submitTransaction('queryAllStudents');
        // console.log(`Data Found for All students: ${result4.toString()}`);
        // await contract.submitTransaction('editStudent', 'pranaychawhan2015@gmail.com', '9972901232', 'new addr', 'firstName', 'lastName', 'city');
        // let result5 = await contract.submitTransaction('queryStudent','pranaychawhan@gmail.com');
        // console.log(`Updated Data For pranaychawhan2015@gmail.com: ${result5.toString()}`);
        // Disconnect from the gateway.
        
        await sleep(9000)
        //const discovery = new DiscoveryService(chaincode_id, network.getChannel());
        //discovery.targets = endorsers;
        //const userContext = await provider.getUserContext(appUserIdentity, "appUser");
        
        //#region For SetEndorsingPeers Transaction
        //let endorsers = (await gateway.getNetwork('mychannel')).getChannel().getEndorsers().filter(x=>x.name.startsWith("peer0.org1.example.com") || x.name.startsWith("peer1.org1.example.com"))
        //let result = await contract.createTransaction("ChangeCarOwner").setEndorsingPeers(endorsers).submit('CAR7','pranay3')
        //#endregion

        //#region For Multichaincode purpose
        //let result = await contract.submitTransaction('QueryCar','CAR8')
        //#endregion

        //#region  For State Based Endorsement
        const randomNumber = Math.floor(Math.random() * 100) + 1;
		//use a random key so that we can run multiple times
		const assetKey = `asset-${randomNumber}`;
        const org1 = 'Org1MSP';

        const asset_properties = {
            object_type: 'asset_properties',
            asset_id: assetKey,
            color: 'blue',
            size: 35,
            salt: Buffer.from(randomNumber.toString()).toString('hex')
        };
        const asset_properties_string = JSON.stringify(asset_properties);
        let transaction = contract.createTransaction('CreateAsset')
        //transaction.setEndorsingOrganizations([org1]);
        transaction.setTransient({
            asset_properties: Buffer.from(asset_properties_string)
        });
        let result = await transaction.submit("asset1", "This is a new asset",org1)
        //let result = await contract.submitTransaction("GetAssetStateBasedEndorsement", "asset1")
        //console.log("Policy result is ", result.toString('ascii'))
        //#endregion

        //console.log("Result is ", Buffer.from(result).toString('ascii'))
           
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
