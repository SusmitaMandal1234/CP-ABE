// package main

// import (
// 	"context"
// 	"crypto/ecdsa"
// 	"crypto/elliptic"
// 	"crypto/rand"
// 	"crypto/sha256"
// 	"crypto/x509"
// 	"encoding/hex"
// 	"encoding/json"
// 	"encoding/pem"
// 	"errors"
// 	"fmt"
// 	"io/ioutil"
// 	"math/big"
// 	rand1 "math/rand"
// 	"os"
// 	"path/filepath"
// 	"strconv"

// 	"strings"
// 	"time"

// 	"github.com/fentec-project/bn256"
// 	"github.com/fentec-project/gofe/abe"
// 	"github.com/fentec-project/gofe/data"
// 	"github.com/fentec-project/gofe/sample"
// 	"github.com/hyperledger/fabric-sdk-go/pkg/core/config"
// 	"github.com/hyperledger/fabric-sdk-go/pkg/gateway"
// 	"github.com/segmentio/kafka-go"
// 	//"golang.org/x/exp/slices"
// 	// "gopkg.in/confluentinc/confluent-kafka-go.v1/kafka"
// )

// type cps struct {
// 	P *big.Int // order of the elliptic curve
// }

// const (
// 	topic         = "production"
// 	brokerAddress = "172.16.85.135:9092"
// )

// // NewFAME configures a new instance of the scheme.
// func newcps() *cps {

// 	return &cps{P: bn256.Order}
// }

// // FAMESecKey represents a master secret key of a FAME scheme.
// type cpsSecKey struct {
// 	PartInt [4]*big.Int
// 	PartG1  [3]*bn256.G1
// }

// // FAMEPubKey represents a public key of a FAME scheme.
// type cpsPubKey struct {
// 	PartG2 [2]*bn256.G2
// 	PartGT [2]*bn256.GT
// }
// type MSP struct {
// 	P           *big.Int
// 	Mat         data.Matrix
// 	RowToAttrib []string
// }
// type person struct {
// 	name string
// 	age  int
// }

// func main() {

// 	//this is message and policy  from comming kafka side front end

// 	var msg string
// 	//msg = `{"Txn Request":"submit Tender","Aadhar no":"231231233432","phone no":"7823086577","company name":"IDRBT","year of service":"2022"}`
// 	msg = `{"Name":"Pranay", "Email":"PranayChawhan2015@gmail.com", "Sample":"(National_Highway AND Suppliers_Raw_materials AND (Sand OR Soils OR Cement) )"}`
// 	policy := "(National_Highway AND Suppliers_Raw_materials AND (Sand OR Soils) )"

// 	//we converting that policy to lsss matrix

// 	lsss, err := abe.BooleanToMSP(policy, false)

// 	//we declare attribute of public key and attribute of private key

// 	attrToPubKeyMap := make(map[string]*big.Int)

// 	attrToPrivatMsp := make(map[string]*big.Int)
// 	fmt.Println("lsss", lsss.Mat)

// 	for i := 0; i < len(lsss.RowToAttrib); i++ {
// 		s := []byte(strconv.Itoa(5))

// 		x1, y1 := elliptic.P256().ScalarBaseMult(s)
// 		GProduct := elliptic.Marshal(elliptic.P256(), x1, y1)

// 		privateKey, _ := ecdsa.GenerateKey(elliptic.P256(), rand.Reader)

// 		pub1 := new(big.Int)
// 		pub1.SetBytes(GProduct)
// 		attribute_public_key := new(big.Int)

// 		attribute_public_key = attribute_public_key.Mul(pub1, privateKey.D)

// 		attrToPubKeyMap[lsss.RowToAttrib[i]] = attribute_public_key

// 		attrToPrivatMsp[lsss.RowToAttrib[i]] = privateKey.D

// 	}

// 	if err != nil {
// 		fmt.Println(attrToPrivatMsp, msg, attrToPubKeyMap, lsss)
// 	}

// 	//this is vectorArray generator for random vector
// 	vectorArray := make([]data.Vector, 0)

