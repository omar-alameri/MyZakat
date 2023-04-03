
import 'package:app2/shared/dataModels.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:app2/shared/tools.dart';
import 'package:app2/shared/DataBase.dart';
import 'package:flutter/services.dart';



class DataType extends StatefulWidget {
  final String datatype;

  const DataType({super.key, required this.datatype});

  @override
  State<DataType> createState() => _DataTypeState();
}

class _DataTypeState extends State<DataType> {
  dynamic selected ;
  TextEditingController input1 = TextEditingController();
  TextEditingController input2 = TextEditingController();
  TextEditingController input3 = TextEditingController();
  String stockPrice='';
  PageController s= PageController() ;
  Widget holder = const CircularProgressIndicator();
  int? selectedId;
  String preferredCurrency = '';
  List<String> goldRate = [];
  final double sizeRatio = 0.6;
  TextInputFormatter doubleFormatter = TextInputFormatter.withFunction((oldValue, newValue)
  {
    if (double.tryParse(newValue.text) != null || newValue.text == '' ||newValue.text == '.') {
      return newValue;
    }
    else {
      return oldValue;
    }
  });

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    AppManager.readPref('pCurrency').then((value)
         {setState(() {preferredCurrency = value;});});
  }

  Widget MoneyWidget() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
                flex: 3,
                child: TextField(


                  decoration:  const InputDecoration(
                    floatingLabelStyle: TextStyle(color: Colors.green,),
                    labelText: 'Amount',
                    constraints: BoxConstraints(maxHeight: 30,minHeight:30 ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(32)),
                        borderSide: BorderSide(color: Colors.green)
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(32)),
                          borderSide: BorderSide(color: Colors.grey)
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                  ),
                  keyboardType: const TextInputType.numberWithOptions(signed: false, decimal: true),
                  style: const TextStyle(fontSize:20),
                  controller: input1,
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(' '),
                    FilteringTextInputFormatter.deny('-'),
                    doubleFormatter
                  ],

                  ),),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(),
                child: DropdownButton(
                    underline: const Text(''),
                    isExpanded: true,
                    borderRadius: BorderRadius.circular(5),
                    hint: const Text('Currency'),
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
                onPressed: ()  {
                  if(input1.text != ''&& input1.text != '.'&& double.parse(input1.text)!=0&&selected!=null) {
                    DatabaseHelper.instance.addData(
                    Money(amount: double.parse(input1.text),currency: selected,userId: 1,date: DateTime.now()),
                    );
                    DatabaseHelper.instance.convertRate(selected, preferredCurrency);
                  }
                  if(input1.text!=''&&selected!=null) {
                    setState(() {
                      input1.text = '';
                    });
                  }
                },
              ),
            ),
          ],
        ),
        const Divider(height: 10),
        SizedBox(
             height: MediaQuery.of(context).size.height*sizeRatio,
          child:  DataTable(dataType: 'Money')
        ),
        const Divider(height: 10, color: Colors.green,),
        ElevatedButton(onPressed: calculateMoneyZakat, child: const Text('Calculate Zakat')),
      ],
    );
  }
  Widget GoldWidget() {

    AppManager.get_GoldPriceDubai().then((value) {
      if (goldRate.toString() != value.toString())
      {goldRate = value;
      holder = Text('1: ${goldRate[0]} 2: ${goldRate[1]} 3: ${goldRate[2]} 4: ${goldRate[3]} ',textDirection: TextDirection.ltr,);
        setState(() {});
      }});
    return Column(

      children: [
        Row(
          children: [
            Expanded(
              flex: 3,
              child: TextField(
                decoration: const InputDecoration(
                  floatingLabelStyle: TextStyle(color: Colors.green,),
                  labelText: 'Weight (Gram)',
                  constraints: BoxConstraints(maxHeight: 30,minHeight:30 ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(32)),
                      borderSide: BorderSide(color: Colors.green)
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(32)),
                      borderSide: BorderSide(color: Colors.grey)
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                ),
                keyboardType: const TextInputType.numberWithOptions(signed: false, decimal: true),
                style: const TextStyle(fontSize:20),
                controller: input1,
                inputFormatters: [
                  FilteringTextInputFormatter.deny(' '),
                  FilteringTextInputFormatter.deny('-'),
                  doubleFormatter
                ],

              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(),
                child: DropdownButton(
                    underline: const Text(''),
                    isExpanded: true,
                    borderRadius: BorderRadius.circular(5),
                    hint: const Text('Unit'),
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
                  if(input1.text != ''&& input1.text !='.'&&double.parse(input1.text)!=0) {
                    await DatabaseHelper.instance.addData(
                      Gold(amount: double.parse(input1.text),unit: selected,userId: 1,date: DateTime.now()),
                    );
                  }
                  if(input1.text!=''&&selected!=null) {
                    setState(() {
                      input1.text = '';
                    });
                  }
                },
              ),
            ),
          ],
        ),
        const Divider(height: 10),

        SizedBox(
          height: MediaQuery.of(context).size.height*sizeRatio,
          child: DataTable(dataType: 'Gold')
        ),
        holder,
      ],
    );
  }
  Widget SilverWidget() {


    return Column(

      children: [
        Row(
          children: [
            Expanded(
              flex: 3,
              child: TextField(
                decoration: const InputDecoration(
                  floatingLabelStyle: TextStyle(color: Colors.green,),
                  labelText: 'Weight (Gram)',
                  constraints: BoxConstraints(maxHeight: 30,minHeight:30 ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(32)),
                      borderSide: BorderSide(color: Colors.green)
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(32)),
                      borderSide: BorderSide(color: Colors.grey)
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                ),
                keyboardType: const TextInputType.numberWithOptions(signed: false, decimal: true),
                style: const TextStyle(fontSize:20),
                controller: input1,
                inputFormatters: [
                  FilteringTextInputFormatter.deny(' '),
                  FilteringTextInputFormatter.deny('-'),
                  doubleFormatter
                ],

              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(),
                child: DropdownButton(
                    underline: const Text(''),
                    isExpanded: true,
                    borderRadius: BorderRadius.circular(5),
                    hint: const Text('Unit'),
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
                  if(input1.text != '' && input1.text !='.'&&double.parse(input1.text)!=0) {
                    await DatabaseHelper.instance.addData(
                      Silver(amount: double.parse(input1.text),unit: selected,userId: 1,date: DateTime.now()),
                    );
                  }
                  if(input1.text!=''&&selected!=null) {
                    setState(() {
                      input1.text = '';
                    });
                  }
                },
              ),
            ),
          ],
        ),
        const Divider(height: 10),

        SizedBox(
          height: MediaQuery.of(context).size.height*sizeRatio,
          child: DataTable(dataType: 'Silver')
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
                decoration: const InputDecoration(
                  floatingLabelStyle: TextStyle(color: Colors.green,),
                  labelText: 'Number',
                  constraints: BoxConstraints(maxHeight: 30,minHeight:30 ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(32)),
                      borderSide: BorderSide(color: Colors.green)
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(32)),
                      borderSide: BorderSide(color: Colors.grey)
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                ),
                keyboardType: const TextInputType.numberWithOptions(signed: false),
                style: const TextStyle(fontSize:20),
                controller: input1,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(),
                child: DropdownButton(
                    underline: const Text(''),
                    isExpanded: true,
                    borderRadius: BorderRadius.circular(5),
                    hint: const Text('Type'),
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
                  if(input1.text != ''&&int.parse(input1.text) !=0) {
                    await DatabaseHelper.instance.addData(
                      Cattle(amount: int.parse(input1.text),type: selected,userId: 1,date: DateTime.now()),
                    );
                  }
                  if(input1.text!=''&&selected!=null) {
                    setState(() {
                      input1.text = '';
                    });
                  }
                },
              ),
            ),
          ],
        ),
        const Divider(height: 10),

        SizedBox(
          height: MediaQuery.of(context).size.height*sizeRatio,
          child: DataTable(dataType: 'Cattle')
        ),
        ElevatedButton(onPressed: calculateCattleZakat, child: const Text('Calculate Zakat'))
      ],
    );
  }
  Widget CropsWidget() {

    return Column(

      children: [
        Row(
          children: [
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  const SizedBox(height: 10,),
                  TextField(
                    decoration: const InputDecoration(
                      floatingLabelStyle: TextStyle(color: Colors.green,),
                      labelText: 'Weight (Kg)',
                      constraints: BoxConstraints(maxHeight: 30,minHeight:30 ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(32)),
                          borderSide: BorderSide(color: Colors.green)
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(32)),
                          borderSide: BorderSide(color: Colors.grey)
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(signed: false, decimal: true),
                    style: const TextStyle(fontSize:20),
                    controller: input1,
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(' '),
                      FilteringTextInputFormatter.deny('-'),
                      doubleFormatter
                    ],

                  ),
                  const SizedBox(height: 10,),
                  TextField(
                    decoration: const InputDecoration(
                      floatingLabelStyle: TextStyle(color: Colors.green,),
                      labelText: 'Price per Kg',
                      constraints: BoxConstraints(maxHeight: 30,minHeight:30 ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(32)),
                          borderSide: BorderSide(color: Colors.green)
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(32)),
                          borderSide: BorderSide(color: Colors.grey)
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(signed: false, decimal: true),
                    style: const TextStyle(fontSize:20),
                    controller: input2,
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(' '),
                      FilteringTextInputFormatter.deny('-'),
                      doubleFormatter
                    ],

                  ),

                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: DropdownButton(
                    underline: const Text(''),
                    isExpanded: true,
                    borderRadius: BorderRadius.circular(10),
                    hint: const Text('Irrigation'),
                    value: selected,
                    items: const [
                      DropdownMenuItem(
                        value: 'Without cost',
                        child: Text('Without cost'),
                      ),
                      DropdownMenuItem(
                        value: 'With cost',
                        child: Text('With cost'),
                      ),
                      DropdownMenuItem(
                        value: 'Both methods alike',
                        child: Text('Both methods alike'),
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
                  if(input1.text != ''&& input1.text !='.'&&double.parse(input1.text)!=0) {
                    await DatabaseHelper.instance.addData(
                      Crops(amount: double.parse(input1.text),type: selected,price: double.parse(input2.text),userId: 1,date: DateTime.now()),
                    );
                  }
                  if(input1.text!=''&&input2.text!=''&&selected!=null) {
                    setState(() {
                      input1.text = '';
                      input2.text = '';
                      selected=null;
                    });
                  }
                },
              ),
            ),
          ],
        ),
        const Divider(height: 10),
        SizedBox(
            height: MediaQuery.of(context).size.height*sizeRatio,
            child: DataTable(dataType:'Crops')
        ),
      ],
    );
  }
  Widget StockWidget() {

    return Column(

      children: [
        Row(
          children: [
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  const SizedBox(height: 5,),
                  DropdownSearch<String>(
                    onBeforePopupOpening: (x) async{
                      if(selected == null || selected == '') {
                        return false;
                      } else {
                        return true;
                      }
                    },
                    onChanged: (s){
                      input1.text = s?.substring(0,s.indexOf(' '))??'';
                      AppManager.get_StockPrice(input1.text).then((value) {
                        if(double.tryParse(value[0]) != null) {
                          DatabaseHelper.instance.convertRate(value[1], preferredCurrency).then((rate) {
                            setState(() {
                              input3.text = (double.parse(value[0])*rate).toStringAsFixed(2);
                            });
                          });

                        }else {
                           var snackBar = SnackBar(
                            content: Text('Price not founded. Please enter it in $preferredCurrency'),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      });
                    },
                    asyncItems: (x) async{
                      var s = await AppManager.search_StockName(selected);
                      List<String> list =[];
                      for(int i=0;i<s.first.length;i++){
                        list.add('${s.first[i]} (${s.last[i]})');
                      }
                      return list;
                    },
                    dropdownBuilder: (context,s){
                      return TextField(
                        smartDashesType: SmartDashesType.disabled,
                        style: const TextStyle(fontSize:20),

                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          isCollapsed: true,
                          hintText: 'Search',
                        ),
                        controller: input1,
                        onChanged: (s){
                          selected = input1.text;
                        },
                      );
                    },
                    selectedItem: selected,
                    dropdownButtonProps: const DropdownButtonProps(
                      icon: Icon(Icons.search),
                      padding: EdgeInsets.symmetric(vertical: 4)
                    ),

                    dropdownDecoratorProps: const DropDownDecoratorProps(
                      baseStyle: TextStyle(fontSize:20),
                      dropdownSearchDecoration: InputDecoration(
                        floatingLabelStyle: TextStyle(color: Colors.green,),
                        labelText: 'Name',
                        constraints: BoxConstraints(maxHeight: 30,minHeight:30 ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(32)),
                            borderSide: BorderSide(color: Colors.green)
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(32)),
                            borderSide: BorderSide(color: Colors.grey)
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 20),
                      ),
                    ),


                  ),
                  const SizedBox(height: 10,),
                  TextField(
                    decoration: const InputDecoration(
                      floatingLabelStyle: TextStyle(color: Colors.green,),
                      labelText: 'Quantity',
                      constraints: BoxConstraints(maxHeight: 30,minHeight:30 ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(32)),
                          borderSide: BorderSide(color: Colors.green)
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(32)),
                          borderSide: BorderSide(color: Colors.grey)
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(signed: false, decimal: true),
                    style: const TextStyle(fontSize:20),
                    controller: input2,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly
                    ],

                  ),
                  const SizedBox(height: 10,),
                  TextField(

                    decoration:  const InputDecoration(
                      floatingLabelStyle: TextStyle(color: Colors.green,),
                      labelText: 'Price',
                      constraints: BoxConstraints(maxHeight: 30,minHeight:30 ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(32)),
                          borderSide: BorderSide(color: Colors.green)
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(32)),
                          borderSide: BorderSide(color: Colors.grey)
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(signed: false, decimal: true),
                    style: const TextStyle(fontSize:20),
                    controller: input3,
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(' '),
                      FilteringTextInputFormatter.deny('-'),
                      doubleFormatter
                    ],

                  ),

                ],
              ),
            ),
            // Expanded(
            //   flex: 2,
            //   child: Padding(
            //     padding: const EdgeInsets.symmetric(),
            //     child: DropdownButton(
            //         underline: const Text(''),
            //         isExpanded: true,
            //         borderRadius: BorderRadius.circular(10),
            //         hint: const Text('Irrigation'),
            //         value: selected,
            //         items: const [
            //           DropdownMenuItem(
            //             value: 'Without cost',
            //             child: Text('Without cost'),
            //           ),
            //           DropdownMenuItem(
            //             value: 'With cost',
            //             child: Text('With cost'),
            //           ),
            //           DropdownMenuItem(
            //             value: 'Both methods alike',
            //             child: Text('Both methods alike'),
            //           ),
            //
            //         ],
            //         onChanged: (var newValue) {
            //           setState(() {
            //             selected = newValue;
            //           });
            //         }),
            //   ),
            // ),
            Expanded(
              flex: 1,
              child: IconButton(
                icon: const Icon(Icons.add),
                onPressed: () async {
                  if(input2.text != ''&& input2.text !='.'&&double.parse(input2.text)!=0) {
                    await DatabaseHelper.instance.addData(
                      Stock(amount: int.parse(input2.text),stock: input1.text,price: double.parse(input3.text),userId: 1,date: DateTime.now()),
                    );
                  }
                  if(input1.text!=''&&input2.text!=''&&input3.text!='') {
                    setState(() {
                      input1.text = '';
                      input2.text = '';
                      input3.text = '';
                      selected=null;
                    });
                  }
                },
              ),
            ),
          ],
        ),
        const Divider(height: 10),
        SizedBox(
            height: MediaQuery.of(context).size.height*sizeRatio,
            child: DataTable(dataType:'Stock')
        ),
      ],
    );
  }


  void calculateCattleZakat() async {
    List<dynamic> list = await DatabaseHelper.instance.getData(1,'Cattle');
    int cow= 0;
    int camel= 0;
    int sheep= 0;
    String CowMessage1 = '';
    String CowMessage2 = '';
    String SheepMessage = '';
    String CamelMessage1 = '';
    String CamelMessage2 = '';
    const String CowHint1 = 'Calf that is one year old.';
    const String CowHint2 = 'Calf that is already two years old.';
    const String sheepHint = 'Female sheep that are one year old at least.';
    const String camelHint1 = 'Female camel that is already one year old.';
    const String camelHint2 = 'Female camel that is already two years old';
    const String camelHint3 = 'Female camel that is already three years old.';
    const String camelHint4 = 'Female camel that is already four years old.';
    const String nothing = 'Nothing.';
    List<String> Hints = [];




    for (var e in list){
      if(e.type == 'Cow') {cow+= e.amount as int;
      } else if(e.type == 'Sheep') {sheep+= e.amount as int;
      } else if(e.type == 'Camel') {camel+= e.amount as int;
      }
    }

    if(cow<30) {
      CowMessage1 = nothing;
    } else if(cow>=30 && cow<=39) {
      CowMessage1 =("1 tabea'.");
      Hints.add(CowHint1);
    } else if(cow>=40 && cow<=59) {
      CowMessage1 =("1 msna.");
      Hints.add(CowHint2);
    } else if(cow>=60 && cow<=69) {
      CowMessage1 =("2 tabea'.");
      Hints.add(CowHint1);
    } else if(cow>=70 && cow<=79) {
      CowMessage1 =("1 msna");
      Hints.add(CowHint2);
      CowMessage2 =(" and 1 tbea'.");
      Hints.add(CowHint1);

    } else if(cow>=80 && cow<=89) {
      CowMessage1 =("2 msna.");
      Hints.add(CowHint2);
    } else if(cow>=90 && cow<=99) {
      CowMessage1 =("3 tbea'.");
      Hints.add(CowHint1);
    } else if(cow>=100 && cow<=109) {
      CowMessage1 =("1 msna");
      Hints.add(CowHint2);
      CowMessage2 =(" and 2 tbea'.");
      Hints.add(CowHint1);
    } else if(cow>=110 && cow<=119) {
      CowMessage1 =("2 msna");
      Hints.add(CowHint2);
      CowMessage2 =(" and 2 tbea'.");
      Hints.add(CowHint1);
    } else if(cow>=120 && cow<=129) {
      CowMessage1 =("3 msna");
      CowMessage2 =(" or 4 tbea'.");
      Hints.add(CowHint2);
      Hints.add(CowHint1);
    } else {
      int temp = cow - 120;
      int tbea = temp ~/ 30;
      int msna = temp ~/ 40;
      CowMessage1 ="${3+msna} msna";
      CowMessage2 = " or ${4+tbea} tbea'.";
      Hints.add(CowHint2);
      Hints.add(CowHint1);
    }
    Hints.add(sheepHint);
    if(sheep<40) {
      SheepMessage =nothing;
      Hints.remove(sheepHint);
    } else if(sheep>=40 && sheep<=120) {
      SheepMessage =("shah.");
    } else if(sheep>=121 && sheep<=200) {
      SheepMessage =("2 shah.");
    } else if(sheep>=201 && sheep<=399) {
      SheepMessage =("3 shah.");
    } else if(sheep>=400 && sheep<=499) {
      SheepMessage =("4 shah.");
    } else if(sheep>=500 && sheep<=599) {
      SheepMessage =("5 shah.");
    } else {
      int temp = sheep - 500;
      int shah = temp ~/ 100;
      SheepMessage =("${5+shah} shah.");
    }
    if(camel<4) {
      CamelMessage1 =nothing;
    } else if(camel>=5 && camel<=9) {
      CamelMessage1 =("1 shah.");
    } else if(camel>=10 && camel<=14) {
      CamelMessage1 =("2 shah.");
    } else if(camel>=15 && camel<=19) {
      CamelMessage1 =(" 3 shah.");
    } else if(camel>=20 && camel<=24) {
      CamelMessage1 =(" 4 shah.");
    } else if(camel>=25 && camel<=35) {
      CamelMessage1 =("1 bnt mkhad.");
      Hints.add(camelHint1);
    } else if(camel>=36 && camel<=45) {
      CamelMessage1 =("1 bnt lboon.");
      Hints.add(camelHint2);
    } else if(camel>=46 && camel<=60) {
      CamelMessage1 =("1 haqqa.");
      Hints.add(camelHint3);
    } else if(camel>=61 && camel<=75) {
      CamelMessage1 =("1 jtha'a.");
      Hints.add(camelHint4);
    } else if(camel>=76 && camel<=90) {
      CamelMessage1 =("2 bnt lboon.");
      Hints.add(camelHint2);
    } else if(camel>=91 && camel<=120) {
      CamelMessage1 =("2 haqqa.");
      Hints.add(camelHint3);
    } else if(camel>=121 && camel<=129) {
      CamelMessage1 =("3 bnt lboon.");
      Hints.add(camelHint2);
    } else if(camel>=130 && camel<=139) {
      CamelMessage1 =("2 bnt lboon");
      CamelMessage2 =(" and 1 haqqa.");
      Hints.add(camelHint2);
      Hints.add(camelHint3);
    } else if(camel>=140 && camel<=149) {
      CamelMessage1 =("1 bnt lboon");
      CamelMessage2 =(" and 2 haqqa.");
      Hints.add(camelHint2);
      Hints.add(camelHint3);
    } else if(camel>=150 && camel<=159) {
      CamelMessage1 =("3 haqqa.");
      Hints.add(camelHint3);
    } else if(camel>=160 && camel<=169) {
      CamelMessage1 =("4 bnt lboon.");
      Hints.add(camelHint2);
    } else if(camel>=170 && camel<=179) {
      CamelMessage1 =("3 bnt lboon");
      CamelMessage2 =(" and 1 haqqa.");
      Hints.add(camelHint2);
      Hints.add(camelHint3);
    } else if(camel>=180 && camel<=189) {
      CamelMessage1 =("2 bnt lboon");
      CamelMessage2 =(" and 2 haqqa.");
      Hints.add(camelHint2);
      Hints.add(camelHint3);
    } else if(camel>=190 && camel<=199) {
      CamelMessage1 =("1 bnt lboon");
      CamelMessage2 =(" and 3 haqqa.");
      Hints.add(camelHint2);
      Hints.add(camelHint3);
    } else if(camel>=200 && camel<=209) {
      CamelMessage1 =("5 bnt lboon");
      CamelMessage2 =(" or 4 haqqa.");
      Hints.add(camelHint2);
      Hints.add(camelHint3);
    } else {
      int temp = camel - 200;
      int bntlaboon = temp ~/ 40;
      int haqqa = temp ~/ 50;
      CamelMessage1 =("${5+bntlaboon} bnt lboon");
      CamelMessage2 =(" or ${4+haqqa} haqqa.");
      Hints.add(camelHint2);
      Hints.add(camelHint3);
    }

    showDialog(context: context, builder: (context) => AlertDialog(
        title: const Center(child: Text('Cattle Zakat')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(children: [const Text('Cow : '),CowMessage1 != nothing?Info(message: Hints.removeAt(0), child: Text(CowMessage1)):Text(CowMessage1) , CowMessage2 != '' ? Info(message: Hints.removeAt(0), child: Text(CowMessage2)):Text(CowMessage2)]),
            Row(children: [const Text('Sheep : '),SheepMessage != nothing ?Info(message: Hints.removeAt(0), child: Text(SheepMessage)):Text(SheepMessage)]),
            Row(children: [const Text('Camel : '),CamelMessage1 != nothing ?Info(message: Hints.removeAt(0), child: Text(CamelMessage1)):Text(CamelMessage1),CamelMessage2 != '' ? Info(message: Hints.removeAt(0), child: Text(CamelMessage2)):Text(CamelMessage2)]),

        ],),
      actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('ok'))],
    ));
}
  void calculateMoneyZakat() async {
    String message = '';
    showDialog(context: context, builder: (context)=>Center(child: holder));
    double total = await AppManager.calcTotalMoney();
    List<String> goldList = await AppManager.get_GoldPriceDubai();
    if(double.tryParse(goldList[0].substring(0,5)) != null) {
      double goldPrice = double.parse(goldList[0].substring(0,5));
      goldPrice = await DatabaseHelper.instance.convertRate('AED', preferredCurrency)*goldPrice;
      //print(goldPrice+total);
      Navigator.pop(context);
      showDialog(context: context, builder: (context) => AlertDialog(
        title: const Center(child: Text('Money Zakat')),
        content: SizedBox(
          height: 60,
          child: Column(children: [Text('Total: ${total.toStringAsFixed(2)} $preferredCurrency'),
            Text('Nisab: ${(goldPrice*85).toStringAsFixed(2)} $preferredCurrency'),
            Text('Zakat: ${total>goldPrice*85 ? (total*0.025).toStringAsFixed(2):'Nothing'}')],),
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('ok'))],
      ));
    }
    else {
      Navigator.pop(context);
      showDialog(context: context, builder: (context) => AlertDialog(content: Text(goldList[0]),));
    }

  }
  @override
  Widget build(BuildContext context) {
    switch (widget.datatype) {
      case 'Money': return MoneyWidget();
      case 'Gold': return GoldWidget();
      case 'Silver': return SilverWidget();
      case 'Cattle': return CattleWidget();
      case 'Crops': return CropsWidget();
      case 'Stock': return StockWidget();
      default: return const Text('N/A');
    }
  }
}

