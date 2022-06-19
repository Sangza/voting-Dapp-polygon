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
    Web3Client maticClient, String PrivateKey) async {
  EthPrivateKey credential = EthPrivateKey.fromHex(PrivateKey);

  DeployedContract contract = await loadcontract();
  final ethfunction = contract.function(funcname);
  final result = await maticClient.sendTransaction(
    credential,
    Transaction.callContract(
        contract: contract, function: ethfunction, parameters: args),
    chainId: null,
    fetchChainIdFromNetworkId: true,
  );

  return result;
}

//funx to start election
Future<String> startElection(String name, Web3Client maticClient) async {
  var response = await callFunction(
      'startElection', [name], maticClient, owner_private_key);
  print('Election Started Successfully');
  return response;
}

// function to add a candidate
Future<String> addCandidate(String name, Web3Client maticClient) async {
  var response = await callFunction(
      'addCandidate', [name], maticClient, owner_private_key);
  print('Candidate added Successfully');
  return response;
}

//function to authorize A voter
Future<String> authorizeVoter(String address, Web3Client maticClient) async {
  var response = await callFunction('authorizeVoter',
      [EthereumAddress.fromHex(address)], maticClient, owner_private_key);
  print('Voter Authorized Successfully');
  return response;
}

// function to call the function below
Future<List> getCandidatesNum(Web3Client maticClient) async {
  List<dynamic> result = await ask('getNumCandidates', [], maticClient);
  return result;
}

Future<List> getTotalVotes(Web3Client maticClient) async {
  List<dynamic> result = await ask('getTotalVotes', [], maticClient);
  return result;
}

Future<List> candidateInfo(int index, Web3Client maticClient) async {
  List<dynamic> result =
      await ask('candidateInfo', [BigInt.from(index)], maticClient);
  return result;
}

//function for getting the number of candidates
Future<List<dynamic>> ask(
    String funcName, List<dynamic> args, Web3Client maticClient) async {
  final contract = await loadcontract();
  final ethFunction = contract.function(funcName);
  final result =
      maticClient.call(contract: contract, function: ethFunction, params: args);
  return result;
}

//function for voting
Future<String> vote(int candidateIndex, Web3Client maticClient) async {
  var response = await callFunction(
      'vote', [BigInt.from(candidateIndex)], maticClient, voter_private_key);
  print('Vote counted Successfully');
  return response;
}