// 	bigArray := make([]*big.Int, 1)
// 	bigArray[0] = big.NewInt(2)
// 	vector := data.NewVector(bigArray)
// 	vectorArray = append(vectorArray, vector)
// 	for i := 0; i < len(lsss.Mat[0])-1; i++ {
// 		newBigInt, _ := rand.Prime(rand.Reader, 212)

// 		bigArray := make([]*big.Int, 1)
// 		bigArray[0] = newBigInt
// 		vector := data.NewVector(bigArray)

// 		vectorArray = append(vectorArray, vector)
// 	}
// 	fmt.Println("\nthis is vector data", vectorArray)

// 	//end for random vector

// 	//now genarating is only G value is
// 	s := []byte(strconv.Itoa(5))
// 	x3, y4 := elliptic.P256().ScalarBaseMult(s)
// 	SGProduct := elliptic.Marshal(elliptic.P256(), x3, y4)
// 	G_value := new(big.Int)
// 	G_value.SetBytes(SGProduct)

// 	//now genarating for hash of g value and hash of message C0
// 	s2 := []byte(strconv.Itoa(2))
// 	x1, y1 := elliptic.P256().ScalarBaseMult(s2)
// 	SGProduct1 := elliptic.Marshal(elliptic.P256(), x1, y1)
// 	hash := sha256.New()
// 	hash.Write(SGProduct1)
// 	hashstr := hex.EncodeToString(hash.Sum(nil))
// 	messageInhex := hex.EncodeToString([]byte(msg))
// 	hashInValue, _ := new(big.Int).SetString(hashstr, 16)
// 	messageInValue, _ := new(big.Int).SetString(messageInhex, 16)
// 	C0 := hashInValue.Xor(hashInValue, messageInValue)

// 	fmt.Println("this is C0 value", C0)

// 	ur_content, _ := ioutil.ReadFile("/home/cps16/Documents/New/test-network/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/msp/signcerts/cert.pem")
// 	ur_pem, _ := pem.Decode(ur_content)
// 	ur_key, _ := x509.ParseCertificate(ur_pem.Bytes)
// 	peer_key := ur_key.PublicKey.(*ecdsa.PublicKey)
// 	pkp_signer_key := elliptic.Marshal(elliptic.P256(), peer_key.X, peer_key.Y)
// 	ur_value := new(big.Int)
// 	ur_value.SetBytes(pkp_signer_key)

// 	ur_into_g := new(big.Int)
// 	ur_into_g = ur_into_g.Mul(G_value, ur_value)

// 	tr_content, _ := ioutil.ReadFile("/home/cps16/Documents/New/test-network/organizations/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/msp/keystore/priv_sk")
// 	tr_pem, _ := pem.Decode(tr_content)
// 	tr_key, _ := x509.ParsePKCS8PrivateKey(tr_pem.Bytes)
// 	tr_private_key := tr_key.(*ecdsa.PrivateKey)

// 	tr_g := new(big.Int)
// 	tr_g = tr_g.Mul(tr_private_key.D, G_value)

// 	X1 := new(big.Int)
// 	X1 = X1.Mul(tr_g, ur_value)

// 	// // //signer public and private key this is orginal wait for ------------this key wallet

// 	caCertificatePath, _ := ioutil.ReadFile("/home/cps16/Documents/New/test-network/organizations/peerOrganizations/org1.example.com/ca/ca.org1.example.com-cert.pem")
// 	pem_certificate, _ := pem.Decode(caCertificatePath)
// 	certificate_peer, _ := x509.ParseCertificate(pem_certificate.Bytes)

// 	PKAA, _ := new(big.Int).SetString(hex.EncodeToString(elliptic.Marshal(elliptic.P256(), certificate_peer.PublicKey.(*ecdsa.PublicKey).X, certificate_peer.PublicKey.(*ecdsa.PublicKey).Y)), 16)
// 	PID, _ := new(big.Int).SetString(hex.EncodeToString([]byte("peer1.org2.example.com")), 16)

