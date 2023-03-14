/*
SPDX-License-Identifier: Apache-2.0
*/

package cp_abe

import (
	"crypto/ecdsa"
	"crypto/elliptic"
	"crypto/rand"
	"crypto/sha256"
	"crypto/x509"
	"encoding/json"
	"encoding/pem"
	"errors"
	"fmt"
	"io/ioutil"

	//"log"

	"encoding/hex"

	//"github.com/valyala/fastjson"
	"math/big"

	//"encoding/json"
	//"fmt"

	"strconv"

	"github.com/fentec-project/gofe/abe"
	"github.com/fentec-project/gofe/data"
)

//type handler struct{}

// func (h handler) Decrypt(msg []byte, peer_id string) ([]byte, error) {
// 	fmt.Println("Stmt1")
// 	s1 := []byte(strconv.Itoa(5))

// 	x3, y4 := elliptic.P256().ScalarBaseMult(s1)
// 	fmt.Println("Stmt2")
// 	SGProduct := elliptic.Marshal(elliptic.P256(), x3, y4)

// 	G_value := new(big.Int)

// 	G_value.SetBytes(SGProduct)

// 	fmt.Println("received: ", msg)

// 	if string(msg) == "Invalid Message" {
// 		fmt.Println("Not able to decrypt")
// 		return nil, errors.New("not able to decrypt")
// 	} else {
// 		DecryptionInput := make(map[string][]byte)

// 		json.Unmarshal(msg, &DecryptionInput)
// 		fmt.Println("Successful value", DecryptionInput)

// 		//map[string]*big.Int
// 		CTjArray := make(map[string]*big.Int)
// 		json.Unmarshal(DecryptionInput["CT_value"], &CTjArray)

// 		//big int
// 		C0 := big.NewInt(0)
// 		json.Unmarshal(DecryptionInput["hash_value"], &C0)
// 		fmt.Println("Stmt4 ")

// 		PS := big.NewInt(0)
// 		json.Unmarshal(DecryptionInput["PS"], &PS)

// 		DK := make(map[string]*big.Int)
// 		json.Unmarshal(DecryptionInput["DK_value"], &DK)

// 		signer := big.NewInt(0)
// 		json.Unmarshal(DecryptionInput["signer"], &signer)

// 		DM := make(map[string]*big.Int)
// 		fmt.Println("Stmt5 ")
// 		fmt.Println("PS ", PS)
// 		fmt.Println("Stmt6 ")
// 		for i, x := range DK {
// 			new5 := new(big.Int)

// 			new5 = new5.Mul(x, PS)

// 			DM[i] = new5
// 		}
// 		fmt.Println("Stmt7 ")
// 		Sum_CTJ_DM := make(map[string]*big.Int)
// 		for i, _ := range DM {
// 			new6 := new(big.Int)
// 			new6 = new6.Add(CTjArray[i], DM[i])
// 			Sum_CTJ_DM[i] = new6
// 		}
// 		fmt.Println("Stmt8 ")
// 		fmt.Println(Sum_CTJ_DM)
// 		occurred3 := map[string]struct{}{}
// 		occurred2 := make(map[*big.Int]string)
// 		fmt.Println("Stmt9 ")
// 		Checking_data := make(map[string]string)
// 		occurred6 := make([]*big.Int, 0)
// 		occurred1 := make([]*big.Int, 0)
// 		fmt.Println("Stmt10 ")
// 		total := new(big.Int)
// 		for i, j := range Sum_CTJ_DM {
// 			// fmt.Println(i, j)
// 			k := big.NewInt(0)
// 			k = k.Add(k, j)
// 			occurred3[j.String()] = struct{}{}
// 			Checking_data[j.String()] = i
// 			occurred2[j] = i
// 			occurred1 = append(occurred1, j)
// 			total = total.Add(total, k)
// 		}
// 		fmt.Println("Stmt11 ")
// 		fmt.Println("this is total data", total)
// 		//fmt.Println("this is vector data", vectorArray)
// 		for _, i2 := range Checking_data {
// 			i3, t := Sum_CTJ_DM[i2]
// 			if t {
// 				occurred6 = append(occurred6, i3)
// 			}
// 		}
// 		new2 := new(big.Int)
// 		new4 := new(big.Int)
// 		new9 := new(big.Int)
// 		for _, k := range occurred6 {
// 			new3 := k.Sign()
// 			fmt.Println(new3)
// 			if new3 < 0 {
// 				new2 = new2.Add(new2, k)
// 			} else {
// 				new4 = new4.Add(new4, k)
// 			}

// 			new9 = new9.Add(new4, new2)
// 		}
// 		fmt.Println("Stmt12 ")
// 		secrete_value := new(big.Int)

// 		secrete_value = secrete_value.Div(new9, G_value)

