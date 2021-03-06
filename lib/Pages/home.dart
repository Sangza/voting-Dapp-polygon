import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:voting_dapp/Pages/electionInfo.dart';
import 'package:voting_dapp/Utils/constant.dart';
import 'package:voting_dapp/services/functions.dart';
import 'package:web3dart/web3dart.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Client? httpClient;
  Web3Client? maticClient;
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    httpClient = Client();
    maticClient = Web3Client(alchemy_url, httpClient!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Start Election'),
      ),
      body: Container(
        padding: const EdgeInsets.all(14),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                  filled: true, hintText: 'Enter Election Name'),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                    onPressed: () async {
                      if (controller.text.length > 0) {
                        await startElection(controller.text, maticClient!);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => ElectionInfo(
                                    ethClient: maticClient!,
                                    electionName: controller.text))));
                      }
                    },
                    child: Text('Start Election')))
          ],
        ),
      ),
    );
  }
}
