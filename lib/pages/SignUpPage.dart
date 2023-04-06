import 'dart:async';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:app2/shared/FireStoreFunctions.dart';
import 'package:app2/pages/LoginPage.dart';

import '../shared/tools.dart';

class SignUpPage extends StatefulWidget{
  const SignUpPage({super.key});


  @override
  _SignUpPage createState() => _SignUpPage();
}
late Timer DeleteAccountTimer;
late Timer VerifyTimer;
class _SignUpPage extends State<SignUpPage>{
  TextEditingController SignUpemailController = TextEditingController();
  TextEditingController SignUppasswordController = TextEditingController();


  @override
  Widget build(BuildContext context){
    return Scaffold(
      body:SingleChildScrollView(
        padding: const EdgeInsets.all(45),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height*0.35),
              TextField(

                controller: SignUpemailController,
                cursorColor: Colors.blueGrey,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                    labelText: "Enter Email",
                    constraints: BoxConstraints(maxHeight: 40,minHeight:30 ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: SignUppasswordController,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                    labelText: "Enter Password",
                    constraints: BoxConstraints(maxHeight: 40,minHeight:30 ),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                
                style: ElevatedButton.styleFrom(
                  maximumSize: const Size.fromHeight(50),
                ),
                icon: const Icon(Icons.add_box, size: 32),
                label: const Text(
                  'Sign Up',
                  style: TextStyle(fontSize: 24),
                ),
                onPressed: () async{
                  bool signedUp = await signUp(SignUpemailController.text.trim(),SignUppasswordController.text.trim());
                  if(EmailValidator.validate(SignUpemailController.text.trim()) && signedUp){
                      bool signedIn = await signIn(SignUpemailController.text.trim(),SignUppasswordController.text.trim());
                      await Add_Email_To_Database(SignUpemailController.text.trim());
                      await get_UserInfo();
                      print(SignUpemailController.text.trim() + " " + SignUppasswordController.text.trim());
                      FirebaseAuth.instance.currentUser?.sendEmailVerification();
                      DeleteAccountTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Email verification link has expired. Please sign up again'),
                          behavior: SnackBarBehavior.floating,
                        ));
                        AppManager.delete_User(SignUpemailController.text.trim());
                      });
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        duration: Duration(seconds: 10),
                        content: CountDown(time: 10,),
                        behavior: SnackBarBehavior.floating,
                      ));
                      VerifyTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
                        User_Verified(signedIn);
                      });

                  }
                  else{
                      print("Email invalid format or The Email is already used for another account");
                      if(signedUp) {
                        Delete_User_Info(SignUpemailController.text.trim());
                      }
                      //AppManager.delete_User(SignUpemailController.text.trim());
                  }

                },
              ),
              const SizedBox(height: 20),
              RichText(
                text: TextSpan(
                    style: const TextStyle(color: Colors.blueGrey),
                    text: 'Already have an account?  ',
                    children: [
                      TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap= () {Navigator.pop(context);},
                        text: "Sing In",
                        style: const TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.black,
                        ),
                      ),

                    ]
                ),
              ),
            ]
        ),

      ),
    );
  }



  Future User_Verified(bool SignedIn) async{
    // print(FirebaseAuth.instance.authStateChanges().listen((event) {print("Event from authStateChanges() : $event");}));
    print("Am I Signed In? : $SignedIn");
    if(!FirebaseAuth.instance.currentUser!.emailVerified) {
      await FirebaseAuth.instance.currentUser?.reload();
    }
    // print(FirebaseAuth.instance.currentUser?.emailVerified);
    if(FirebaseAuth.instance.currentUser?.emailVerified == true){
      //print("User Verified!");
      await signOut();
      DeleteAccountTimer.cancel();
      VerifyTimer.cancel();
      Navigator.pop(context);
    }
  }

  @override
  void dispose(){
    DeleteAccountTimer.cancel();
    VerifyTimer.cancel();
    super.dispose();

  }
}




