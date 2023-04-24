import 'package:firebase_auth/firebase_auth.dart';
import 'package:app2/shared/FireStoreFunctions.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:app2/shared/tools.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    AppManager.readPref('userEmail').then((value) {
      if (value != null) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          Navigator.popAndPushNamed(context, '/language');
        });
      }
    });
  }

  Future signInButton() async {
    showDialog(
        context: context,
        builder: (context) => const Center(child: CircularProgressIndicator()));
    bool signedIn = await signIn(emailController.text, passwordController.text);
    // SignedIn = await signIn();
    if (signedIn) {
      AppManager.savePref('userEmail', emailController.text.trim());
      Navigator.pushNamedAndRemoveUntil(context, '/language', (route) => false);
      // Navigator.popAndPushNamed(context, '/home');
    } else {
      if (mounted) {
        Navigator.pop(context, (route) => false);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Incorrect email or password.'),
          behavior: SnackBarBehavior.floating,
        ));
      }
      print("Not Signed In");
    }

// signOut();
// FirebaseAuth.instance.authStateChanges().listen((value) { print(value);});
  }

  // SingleChildScrollView
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(45),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.35),
          TextField(
            keyboardType: TextInputType.emailAddress,
            controller: emailController,
            cursorColor: Colors.blue,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: "Email",
              constraints: BoxConstraints(maxHeight: 40, minHeight: 30),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            onSubmitted: (s) {
              signInButton.call();
            },
            controller: passwordController,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(
              labelText: "Password",
              constraints: BoxConstraints(maxHeight: 40, minHeight: 30),
            ),
            obscureText: true,
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              maximumSize: const Size.fromHeight(50),
            ),
            icon: const Icon(Icons.lock_open, size: 32),
            label: const Text(
              'Sign In',
              style: TextStyle(fontSize: 24),
            ),
            onPressed: signInButton,
          ),
          const SizedBox(height: 20),
          RichText(
            text: TextSpan(
                style: const TextStyle(color: Colors.blueGrey),
                text: 'No account?  ',
                children: [
                  TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.pushNamed(context, '/signup');
                      },
                    text: "Sing Up",
                    style: const TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.black,
                    ),
                  ),
                ]),
          ),
        ]),
      ),
    );
  }
}

Future<bool> signIn(String Email, String Password) async {
  try {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: Email, password: Password);
    User_Email = await get_email();
    await get_User_Document_Id(User_Email);
    await Read_User_Zakat_Dates();
    print(
        "The email of the user is $User_Email \nThe Document Id is $User_Document_Id");
    //SignedIn =  true;
    return true;
  } on FirebaseAuthException catch (e) {
    print('Failed with error code: ${e.code}');
    print(e.message);
    //SignedIn = false;
    return false;
  }
}

Future signOut() async {
  await FirebaseAuth.instance.signOut();
  //SignedIn = false;
  // print("SignedIn in LoginPage after Signout is called: $SignedIn");
}

Future PrintUser_Info() async {
  FirebaseAuth.instance.authStateChanges().listen((value) {
    print("Printing from Home Page User Info : $value");
  });
}

Future signUp(email, password) async {
  try {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    return true;
  } on FirebaseAuthException catch (e) {
    print("Error while Signing you up: $e");
    return false;
  }
}

Future get_email() async {
  return await FirebaseAuth.instance.currentUser?.email;
}

Future verify_email() async {
  print("Verify account:");
  print(FirebaseAuth.instance.currentUser?.emailVerified);
  FirebaseAuth.instance.currentUser?.sendEmailVerification();
}
