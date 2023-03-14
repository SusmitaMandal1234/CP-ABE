package main

//"log"

//"github.com/valyala/fastjson"

//"encoding/json"
//"fmt"
//func run() {
// fmt.Println("Stmt1")
// s1 := []byte(strconv.Itoa(5))

// x3, y4 := elliptic.P256().ScalarBaseMult(s1)
// fmt.Println("Stmt2")
// SGProduct := elliptic.Marshal(elliptic.P256(), x3, y4)

// G_value := new(big.Int)

// G_value.SetBytes(SGProduct)

// //r.SetOffset(-1)
// //for {
// // the `ReadMessage` method blocks until we receive the next event
// msg, err := r.ReadMessage(ctx1)
// fmt.Println("Read msg Stmt3")
// if err != nil {
// 	panic("could not read message " + err.Error())
// }
// // after receiving the message, log its value
// fmt.Println("received: ", msg.Value)

// if string(msg.Value) == "Invalid Message" {
// 	fmt.Println("Not able to decrypt")
// 	//return errors.New("not able to decrypt")
// 	//break
// } else {
// 	DecryptionInput := make(map[string][]byte)

// 	json.Unmarshal(msg.Value, &DecryptionInput)
// 	fmt.Println("Successful value", DecryptionInput)

// 	//map[string]*big.Int
// 	CTjArray := make(map[string]*big.Int)
// 	json.Unmarshal(DecryptionInput["CT_value"], &CTjArray)

// 	//big int
// 	C0 := big.NewInt(0)
// 	json.Unmarshal(DecryptionInput["hash_value"], &C0)
// 	fmt.Println("Stmt4 ")

// 	PS := big.NewInt(0)
// 	json.Unmarshal(DecryptionInput["PS"], &PS)

// 	DK := make(map[string]*big.Int)
// 	json.Unmarshal(DecryptionInput["DK_value"], &DK)

// 	signer := big.NewInt(0)
// 	json.Unmarshal(DecryptionInput["signer"], &signer)

// 	DM := make(map[string]*big.Int)
// 	fmt.Println("Stmt5 ")
// 	fmt.Println("PS ", PS)
// 	fmt.Println("Stmt6 ")
// 	for i, x := range DK {
// 		new5 := new(big.Int)

// 		new5 = new5.Mul(x, PS)

// 		DM[i] = new5
// 	}
// 	fmt.Println("Stmt7 ")
// 	Sum_CTJ_DM := make(map[string]*big.Int)
// 	for i, _ := range DM {
// 		new6 := new(big.Int)
// 		new6 = new6.Add(CTjArray[i], DM[i])
// 		Sum_CTJ_DM[i] = new6
// 	}
// 	fmt.Println("Stmt8 ")
// 	fmt.Println(Sum_CTJ_DM)
// 	occurred3 := map[string]struct{}{}
// 	occurred2 := make(map[*big.Int]string)
// 	fmt.Println("Stmt9 ")
// 	Checking_data := make(map[string]string)
// 	occurred6 := make([]*big.Int, 0)
// 	occurred1 := make([]*big.Int, 0)
// 	fmt.Println("Stmt10 ")
// 	total := new(big.Int)
// 	for i, j := range Sum_CTJ_DM {
// 		// fmt.Println(i, j)
// 		k := big.NewInt(0)
// 		k = k.Add(k, j)
// 		occurred3[j.String()] = struct{}{}
// 		Checking_data[j.String()] = i
// 		occurred2[j] = i
// 		occurred1 = append(occurred1, j)
// 		total = total.Add(total, k)
// 	}
// 	fmt.Println("Stmt11 ")
// 	fmt.Println("this is total data", total)
// 	//fmt.Println("this is vector data", vectorArray)
// 	for _, i2 := range Checking_data {
// 		i3, t := Sum_CTJ_DM[i2]
// 		if t {
// 			occurred6 = append(occurred6, i3)
// 		}
// 	}
// 	new2 := new(big.Int)
// 	new4 := new(big.Int)
// 	new9 := new(big.Int)
// 	for _, k := range occurred6 {
// 		new3 := k.Sign()
// 		fmt.Println(new3)
// 		if new3 < 0 {
// 			new2 = new2.Add(new2, k)
// 		} else {
// 			new4 = new4.Add(new4, k)
// 		}

