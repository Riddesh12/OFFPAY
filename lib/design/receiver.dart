import 'package:flutter/material.dart';
import 'package:offpay/query/data.dart';
import 'package:qr_flutter/qr_flutter.dart';

class Receiver extends StatefulWidget {
  const Receiver({super.key});

  @override
  State<Receiver> createState() => _ReceiverState();
}

class _ReceiverState extends State<Receiver> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 219, 181, 248),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20), // Add some spacing
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: QrImageView(
                    data: Variables.profile['Phone'],/////////////////////////////////////////////////////////
                  size: 200.0,
                  embeddedImage: AssetImage('asset/images.jpg'),
                  embeddedImageStyle: QrEmbeddedImageStyle(
                    size: Size(10, 10),
                  ),
                ),
              ),
              Text(Variables.profile['Name']),
            ],
          ),
        ),
      ),
    );
  }
}
