
import 'package:app2/shared/dataModels.dart';
import 'package:flutter/material.dart';
import 'package:app2/shared/tools.dart';
import 'package:app2/shared/DataBase.dart';

class DataType extends StatefulWidget {
  final String datatype;

  const DataType({super.key, required this.datatype});

  @override
  State<DataType> createState() => _DataTypeState();
}

class _DataTypeState extends State<DataType> {
  dynamic selected;
  TextEditingController input = TextEditingController();
  double? height = 15;
  Widget holder = const CircularProgressIndicator();
  int? selectedId;
  double total = 0;
  String preferredCurrency = '';
  List<String> goldRate = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    AppManager.readPref('pCurrency').then((value)
         {setState(() {preferredCurrency = value;});});
  }
  Widget dataTable(String dataType){
    return FutureBuilder<List<dynamic>>(
        future: DatabaseHelper.instance.getData(1,dataType),
        builder: (BuildContext context,
            AsyncSnapshot<List<dynamic>> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: Text('Loading...'));
          }
          return snapshot.data!.isEmpty
              ? const Center(child: Text('No Gold in List.'))
              : ListView(
            children: snapshot.data!.map((dataInstance) {
              return Center(
                heightFactor: 1,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(flex:3,child: Text(dataInstance.amount.toString())),
                        Expanded(flex:2,child: Text(dataType == 'Money' ? dataInstance.currency :
                        dataType == 'Cattle' ? dataInstance.type : dataInstance.unit)),
                        Expanded(
                          flex: 1,
                          child: IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: ()  {
                              setState(() {
                                DatabaseHelper.instance.removeData(dataInstance);
                              });
                            },
                          ),
                        ),
                      ],

                    ),
                    const Divider(),
                  ],
                ),
              );
            }).toList(),
          );
        });
  }
  Widget MoneyWidget() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
                flex: 3,
                child: TextField(
                    decoration: const InputDecoration(border: OutlineInputBorder()),
                    keyboardType: const TextInputType.numberWithOptions(signed: false),
                    style: const TextStyle(fontSize:20),
                    controller: input,
                  ),),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(),
                child: DropdownButton(

                    hint: const Text('Select currency'),
                    value: selected,
                    items: const [
                      DropdownMenuItem(
                        value: 'AED',
                        child: Text('AED'),
                      ),
                      DropdownMenuItem(
                        value: 'USD',
                        child: Text('USD'),
                      ),
                    ],
                    onChanged: (var newValue) {
                      setState(() {
                        selected = newValue;
                      });
                    }),
              ),
            ),
            Expanded(
              flex: 1,
              child: IconButton(
                icon: const Icon(Icons.add),
                onPressed: () async {
                  if(input.text != '') {
                    await DatabaseHelper.instance.addData(
                    Money(amount: double.parse(input.text),currency: selected,userId: 1,date: DateTime.now()),
                  );
                  }
                  AppManager.calcTotalMoney().then((value)
                  {setState(() {total=value;
                  });});
                  setState(() {
                    if(input.text!=''&&selected!=null) {
                      input.text='';
                    }
                    height=15 + (height ?? 0) ;
                  });
                },
              ),
            ),
          ],
        ),
        const Divider(height: 10),
        SizedBox(
             height: MediaQuery.of(context).size.height*0.4,
          child: dataTable('Money')
        ),
        const Divider(height: 20, color: Colors.green,),
        ElevatedButton(onPressed: calculateMoneyZakat, child: const Text('Calculate Zakat')),
      ],
    );
  }
  Widget GoldWidget() {

    AppManager.get_GoldPriceDubai().then((value) {
      if (goldRate.toString() != value.toString())
      {goldRate = value;
      holder = Text('1: ${goldRate[0]} 2: ${goldRate[1]}, 3: ${goldRate[2]}, 4: ${goldRate[3]} ');
        setState(() {});
      }});
    return Column(

      children: [
        Row(
          children: [
            Expanded(
              flex: 3,
              child: TextField(
                  decoration: const InputDecoration(border: OutlineInputBorder()),
                  keyboardType: const TextInputType.numberWithOptions(signed: false),
                  //contextMenuBuilder: ,
                  style: const TextStyle(fontSize:20),
                  controller: input,
                ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(),
                child: DropdownButton(

                    hint: const Text('Select unit'),
                    value: selected,
                    items: const [
                      DropdownMenuItem(
                        value: 'Gram K24',
                        child: Text('Gram K24'),
                      ),
                      DropdownMenuItem(
                        value: 'Gram K22',
                        child: Text('Gram K22'),
                      ),
                      DropdownMenuItem(
                        value: 'Gram K21',
                        child: Text('Gram K21'),
                      ),
                      DropdownMenuItem(
                        value: 'Gram K18',
                        child: Text('Gram K18'),
                      ),
                    ],
                    onChanged: (var newValue) {
                      setState(() {
                        selected = newValue;
                      });
                    }),
              ),
            ),
            Expanded(
              flex: 1,
              child: IconButton(
                icon: const Icon(Icons.add),
                onPressed: () async {
                  if(input.text != '') {
                    await DatabaseHelper.instance.addData(
                      Gold(amount: double.parse(input.text),unit: selected,userId: 1,date: DateTime.now()),
                    );
                  }
                  setState(() {
                    if(input.text!=''&&selected!=null) {
                      input.text='';
                    }
                    height=15 + (height ?? 0) ;
                  });
                },
              ),
            ),
          ],
        ),
        const Divider(height: 10),

        SizedBox(
          height: MediaQuery.of(context).size.height*0.4,
          child: dataTable('Gold')
        ),
        holder,
      ],
    );
  }
  Widget SilverWidget() {

    AppManager.get_GoldPriceDubai().then((value) {
      if (goldRate.toString() != value.toString())
      {goldRate = value;
      holder = Text('1: ${goldRate[0]} 2: ${goldRate[1]}, 3: ${goldRate[2]}, 4: ${goldRate[3]} ');
      }});
    return Column(

      children: [
        Row(
          children: [
            Expanded(
              flex: 3,
              child: TextField(
                decoration: const InputDecoration(border: OutlineInputBorder()),
                keyboardType: const TextInputType.numberWithOptions(signed: false),
                //contextMenuBuilder: ,
                style: const TextStyle(fontSize:20),
                controller: input,
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(),
                child: DropdownButton(

                    hint: const Text('Select unit'),
                    value: selected,
                    items: const [
                      DropdownMenuItem(
                        value: 'Gram K99.9',
                        child: Text('Gram K99.9'),
                      ),
                      DropdownMenuItem(
                        value: 'Gram K95.8',
                        child: Text('Gram K95.8'),
                      ),
                      DropdownMenuItem(
                        value: 'Gram K92.5',
                        child: Text('Gram K92.5'),
                      ),
                      DropdownMenuItem(
                        value: 'Gram K90',
                        child: Text('Gram K90'),
                      ),
                      DropdownMenuItem(
                        value: 'Gram K80',
                        child: Text('Gram K80'),
                      ),
                    ],
                    onChanged: (var newValue) {
                      setState(() {
                        selected = newValue;
                      });
                    }),
              ),
            ),
            Expanded(
              flex: 1,
              child: IconButton(
                icon: const Icon(Icons.add),
                onPressed: () async {
                  if(input.text != '') {
                    await DatabaseHelper.instance.addData(
                      Silver(amount: double.parse(input.text),unit: selected,userId: 1,date: DateTime.now()),
                    );
                  }
                  setState(() {
                    if(input.text!=''&&selected!=null) {
                      input.text='';
                    }
                    height=15 + (height ?? 0) ;
                  });
                },
              ),
            ),
          ],
        ),
        const Divider(height: 10),

        SizedBox(
          height: MediaQuery.of(context).size.height*0.4,
          child: dataTable('Silver')
        ),

      ],
    );
  }
  Widget CattleWidget() {
    return Column(

      children: [
        Row(
          children: [
            Expanded(
              flex: 3,
              child: TextField(
                decoration: const InputDecoration(border: OutlineInputBorder()),
                keyboardType: const TextInputType.numberWithOptions(signed: false),
                //contextMenuBuilder: ,
                style: const TextStyle(fontSize:20),
                controller: input,
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(),
                child: DropdownButton(

                    hint: const Text('Select type'),
                    value: selected,
                    items: const [
                      DropdownMenuItem(
                        value: 'Cow',
                        child: Text('Cow'),
                      ),
                      DropdownMenuItem(
                        value: 'Camel',
                        child: Text('Camel'),
                      ),
                      DropdownMenuItem(
                        value: 'Sheep',
                        child: Text('Sheep'),
                      ),
                    ],
                    onChanged: (var newValue) {
                      setState(() {
                        selected = newValue;
                      });
                    }),
              ),
            ),
            Expanded(
              flex: 1,
              child: IconButton(
                icon: const Icon(Icons.add),
                onPressed: () async {
                  if(input.text != '') {
                    await DatabaseHelper.instance.addData(
                      Cattle(amount: int.parse(input.text),type: selected,userId: 1,date: DateTime.now()),
                    );
                  }
                  setState(() {
                    if(input.text!=''&&selected!=null) {
                      input.text='';
                    }
                    height=15 + (height ?? 0) ;
                  });
                },
              ),
            ),
          ],
        ),
        const Divider(height: 10),

        SizedBox(
          height: MediaQuery.of(context).size.height*0.4,
          child: dataTable('Cattle')
        ),
        ElevatedButton(onPressed: calculateCattleZakat, child: const Text('Calculate Zakat'))
      ],
    );
  }


  void calculateCattleZakat() async {
    List<dynamic> list = await DatabaseHelper.instance.getData(1,'Cattle');
    int cow= 0;
    int camel= 0;
    int sheep= 0;
    String message = '';

    for (var e in list){
      if(e.type == 'Cow') {cow+= int.parse(e.amount);
      } else if(e.type == 'Sheep') {sheep+= int.parse(e.amount);
      } else if(e.type == 'Camel') {camel+= int.parse(e.amount);
      }
    }
    message +='Cow Zakat: ';

    if(cow<30) {
      message +=("nothing");
    } else if(cow>=30 && cow<=39) {
      message +=("tabeea'");
    } else if(cow>=40 && cow<=59) {
      message +=("msnaa");
    } else if(cow>=60 && cow<=69) {
      message +=("2 tabeea'");
    } else if(cow>=70 && cow<=79) {
      message +=("msnaa and tbeea'");
    } else if(cow>=80 && cow<=89) {
      message +=("2 msnaa");
    } else if(cow>=90 && cow<=99) {
      message +=("3 tabeea'");
    } else if(cow>=100 && cow<=109) {
      message +=("msnaa and 2 tbeea'");
    } else if(cow>=110 && cow<=119) {
      message +=("2 msnaa and 2 tbeea'");
    } else if(cow>=120 && cow<=129) {
      message +=("3 msnaaa or 4 tbeea'");
    }
    message +='\nSheep Zakat: ';
    if(sheep<40) {
      message +=("nothing");
    } else if(sheep>=40 && sheep<=120) {
      message +=("shaah");
    } else if(sheep>=121 && sheep<=200) {
      message +=("2 shaaah");
    } else if(sheep>=201 && sheep<=399) {
      message +=("3 shah");
    } else if(sheep>=400 && sheep<=499) {
      message +=("4 shaah");
    } else if(sheep>=500 && sheep<=599) {
      message +=("5 shhah");
    }
    message +='\nCamel Zakat: ';
    if(camel<4) {
      message +=("nothing");
    } else if(camel>=5 && camel<=9) {
      message +=("shaah");
    } else if(camel>=10 && camel<=14) {
      message +=("2 shaaah");
    } else if(camel>=15 && camel<=19) {
      message +=(" 3 shah");
    } else if(camel>=20 && camel<=24) {
      message +=(" 4 shaah");
    } else if(camel>=25 && camel<=35) {
      message +=("bnt m5a9");
    } else if(camel>=36 && camel<=45) {
      message +=("bnt lboon");
    } else if(camel>=46 && camel<=60) {
      message +=("jaqqa");
    } else if(camel>=61 && camel<=75) {
      message +=("jth3a");
    } else if(camel>=76 && camel<=90) {
      message +=("2 bnt lboon");
    } else if(camel>=91 && camel<=120) {
      message +=("2 7qaa");
    } else if(camel>=121 && camel<=129) {
      message +=("3 bnt lboon");
    } else if(camel>=130 && camel<=139) {
      message +=("7qqa and 2 bnt lboon");
    } else if(camel>=140 && camel<=149) {
      message +=("2 7qqa and 2 bnt lboon");
    } else if(camel>=150 && camel<=159) {
      message +=("3 7aqqas");
    } else if(camel>=160 && camel<=169) {
      message +=("4 bnt lboon");
    } else if(camel>=170 && camel<=179) {
      message +=("3 bnt laboon and haqaa");
    } else if(camel>=180 && camel<=189) {
      message +=("2 bnt laboon and 2 haqaa");
    } else if(camel>=190 && camel<=199) {
      message +=("3 haqqa and 4 bnt laboon");
    } else if(camel>=200 && camel<=209) {
      message +=("4 haqqa and 5 bnt laboon");
    } else {
      int newX = camel - 209;
      int newX4 = newX ~/ 40;
      int newX5 = newX ~/ 50;
      if (newX4 > newX5) {
        print("4 haqqa and ${5 + newX4} bnt laboon");
      } else if (newX5 > newX4) {
        print("${4 + newX5} haqqa and 5 bnt laboon");
      } else {
        print("${4 + newX5} haqqa and 5 bnt laboon");
      }
    }

    showDialog(context: context, builder: (context) => AlertDialog(
        title: const Center(child: Text('Cattle Zakat')),
        content: Text(message),
      actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('ok'))],
    ));
}
  void calculateMoneyZakat() async {
    String message = '';
    double total = await AppManager.calcTotalMoney();
    List<String> goldList = await AppManager.get_GoldPriceDubai();
    double goldPrice = double.parse(goldList[0].substring(0,5));
    print(goldPrice+total);
    
    showDialog(context: context, builder: (context) => AlertDialog(
      title: const Center(child: Text('Money Zakat')),
      content: SizedBox(
        height: 100,
        child: Column(children: [Text('Total: ${total.toStringAsFixed(2)} $preferredCurrency'),
          Text('Nisab: ${goldPrice*85} $preferredCurrency'),
          Text('Zakat: ${total>goldPrice*85 ? (total*0.025).toStringAsFixed(2):'Nothing'}')],),
      ),
      actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('ok'))],
    ));
  }
  @override
  Widget build(BuildContext context) {
    switch (widget.datatype) {
      case 'Money': return MoneyWidget();
      case 'Gold': return GoldWidget();
      case 'Silver': return SilverWidget();
      case 'Cattle': return CattleWidget();
      default: return Container();
    }
  }
}
