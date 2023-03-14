'use strict';

const { Gateway, Wallets, HsmX509Provider, Transaction,GatewayOptions, DefaultEventHandlerStrategies } = require('fabric-network');
const {DiscoveryService, IdentityContext, Client, Discoverer, Utils} = require('fabric-common');
const path = require('path');
const fs = require('fs');
const FabricCAServices = require('fabric-ca-client');
const { TransactionEventHandler } = require('fabric-network/lib/impl/event/transactioneventhandler');

const { networkInterfaces } = require('os');
const crypto = require('crypto');
const { query } = require('express');
const { channel } = require('diagnostics_channel');
const { fail } = require('assert');
const { decode } = require('querystring');
const { TextDecoder } = require('util');
const openssl = require('openssl');
const { StringDecoder } = require('string_decoder');
const Endorser = require('fabric-common');
const yaml = require('js-yaml');
const ecdsa = require('ecdsa');
var BigInteger = require('bigi');
const { OutputFileType } = require('typescript');
const { syncBuiltinESMExports } = require('module');
const { time, timeEnd, timeStamp } = require('console');
//require('node-go-require');

class MyTransactionEventHandler extends TransactionEventHandler {
    /**
     * Called to initiate listening for transaction events.
     */
    async startListening() { 
        console.log("Event started") }

    /**
     * Wait until enough events have been received from peers to satisfy the event handling strategy.
     * @throws {Error} if the transaction commit is not successfully confirmed.
     */
    async waitForEvents() { console.log("wait for event") }

    /**
     * Cancel listening for events.
     */
    cancelListening() { console.log("Cancel listening") }
}