// 		fmt.Println(secrete_value)
// 		//msg decryption
// 		s5 := secrete_value.String()
// 		s4 := []byte(s5)
// 		x5, y6 := elliptic.P256().ScalarBaseMult(s4)
// 		SGProduct5 := elliptic.Marshal(elliptic.P256(), x5, y6)
// 		hash2 := sha256.New()

// 		hash2.Write(SGProduct5)

// 		hashstr2 := hex.EncodeToString(hash2.Sum(nil))

// 		hashInValue2, _ := new(big.Int).SetString(hashstr2, 16)

// 		C02 := C0

// 		new7 := new(big.Int)

// 		new7 = new7.Xor(hashInValue2, C02)

// 		msg2 := new7.Bytes()

// 		myString := string(msg2[:])

// 		PID, _ := new(big.Int).SetString(hex.EncodeToString([]byte(peer_id)), 16)

// 		concatenated_msg_peerID1 := fmt.Sprintf("%d%d", new7, PID)

// 		hash3 := sha256.New()
// 		hash3.Write([]byte(concatenated_msg_peerID1))
// 		hashvalue_of_W1, _ := new(big.Int).SetString(hex.EncodeToString(hash3.Sum(nil)), 16)

// 		// fmt.Println("this is equil testing", hashvalue_of_W, hashvalue_of_W1)
// 		fmt.Println("this is screate value", s5)

// 		verify_secreate__into_G := new(big.Int)
// 		verify_secreate__into_G = verify_secreate__into_G.Mul(secrete_value, G_value)
// 		verify_hash := new(big.Int)
// 		verify_hash = verify_hash.Mul(verify_secreate__into_G, hashvalue_of_W1)

// 		verify_PS_ADD_verify_hash := new(big.Int)
// 		verify_PS_ADD_verify_hash = verify_PS_ADD_verify_hash.Add(verify_hash, PS)

// 		// fmt.Println("this is newbig5", verify_PS_ADD_verify_hash)
// 		// fmt.Println("this is newBig2", finalvalue_into_G)
// 		// if signer == verify_PS_ADD_verify_hash {
// 		// 	fmt.Println("successfully decrtpted")
// 		// }
// 		checking1 := fmt.Sprintf("%v", signer)

// 		checking2 := fmt.Sprintf("%v", verify_PS_ADD_verify_hash)

// 		if checking1 == checking2 {
// 			//fmt.Println("success encryption and decryption")
// 			fmt.Println("this is decryption data::", string(myString))
// 			jsonMap := make(map[string]string)
// 			json.Unmarshal(msg2, &jsonMap)
// 			fmt.Println("Transaction Data in map", jsonMap)
// 			transactionData, _ := json.Marshal(jsonMap)
// 			fmt.Println("Tranaction Data in bytes", transactionData)
// 			//result := ctx.GetStub().PutState(transactionID, transactionData)
// 			//fmt.Println("Result from putting state", result)
// 			return transactionData, nil
// 		}
// 		return nil, errors.New("not able to decrypt")
// 		//break
// 	}
// }