// 	matrix2, err := data.NewMatrix(vectorArray)

// 	//vector to new matrix are genarating and then multi of lsss.Mat

// 	answerVector, err := lsss.Mat.Mul(matrix2)
// 	if err != nil {
// 		fmt.Println(PKAA, PID, C0)
// 	}

// 	//now calculate of encryption of
// 	CTjArray := make(map[string]*big.Int)

// 	for i, x := range lsss.RowToAttrib {
// 		Dj := answerVector[i][0]
// 		//set_off means Dj*G value calculate

// 		set_of1 := new(big.Int)
// 		set_of1 = set_of1.Mul(Dj, G_value)
// 		//set_off2 means Yj*Pj*ur cal

// 		yjValue := attrToPubKeyMap[x]
// 		pjValue := lsss.Mat[i]
// 		// ur := ur_key_private

// 		new1 := new(big.Int)

// 		new1 = new1.Mul(yjValue, ur_value)

// 		for p := 0; p < len(pjValue); p++ {
// 			number := 1
// 			if number == 1 {
// 				if pjValue[p] == big.NewInt(1) {
// 					new1 = new1.Mul(new1, big.NewInt(1))
// 					number = number + 1
// 				}

// 				if pjValue[p] == big.NewInt(-1) {

// 					new1 = new1.Mul(new1, big.NewInt(1))
// 					number = number + 1
// 				}
// 			}
// 		}

// 		// logical2 := new(big.Int)
// 		concatenated := fmt.Sprintf("%d%d", PKAA, PID)

// 		hash = sha256.New()
// 		hash.Write([]byte(concatenated))
// 		hashValue1, _ := new(big.Int).SetString(hex.EncodeToString(hash.Sum(nil)), 16)

// 		new3 := new(big.Int)
// 		new3 = new3.Mul(X1, hashValue1)
// 		final_data := new(big.Int)
// 		// final_data1 := new(big.Int)
// 		final_data2 := new(big.Int)

// 		final_data = final_data.Add(new1, new3)
// 		final_data2 = final_data2.Sub(set_of1, final_data)

// 		CTjArray[x] = final_data2
// 		// t1 := time.Now()
// 		// fmt.Println(new1)
// 	}

// 	t1 := time.Now()
// 	// fmt.Println("\nThis is chipertext data ABE ", CTjArray)
// 	DK := make(map[string]*big.Int)
// 	for i, x := range lsss.RowToAttrib {
// 		yjValue, _ := attrToPrivatMsp[x]
// 		concatenated := fmt.Sprintf("%d%d", PKAA, PID)
// 		// logical2.SetBytes([]byte(concatenated))

// 		hash = sha256.New()
// 		hash.Write([]byte(concatenated))
// 		hashValue1, _ := new(big.Int).SetString(hex.EncodeToString(hash.Sum(nil)), 16)
// 		new4 := new(big.Int)
// 		new4 = new4.Mul(hashValue1, tr_private_key.D)
// 		final_data := new(big.Int)
// 		final_data = final_data.Add(yjValue, new4)
// 		DK[lsss.RowToAttrib[i]] = final_data

// 	}

// 	// fmt.Println(DK)
// 	// dm := make(map[string]*big.Int)

// 	DM := make(map[string]*big.Int)

// 	for i, x := range DK {

// 		new5 := new(big.Int)
// 		new5 = new5.Mul(x, ur_into_g)
// 		DM[i] = new5

// 	}

// 	Summetion := make(map[string]*big.Int)

// 	for i, _ := range DM {

// 		new6 := new(big.Int)
// 		new6 = new6.Add(CTjArray[i], DM[i])
// 		Summetion[i] = new6

// 	}

// 	fmt.Println(Summetion)

// 	Checking_data := make(map[string]string)

// 	sign_values_cal := make([]*big.Int, 0)

// 	total := new(big.Int)

// 	for i, j := range Summetion {
// 		// fmt.Println(i, j)
// 		k := big.NewInt(0)

// 		k = k.Add(k, j)

// 		Checking_data[j.String()] = i

