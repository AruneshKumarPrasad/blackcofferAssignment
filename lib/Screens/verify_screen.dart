import 'package:blackcoffer/Helpers/firebase.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

import '../Global/global.dart';

class MyVerify extends StatefulWidget {
  const MyVerify({Key? key}) : super(key: key);

  @override
  State<MyVerify> createState() => _MyVerifyState();
}

class _MyVerifyState extends State<MyVerify> {
  String pinCode = '';
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as List<String>;

    return Scaffold(
      backgroundColor: GlobalTraits.bgGlobalColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.black,
          ),
        ),
        elevation: 0,
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 25, right: 25),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.phone_iphone,
                size: 60,
              ),
              const SizedBox(
                height: 25,
              ),
              const Text(
                "Phone Verification",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "We need to register your phone before getting started!",
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 30,
              ),
              Pinput(
                length: 6,
                showCursor: true,
                onChanged: (value) {
                  pinCode = value;
                },
                onCompleted: (value) {
                  pinCode = value;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: GlobalTraits.bgGlobalColorDark,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    onPressed: () {
                      final uid = FireHelp()
                          .fireReceiveCodeAndLogin(args[0], pinCode)
                          .then((value) => Navigator.pushNamedAndRemoveUntil(
                                context,
                                'home',
                                (route) => false,
                                arguments: [value],
                              ))
                          .catchError((e) {
                        return e.toString();
                      });
                    },
                    child: const Text("Verify Phone Number")),
              ),
              Row(
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          'phone',
                          (route) => false,
                        );
                      },
                      child: const Text(
                        "Edit Phone Number ?",
                        style: TextStyle(color: Colors.black),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