func Decrypt(msg []byte, peer_id string) ([]byte, error) {
	fmt.Println("Stmt1")
	s1 := []byte(strconv.Itoa(5))

	x3, y4 := elliptic.P256().ScalarBaseMult(s1)
	fmt.Println("Stmt2")
	SGProduct := elliptic.Marshal(elliptic.P256(), x3, y4)

	G_value := new(big.Int)

	G_value.SetBytes(SGProduct)

	fmt.Println("received: ", msg)

	if string(msg) == "Invalid Message" {
		fmt.Println("Not able to decrypt")
		return nil, errors.New("not able to decrypt")
	} else {
		DecryptionInput := make(map[string][]byte)

		json.Unmarshal(msg, &DecryptionInput)
		fmt.Println("Successful value", DecryptionInput)

		//map[string]*big.Int
		CTjArray := make(map[string]*big.Int)
		json.Unmarshal(DecryptionInput["CT_value"], &CTjArray)

		//big int
		C0 := big.NewInt(0)
		json.Unmarshal(DecryptionInput["hash_value"], &C0)
		fmt.Println("Stmt4 ")

		PS := big.NewInt(0)
		json.Unmarshal(DecryptionInput["PS"], &PS)

		DK := make(map[string]*big.Int)
		json.Unmarshal(DecryptionInput["DK_value"], &DK)

		signer := big.NewInt(0)
		json.Unmarshal(DecryptionInput["signer"], &signer)

		DM := make(map[string]*big.Int)
		fmt.Println("Stmt5 ")
		fmt.Println("PS ", PS)
		fmt.Println("Stmt6 ")
		for i, x := range DK {
			new5 := new(big.Int)

			new5 = new5.Mul(x, PS)

			DM[i] = new5
		}
		fmt.Println("Stmt7 ")
		Sum_CTJ_DM := make(map[string]*big.Int)
		for i, _ := range DM {
			new6 := new(big.Int)
			new6 = new6.Add(CTjArray[i], DM[i])
			Sum_CTJ_DM[i] = new6
		}
		fmt.Println("Stmt8 ")
		fmt.Println(Sum_CTJ_DM)
		occurred3 := map[string]struct{}{}
		occurred2 := make(map[*big.Int]string)
		fmt.Println("Stmt9 ")
		Checking_data := make(map[string]string)
		occurred6 := make([]*big.Int, 0)
		occurred1 := make([]*big.Int, 0)
		fmt.Println("Stmt10 ")
		total := new(big.Int)
		for i, j := range Sum_CTJ_DM {
			// fmt.Println(i, j)
			k := big.NewInt(0)
			k = k.Add(k, j)
			occurred3[j.String()] = struct{}{}
			Checking_data[j.String()] = i
			occurred2[j] = i
			occurred1 = append(occurred1, j)
			total = total.Add(total, k)
		}
		fmt.Println("Stmt11 ")
		fmt.Println("this is total data", total)
		//fmt.Println("this is vector data", vectorArray)
		for _, i2 := range Checking_data {
			i3, t := Sum_CTJ_DM[i2]
			if t {
				occurred6 = append(occurred6, i3)
			}
		}
		new2 := new(big.Int)
		new4 := new(big.Int)
		new9 := new(big.Int)
		for _, k := range occurred6 {
			new3 := k.Sign()
			fmt.Println(new3)
			if new3 < 0 {
				new2 = new2.Add(new2, k)
			} else {
				new4 = new4.Add(new4, k)
			}

			new9 = new9.Add(new4, new2)
		}
		fmt.Println("Stmt12 ")
		secrete_value := new(big.Int)

		secrete_value = secrete_value.Div(new9, G_value)

		fmt.Println(secrete_value)
		//msg decryption
		s5 := secrete_value.String()
		s4 := []byte(s5)
		x5, y6 := elliptic.P256().ScalarBaseMult(s4)
		SGProduct5 := elliptic.Marshal(elliptic.P256(), x5, y6)
		hash2 := sha256.New()

		hash2.Write(SGProduct5)

		hashstr2 := hex.EncodeToString(hash2.Sum(nil))

		hashInValue2, _ := new(big.Int).SetString(hashstr2, 16)

		C02 := C0

		new7 := new(big.Int)

		new7 = new7.Xor(hashInValue2, C02)

		msg2 := new7.Bytes()

		myString := string(msg2[:])

		PID, _ := new(big.Int).SetString(hex.EncodeToString([]byte(peer_id)), 16)

		concatenated_msg_peerID1 := fmt.Sprintf("%d%d", new7, PID)

		hash3 := sha256.New()
		hash3.Write([]byte(concatenated_msg_peerID1))
		hashvalue_of_W1, _ := new(big.Int).SetString(hex.EncodeToString(hash3.Sum(nil)), 16)

		// fmt.Println("this is equil testing", hashvalue_of_W, hashvalue_of_W1)
		fmt.Println("this is screate value", s5)

		verify_secreate__into_G := new(big.Int)
		verify_secreate__into_G = verify_secreate__into_G.Mul(secrete_value, G_value)
		verify_hash := new(big.Int)
		verify_hash = verify_hash.Mul(verify_secreate__into_G, hashvalue_of_W1)

		verify_PS_ADD_verify_hash := new(big.Int)
		verify_PS_ADD_verify_hash = verify_PS_ADD_verify_hash.Add(verify_hash, PS)

		// fmt.Println("this is newbig5", verify_PS_ADD_verify_hash)
		// fmt.Println("this is newBig2", finalvalue_into_G)
		// if signer == verify_PS_ADD_verify_hash {
		// 	fmt.Println("successfully decrtpted")
		// }
		checking1 := fmt.Sprintf("%v", signer)

		checking2 := fmt.Sprintf("%v", verify_PS_ADD_verify_hash)

		if checking1 == checking2 {
			//fmt.Println("success encryption and decryption")
			fmt.Println("this is decryption data::", string(myString))
			jsonMap := make(map[string]string)
			json.Unmarshal(msg2, &jsonMap)
			fmt.Println("Transaction Data in map", jsonMap)
			transactionData, _ := json.Marshal(jsonMap)
			fmt.Println("Tranaction Data in bytes", transactionData)
			//result := ctx.GetStub().PutState(transactionID, transactionData)
			//fmt.Println("Result from putting state", result)
			return transactionData, nil
		}
		return nil, errors.New("not able to decrypt")
		//break
	}
}

