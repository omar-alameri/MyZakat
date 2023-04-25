
import 'package:app2/shared/tools.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../shared/DataBase.dart';

class ZakatHistory extends StatefulWidget {
  const ZakatHistory({Key? key}) : super(key: key);

  @override
  State<ZakatHistory> createState() => _ZakatHistoryState();
}

class _ZakatHistoryState extends State<ZakatHistory> {
  late String userEmail='';
  @override
  void initState() {
    AppManager.readPref('userEmail').then((value)  {
    setState(() {
      userEmail=value;
    });});
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder<List<dynamic>>(
          future: DatabaseHelper.instance.getData(userEmail:userEmail,type:'Zakat'),
          builder: (BuildContext context,
              AsyncSnapshot<List<dynamic>> snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: Text('Loading...'));
            }
            return snapshot.data!.isEmpty
                ? Center(child: Text('No Zakat in List.'))
                : ListView(
              physics: const BouncingScrollPhysics(),
              children: snapshot.data!.map((dataInstance) {
                return Card(
                  child: ExpansionTile(
                    expandedAlignment: Alignment.centerLeft,
                    title: Text(dataInstance.date.toString().substring(0,16)),
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if(dataInstance.Gold!='')Text(dataInstance.Gold.toString()),
                          if(dataInstance.Silver!='')Text(dataInstance.Silver.toString()),
                          if(dataInstance.Stock!='')Text(dataInstance.Stock.toString()),
                          if(dataInstance.Money!='')Text(dataInstance.Money.toString()),
                          if(dataInstance.Livestock!='')Text(dataInstance.Livestock.toString()),
                          if(dataInstance.Crops!='')Text(dataInstance.Crops.toString()),
                        ],
                      )
                    ],
                  )
                );
              }).toList(),
            );
          }),
    );
  }
}