// 		total = total.Add(total, k)
// 	}

// 	for _, i2 := range Checking_data {
// 		i3, t := Summetion[i2]
// 		if t == true {
// 			sign_values_cal = append(sign_values_cal, i3)

// 		}

// 	}

// 	new2 := new(big.Int)

// 	new4 := new(big.Int)

// 	summation_DJ_G := new(big.Int)
// 	for _, k := range sign_values_cal {
// 		new3 := k.Sign()
// 		fmt.Println(new3)
// 		if new3 < 0 {
// 			new2 = new2.Add(new2, k)

// 		} else {
// 			new4 = new4.Add(new4, k)

// 		}

// 		summation_DJ_G = summation_DJ_G.Add(new4, new2)
// 	}

// 	secreate_value := new(big.Int)
// 	secreate_value = secreate_value.Div(summation_DJ_G, G_value)
// 	fmt.Println(secreate_value)

// 	//msg decryption

// 	secreate_value_string := secreate_value.String()
// 	secreate_value_bytes := []byte(secreate_value_string)
// 	X_value, Y_value := elliptic.P256().ScalarBaseMult(secreate_value_bytes)
// 	SGProduct5 := elliptic.Marshal(elliptic.P256(), X_value, Y_value)

// 	hash_create := sha256.New()
// 	hash_create.Write(SGProduct5)
// 	hash_to_hexa := hex.EncodeToString(hash_create.Sum(nil))
// 	hash_value2, _ := new(big.Int).SetString(hash_to_hexa, 16)
// 	C0_value := C0
// 	new7 := new(big.Int)
// 	new7 = new7.Xor(hash_value2, C0_value)
// 	msg2 := new7.Bytes()
// 	myString := string(msg2[:])
// 	fmt.Println("this is decryption data::", string(myString))

// 	final_data := make(map[string][]byte)

// 	// final_data1 := make(map[string][]byte)

// 	CT, _ := json.Marshal(CTjArray)

// 	hash_value, _ := json.Marshal(C0)

// 	DK_value, _ := json.Marshal(DK)

// 	PS, _ := json.Marshal(ur_into_g)

// 	lsss_value, _ := json.Marshal(lsss.RowToAttrib)

// 	final_data["CT_value"] = CT
// 	final_data["hash_value"] = hash_value
// 	final_data["DK_value"] = DK_value
// 	final_data["lsss"] = lsss_value
// 	final_data["PS"] = PS

// 	fmt.Println(final_data["lsss"])

// 	Producer_send_data1, _ := json.Marshal(final_data)

// 	rand1.Seed(time.Now().UnixNano())
// 	min := 2
// 	max := 4

// 	m := 4
// 	for m >= 1 {
// 		m = rand1.Intn(max-min+1) + min
// 		if m >= 2 {
// 			break
// 		}
// 	}

// 	ls := rand1.Perm(m)
// 	fmt.Println("this is random select", ls)
// 	mainlist := make([]int, 0)
// 	mainlist = append(mainlist, 0, 1, 2, 3)

// 	//topic := "idrbt3"
// 	fmt.Println(m)

// 	for _, j := range mainlist {
// 		partition := j
// 		conn, _ := kafka.DialLeader(context.Background(), "tcp", "172.16.85.135:9092", topic, partition)
// 		conn.SetWriteDeadline(time.Now().Add(10 * time.Second))

// 		sendMessage := false
// 		for _, k := range ls {
// 			if k == partition {
// 				sendMessage = true
// 				break
// 			}
// 		}
// 		if sendMessage {
// 			_, err = conn.WriteMessages(
// 				kafka.Message{
// 					Key:   []byte("5"),
// 					Value: Producer_send_data1},
// 			)
// 			fmt.Println("PArtition Value", j)
// 		} else {
// 			_, err = conn.WriteMessages(
// 				kafka.Message{
// 					Key:   []byte("5"),
// 					Value: []byte("Invalid Message")},
// 			)
// 			fmt.Println("PArtition nil", j)
// 		}
// 		//fmt.Println(err)
// 	}