// 		new9 = new9.Add(new4, new2)
// 	}
// 	fmt.Println("Stmt12 ")
// 	secrete_value := new(big.Int)

// 	secrete_value = secrete_value.Div(new9, G_value)

// 	fmt.Println(secrete_value)
// 	//msg decryption
// 	s5 := secrete_value.String()
// 	s4 := []byte(s5)
// 	x5, y6 := elliptic.P256().ScalarBaseMult(s4)
// 	SGProduct5 := elliptic.Marshal(elliptic.P256(), x5, y6)
// 	hash2 := sha256.New()

// 	hash2.Write(SGProduct5)

// 	hashstr2 := hex.EncodeToString(hash2.Sum(nil))

// 	hashInValue2, _ := new(big.Int).SetString(hashstr2, 16)

// 	C02 := C0

// 	new7 := new(big.Int)

// 	new7 = new7.Xor(hashInValue2, C02)

// 	msg2 := new7.Bytes()

// 	myString := string(msg2[:])

// 	PID, _ := new(big.Int).SetString(hex.EncodeToString([]byte("peer1.org2.example.com")), 16)

// 	concatenated_msg_peerID1 := fmt.Sprintf("%d%d", new7, PID)

// 	hash3 := sha256.New()
// 	hash3.Write([]byte(concatenated_msg_peerID1))
// 	hashvalue_of_W1, _ := new(big.Int).SetString(hex.EncodeToString(hash3.Sum(nil)), 16)

// 	// fmt.Println("this is equil testing", hashvalue_of_W, hashvalue_of_W1)
// 	fmt.Println("this is screate value", myString)

// 	verify_secreate__into_G := new(big.Int)
// 	verify_secreate__into_G = verify_secreate__into_G.Mul(secrete_value, G_value)
// 	verify_hash := new(big.Int)
// 	verify_hash = verify_hash.Mul(verify_secreate__into_G, hashvalue_of_W1)

// 	verify_PS_ADD_verify_hash := new(big.Int)
// 	verify_PS_ADD_verify_hash = verify_PS_ADD_verify_hash.Add(verify_hash, PS)

// 	// fmt.Println("this is newbig5", verify_PS_ADD_verify_hash)
// 	// fmt.Println("this is newBig2", finalvalue_into_G)
// 	// if signer == verify_PS_ADD_verify_hash {
// 	// 	fmt.Println("successfully decrtpted")
// 	// }
// 	checking1 := fmt.Sprintf("%v", signer)

// 	checking2 := fmt.Sprintf("%v", verify_PS_ADD_verify_hash)
// 	fmt.Println("Checking 1", checking1, "Checking2", checking2)
// 	if checking1 == checking2 && checking1 != "0" && checking2 != "0" {
// 		//fmt.Println("success encryption and decryption")
// 		fmt.Println("this is decryption data::", string(myString))
// 		//transactionData, _ := json.Marshal(string(myString))
// 		//result := ctx.GetStub().PutState(transactionID, transactionData)
// 		//fmt.Println("Result from putting state", result)
// 	}
// 	//return nil
// 	//break
// }

// ctx := context.Background()
// //consume(ctx)
// //return
// l := log.New(os.Stdout, "kafka reader: ", 2)
// // initialize a new reader with the brokers and topic
// // the groupID identifies the consumer and prevents
// // it from receiving duplicate messages
// r := kafka.NewReader(kafka.ReaderConfig{
// 	Brokers: []string{brokerAddress},
// 	Topic:   topic,
// 	GroupID: "peer0",
// 	// assign the logger to the reader
// 	Logger: l,
// })

// s1 := []byte(strconv.Itoa(5))

// x3, y4 := elliptic.P256().ScalarBaseMult(s1)

// SGProduct := elliptic.Marshal(elliptic.P256(), x3, y4)

// G_value := new(big.Int)

// G_value.SetBytes(SGProduct)

// r.SetOffset(-1)
// for {
// 	// the `ReadMessage` method blocks until we receive the next event
// 	msg, err := r.ReadMessage(ctx)
// 	if err != nil {
// 		panic("could not read message " + err.Error())
// 	}
// 	// after receiving the message, log its value
// 	fmt.Println("received: ", msg.Value)
// 	DecryptionInput := make(map[string][]byte)

// 	json.Unmarshal(msg.Value, &DecryptionInput)
// 	fmt.Println("Successful value", DecryptionInput)

