curl -X POST http://127.0.0.1:22000 --data "{\"jsonrpc\":\"2.0\",\"method\":\"eth_signTransaction\",\"params\":[{\"from\":\"0xed9d02e382b34818e88b88a309c7fe71e65f419d\",\"gas\":\"0x47b760\",\"data\":\"0x608060405234801561001057600080fd5b506040516020806101698339810180604052602081101561003057600080fd5b81019080805190602001909291905050508060008190555050610111806100586000396000f3fe6080604052348015600f57600080fd5b5060043610604f576000357c01000000000000000000000000000000000000000000000000000000009004806360fe47b11460545780636d4ce63c14607f575b600080fd5b607d60048036036020811015606857600080fd5b8101908080359060200190929190505050609b565b005b608560dc565b6040518082815260200191505060405180910390f35b806000819055507fefe5cb8d23d632b5d2cdd9f0a151c4b1a84ccb7afa1c57331009aa922d5e4f36816040518082815260200191505060405180910390a150565b6000805490509056fea165627a7a72305820d3097fece2e8aac56ea743d30825111f2d97564c44ab8dc0dd5c4599d1631b010029000000000000000000000000000000000000000000000000000000000130b973\",\"gasPrice\":\"0x0\",\"nonce\":\"0x0\"}],\"id\":\"$i\"}" --header "Content-Type: application/json"

# curl -X POST http://127.0.0.1:22000 --data "{\"jsonrpc\":\"2.0\",\"method\":\"eth_sendRawTransaction\",\"params\":[\"0xf901d701808347b7608080b90189608060405234801561001057600080fd5b506040516020806101698339810180604052602081101561003057600080fd5b81019080805190602001909291905050508060008190555050610111806100586000396000f3fe6080604052348015600f57600080fd5b5060043610604f576000357c01000000000000000000000000000000000000000000000000000000009004806360fe47b11460545780636d4ce63c14607f575b600080fd5b607d60048036036020811015606857600080fd5b8101908080359060200190929190505050609b565b005b608560dc565b6040518082815260200191505060405180910390f35b806000819055507fefe5cb8d23d632b5d2cdd9f0a151c4b1a84ccb7afa1c57331009aa922d5e4f36816040518082815260200191505060405180910390a150565b6000805490509056fea165627a7a72305820d3097fece2e8aac56ea743d30825111f2d97564c44ab8dc0dd5c4599d1631b010029000000000000000000000000000000000000000000000000000000000130b97338a0eac02896d8a6dbff0df619d3048e375692ae01817437577cdd7d6cc465540bcba02b9d5243901ab2712b0056c2b94a4c140dcb6309f7178fadad80b249bdd74dc3\"],\"id\":\"$i\"}" --header "Content-Type: application/json"