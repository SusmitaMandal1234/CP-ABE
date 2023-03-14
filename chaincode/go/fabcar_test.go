/*
SPDX-License-Identifier: Apache-2.0
*/

package main

import (
	"testing"

	"github.com/hyperledger/fabric-contract-api-go/contractapi"
)

func TestSmartContract_DecryptMessage(t *testing.T) {
	type fields struct {
		Contract contractapi.Contract
	}
	type args struct {
		ctx           contractapi.TransactionContextInterface
		transactionID string
	}
	tests := []struct {
		name    string
		fields  fields
		args    args
		wantErr bool
	}{
		// TODO: Add test cases.
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			s := &SmartContract{
				Contract: tt.fields.Contract,
			}
			if err := s.DecryptMessage(tt.args.ctx, tt.args.transactionID); (err != nil) != tt.wantErr {
				t.Errorf("SmartContract.DecryptMessage() error = %v, wantErr %v", err, tt.wantErr)
			}
		})
	}
}