class DataTable extends StatefulWidget {
  final String dataType;
  const DataTable({Key? key,required this.dataType}) : super(key: key);

  @override
  State<DataTable> createState() => _DataTableState();
}

class _DataTableState extends State<DataTable> {
  @override
  Widget build(BuildContext context) {
    String dataType = widget.dataType;
    return FutureBuilder<List<dynamic>>(
        future: DatabaseHelper.instance.getData(1,dataType),
        builder: (BuildContext context,
            AsyncSnapshot<List<dynamic>> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: Text('Loading...'));
          }
          return snapshot.data!.isEmpty
              ? Center(child: Text('No $dataType in List.'))
              : ListView(
            physics: const BouncingScrollPhysics(),
            children: snapshot.data!.map((dataInstance) {
              return Center(
                heightFactor: 1,
                child: Column(
                  children: [
                    Row(
                      children:[
                        // dataInstance.toMap().forEach((String s,dynamic data) =>Text(data.toString())).toList()
                        Expanded(flex:3,child: Text(dataType == 'Stock'? dataInstance.stock :dataInstance.amount.toString())),
                        Expanded(flex:2,child: Text(dataType == 'Money' ? dataInstance.currency : dataType == 'Cattle' ? dataInstance.type :
                        dataType == 'Crops' ? dataInstance.type : dataType == 'Stock' ? dataInstance.amount.toString() :dataInstance.unit)),
                        dataType == 'Stock' ? Expanded(child: Text(dataInstance.price.toString())): const Text(''),
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
                  ],
                ),
              );
            }).toList(),
          );
        });
  }
}