func UnsuccessfulEncryption(lsss *abe.MSP, msg string, answerVector []data.Vector, CTjArray1 map[string]*big.Int, attrToPrivatMsp map[string]*big.Int, attrToPubKeyMap map[string]*big.Int, DM1 map[string]*big.Int, DK1 map[string]*big.Int, Summetion1 map[string]*big.Int, G_value *big.Int, PID *big.Int, PKAA *big.Int, ur_value *big.Int, ur_into_g *big.Int, X1 *big.Int, tr_private_key *ecdsa.PrivateKey, C0 *big.Int) []byte {
	for i, x := range lsss.RowToAttrib {
		Dj := answerVector[i][0]
		//set_off means Dj*G value calculate

		set_of1 := new(big.Int)
		set_of1 = set_of1.Mul(Dj, G_value)
		//set_off2 means Yj*Pj*ur cal

		yjValue := attrToPubKeyMap[x]
		pjValue := lsss.Mat[i]
		// ur := ur_key_private

		new1 := new(big.Int)

		new1 = new1.Mul(yjValue, ur_value)

		for p := 0; p < len(pjValue); p++ {
			number := 1
			if number == 1 {
				if pjValue[p] == big.NewInt(1) {
					new1 = new1.Mul(new1, big.NewInt(1))
					number = number + 1
				}

				if pjValue[p] == big.NewInt(-1) {

					new1 = new1.Mul(new1, big.NewInt(1))
					number = number + 1
				}
			}
		}

		// logical2 := new(big.Int)
		concatenated := fmt.Sprintf("%d%d", PKAA, PID)

		hash := sha256.New()
		hash.Write([]byte(concatenated))
		hashValue1, _ := new(big.Int).SetString(hex.EncodeToString(hash.Sum(nil)), 16)

		new3 := new(big.Int)
		new3 = new3.Mul(X1, hashValue1)
		final_data := new(big.Int)
		// final_data1 := new(big.Int)
		final_data2 := new(big.Int)

		// final_data = final_data.Add(new1, new3)
		final_data2 = final_data2.Sub(set_of1, final_data)

		CTjArray1[x] = final_data2
		// t1 := time.Now()
		// fmt.Println(new1)
	}

	// fmt.Println("this is CTJ value", CTjArray)
	map3 := make([]string, 0)

	map1 := make(map[string]int)
	for i, p := range lsss.RowToAttrib {
		fmt.Println(i)
		if i+2 > len(map1) {
			map1[p] = i
			map3 = append(map3, p)
		}
	}
	k3 := map3[len(map3)-1]

	k4 := map3[len(map3)-2]

	k5 := map3[len(map3)-3]

	k6 := map3[len(map3)-4]
	// fmt.Println(k)

	delete(CTjArray1, k3)

	delete(CTjArray1, k4)

	delete(CTjArray1, k5)

	delete(CTjArray1, k6)

	// fmt.Println("\nThis is chipertext data ABE ", CTjArray)

	for i, _ := range CTjArray1 {
		yjValue, _ := attrToPrivatMsp[i]
		concatenated := fmt.Sprintf("%d%d", PKAA, PID)
		// logical2.SetBytes([]byte(concatenated))

		hash := sha256.New()
		hash.Write([]byte(concatenated))
		hashValue1, _ := new(big.Int).SetString(hex.EncodeToString(hash.Sum(nil)), 16)
		new4 := new(big.Int)
		new4 = new4.Mul(hashValue1, tr_private_key.D)
		final_data := new(big.Int)
		final_data = final_data.Add(yjValue, new4)
		DK1[i] = final_data

	}

	// fmt.Println(DK)
	// dm := make(map[string]*big.Int)

	// DM := make(map[string]*big.Int)

	for i, x := range DK1 {

		new5 := new(big.Int)
		new5 = new5.Mul(x, ur_into_g)
		DM1[i] = new5

	}

	for i, _ := range DM1 {

		new6 := new(big.Int)
		new6 = new6.Add(CTjArray1[i], DM1[i])
		Summetion1[i] = new6

	}

	// fmt.Println(Summetion)

	Checking_data := make(map[string]string)

	sign_values_cal := make([]*big.Int, 0)

	total := new(big.Int)

	for i, j := range Summetion1 {
		// fmt.Println(i, j)
		k := big.NewInt(0)

		k = k.Add(k, j)

		Checking_data[j.String()] = i

		total = total.Add(total, k)
	}

	for _, i2 := range Checking_data {
		i3, t := Summetion1[i2]
		if t == true {
			sign_values_cal = append(sign_values_cal, i3)
		}
	}

	new2 := new(big.Int)

	new4 := new(big.Int)

	summation_DJ_G := new(big.Int)
	for _, k := range sign_values_cal {
		new3 := k.Sign()
		fmt.Println(new3)
		if new3 < 0 {
			new2 = new2.Add(new2, k)

		} else {
			new4 = new4.Add(new4, k)

		}

		summation_DJ_G = summation_DJ_G.Add(new4, new2)
	}

	secreate_value := new(big.Int)
	secreate_value = secreate_value.Div(summation_DJ_G, G_value)
	fmt.Println(secreate_value)

	//msg decryption

	secreate_value_string := secreate_value.String()
	secreate_value_bytes := []byte(secreate_value_string)
	X_value, Y_value := elliptic.P256().ScalarBaseMult(secreate_value_bytes)
	SGProduct5 := elliptic.Marshal(elliptic.P256(), X_value, Y_value)

	hash_create := sha256.New()
	hash_create.Write(SGProduct5)
	hash_to_hexa := hex.EncodeToString(hash_create.Sum(nil))
	hash_value2, _ := new(big.Int).SetString(hash_to_hexa, 16)
	C0_value := C0
	new7 := new(big.Int)
	new7 = new7.Xor(hash_value2, C0_value)

	msg2 := new7.Bytes()
	myString := string(msg2[:])
	fmt.Println("this is decryption data::", string(myString))
	// fmt.Println("this is DK", DK)
	// fmt.Println("this is DM", DM)

	//working W signer encryption

	// w_test1 := new(big.Int)
	messageInhex1 := hex.EncodeToString([]byte(msg))
	messageInValue1, _ := new(big.Int).SetString(messageInhex1, 16)
	concatenated_msg_peerID := fmt.Sprintf("%d%d", messageInValue1, PID)
	hash0 := sha256.New()
	hash0.Write([]byte(concatenated_msg_peerID))
	hashvalue_of_W, _ := new(big.Int).SetString(hex.EncodeToString(hash0.Sum(nil)), 16)

	multi_secreate_hash := new(big.Int)
	multi_secreate_hash = multi_secreate_hash.Mul(secreate_value, hashvalue_of_W)

	ur_add_screate_hash := new(big.Int)
	ur_add_screate_hash = ur_add_screate_hash.Add(ur_value, multi_secreate_hash)

	finalvalue_into_G := new(big.Int)
	finalvalue_into_G = finalvalue_into_G.Mul(ur_add_screate_hash, G_value)

	//verify side

	// concatenated_msg_peerID1 := fmt.Sprintf("%d%d", new7, PID)
	// hash2 := sha256.New()
	// hash2.Write([]byte(concatenated_msg_peerID1))
	// hashvalue_of_W1, _ := new(big.Int).SetString(hex.EncodeToString(hash2.Sum(nil)), 16)

	// fmt.Println("this is equil testing", hashvalue_of_W, hashvalue_of_W1)
	// // fmt.Println("this is screate value", secreate_value)

	// verify_secreate__into_G := new(big.Int)
	// verify_secreate__into_G = verify_secreate__into_G.Mul(secreate_value, G_value)
	// verify_hash := new(big.Int)
	// verify_hash = verify_hash.Mul(verify_secreate__into_G, hashvalue_of_W1)

	// verify_PS_ADD_verify_hash := new(big.Int)
	// verify_PS_ADD_verify_hash = verify_PS_ADD_verify_hash.Add(verify_hash, ur_into_g)

	// fmt.Println("this is newbig5", verify_PS_ADD_verify_hash)
	// fmt.Println("this is newBig2", finalvalue_into_G)
	// if finalvalue_into_G == verify_PS_ADD_verify_hash {
	// 	fmt.Println("successfully decrtpted")
	// }

	final_data := make(map[string][]byte)

	CT, _ := json.Marshal(CTjArray1)

	hash_value1, _ := json.Marshal(C0)

	signer_value, _ := json.Marshal(finalvalue_into_G)

	DK_value, _ := json.Marshal(DK1)

	lsss_value, _ := json.Marshal(lsss.RowToAttrib)

	Producer_send_data2, _ := json.Marshal(final_data)

	final_data["CT_value"] = CT
	final_data["hash_value"] = hash_value1
	final_data["DK_value"] = DK_value
	final_data["lsss"] = lsss_value

	final_data["signer"] = signer_value
	// fmt.Println(w1)

	return Producer_send_data2
}

