import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:epocket/models/category.dart';
import 'package:epocket/models/transaction.dart';
import 'package:intl/intl.dart';
class CategoriesController{
  Firestore _firestore = Firestore.instance;
  String ref = "categories";

  ///record new category line
  void createCategory(String user_id, String title){
    _firestore.collection(ref).add({
      'user_id': user_id,
      'title': title,
      'deleted': "non",
    });
  }

  ///fetch currentuser categories

  Future<List<Category>>  getCategoriesByUser(String id) =>
      _firestore.collection(ref).where('user_id', isEqualTo:id).where('deleted', isEqualTo: "non").getDocuments().then((snap){
        List<Category> etrans = [];
        print("==Category by user lenght is  ${snap.documents.length}");
        for(DocumentSnapshot item in snap.documents){
          etrans.add(Category.fromSnapshot(item));
          print("====Category by uuid  ${etrans.length}");
        }
        return etrans;
      });

  ///archive selected transaction
  deleteById(String uid)async{
    _firestore.collection(ref).document(uid).updateData({'deleted' : 'oui'});
  }


}