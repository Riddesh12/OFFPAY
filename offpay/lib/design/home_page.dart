import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart'; // To check connectivity
import 'package:offpay/query/data.dart';
import 'package:offpay/query/ussd.dart';
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
      drawer: Drawer(
        backgroundColor: Color(0xFFF3E5F5), // Light Lavender,
        child: Column(
          children: [
            DrawerHeader(
              child: Icon(
                Icons.verified_user,
                size: 50,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.send),
              title: const Text("SEND BY NUMBER"),
              onTap: () {
                Navigator.pushNamed(context, '/sendpage');
              },
            ),
            ListTile(
              leading: const Icon(Icons.qr_code),
              title: const Text("SEND BY QR"),
              onTap: () {
                Navigator.pushNamed(context, '/scanpage');
              },
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text("Transaction"),
              onTap: () {
                Navigator.pushNamed(context, '/transactionspage');
              },
            ),
          ],
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