func GenerateAttributeKeys(lsss *abe.MSP) (map[string]*big.Int, map[string]*big.Int, error) {
	attrToPubKeyMap := make(map[string]*big.Int)

	attrToPrivatMsp := make(map[string]*big.Int)
	fmt.Println("lsss", lsss.Mat)

	for i := 0; i < len(lsss.RowToAttrib); i++ {
		s := []byte(strconv.Itoa(5))

		x1, y1 := elliptic.P256().ScalarBaseMult(s)
		GProduct := elliptic.Marshal(elliptic.P256(), x1, y1)

		privateKey, _ := ecdsa.GenerateKey(elliptic.P256(), rand.Reader)

		pub1 := new(big.Int)
		pub1.SetBytes(GProduct)
		attribute_public_key := new(big.Int)

		attribute_public_key = attribute_public_key.Mul(pub1, privateKey.D)

		attrToPubKeyMap[lsss.RowToAttrib[i]] = attribute_public_key

		attrToPrivatMsp[lsss.RowToAttrib[i]] = privateKey.D
	}
	//if err != nil {
	fmt.Println(attrToPrivatMsp, attrToPubKeyMap, lsss)
	return attrToPrivatMsp, attrToPubKeyMap, nil
	//}
	//return nil, nil, errors.New("Not able to generate the attribute keys")
}

