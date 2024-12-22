import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:offpay/query/data.dart';

class PhoneAuth {
  String _verificationId = "";

  // This method verifies the phone number and sends the OTP
  Future<void> verifyPhone(String phone) async {
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phone, // Use the passed phone number
        verificationCompleted: (PhoneAuthCredential credential) async {
          // This callback is called when the verification is automatically completed
          await FirebaseAuth.instance.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          // Handle errors
          print('Verification failed: ${e.message}');
        },
        codeSent: (String verificationId, int? resendToken) {
          // This callback is called when the OTP is sent
          _verificationId = verificationId;
          print("Verification code sent to $phone");
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // This callback is called when the code auto-retrieval times out
          print("Timeout reached for auto retrieval");
        },
      );
    } catch (e) {
    // Handle any errors during phone number verification
    print('Error verifying phone number: ${e.toString()}');
    }
  }

  // This method signs the user in using the SMS code (OTP)
  Future<void> signIn(String sms) async {
    try {
      // Create the credential using the verificationId and the SMS code
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: sms,
      );

      // Sign in the user with the credential
      await FirebaseAuth.instance.signInWithCredential(credential);
      print("User signed in successfully");
    } catch (e) {
    // Handle any errors during sign-in
    print('Error signing in with OTP: ${e.toString()}');
    }
  }

  Future<void> databaseLogIn(String phone) async {
    final db = FirebaseFirestore.instance;
    await db.collection(phone).doc("profile").set(Variables.profile);
  }
}
