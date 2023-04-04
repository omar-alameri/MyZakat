import 'package:app2/shared/myDrawer.dart';
import 'package:flutter/material.dart';
import 'package:app2/shared/tools.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class homePage extends StatefulWidget {
  const homePage({Key? key}) : super(key: key);

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  @override

  Widget build(BuildContext context) {

    return Scaffold(

      drawer: const myDrawer(),
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: (){

                 Navigator.pushNamed(context, '/language');
              },
              child: const Text('Start'),
            ),

          ],
        ),
      ),
    );
  }
}