func GenerateHashValues(lsss *abe.MSP, msg string) (string, *big.Int, *big.Int, *big.Int, []data.Vector, *big.Int, error) {
	vectorArray := make([]data.Vector, 0)

	bigArray := make([]*big.Int, 1)
	bigArray[0] = big.NewInt(2)
	vector := data.NewVector(bigArray)
	vectorArray = append(vectorArray, vector)
	for i := 0; i < len(lsss.Mat[0])-1; i++ {
		newBigInt, _ := rand.Prime(rand.Reader, 212)

		bigArray := make([]*big.Int, 1)
		bigArray[0] = newBigInt
		vector := data.NewVector(bigArray)

		vectorArray = append(vectorArray, vector)
	}
	fmt.Println("\nthis is vector data", vectorArray)

	//end for random vector

	//now genarating is only G value is
	s := []byte(strconv.Itoa(5))
	x3, y4 := elliptic.P256().ScalarBaseMult(s)
	SGProduct := elliptic.Marshal(elliptic.P256(), x3, y4)
	G_value := new(big.Int)
	G_value.SetBytes(SGProduct)

	//now genarating for hash of g value and hash of message C0
	s2 := []byte(strconv.Itoa(2))
	x1, y1 := elliptic.P256().ScalarBaseMult(s2)
	SGProduct1 := elliptic.Marshal(elliptic.P256(), x1, y1)
	hash := sha256.New()
	hash.Write(SGProduct1)
	hashstr := hex.EncodeToString(hash.Sum(nil))

	messageInhex := hex.EncodeToString([]byte(msg))
	hashInValue, _ := new(big.Int).SetString(hashstr, 16)
	messageInValue, _ := new(big.Int).SetString(messageInhex, 16)
	C0 := hashInValue.Xor(hashInValue, messageInValue)

	return messageInhex, hashInValue, messageInValue, C0, vectorArray, G_value, nil
}

func UtitlizePeerKeysFromMsp(C0 *big.Int, G_value *big.Int, vectorArray []data.Vector, lsss *abe.MSP) (*big.Int, *big.Int, []data.Vector, *big.Int, *big.Int, *big.Int, *ecdsa.PrivateKey) {
	//Read Signing key of Peer from the MSP
	ur_content, _ := ioutil.ReadFile("../../test-network/organizations/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/msp/signcerts/cert.pem")
	ur_pem, _ := pem.Decode(ur_content)
	ur_key, _ := x509.ParseCertificate(ur_pem.Bytes)
	peer_key := ur_key.PublicKey.(*ecdsa.PublicKey)
	pkp_signer_key := elliptic.Marshal(elliptic.P256(), peer_key.X, peer_key.Y)
	ur_value := new(big.Int)
	ur_value.SetBytes(pkp_signer_key)

	ur_into_g := new(big.Int)
	ur_into_g = ur_into_g.Mul(G_value, ur_value)

	//Read Private Key of the same peer from the MSP
	tr_content, _ := ioutil.ReadFile("../../test-network/organizations/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/msp/keystore/priv_sk")
	tr_pem, _ := pem.Decode(tr_content)
	tr_key, _ := x509.ParsePKCS8PrivateKey(tr_pem.Bytes)
	tr_private_key := tr_key.(*ecdsa.PrivateKey)

	tr_g := new(big.Int)
	tr_g = tr_g.Mul(tr_private_key.D, G_value)

	X1 := new(big.Int)
	X1 = X1.Mul(tr_g, ur_value)

	// // //signer public and private key this is orginal wait for ------------this key wallet

	//Read CA file from the MSP
	caCertificatePath, _ := ioutil.ReadFile("../../test-network/organizations/peerOrganizations/org1.example.com/ca/ca.org1.example.com-cert.pem")
	pem_certificate, _ := pem.Decode(caCertificatePath)
	certificate_peer, _ := x509.ParseCertificate(pem_certificate.Bytes)

	PKAA, _ := new(big.Int).SetString(hex.EncodeToString(elliptic.Marshal(elliptic.P256(), certificate_peer.PublicKey.(*ecdsa.PublicKey).X, certificate_peer.PublicKey.(*ecdsa.PublicKey).Y)), 16)
	PID, _ := new(big.Int).SetString(hex.EncodeToString([]byte(peer_id)), 16)

	matrix2, err := data.NewMatrix(vectorArray)

	//vector to new matrix are genarating and then multi of lsss.Mat

	answerVector, err := lsss.Mat.Mul(matrix2)
	if err != nil {
		fmt.Println(PKAA, PID, C0)
	}
	return PKAA, PID, answerVector, ur_value, ur_into_g, X1, tr_private_key
}

