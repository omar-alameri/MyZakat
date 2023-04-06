import 'package:cloud_firestore/cloud_firestore.dart';



late Future<QuerySnapshot> _futureData;
List<Map> _UserInfoMap = [];
List<Map> User_Id = [];
List<Map> Zakat_Dates=[];
List<Map> Zakat_Data=[];
late String User_Document_Id;
late String User_Email;


bool email_Used(String Email){

  for (int i = 0; i < User_Id.length; i++) {
    if (Email.toLowerCase() == _UserInfoMap.elementAt(i)['Email'].toString().toLowerCase()) {
      return true;
    }
  }

  return false;
}


Future get_User_Document_Id(String Email) async {
  await get_UserInfo();
  bool Notfound = false;
  String FoundId = "";

  for (int i = 0; i < User_Id.length; i++) {
    if (Email.toLowerCase() == _UserInfoMap.elementAt(i)['Email'].toString().toLowerCase()) {
      Notfound = true;
      FoundId = User_Id.elementAt(i)["Id"];
      break;
    }
  }

  if (!Notfound) {
    User_Document_Id =  "User Not found";
  } else {
    User_Document_Id = FoundId;
  }
}


Future get_UserInfo() async {
  final CollectionReference _referenceUserInfo = await FirebaseFirestore.instance
      .collection("Users");
  _futureData = _referenceUserInfo.get();
  _futureData.then((value) {
    _UserInfoMap = parseData(value);
    User_Id = User_Id_List(value);
  });
  // return _UserInfoMap.toList();
}

List<Map> User_Id_List(QuerySnapshot querySnapshot) {
  List<QueryDocumentSnapshot> listDocs = querySnapshot.docs;
  List<Map> listItems = [];
  for (int i = 0; i < listDocs.length; i++) {
    listItems.add({"Id": listDocs
        .elementAt(i)
        .id});
  }

  return listItems;
}


List<Map> parseData(QuerySnapshot querySnapshot) {
  List<QueryDocumentSnapshot> listDocs = querySnapshot.docs;
  List<Map> listItems = listDocs.map((e) =>
  {
    'Email': e['Email']

  }).toList();
  return listItems;
}


Future Add_Email_To_Database(String Email) async {
  final CollectionReference Users = await FirebaseFirestore.instance.collection(
      "Users");
  print(Users.add({"Email": Email}).then((
      value) => ('user Added')).catchError((onError) =>
      print('Failed to add user: $onError')));
}


Future Delete_User_Info(String Email) async {
  await get_UserInfo();
  CollectionReference Users = await FirebaseFirestore.instance.collection("Users");
  if (User_Document_Id == "User Not found") {
    print(User_Document_Id);
  } else {
    Users.doc(User_Document_Id).delete();
    await get_UserInfo();
    print("User Deleted");
  }
}


Future Update_User(List<String> Data, String category) async {
  CollectionReference Users = await FirebaseFirestore.instance.collection("Users");
  if (User_Document_Id == "User Not found") {
    print(User_Document_Id);
  } else {
    Users.doc(User_Document_Id).update({category: Data});
    print("User Updated");
  }
}


Future Write_User_ZakatData(Map<String,String> Data, String category, String WantedZakatDate) async {
  String ZakatCollection = "Users/$User_Document_Id/Zakat Data";
  CollectionReference Users = await FirebaseFirestore.instance.collection(ZakatCollection);
  if (User_Document_Id == "User Not found")
    print(User_Document_Id);
  else {
    Users.doc(WantedZakatDate).update({category: Data});
    Read_User_Zakat_Data(WantedZakatDate);
    print("User Updated");
  }
}




Future Append_User_ZakatData(Map<String,String> Data, String category, String WantedZakatDate) async {
  String ZakatCollection = "Users/$User_Document_Id/Zakat Data";
  List temp = [];
  Map<String,String> InfoToSet;
  await Read_User_Zakat_Data(WantedZakatDate);

  // print("Pre Add Data: $Data");
  // print("==================================================");
  for(int i=0;i<Zakat_Data.length;i++) {
    if(Zakat_Data.elementAt(i).keys.elementAt(0)==category)
    {
      temp =Zakat_Data.elementAt(i).values.toList();
      for(int j=0;j<temp.elementAt(0).keys.length;j++)
      {
        InfoToSet = <String, String>{
          temp.elementAt(0).keys.elementAt(j): temp.elementAt(0).values.elementAt(j),

        };
        Data.addAll(InfoToSet);
        // print("InfoToSet: $InfoToSet");
        // print("Post Add Data: $Data");
        // print("==================================================");
      }
      break;
    }
  }
  CollectionReference Users = await FirebaseFirestore.instance.collection(ZakatCollection);
  if (User_Document_Id == "User Not found") {
    print(User_Document_Id);
  } else {
    Users.doc(WantedZakatDate).update({category: Data});
    Read_User_Zakat_Data(WantedZakatDate);
    print("Appended User Data");
  }
}

