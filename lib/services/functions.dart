import 'package:flutter/services.dart';
import 'package:voting_dapp/Utils/constant.dart';
import 'package:web3dart/web3dart.dart';

//to load the contract
Future<DeployedContract> loadcontract() async {
  String abi = await rootBundle.loadString('assets/abi.json');
  String contractAddress = contractAddress1;

  final contract = DeployedContract(ContractAbi.fromJson(abi, 'Election'),
      EthereumAddress.fromHex(contractAddress));
  return contract;
}

//hyper func
Future<String> callFunction(String funcname, List<dynamic> args,
    Web3Client ethClient, String PrivateKey) async {
  EthPrivateKey credential = EthPrivateKey.fromHex(PrivateKey);
  DeployedContract contract = await loadcontract();
  final ethfunction = contract.function(funcname);
  final result = await ethClient.sendTransaction(
    credential,
    Transaction.callContract(
        contract: contract, function: ethfunction, parameters: args),
    chainId: null,
    fetchChainIdFromNetworkId: true,
  );

  return result;
}

//funx to start election
Future<String> startElection(String name, Web3Client ethClient) async {
  var response =
      await callFunction('startElection', [name], ethClient, owner_private_key);
  print('Election Started Successfully');
  return response;
}

// function to add a candidate
Future<String> addCandidate(String name, Web3Client ethClient) async {
  var response =
      await callFunction('addCandidate', [name], ethClient, owner_private_key);
  print('Candidate added Successfully');
  return response;
}

//function to authorize A voter
Future<String> authorizeVoter(String address, Web3Client ethClient) async {
  var response = await callFunction('authorizeVoter',
      [EthereumAddress.fromHex(address)], ethClient, owner_private_key);
  print('Voter Authorized Successfully');
  return response;
}

// function to call the function below
Future<List> getCandidatesNum(Web3Client ethClient) async {
  List<dynamic> result = await ask('getNumCandidates', [], ethClient);
  return result;
}

Future<List> getTotalVotes(Web3Client ethClient) async {
  List<dynamic> result = await ask('getTotalVotes', [], ethClient);
  return result;
}

Future<List> candidateInfo(int index, Web3Client ethClient) async {
  List<dynamic> result =
      await ask('candidateInfo', [BigInt.from(index)], ethClient);
  return result;
}

//function for getting the number of candidates
Future<List<dynamic>> ask(
    String funcName, List<dynamic> args, Web3Client ethClient) async {
  final contract = await loadcontract();
  final ethFunction = contract.function(funcName);
  final result =
      ethClient.call(contract: contract, function: ethFunction, params: args);
  return result;
}

//function for voting
Future<String> vote(int candidateIndex, Web3Client ethClient) async {
  var response = await callFunction(
      'vote', [BigInt.from(candidateIndex)], ethClient, voter_private_key);
  print('Vote counted Successfully');
  return response;
}
