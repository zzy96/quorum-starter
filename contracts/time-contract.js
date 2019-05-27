web3.eth.defaultAccount = eth.accounts[0];

var abi = [{"constant":true,"inputs":[{"name":"timestamp","type":"uint256"}],"name":"getDifferenceInSeconds","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"get1Second","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"pure","type":"function"},{"constant":true,"inputs":[],"name":"getBlockTimeInSeconds","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"}]

var bytecode = "0x608060405234801561001057600080fd5b50610147806100206000396000f3fe608060405234801561001057600080fd5b506004361061005e576000357c0100000000000000000000000000000000000000000000000000000000900480634bed555a146100635780635a5ec77b146100a557806390627273146100c3575b600080fd5b61008f6004803603602081101561007957600080fd5b81019080803590602001909291905050506100e1565b6040518082815260200191505060405180910390f35b6100ad6100fe565b6040518082815260200191505060405180910390f35b6100cb610107565b6040518082815260200191505060405180910390f35b60008082420390506001818115156100f557fe5b04915050919050565b60006001905090565b600060014281151561011557fe5b0490509056fea165627a7a7230582010db125a2e381ed997cccf5ede3105c6dabcc47a76f3b68feffc7798d583b4df0029";

var newContract = web3.eth.contract(abi);
var c = newContract.new({from:web3.eth.accounts[0], data: bytecode, gas: 0x47b760}, function(e, contract) {
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