Future create_NewEntry_ZakatData(String DateToCreate) async{
  bool dateExists=false;
  await Read_User_Zakat_Dates();
  for(int i=0;i<Zakat_Dates.length;i++) {
    if(DateToCreate.toLowerCase() == Zakat_Dates.elementAt(i)["Id"].toString().toLowerCase()){
      dateExists = true;
      print("Date already exists");
      break;
    }
  }
  if(!dateExists){
    String zakatCollection = "Users/$User_Document_Id/Zakat Data";
    CollectionReference Users = await FirebaseFirestore.instance.collection(zakatCollection);
    await Users.doc(DateToCreate).set({'ZMoney': "20"});
    print("Created new Date");
  }
}


Future Read_User_Zakat_Dates() async {
  String zakatCollection = "Users/$User_Document_Id/Zakat Data";
  final docRef = FirebaseFirestore.instance.collection(zakatCollection);
  docRef.get().then(
        (doc) { Zakat_Dates =  User_Id_List(doc);},
    onError: (e) => print("Error getting document: $e"),
  );
}

Future Read_User_Zakat_Data(String WantedZakatDate) async {
  await Read_User_Zakat_Dates();
  String zakatCollection = "Users/$User_Document_Id/Zakat Data";
  List<Map> Value = [];
  for (int i = 0; i < Zakat_Dates.length; i++) {
    if (WantedZakatDate.toLowerCase() ==
        Zakat_Dates.elementAt(i)["Id"].toString().toLowerCase()) {
      final docRef = FirebaseFirestore.instance.collection(zakatCollection).doc(
          Zakat_Dates.elementAt(i)["Id"]);
      docRef.get().then(
            (doc) {
          final TempData = doc.data();
          // print("TempData: $TempData");
          TempData?.forEach((k, v) => Value.add({k: v})
          );
          Zakat_Data = Value;
        },
        onError: (e) => print("Error getting document: $e"),
      );
      break;
    }
  }
}

Future print_ZakatData() async{
  List F=[];
  for(int IndexOfZakatData=0;IndexOfZakatData<Zakat_Data.length;IndexOfZakatData++){
    print("=====================================");
    print("Info of ${Zakat_Data.elementAt(IndexOfZakatData).keys.elementAt(0)}");

    if (Zakat_Data.elementAt(IndexOfZakatData).keys.toList().elementAt(0) == "ZMoney") {
      print("${Zakat_Data.elementAt(IndexOfZakatData).keys.toList().elementAt(0)}: ${Zakat_Data.elementAt(IndexOfZakatData).values.toList().elementAt(0)}");
      // Print_KeysandValues(F);
    }
    else if (Zakat_Data.elementAt(IndexOfZakatData).keys.toList().elementAt(0) == "ZFarmproduce") {
      print("${Zakat_Data.elementAt(IndexOfZakatData).keys.toList().elementAt(0)}: ${Zakat_Data.elementAt(IndexOfZakatData).values.toList().elementAt(0)}");
      // Print_KeysandValues(F);
    }
    else if(Zakat_Data.elementAt(IndexOfZakatData).keys.toList().elementAt(0) == "Stocks" || Zakat_Data.elementAt(IndexOfZakatData).keys.toList().elementAt(0) == "Cryptocurrency"){
      F = Zakat_Data.elementAt(IndexOfZakatData).values.toList();
      Detach_StockandCrypto(F);

    }
    else{
      F = Zakat_Data.elementAt(IndexOfZakatData).values.toList();
      Print_KeysandValues(F);
    }

  }

}

void Print_KeysandValues(List F){
  for(int indexF = 0; indexF<F.elementAt(0).keys.length;indexF++) {
    print('${F.elementAt(0).keys.elementAt(indexF)}: ${F.elementAt(0).values.elementAt(indexF)}');
  }
}

void Detach_StockandCrypto(List F){
  String Temp="";
  List RateandAmount=[];
  for(int indexF = 0; indexF<F.elementAt(0).keys.length;indexF++){
    Temp =  F.elementAt(0).values.elementAt(indexF).toString();
    RateandAmount = Temp.split("-");
    print('${F.elementAt(0).keys.elementAt(indexF)}: ${RateandAmount[0]}  ${RateandAmount[1]}');
  }




}