import 'package:flutter/material.dart';
import 'package:offpay/query/data.dart';
import 'package:offpay/query/trascation_query.dart';
import 'package:offpay/query/ussd.dart';

class SendPage extends StatelessWidget {
  const SendPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Controllers for the input fields
    final TextEditingController phoneController = TextEditingController();
    final TextEditingController amountController = TextEditingController();
    final TextEditingController remarkController = TextEditingController();

    return Scaffold(
     // appBar: AppBar(
       // title: Text('Send Money'),
      //),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      UssdQuery.sendUssdCode("*99*3#");
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow, // Yellow background
                      fixedSize: Size(120, 50), // Button size
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text("Balance"),
                  ),
                  // ElevatedButton(
                  //   onPressed: () {
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(builder: (context) => Receiver()),
                  //     );
                  //   },
                  //   style: ElevatedButton.styleFrom(
                  //     backgroundColor: Colors.yellow, // Yellow background
                  //     fixedSize: Size(120, 50), // Button size
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(8),
                  //     ),
                  //   ),
                  //   child: Text("QR"),
                  // ),
                ],
              ),
              SizedBox(height: 16),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 16),
              TextField(
                controller: amountController,
                decoration: InputDecoration(
                  labelText: 'Amount',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.attach_money),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              TextField(
                controller: remarkController,
                decoration: InputDecoration(
                  labelText: 'Remark (optional)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.feedback),
                ),
              ),
              SizedBox(height: 24),
              Center(
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Fetch values from the controllers
                        String phone = phoneController.text;
                        String amount = amountController.text;
                        String remark = remarkController.text.isEmpty
                            ? "1"
                            : remarkController.text.trim();
                        // Simple validation
                        if (phone.isEmpty || amount.isEmpty || remark.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Please fill all the fields')),
                          );
                        } else {
                          UssdQuery.sendUssdCode(
                              "*99*1*1*${phoneController.text.trim()}*${amountController.text.trim()}*$remark#");
                          Variables.mapTransaction = {
                            "payto": phoneController.text.trim(),
                            "amount": amountController.text.trim(),
                            "time": DateTime.now().toString(),
                            "location": "",
                            "status": Variables.tranStatus,
                            "remark": remark
                          };
                          Transaction()
                              .transactionCheckAndAdd(Variables.mapTransaction);
                          /////enter transaction code here and check transaction status
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding:
                        EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      ),
                      child: Text('Pay'),
                    ),
                    SizedBox(height: 8), // Space between button and text
                    Text(
                      'Quick Access Offline Service',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 16), // Space below Quick Access
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     // ElevatedButton(
                    //     //   onPressed: () {
                    //     //     UssdQuery.sendUssdCode("*99*3#");
                    //     //   },
                    //     //   style: ElevatedButton.styleFrom(
                    //     //     backgroundColor: Colors.yellow, // Yellow background
                    //     //     fixedSize: Size(80, 80), // Square shape
                    //     //     shape: RoundedRectangleBorder(
                    //     //       borderRadius: BorderRadius.circular(8),
                    //     //     ),
                    //     //   ),
                    //     //   child: Text("Check Amount"),
                    //     // ),
                    //    // SizedBox(width: 16), // Space between buttons
                    //     ElevatedButton(
                    //       onPressed: () {
                    //         Navigator.push(
                    //             context,
                    //             MaterialPageRoute(
                    //                 builder: (context) => Receiver()));
                    //       },
                    //       style: ElevatedButton.styleFrom(
                    //         backgroundColor: Colors.yellow, // Yellow background
                    //         fixedSize: Size(80, 80), // Square shape
                    //         shape: RoundedRectangleBorder(
                    //           borderRadius: BorderRadius.circular(8),
                    //         ),
                    //       ),
                    //       child: Text("QR"),
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
//send page