// 	t2 := time.Now()

// 	diff1 := t2.Sub(t1)

// 	fmt.Println("total time will taken ", diff1)

// 	os.Setenv("DISCOVERY_AS_LOCALHOST", "true")
// 	wallet, err := gateway.NewFileSystemWallet("wallet")
// 	if err != nil {
// 		fmt.Printf("Failed to create wallet: %s\n", err)
// 		os.Exit(1)
// 	}

// 	if !wallet.Exists("appUser") {
// 		err = populateWallet(wallet)
// 		if err != nil {
// 			fmt.Printf("Failed to populate wallet contents: %s\n", err)
// 			os.Exit(1)
// 		}
// 	}

// 	ccpPath := filepath.Join(
// 		"..",
// 		"..",
// 		"test-network",
// 		"organizations",
// 		"peerOrganizations",
// 		"org1.example.com",
// 		"connection-org1.yaml",
// 	)

// 	gw, err := gateway.Connect(
// 		gateway.WithConfig(config.FromFile(filepath.Clean(ccpPath))),
// 		gateway.WithIdentity(wallet, "appUser"),
// 	)
// 	defer gw.Close()

// 	network, err := gw.GetNetwork("mychannel")
// 	contract := network.GetContract("LC_Transfer")

// 	txn, _ := contract.CreateTransaction("CreateRecord1")
// 	fmt.Println(txn)

// }

// func (a *cps) GenerateMasterKeys() (*cpsPubKey, *cpsSecKey, error) {
// 	sampler := sample.NewUniformRange(big.NewInt(1), a.P)
// 	val, err := data.NewRandomVector(7, sampler)
// 	if err != nil {
// 		return nil, nil, err
// 	}

// 	partInt := [4]*big.Int{val[0], val[1], val[2], val[3]}
// 	partG1 := [3]*bn256.G1{new(bn256.G1).ScalarBaseMult(val[4]),
// 		new(bn256.G1).ScalarBaseMult(val[5]),
// 		new(bn256.G1).ScalarBaseMult(val[6])}
// 	partG2 := [2]*bn256.G2{new(bn256.G2).ScalarBaseMult(val[0]),
// 		new(bn256.G2).ScalarBaseMult(val[1])}
// 	tmp1 := new(big.Int).Mod(new(big.Int).Add(new(big.Int).Mul(val[0], val[4]), val[6]), a.P)
// 	tmp2 := new(big.Int).Mod(new(big.Int).Add(new(big.Int).Mul(val[1], val[5]), val[6]), a.P)
// 	partGT := [2]*bn256.GT{new(bn256.GT).ScalarBaseMult(tmp1),
// 		new(bn256.GT).ScalarBaseMult(tmp2)}

// 	return &cpsPubKey{PartG2: partG2, PartGT: partGT},
// 		&cpsSecKey{PartInt: partInt, PartG1: partG1}, nil
// }

// func populateWallet(wallet *gateway.Wallet) error {
// 	credPath := filepath.Join(
// 		"..",
// 		"..",
// 		"test-network",
// 		"organizations",
// 		"peerOrganizations",
// 		"org1.example.com",
// 		"users",
// 		"User1@org1.example.com",
// 		"msp",
// 	)

// 	certPath := filepath.Join(credPath, "signcerts", "cert.pem")
// 	// read the certificate pem
// 	cert, err := ioutil.ReadFile(filepath.Clean(certPath))
// 	if err != nil {
// 		return err
// 	}

// 	keyDir := filepath.Join(credPath, "keystore")
// 	// there's a single file in this dir containing the private key
// 	files, err := ioutil.ReadDir(keyDir)
// 	if err != nil {
// 		return err
// 	}
// 	if len(files) != 1 {
// 		return errors.New("keystore folder should have contain one file")
// 	}
// 	keyPath := filepath.Join(keyDir, files[0].Name())
// 	key, err := ioutil.ReadFile(filepath.Clean(keyPath))
// 	if err != nil {
// 		return err
// 	}