// 	//map[string]*big.Int
// 	CTjArray := make(map[string]*big.Int)
// 	json.Unmarshal(DecryptionInput["CT_value"], &CTjArray)

// 	//big int
// 	C0 := big.NewInt(0)
// 	json.Unmarshal(DecryptionInput["hash_value"], &C0)

// 	//map[string]*big.Int
// 	DK := make(map[string]*big.Int)
// 	json.Unmarshal(DecryptionInput["DK_value"], &DK)

// 	//[string]
// 	lsss := DecryptionInput["lsss"]
// 	json.Unmarshal(DecryptionInput["lsss"], &lsss)

// 	//big int
// 	PS := big.NewInt(0)
// 	json.Unmarshal(DecryptionInput["PS"], &PS)
// 	fmt.Println("PS", PS)

// 	//initialize new map DMj
// 	//DMj := make(map[string]*big.Int)

// 	//Initialize Dj.G
// 	//DjG := make(map[string]*big.Int)

// 	// for key, _ := range DK {
// 	// 	DMj[key] = DK[key].Mul(DK[key], PS)
// 	// 	DjG[key] = CTjArray[key].Add(CTjArray[key], DMj[key])
// 	// }

// 	DM := make(map[string]*big.Int)
// 	fmt.Println("PS ", PS)
// 	for i, x := range DK {
// 		new5 := new(big.Int)

// 		new5 = new5.Mul(x, PS)

// 		DM[i] = new5
// 	}

// 	Sum_CTJ_DM := make(map[string]*big.Int)
// 	for i, _ := range DM {
// 		new6 := new(big.Int)
// 		new6 = new6.Add(CTjArray[i], DM[i])
// 		Sum_CTJ_DM[i] = new6
// 	}
// 	fmt.Println(Sum_CTJ_DM)
// 	occurred3 := map[string]struct{}{}
// 	occurred2 := make(map[*big.Int]string)

// 	Checking_data := make(map[string]string)
// 	occurred6 := make([]*big.Int, 0)
// 	occurred1 := make([]*big.Int, 0)

// 	total := new(big.Int)
// 	for i, j := range Sum_CTJ_DM {
// 		// fmt.Println(i, j)
// 		k := big.NewInt(0)
// 		k = k.Add(k, j)
// 		occurred3[j.String()] = struct{}{}
// 		Checking_data[j.String()] = i
// 		occurred2[j] = i
// 		occurred1 = append(occurred1, j)
// 		total = total.Add(total, k)
// 	}
// 	fmt.Println("this is total data", total)
// 	//fmt.Println("this is vector data", vectorArray)
// 	for _, i2 := range Checking_data {
// 		i3, t := Sum_CTJ_DM[i2]
// 		if t {
// 			occurred6 = append(occurred6, i3)
// 		}
// 	}
// 	new2 := new(big.Int)
// 	new4 := new(big.Int)
// 	new9 := new(big.Int)
// 	for _, k := range occurred6 {
// 		new3 := k.Sign()
// 		fmt.Println(new3)
// 		if new3 < 0 {
// 			new2 = new2.Add(new2, k)
// 		} else {
// 			new4 = new4.Add(new4, k)
// 		}

// 		new9 = new9.Add(new4, new2)
// 	}
// 	secrete_value := new(big.Int)

// 	secrete_value = secrete_value.Div(new9, G_value)

// 	fmt.Println(secrete_value)
// 	//msg decryption
// 	s5 := secrete_value.String()
// 	s4 := []byte(s5)
// 	x5, y6 := elliptic.P256().ScalarBaseMult(s4)
// 	SGProduct5 := elliptic.Marshal(elliptic.P256(), x5, y6)
// 	hash2 := sha256.New()

// 	hash2.Write(SGProduct5)

// 	hashstr2 := hex.EncodeToString(hash2.Sum(nil))

// 	hashInValue2, _ := new(big.Int).SetString(hashstr2, 16)

// 	C02 := C0

// 	new7 := new(big.Int)

// 	new7 = new7.Xor(hashInValue2, C02)

// 	msg2 := new7.Bytes()

// 	myString := string(msg2[:])

// 	fmt.Println("this is decryption data::", string(myString))

// 	convertJsonMessage, _ := json.Marshal(string(myString))
// 	fmt.Println("Converted JSON Message", convertJsonMessage)

// 	// newMapForData := make(map[string]string)
//}
