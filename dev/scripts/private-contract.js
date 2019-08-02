// abi and bytecode generated from simplestorage.sol:
// > solcjs --bin --abi simplestorage.sol
var abi = [{"constant":true,"inputs":[],"name":"storedData","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"x","type":"uint256"}],"name":"set","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"get","outputs":[{"name":"retVal","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"inputs":[{"name":"initVal","type":"uint256"}],"payable":false,"stateMutability":"nonpayable","type":"constructor"},{"anonymous":false,"inputs":[{"indexed":false,"name":"value","type":"uint256"}],"name":"valueSet","type":"event"}];
var bytecode = "0x608060405234801561001057600080fd5b506040516020806101a583398101806040528101908080519060200190929190505050806000819055505061015b8061004a6000396000f300608060405260043610610057576000357c0100000000000000000000000000000000000000000000000000000000900463ffffffff1680632a1afcd91461005c57806360fe47b1146100875780636d4ce63c146100b4575b600080fd5b34801561006857600080fd5b506100716100df565b6040518082815260200191505060405180910390f35b34801561009357600080fd5b506100b2600480360381019080803590602001909291905050506100e5565b005b3480156100c057600080fd5b506100c9610126565b6040518082815260200191505060405180910390f35b60005481565b806000819055507fefe5cb8d23d632b5d2cdd9f0a151c4b1a84ccb7afa1c57331009aa922d5e4f36816040518082815260200191505060405180910390a150565b600080549050905600a165627a7a7230582075a0aa396432fc1ffe6265f15922e306dc2f02bcd25b40decc75f1d5213488090029";

// privateFor
var allNodes = ["QfeDAys9MPDs2XHExtc84jKGHxZg/aj52DTh0vtA3Xc=", "1iTZde/ndBHvzhcl7V68x44Vx7pl8nwx9LqnM/AfJUg=","oNspPPgszVUFw0qmGFfWwh1uxVUXgvBxleXORHj07g8=","R56gy4dn24YOjwyesTczYa8m5xhP6hF2uTMCju/1xkY=","UfNSeSGySeKg11DVNEnqrUtxYRVor4+CvluI8tVv62Y=","ROAZBWtSacxXQrOe3FGAqJDyJjFePR5ce4TSIzmJ0Bc="];
var fourNodes = ["QfeDAys9MPDs2XHExtc84jKGHxZg/aj52DTh0vtA3Xc=", "1iTZde/ndBHvzhcl7V68x44Vx7pl8nwx9LqnM/AfJUg=","oNspPPgszVUFw0qmGFfWwh1uxVUXgvBxleXORHj07g8="];
var twoNodes = ["QfeDAys9MPDs2XHExtc84jKGHxZg/aj52DTh0vtA3Xc="];
var singleNode = [];

var simpleContract = web3.eth.contract(abi);
var simple = simpleContract.new(42, {from:eth.accounts[0], data: bytecode, gas: 0x47b760, privateFor: fourNodes}, function(e, contract) {
	if (e) {
		console.log("err creating contract", e);
	} else {
		if (!contract.address) {
			console.log("Contract transaction send: TransactionHash: " + contract.transactionHash + " waiting to be mined...");
		} else {
			console.log("Contract mined! Address: " + contract.address);
		}
	}
});

// Node1 constellation key: BULeR8JyUWhiuuCMU/HLA0Q5pzkYT+cHII3ZKBey3Bo=