// 	identity := gateway.NewX509Identity("Org1MSP", string(cert), string(key))

// 	err = wallet.Put("appUser", identity)
// 	if err != nil {
// 		return err
// 	}
// 	return nil
// }

// func GetPolicy(matrix data.Matrix, rowAttributes []string) map[string]*big.Int {

// 	RowToAttrib := make(map[string][]string, 0)

// 	for i := 0; i < len(matrix); i++ {
// 		//newString := matrix[i][0].String() + matrix[i][1].String() + matrix[i][2].String()
// 		newString := ""
// 		for j := 0; j < len(matrix[i]); j++ {
// 			newString += matrix[i][j].String()
// 		}
// 		valueFromMap := RowToAttrib[newString]
// 		valueFromMap = append(valueFromMap, rowAttributes[i])
// 		fmt.Println("Row to Attr", valueFromMap)
// 		for j := i + 1; j < len(matrix); j++ {
// 			newString1 := ""

// 			for k := 0; k < len(matrix[j]); k++ {
// 				newString1 += matrix[j][k].String()
// 			}
// 			if newString1 == newString {
// 				valueFromMap = append(valueFromMap, rowAttributes[j])
// 			}
// 		}
// 		RowToAttrib[newString] = valueFromMap
// 	}
// 	totalMap := make(map[string]*big.Int, 0)

// 	fmt.Println("RowToAttr", RowToAttrib)
// 	count := 1
// 	for _, value := range RowToAttrib {
// 		index := 0
// 		if len(value) > 1 {
// 			rand1.Seed(time.Now().UnixNano())
// 			min := 0
// 			max := len(value) - 1
// 			index = rand1.Intn(max-min+1) + min
// 			fmt.Println("index", index)
// 		} else {
// 			index = 0
// 		}
// 		totalMap[value[index]] = big.NewInt(int64(count))
// 		count++
// 	}

// 	return totalMap
// }

// func BooleanToMSP(boolExp string, convertToOnes bool) (*MSP, error) {
// 	// by the Lewko-Waters algorithm we obtain a MSP struct with the property
// 	// that is the the boolean expression is satisfied if and only if the corresponding
// 	// rows of the msp matrix span the vector [1, 0,..., 0]
// 	vec := make(data.Vector, 1)
// 	vec[0] = big.NewInt(1)
// 	msp, _, err := booleanToMSPIterative(boolExp, vec, 1)
// 	if err != nil {
// 		return nil, err
// 	}

// 	// if convertToOnes is set to true convert the matrix to such a MSP
// 	// struct so that the boolean expression is satisfied iff the
// 	// corresponding rows span the vector [1, 1,..., 1]
// 	if convertToOnes {
// 		// create an invertible matrix that maps [1, 0,..., 0] to [1,1,...,1]
// 		invMat := make(data.Matrix, len(msp.Mat[0]))
// 		for i := 0; i < len(msp.Mat[0]); i++ {
// 			invMat[i] = make(data.Vector, len(msp.Mat[0]))
// 			for j := 0; j < len(msp.Mat[0]); j++ {
// 				if i == 0 || j == i {
// 					invMat[i][j] = big.NewInt(1)
// 				} else {
// 					invMat[i][j] = big.NewInt(0)
// 				}
// 			}
// 		}
// 		//change the msp matrix by multiplying with it the matrix invMat
// 		msp.Mat, err = msp.Mat.Mul(invMat)
// 		if err != nil {
// 			return nil, err
// 		}
// 	}

// 	return msp, nil
// }
// func booleanToMSPIterative(boolExp string, vec data.Vector, c int) (*MSP, int, error) {
// 	boolExp = strings.TrimSpace(boolExp)
// 	numBrc := 0
// 	var boolExp1 string
// 	var boolExp2 string
// 	var c1 int
// 	var cOut int
// 	var msp1 *MSP
// 	var msp2 *MSP
// 	var err error
// 	found := false

