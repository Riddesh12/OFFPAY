import 'package:flutter/material.dart';
import 'package:offpay/design/home_page.dart';
import 'package:offpay/design/signin.dart';
import 'dart:async';

import 'package:offpay/query/log_status.dart';

class SomeSecondPage extends StatefulWidget {
  const SomeSecondPage({super.key});

  @override
  State<SomeSecondPage> createState() => _SomeSecondPageState();
}

class _SomeSecondPageState extends State<SomeSecondPage> {
  @override
  void initState() {
    super.initState();
    firsCall();
  }

  void firsCall(){
    Timer(Duration(seconds: 2), () async {
      if(await LogStatus().fileIsEmpty("profile.json")){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>LogInState()));
      } else{
        Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 219, 181, 248),
      body: Center(
        child: Image.asset(
          'assest/logo.png',
          width: 300,
          height: 700,
        ),
      ),
    );
  }
}
//some