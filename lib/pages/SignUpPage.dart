import 'dart:async';

import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:app2/shared/FireStoreFunctions.dart';
import 'package:app2/pages/LoginPage.dart';

class SignUpPage extends StatefulWidget{
  const SignUpPage({super.key});


  @override
  _SignUpPage createState() => _SignUpPage();
}
late Timer DeleteAccountTimer;
late Timer VerifyTimer;
class _SignUpPage extends State<SignUpPage>{
  final SignUpemailController = TextEditingController();
  final SignUppasswordController = TextEditingController();


  @override
  Widget build(BuildContext context){
    return Scaffold(
      body:SingleChildScrollView(
        padding: EdgeInsets.all(45),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 235),
              TextField(
                controller: SignUpemailController,
                cursorColor: Colors.blueGrey,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(labelText: "Enter Email"),
              ),
              SizedBox(height: 4),
              TextField(
                controller: SignUppasswordController,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(labelText: "Enter Password"),
                obscureText: true,
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                
                style: ElevatedButton.styleFrom(
                  primary: Colors.blueGrey,
                  maximumSize: Size.fromHeight(50),
                ),
                icon: Icon(Icons.add_box, size: 32),
                label: Text(
                  'Sign Up',
                  style: TextStyle(fontSize: 24),
                ),
                onPressed: () async{
                  await signUp(SignUpemailController.text.trim(),SignUppasswordController.text.trim(), context);
                  await get_UserInfo();
                    if(EmailValidator.validate(SignUpemailController.text.trim()) && !email_Used(SignUpemailController.text.trim())){
                      await Add_Email_To_Database(SignUpemailController.text.trim());
                      await get_UserInfo();
                      await signIn(SignUpemailController.text.trim(),SignUppasswordController.text.trim());
                      print(SignUpemailController.text.trim() + " " + SignUppasswordController.text.trim());
                      FirebaseAuth.instance.currentUser?.sendEmailVerification();
                      DeleteAccountTimer = Timer.periodic(Duration(seconds: 30), (timer) {delete_User(SignUpemailController.text.trim());});
                      VerifyTimer = Timer.periodic(Duration(seconds: 2), (timer) {User_Verified();});

                    }
                    else{
                      print("Email invalid format or The Email is already used for another account");
                      delete_User(SignUpemailController.text.trim());
                    }

                },
              ),
              SizedBox(height: 20),
              RichText(
                text: TextSpan(
                    style: TextStyle(color: Colors.blueGrey),
                    text: 'Already have an account?  ',
                    children: [
                      TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap= () {Navigator.pop(context);},
                        text: "Sing In",
                        style: TextStyle(
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



  Future User_Verified() async{
    // print(FirebaseAuth.instance.authStateChanges().listen((event) {print("Event from authStateChanges() : $event");}));
    print("Am I Signed In? : $SignedIn");
    if(!FirebaseAuth.instance.currentUser!.emailVerified)
      await FirebaseAuth.instance.currentUser?.reload();

    // print(FirebaseAuth.instance.currentUser?.emailVerified);
    if(FirebaseAuth.instance.currentUser?.emailVerified == true){
      print("User Verified!");
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



Future delete_User(String Email) async{
  DeleteAccountTimer.cancel();
  VerifyTimer.cancel();
  Delete_User_Info(Email);
  await FirebaseAuth.instance.currentUser?.delete();
  await signOut();
  print("Email verification link has expired. Please sign up again");


}
