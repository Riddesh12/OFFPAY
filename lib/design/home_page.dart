import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart'; // To check connectivity
import 'package:offpay/design/receiver.dart';
import 'package:offpay/design/signin.dart';
import 'package:offpay/query/data.dart';
import 'package:offpay/query/fileHandling.dart';
import 'package:offpay/query/ussd.dart';
import 'package:url_launcher/url_launcher.dart';
import 'scan_page.dart';
import 'send_page.dart';
import 'transactions_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  bool isSyncing = false;

  @override
  void initState() {
    super.initState();
    _checkConnectivityAndSync();
    UssdQuery().permission();
  }

  Future<void> _checkConnectivityAndSync() async {
    List<ConnectivityResult> result = (await Connectivity().checkConnectivity()) as List<ConnectivityResult>;
    if (result != ConnectivityResult.none) {
      Variables.connection=true;
      await _syncTransactions();
    } else {
      Variables.connection=false;
      print("No internet connection. Transactions will sync later.");
    }
  }

  Future<void> _syncTransactions() async {
    setState(() {
      isSyncing = true;
    });
    try {
      //await SyncManager.syncTransactions();
      print("Transactions synced successfully!");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Transactions synchronized!')),
      );
    } catch (e) {
      print("Error syncing transactions: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to sync transactions.')),
      );
    }
    setState(() {
      isSyncing = false;
    });
  }

  void _navigateBottomBar(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  final List pages = [
    SendPage(),
    ScanPage(),
    TransactionsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 219, 181, 248),
      appBar: AppBar(
        title: const Text(
          "OFFPay",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 219, 181, 248),
        actions: [
          if (isSyncing) const CircularProgressIndicator(),
        ],
      ),
      drawer: SafeArea(
        child: Drawer(
          backgroundColor: Color(0xFFF3E5F5), // Light Lavender,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Icon(
                    Icons.verified_user,
                    size: 20,
                  ),
                ),
              ),
              SizedBox(height:350,width:250,child: Receiver()),
              ListTile(
                leading: const Icon(Icons.send),
                title: Text(Variables.profile['Name']),
              ),
              ListTile(
                leading: const Icon(Icons.qr_code),
                title: Text(Variables.profile['Phone']),
              ),
              ListTile(
                leading: const Icon(Icons.contacts),
                title: const Text("Contact Us"),
                onTap: () async {
                  final url = "https://riddesh12.github.io/OFFPAY-contact-us-page/";
                  final Uri uri = Uri.parse(url);
                  if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                  } else {
                  throw 'Could not launch $url';
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text("LogOut"),
                onTap: () async {
                  FirebaseAuth.instance.signOut();
                  FileHandle().deleteLocalFiles("profile.json");
                  FileHandle().deleteLocalFiles("transactions.json");
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LogInState()));
                },
              ),
            ],
          ),
        ),
      ),
      body: pages[selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(
              255, 192, 131, 253),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: _navigateBottomBar,
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.black, // Highlight for the selected item
          unselectedItemColor:
          Colors.grey.shade600, // Grey for unselected items
          selectedIconTheme: const IconThemeData(size: 30),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.send),
              label: 'Send',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.qr_code),
              label: 'Scan',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'Transactions',
            ),
          ],
        ),
      ),
    );
  }
}
//home page