async function  main(){
    try{

        const { exec, execSync, execFile, execFileSync } = require('child_process');
        let outputArray = []
        
        var createTransactionEventHandler = function (transactionId, network) {
            /* Your implementation here */
            //var mspId = network.getGateway().getIdentity().mspId;
            var myOrgPeers = network.getChannel().getEndorsers();
            return new MyTransactionEventHandler(transactionId, network, myOrgPeers);
        };

        let connectOptions = {
            eventHandlerOptions: {
                strategy: createTransactionEventHandler
            }
        };


       let blockListener = async (event) => {

            console.log("--------------------------------------------------------------")
            console.log(`<-- Block Event Received - block number: ${event.blockNumber.toString()}`);
        
            const transEvents = event.getTransactionEvents();
            for (const transEvent of transEvents) {
                console.log(`*** transaction event: ${transEvent.transactionId}`);
                if (transEvent.privateData) {
                    for (const namespace of transEvent.privateData.ns_pvt_rwset) {
                        console.log(`    - private data: ${namespace.namespace}`);
                        for (const collection of namespace.collection_pvt_rwset) {
                            console.log(`     - collection: ${collection.collection_name}`);
                            if (collection.rwset.reads) {
                                for (const read of collection.rwset.reads) {
                                    console.log(`       - read set - ${BLUE}key:${RESET} ${read.key}  ${BLUE}value:${read.value.toString()}`);
                                }
                            }
                            if (collection.rwset.writes) {
                                for (const write of collection.rwset.writes) {
                                    console.log(`      - write set - ${BLUE}key:${RESET}${write.key} ${BLUE}is_delete:${RESET}${write.is_delete} ${BLUE}value:${RESET}${write.value.toString()}`);
                                }
                            }
                        }
                    }
                }
                if (transEvent.transactionData) {
                    showTransactionData(transEvent.transactionData);
                }
            }
        }
      

        
       const ccpPath = path.resolve(__dirname, '..', '..', 'test-network', 'organizations', 'peerOrganizations', 'org1.example.com', 'connection-org1.json');
       const ccp = JSON.parse(fs.readFileSync(ccpPath, 'utf8'));
       
       const ccpPath2 = path.resolve(__dirname, '..', '..', 'test-network', 'organizations', 'peerOrganizations', 'org2.example.com', 'connection-org2.json');
       const ccp2 = JSON.parse(fs.readFileSync(ccpPath2, 'utf8'));


       // Create a new file system based wallet for managing identities.
       const walletPath = path.join(process.cwd(), 'wallet');
       const wallet = await Wallets.newFileSystemWallet(walletPath);
       console.log(`Wallet path: ${walletPath}`);
   
       // Check to see if we've already enrolled the user.
       const identity = await wallet.get('admin');
       if (!identity) {
           console.log('An identity for the user "appUser2" does not exist in the wallet');
           console.log('Run the registerUser.js application before retrying');
           return;
       }
   
       // Create a new gateway for connecting to our peer node.
       const gateway = new Gateway();
       await gateway.connect(ccp, { wallet, identity: 'appUser2', discovery: { enabled: true, asLocalhost: true } }, connectOptions);
   
       // Get the network (channel) our contract is deployed to.
       const network = await gateway.getNetwork('mychannel');
       console.log(1);
       const caURL = ccp.certificateAuthorities['ca.org1.example.com'].url;
       const caInfo = ccp.certificateAuthorities['ca.org1.example.com'];
       const mspId = ccp.organizations['Org1'].mspid;
       const ca = new FabricCAServices(caInfo.url, { trustedRoots: caInfo.tlsCACerts.pem, verify: false }, caInfo.caName);

       const provider = wallet.getProviderRegistry().getProvider('X.509');
       const adminIdentity = await wallet.get('admin');
   
       const adminUser = await provider.getUserContext(adminIdentity, 'admin');
       const appUser2Identity = await wallet.get('appUser2');
       console.log(3);

       const newappUser2 = await provider.getUserContext(appUser2Identity, 'appUser2');
       const identityService = ca.newIdentityService();

       const identities = (await identityService.getAll(adminUser)).result.identities;
       identities.forEach(element => {
           console.log(element);
       });
               
       //console.log(network.getChannel('mychannel').getEndorsers()[0].name);
       //console.log(network.getChannel('mychannel').getEndorsers()[0].endpoint.creds);
       //let endorsers = [];
       let mychannel = network.getChannel('mychannel');
       let contract = network.getContract('LC-Transfer');
       await contract.addContractListener(blockListener);

       console.log("MSP", mychannel.getMsp("Org1MSP"))
       //console.log("endorsers", endorsers)
         const discovery = new DiscoveryService('LC-Transfer', network.getChannel());
        //discovery.targets = endorsers;
        const userContext = await provider.getUserContext(appUser2Identity, "appUser2");
  
        const discoverer = new Discoverer("appUser2", network.getChannel().client, 'Org1MSP');
        //console.log("endorser", endorsers[0].name)
        await discoverer.connect(mychannel.getEndorsers()[0].endpoint);
       
        let endorsement = mychannel.newEndorsement('LC-Transfer');
        discovery.build(new IdentityContext(userContext, network.getChannel().client), {endorsement: endorsement});
        discovery.sign(new IdentityContext(userContext, network.getChannel().client));
        
        //discovery results will be based on the chaincode of the endorsement
        
        const discovery_results = await discovery.send({targets: [discoverer], asLocalhost: true});
        console.log('\nDiscovery test 1 results :: ' + JSON.stringify(discovery_results));

        let resultArray = []
        let successful = 0;
        
        const folderPath = path.resolve(__dirname,'..','javascript','run_old_cp_abe.sh');
        
        // var yourscript = exec(`cd ../go && go run cp-abe_old.go`);
        var yourscript = execSync('cd ../go && go run cp-abe_old.go');             
        console.log(1)
        outputArray = yourscript.toString().split(" ");
       console.log("outputarray", outputArray)

        let dataString = outputArray[0];
        let policyString = outputArray[1];
        console.log(dataString)
        console.log(policyString)


        //for(let i=0;i<100;i++){
            let count = 0;
                            // input to the build a proposal request
            let build_proposal_request = {
                fcn:"CreateRecord", 
                args: [dataString, policyString]
                }
                endorsement.build(new IdentityContext(userContext, network.getChannel().client), build_proposal_request);
                endorsement.sign(new IdentityContext(userContext, network.getChannel().client));
            
                const handler = discovery.newHandler();
                console.log("signed proposal", discovery.getSignedProposal());

                // do not specify 'targets', use a handler instead
                const  endorse_request = {
                    //handler: handler,
                    targets:mychannel.getEndorsers(),
                    requestTimeout: 30000
                };
            
                let endorse_results = await endorsement.send(endorse_request);
                endorse_results.responses.forEach(result=>{
                    console.log("Old",result.response);
                })
                let newEndorse_results = endorse_results;
                let new_responses = endorse_results.responses.filter(x=> x.response.status == 200);  
                endorse_results.responses = new_responses;
                endorse_results.responses.forEach(result=>{
                    console.log("New", result.response);
                    if (result.response.status != 200){
                        ++count;
                    }
                })

                const commit = endorsement.newCommit();
                //let isEndorsement = endorsement.compareProposalResponseResults(endorse_results.responses);
                console.log("Committers", mychannel.getCommitters());
                const  commit_request = {
                handler: handler,
                //targets:mychannel.getCommitters(),
                requestTimeout: 30000
                };
                
                commit.chaincodeId = 'LC-Transfer';
                commit.build(new IdentityContext(userContext, network.getChannel().client), build_proposal_request);
                commit.sign(new IdentityContext(userContext, network.getChannel().client));
                let committedResults = await commit.send(commit_request); 
                console.log("Committed results", committedResults)
                
                if (count == 0){
                    ++successful
                }
            //}


        // const XLSX = require('xlsx');

        // /* create a new blank workbook */
        // const wb = XLSX.utils.book_new();
        
        // XLSX.utils.json_to_sheet()
        // // Do stuff, write data
        // //
        // //
        // resultArray.push({"Txn. ID": i+1, "Success": successful, "Failed": 0})
        console.log("Failed:", 100-successful, "Success:", successful)
        
        
        
        // write the workbook object to a file
        // XLSX.writeFile(wb, 'out.xlsx');

            gateway.disconnect();
        }
    catch(ex){
         console.log("exception: " + ex);
        }
    }

    

    function showTransactionData(transactionData) {
        console.log(JSON.stringify(transactionData))
        const creator = transactionData.actions[0].header.creator;
        console.log(`    - submitted by: ${creator.mspid}-${creator.id_bytes.toString('hex')}`);
        for (const endorsement of transactionData.actions[0].payload.action.endorsements) {
            console.log(`    - endorsed by: ${endorsement.endorser.mspid}-${endorsement.endorser.id_bytes.toString('hex')}`);
        }
        const chaincode = transactionData.actions[0].payload.chaincode_proposal_payload.input.chaincode_spec;
        console.log(`    - chaincode:${chaincode.chaincode_id.name}`);
        console.log(`    - function:${chaincode.input.args[0].toString()}`);
        for (let x = 1; x < chaincode.input.args.length; x++) {
            console.log(`    - arg:${chaincode.input.args[x].toString()}`);
        }
        console.log("all actions", transactionData.actions)
    }

    function sleep(ms) {
        return new Promise((resolve) => {
          setTimeout(resolve, ms);
        });
      }
main();
