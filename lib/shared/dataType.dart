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
  bool done = false;
  dynamic selected ;
  TextEditingController input1 = TextEditingController();
  TextEditingController input2 = TextEditingController();
  TextEditingController input3 = TextEditingController();
  String preferredCurrency = '';
  String userEmail = '';
  final double sizeRatio = 0.6;
  Map<String,String> languageData = {};
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
  void dispose() {
    input1.dispose();
    input2.dispose();
    input3.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getData.call();
  }
  void getData() async {
    AppManager.readPref('pCurrency').then((value)
    {setState(() {preferredCurrency = value;});});
    AppManager.readPref('userEmail').then((value)
    {setState(() {userEmail = value;});});
    String language = await AppManager.readPref('Language');
    var data = await DatabaseHelper.instance.getLanguageData(language:language, page: widget.datatype);
      for (var e in data) {
          languageData[e.name]=e.data;
      }
    setState(() { done =true;});

  }

  Widget MoneyWidget() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
                flex: 3,
                child: TextField(


                  decoration:  InputDecoration(
                    labelText: languageData['Amount']??'Amount',
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
                child: DropdownSearch<String>(


                  onBeforePopupOpening: (x) async{
                    if(selected == null && input2.text=='') {
                      return false;
                    } else {
                      return true;
                    }
                  },
                  asyncItems: (x) async{
                    var s = await AppManager.search_Currency(selected??input2.text);
                    return s;
                  },
                  onChanged: (s){
                    setState(() {
                      input2.text = s??'';
                      selected = s??'';
                    });
                  },
                  dropdownBuilder: (context,s){
                    return TextField(
                      onSubmitted: (s) async{
                        print('submit');

                        List<String> list= await AppManager.search_Currency(s);
                        if(!list.contains(s)) {
                          var snackBar = const SnackBar(
                            content: Center(child: Text('Invalid Currency')),
                            behavior: SnackBarBehavior.floating,
                          );
                          if(context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          }
                        } else{
                          selected = s;
                        }
                      },
                      textInputAction: TextInputAction.search,
                      style: const TextStyle(
                        fontSize:20,
                      ),
                      decoration: const InputDecoration(
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                        isCollapsed: true,
                      ),
                      controller: input2,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z]')),
                        TextInputFormatter.withFunction((oldValue, newValue)
                        {
                          if(newValue.text.length <4) {
                            return TextEditingValue(text:newValue.text.toUpperCase(),selection: newValue.selection);
                          }
                          return oldValue;
                        })
                      ],
                    );
                  },
                  selectedItem: selected,
                  dropdownButtonProps:  const DropdownButtonProps(
                      icon: Icon(Icons.search),
                      padding: EdgeInsets.symmetric(vertical: 4)
                  ),

                  dropdownDecoratorProps:  DropDownDecoratorProps(
                    baseStyle: const TextStyle(fontSize:20),
                    dropdownSearchDecoration: InputDecoration(
                      labelText: languageData['Currency']??'Currency',
                    ),
                  ),


                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: IconButton(
                icon: const Icon(Icons.add),
                onPressed: () async {
                  List<String> list= await AppManager.search_Currency(input2.text);
                  if(!list.contains(input2.text)) {
                    var snackBar = const SnackBar(
                      content: Center(child: Text('Invalid Currency')),
                      behavior: SnackBarBehavior.floating,
                    );
                    if(context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  } else{
                    selected = input2.text;
                  }
                  if(input1.text != ''&& input1.text != '.'&& double.parse(input1.text)!=0&&selected!=null) {
                    DatabaseHelper.instance.addData(
                    Money(amount: double.parse(input1.text),currency: selected,userEmail: userEmail,date: DateTime.now()),
                    );
                    DatabaseHelper.instance.convertRate(selected, preferredCurrency);
                  }
                  if(input1.text!=''&&selected!=null) {
                    setState(() {
                      input1.text = '';
                      input2.text = '';
                      selected = null;
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
          child:  DataTable(dataType: 'Money',userEmail: userEmail,)
        ),
      ],
    );
  }
  Widget GoldWidget() {
    List<String> units = ['Gram K24','Gram K22','Gram K21','Gram K18'];
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 3,
                child: TextField(
                  decoration: InputDecoration(
                    floatingLabelStyle: const TextStyle(color: Colors.green,),
                    labelText: languageData['Weight']??'Weight (Gram)',
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
                      alignment: AlignmentDirectional.center,
                      borderRadius: BorderRadius.circular(5),
                      hint:  Text(languageData['Unit']??'Unit'),
                      value: selected,
                      items: units.map((e) => DropdownMenuItem(value: e,child: Text(languageData[e]??e,textDirection: TextDirection.rtl,),)).toList(),
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
                        Gold(amount: double.parse(input1.text),unit: selected,userEmail: userEmail,date: DateTime.now()),
                      );
                    }
                    if(input1.text!=''&&selected!=null) {
                      setState(() {
                        input1.text = '';
                        selected = null;
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
            child: DataTable(dataType: 'Gold',userEmail: userEmail,)
          ),
        ],
      );
  }
  Widget SilverWidget() {
    List<String> units = ['Gram K99.9','Gram K95.8','Gram K92.5','Gram K90','Gram K80'];

    return Column(

      children: [
        Row(
          children: [
            Expanded(
              flex: 3,
              child: TextField(
                decoration: InputDecoration(
                  labelText: languageData['Weight']??'Weight (Gram)',
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
                    alignment: Alignment.center,
                    underline: const Text(''),
                    isExpanded: true,
                    borderRadius: BorderRadius.circular(5),
                    hint: Text(languageData['Unit']??'Unit'),
                    value: selected,
                    items: units.map((e) => DropdownMenuItem(value: e,child: Text(languageData[e]??e),)).toList(),
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
                      Silver(amount: double.parse(input1.text),unit: selected,userEmail: userEmail,date: DateTime.now()),
                    );
                  }
                  if(input1.text!=''&&selected!=null) {
                    setState(() {
                      input1.text = '';
                      selected = null;
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
          child: DataTable(dataType: 'Silver',userEmail: userEmail,)
        ),

      ],
    );
  }
  Widget LivestockWidget() {
    List<String> animals = ['Cow','Camel','Sheep'];

    return Column(

      children: [
        Row(
          children: [
            Expanded(
              flex: 3,
              child: TextField(
                decoration: InputDecoration(
                  labelText: languageData['Number']??'Number',
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
                    alignment: AlignmentDirectional.center,
                    underline: const Text(''),
                    isExpanded: true,
                    borderRadius: BorderRadius.circular(5),
                    hint:  Text(languageData['Type']??'Type'),
                    value: selected,
                    items: animals.map((e) => DropdownMenuItem(value: e,child: Text(languageData[e]??e),)).toList(),
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
                      Livestock(amount: int.parse(input1.text),type: selected,userEmail: userEmail,date: DateTime.now()),
                    );
                  }
                  if(input1.text!=''&&selected!=null) {
                    setState(() {
                      input1.text = '';
                      selected = null;
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
          child: DataTable(dataType: 'Livestock',userEmail: userEmail,)
        ),
      ],
    );
  }
  Widget CropsWidget() {
    List<String> types = ['Without','With'];
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
                    decoration: InputDecoration(
                      labelText: languageData['Weight']??'Weight (Kg)',
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
                    decoration: InputDecoration(
                      labelText: languageData['Price']??'Price per Kg',
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
                    alignment: AlignmentDirectional.center,
                    underline: const Text(''),
                    isExpanded: true,
                    borderRadius: BorderRadius.circular(10),
                    hint: Text(languageData['Irrigation']??'Irrigation'),
                    value: selected,
                    items: types.map((e) => DropdownMenuItem(value: e,child: Text(languageData[e]??e),)).toList(),
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
                      Crops(amount: double.parse(input1.text),type: selected,price: double.parse(input2.text),userEmail: userEmail,date: DateTime.now()),
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
            child: DataTable(dataType:'Crops',userEmail: userEmail,)
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
                            behavior: SnackBarBehavior.floating,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      });
                    },
                    asyncItems: (x) async{
                      var s = await AppManager.search_StockName(selected);
                      List<String> list =[];
                      if(s.first[0]=='No Internet connection.') {
                        list.add(s.first[0]);
                        return list;
                      }
                      for(int i=0;i<s.first.length;i++){
                        list.add('${s.first[i]} (${s.last[i]})');
                      }
                      return list;
                    },
                    dropdownBuilder: (context,s){
                      return TextField(
                        style: const TextStyle(fontSize:20),
                        decoration:  const InputDecoration(
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                          isCollapsed: true,
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
                    dropdownDecoratorProps:  DropDownDecoratorProps(
                      baseStyle: const TextStyle(fontSize:20),
                      dropdownSearchDecoration: InputDecoration(
                        labelText: languageData['Name']??'Name',
                      ),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  TextField(
                    decoration: InputDecoration(
                      labelText: languageData['Quantity']??'Quantity',
                    ),
                    keyboardType: const TextInputType.numberWithOptions(signed: false, decimal: false),
                    style: const TextStyle(fontSize:20),
                    controller: input2,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly
                    ],
                  ),
                  const SizedBox(height: 10,),
                  TextField(
                    decoration:   InputDecoration(
                      labelText: '${languageData['Price']??'Price'} ($preferredCurrency)',
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
            Expanded(
              flex: 1,
              child: IconButton(
                icon: const Icon(Icons.add),
                onPressed: () async {
                  if(input2.text != ''&& input2.text !='.'&&double.parse(input2.text)!=0) {
                    await DatabaseHelper.instance.addData(
                      Stock(amount: int.parse(input2.text),stock: input1.text,price: double.parse(input3.text),userEmail: userEmail,date: DateTime.now()),
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
            child: DataTable(dataType:'Stock',userEmail: userEmail,)
        ),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    if (done) {
      switch (widget.datatype) {
        case 'Money': return MoneyWidget();
        case 'Gold': return GoldWidget();
        case 'Silver': return SilverWidget();
        case 'Livestock': return LivestockWidget();
        case 'Crops': return CropsWidget();
        case 'Stock': return StockWidget();
        default: return const Text('N/A');
      }
    }
    return const Center(child: CircularProgressIndicator(),);
  }
}

class DataTable extends StatefulWidget {
  final String dataType;
  final String userEmail;
  const DataTable({Key? key,required this.dataType, required this.userEmail}) : super(key: key);

  @override
  State<DataTable> createState() => _DataTableState();
}

class _DataTableState extends State<DataTable> {
  Map<String,String> languageData = {};
  @override
  void initState() {
    super.initState();
    getData.call();
  }
  void getData() async {
    String language = await AppManager.readPref('Language');
    var data = await DatabaseHelper.instance.getLanguageData(language:language, page: widget.dataType);
    for (var e in data) {
      languageData[e.name]=e.data;
    }
    if (mounted) setState(() {});

  }
  @override
  Widget build(BuildContext context) {
    String dataType = widget.dataType;
    return FutureBuilder<List<dynamic>>(
        future: DatabaseHelper.instance.getData(userEmail:widget.userEmail,type:dataType),
        builder: (BuildContext context,
            AsyncSnapshot<List<dynamic>> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: Text('Loading...'));
          }
          return snapshot.data!.isEmpty
              ? Center(child: Text(languageData['No Data']??'No $dataType in List.'))
              : ListView(
            physics: const BouncingScrollPhysics(),
            children: snapshot.data!.map((dataInstance) {
              return Center(
                child: Column(
                  children: [
                    Row(
                      children:[
                        Expanded(flex:3,child: Text((dataType == 'Stock'? dataInstance.stock :dataInstance.amount.toString())+(dataType == 'Crops'?' Kg':''))),
                        Expanded(flex:2,child: Text(dataType == 'Money' ? dataInstance.currency : dataType == 'Livestock' ? languageData[dataInstance.type]?? dataInstance.type :
                        dataType == 'Crops' ? dataInstance.price.toString() : dataType == 'Stock' ? dataInstance.amount.toString() :languageData[dataInstance.unit]??dataInstance.unit)),
                        if (dataType == 'Stock') Expanded(flex: 3,child: Text(dataInstance.price.toString())) else if (dataType == 'Crops') Expanded(flex: 3,child: Text(languageData[dataInstance.type]??dataInstance.type)),
                        Expanded(
                          flex: 1,
                          child: Text(dataInstance.date.toString().substring(0,11),style:const TextStyle(fontSize: 10),),
                        ),
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
