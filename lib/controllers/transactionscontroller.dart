import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:epocket/models/transaction.dart';
import 'package:intl/intl.dart';
class TransactionsController{
  Firestore _firestore = Firestore.instance;
  String ref = "transactions";

  ///record new transaction line
  void createTransaction(String category, String user_id, String title, double amount, DateTime date){
    _firestore.collection(ref).add({
      'category': category,
      'user_id': user_id,
      'title': title,
      'amount': amount,
      'date':  DateFormat('dd-MM-yyyy').format(date),
      'created' :date,
      'deleted': "non",
    });
  }

  ///fetch currentuser transaction

  Future<List<ETransaction>>  getETransactionByUser(String id) =>
      _firestore.collection(ref).where('user_id', isEqualTo:id).where('deleted', isEqualTo: "non").getDocuments().then((snap){
        List<ETransaction> etrans = [];
        print("==etrans by user lenght is  ${snap.documents.length}");
        for(DocumentSnapshot item in snap.documents){
          etrans.add(ETransaction.fromSnapshot(item));
          print("====etrans by uuid  ${etrans.length}");
        }
        return etrans;
      });

  ///fetch currentuser transaction for category

  Future<List<ETransaction>>  getCategoryETransactionByUser(String id, String category) =>
      _firestore.collection(ref).where('user_id', isEqualTo:id).where('deleted', isEqualTo: "non").where("category", isEqualTo:  category).getDocuments().then((snap){
        List<ETransaction> etrans = [];
        print("==etrans by user lenght is  ${snap.documents.length}");
        for(DocumentSnapshot item in snap.documents){
          etrans.add(ETransaction.fromSnapshot(item));
          print("====etrans by uuid  ${etrans.length}");
        }
        return etrans;
      });


  ///fetch currentuser periodic transaction

  Future<List<ETransaction>>  getETransactionByUserPeriod(String id, DateTime start, DateTime end) =>
      _firestore.collection(ref).where("created", isGreaterThanOrEqualTo: start).getDocuments().then((snap){
        List<ETransaction> etrans = [];
        print("==etrans by user lenght is  ${snap.documents.length}");
        for(DocumentSnapshot item in snap.documents){
          etrans.add(ETransaction.fromSnapshot(item));
          print("====etrans by uuid  ${etrans.length}");
        }
        return etrans;
      });

  ///archive selected transaction
  deleteById(String uid)async{
    _firestore.collection(ref).document(uid).updateData({'deleted' : 'oui'});
  }


}