// 	// find the main AND or OR gate and iteratively call the function on
// 	// both the sub-expressions
// 	for i, e := range boolExp {
// 		if e == '(' {
// 			numBrc++
// 			continue
// 		}
// 		if e == ')' {
// 			numBrc--
// 			continue
// 		}
// 		if numBrc == 0 && i < len(boolExp)-3 && boolExp[i:i+3] == "AND" {
// 			boolExp1 = boolExp[:i]
// 			boolExp2 = boolExp[i+3:]
// 			vec1, vec2 := makeAndVecs(vec, c)
// 			msp1, c1, err = booleanToMSPIterative(boolExp1, vec1, c+1)
// 			if err != nil {
// 				return nil, 0, err
// 			}
// 			msp2, cOut, err = booleanToMSPIterative(boolExp2, vec2, c1)
// 			if err != nil {
// 				return nil, 0, err
// 			}
// 			found = true
// 			break
// 		}
// 		if numBrc == 0 && i < len(boolExp)-2 && boolExp[i:i+2] == "OR" {
// 			boolExp1 = boolExp[:i]
// 			boolExp2 = boolExp[i+2:]
// 			msp1, c1, err = booleanToMSPIterative(boolExp1, vec, c)
// 			if err != nil {
// 				return nil, 0, err
// 			}
// 			msp2, cOut, err = booleanToMSPIterative(boolExp2, vec, c1)
// 			if err != nil {
// 				return nil, 0, err
// 			}
// 			found = true
// 			break
// 		}
// 	}

// 	// If the AND or OR gate is not found then there are two options,
// 	// either the whole expression is in brackets, or the the expression
// 	// is only one attribute. It neither of both is true, then
// 	// an error is returned while converting the expression into an
// 	// attribute
// 	if !found {
// 		if boolExp[0] == '(' && boolExp[len(boolExp)-1] == ')' {
// 			boolExp = boolExp[1:(len(boolExp) - 1)]
// 			return booleanToMSPIterative(boolExp, vec, c)
// 		}

// 		if strings.Contains(boolExp, "(") || strings.Contains(boolExp, ")") {
// 			return nil, 0, fmt.Errorf("bad boolean expression or attributes contain ( or )")
// 		}

// 		mat := make(data.Matrix, 1)
// 		mat[0] = make(data.Vector, c)
// 		for i := 0; i < c; i++ {
// 			if i < len(vec) {
// 				mat[0][i] = new(big.Int).Set(vec[i])
// 			} else {
// 				mat[0][i] = big.NewInt(0)
// 			}
// 		}

// 		rowToAttribS := make([]string, 1)
// 		rowToAttribS[0] = boolExp
// 		return &MSP{Mat: mat, RowToAttrib: rowToAttribS}, c, nil

// 	}
// 	// otherwise we join the two msp structures into one
// 	mat := make(data.Matrix, len(msp1.Mat)+len(msp2.Mat))
// 	for i := 0; i < len(msp1.Mat); i++ {
// 		mat[i] = make(data.Vector, cOut)
// 		for j := 0; j < len(msp1.Mat[0]); j++ {
// 			mat[i][j] = msp1.Mat[i][j]
// 		}
// 		for j := len(msp1.Mat[0]); j < cOut; j++ {
// 			mat[i][j] = big.NewInt(0)
// 		}
// 	}
// 	for i := 0; i < len(msp2.Mat); i++ {
// 		mat[i+len(msp1.Mat)] = msp2.Mat[i]
// 	}
// 	rowToAttribS := append(msp1.RowToAttrib, msp2.RowToAttrib...)

// 	return &MSP{Mat: mat, RowToAttrib: rowToAttribS}, cOut, nil
// }

// func makeAndVecs(vec data.Vector, c int) (data.Vector, data.Vector) {
// 	vec1 := data.NewConstantVector(c+1, big.NewInt(0))
// 	vec2 := data.NewConstantVector(c+1, big.NewInt(0))
// 	for i := 0; i < len(vec); i++ {
// 		vec2[i].Set(vec[i])
// 	}
// 	vec1[c] = big.NewInt(-1)
// 	vec2[c] = big.NewInt(1)

// 	return vec1, vec2
// }
