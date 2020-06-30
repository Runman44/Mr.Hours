import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {

  final String uid;
  DatabaseService({this.uid});

  // collection reference
  final CollectionReference clientCollection = Firestore.instance.collection('clients');
  final CollectionReference userCollection = Firestore.instance.collection('users');
  final CollectionReference companyCollection = Firestore.instance.collection('companies');


  Future updateUserData(String name, String email) async {
    return await userCollection.document(uid).setData({
      "name" : name,
      "email" : email
    });
  }


}