func SuccessfulEncryption(lsss *abe.MSP, msg string, answerVector []data.Vector, attrToPubKeyMap map[string]*big.Int, attrToPrivatMsp map[string]*big.Int, Summetion map[string]*big.Int, PKAA *big.Int, PID *big.Int, DK map[string]*big.Int, CTjArray map[string]*big.Int, DM map[string]*big.Int, G_value *big.Int, ur_value *big.Int, ur_into_g *big.Int, tr_private_key *ecdsa.PrivateKey, C0 *big.Int, X1 *big.Int) []byte {

	for i, x := range lsss.RowToAttrib {
		Dj := answerVector[i][0]
		//set_off means Dj*G value calculate

		set_of1 := new(big.Int)
		set_of1 = set_of1.Mul(Dj, G_value)
		//set_off2 means Yj*Pj*ur cal

		yjValue := attrToPubKeyMap[x]
		pjValue := lsss.Mat[i]
		// ur := ur_key_private

		new1 := new(big.Int)

		new1 = new1.Mul(yjValue, ur_value)

		for p := 0; p < len(pjValue); p++ {
			number := 1
			if number == 1 {
				if pjValue[p] == big.NewInt(1) {
					new1 = new1.Mul(new1, big.NewInt(1))
					number = number + 1
				}

				if pjValue[p] == big.NewInt(-1) {

					new1 = new1.Mul(new1, big.NewInt(1))
					number = number + 1
				}
			}
		}

		// logical2 := new(big.Int)
		concatenated := fmt.Sprintf("%d%d", PKAA, PID)

		hash := sha256.New()
		hash.Write([]byte(concatenated))
		hashValue1, _ := new(big.Int).SetString(hex.EncodeToString(hash.Sum(nil)), 16)

		new3 := new(big.Int)
		new3 = new3.Mul(X1, hashValue1)
		final_data := new(big.Int)
		// final_data1 := new(big.Int)
		final_data2 := new(big.Int)

		final_data = final_data.Add(new1, new3)
		final_data2 = final_data2.Sub(set_of1, final_data)

		CTjArray[x] = final_data2
		// t1 := time.Now()
		// fmt.Println(new1)

	}

	fmt.Println("this is CTJ value", CTjArray)
	map3 := make([]string, 0)

	map1 := make(map[string]int)
	for i, p := range lsss.RowToAttrib {
		fmt.Println(i)
		if i+2 > len(map1) {
			map1[p] = i
			map3 = append(map3, p)
		}
	}
	k := map3[len(map3)-1]
	fmt.Println(k)

	// delete(CTjArray, k)

	// fmt.Println("\nThis is chipertext data ABE ", CTjArray)
	// DK := make(map[string]*big.Int)
	for i, _ := range CTjArray {
		yjValue, _ := attrToPrivatMsp[i]
		concatenated := fmt.Sprintf("%d%d", PKAA, PID)
		// logical2.SetBytes([]byte(concatenated))

		hash := sha256.New()
		hash.Write([]byte(concatenated))
		hashValue1, _ := new(big.Int).SetString(hex.EncodeToString(hash.Sum(nil)), 16)
		new4 := new(big.Int)
		new4 = new4.Mul(hashValue1, tr_private_key.D)
		final_data := new(big.Int)
		final_data = final_data.Add(yjValue, new4)
		DK[i] = final_data

	}

	// fmt.Println(DK)
	// dm := make(map[string]*big.Int)
	//
	// DM := make(map[string]*big.Int)

	for i, x := range DK {

		new5 := new(big.Int)
		new5 = new5.Mul(x, ur_into_g)
		DM[i] = new5

	}

	// Summetion := make(map[string]*big.Int)

	for i, _ := range DM {

		new6 := new(big.Int)
		new6 = new6.Add(CTjArray[i], DM[i])
		Summetion[i] = new6

	}

	// fmt.Println(Summetion)

	Checking_data := make(map[string]string)

	sign_values_cal := make([]*big.Int, 0)

	total := new(big.Int)

	for i, j := range Summetion {
		// fmt.Println(i, j)
		k := big.NewInt(0)

		k = k.Add(k, j)

		Checking_data[j.String()] = i

		total = total.Add(total, k)
	}

	for _, i2 := range Checking_data {
		i3, t := Summetion[i2]
		if t == true {
			sign_values_cal = append(sign_values_cal, i3)
		}

	}

	new2 := new(big.Int)

	new4 := new(big.Int)

	summation_DJ_G := new(big.Int)
	for _, k := range sign_values_cal {
		new3 := k.Sign()
		fmt.Println(new3)
		if new3 < 0 {
			new2 = new2.Add(new2, k)

		} else {
			new4 = new4.Add(new4, k)

		}

		summation_DJ_G = summation_DJ_G.Add(new4, new2)
	}

	secreate_value := new(big.Int)
	secreate_value = secreate_value.Div(summation_DJ_G, G_value)
	fmt.Println(secreate_value)

	//msg decryption

	secreate_value_string := secreate_value.String()
	secreate_value_bytes := []byte(secreate_value_string)
	X_value, Y_value := elliptic.P256().ScalarBaseMult(secreate_value_bytes)
	SGProduct5 := elliptic.Marshal(elliptic.P256(), X_value, Y_value)

	hash_create := sha256.New()
	hash_create.Write(SGProduct5)
	hash_to_hexa := hex.EncodeToString(hash_create.Sum(nil))
	hash_value2, _ := new(big.Int).SetString(hash_to_hexa, 16)
	C0_value := C0
	new7 := new(big.Int)
	new7 = new7.Xor(hash_value2, C0_value)

	msg2 := new7.Bytes()
	myString := string(msg2[:])
	fmt.Println("this is decryption data::", string(myString))
	// fmt.Println("this is DK", DK)
	// fmt.Println("this is DM", DM)

	jsonMap := make(map[string]string)
	// err := json.Unmarshal([]byte(string(hex.DecodeString(myString))), &jsonMap)
	// //fmt.Sscanf(myString, "%x", &jsonMap)
	// fmt.Println("JSON Map", jsonMap)
	// //fmt.Println("Error from unmarshalling the map", err)
	// transactionData, err2 := json.Marshal(jsonMap)
	// fmt.Println("Error from marhsalling the map", err2)
	// fmt.Println("Transaction DAta in bytes ", transactionData)
	json.Unmarshal(msg2, &jsonMap)
	fmt.Println("Transaction Data", jsonMap)
	transactionData1, _ := json.Marshal(jsonMap)
	fmt.Println("Tranaction Data", transactionData1)

	//working W signer encryption

	// w_test1 := new(big.Int)
	messageInhex1 := hex.EncodeToString([]byte(msg))
	messageInValue1, _ := new(big.Int).SetString(messageInhex1, 16)
	concatenated_msg_peerID := fmt.Sprintf("%d%d", messageInValue1, PID)
	hash0 := sha256.New()
	hash0.Write([]byte(concatenated_msg_peerID))
	hashvalue_of_W, _ := new(big.Int).SetString(hex.EncodeToString(hash0.Sum(nil)), 16)

	multi_secreate_hash := new(big.Int)
	multi_secreate_hash = multi_secreate_hash.Mul(secreate_value, hashvalue_of_W)

	ur_add_screate_hash := new(big.Int)
	ur_add_screate_hash = ur_add_screate_hash.Add(ur_value, multi_secreate_hash)

	finalvalue_into_G := new(big.Int)
	finalvalue_into_G = finalvalue_into_G.Mul(ur_add_screate_hash, G_value)

	//verify side

	concatenated_msg_peerID1 := fmt.Sprintf("%d%d", new7, PID)
	hash2 := sha256.New()
	hash2.Write([]byte(concatenated_msg_peerID1))
	hashvalue_of_W1, _ := new(big.Int).SetString(hex.EncodeToString(hash2.Sum(nil)), 16)

	// fmt.Println("this is equil testing", hashvalue_of_W, hashvalue_of_W1)
	fmt.Println("this is screate value", secreate_value)

	verify_secreate__into_G := new(big.Int)
	verify_secreate__into_G = verify_secreate__into_G.Mul(secreate_value, G_value)
	verify_hash := new(big.Int)
	verify_hash = verify_hash.Mul(verify_secreate__into_G, hashvalue_of_W1)

	verify_PS_ADD_verify_hash := new(big.Int)
	verify_PS_ADD_verify_hash = verify_PS_ADD_verify_hash.Add(verify_hash, ur_into_g)

	fmt.Println("this is newbig5", verify_PS_ADD_verify_hash)
	fmt.Println("this is newBig2", finalvalue_into_G)
	if finalvalue_into_G == verify_PS_ADD_verify_hash {
		fmt.Println("successfully decrtpted")
	}
	checking1 := fmt.Sprintf("%v", finalvalue_into_G)

	checking2 := fmt.Sprintf("%v", verify_PS_ADD_verify_hash)

	if checking1 == checking2 {
		fmt.Println("success encryption and decryption")
	}

	final_data := make(map[string][]byte)

	CT, _ := json.Marshal(CTjArray)

	hash_value1, _ := json.Marshal(C0)

	signer_value, _ := json.Marshal(finalvalue_into_G)

	DK_value, _ := json.Marshal(DK)

	lsss_value, _ := json.Marshal(lsss.RowToAttrib)

	PS, _ := json.Marshal(ur_into_g)
	// Producer_send_data1, _ := json.Marshal(final_data)

	final_data["CT_value"] = CT
	final_data["hash_value"] = hash_value1

	final_data["signer"] = signer_value
	final_data["DK_value"] = DK_value
	final_data["lsss"] = lsss_value
	final_data["PS"] = PS
	// fmt.Println(w1)
	Producer_send_data1, _ := json.Marshal(final_data)
	fmt.Println("Producer data", Producer_send_data1)
	return Producer_send_data1
}

// var Handler handler

// func main() {
// 	fmt.Println("Program is working fine")
// }
