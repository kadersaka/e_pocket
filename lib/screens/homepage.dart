import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:epocket/controllers/categores_controller.dart';
import 'package:epocket/controllers/transactionscontroller.dart';
import 'package:epocket/models/transaction.dart';
import 'package:epocket/providers/transactions_provider.dart';
import 'package:epocket/providers/user_provider.dart';
import 'package:epocket/screens/dashboard.dart';
import 'package:epocket/widgets/add_transaction.dart';
import 'package:epocket/widgets/customflatButton.dart';
import 'package:epocket/widgets/mychart.dart';
import 'package:epocket/widgets/transaction_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  bool _showChart = false;
  String user_uid;
  DateTime _selectedDate;
  String _currentCategory ;


  TextEditingController  categoryController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController date = TextEditingController();

  GlobalKey<FormState> _categoryFormKey = GlobalKey();
  GlobalKey<FormState> _transactionFormKey = GlobalKey();
  TransactionsController _transactionsController = TransactionsController();
  CategoriesController _categoriesController = CategoriesController();
  final List<ETransaction> _userTransactions = [ ];


  @override
  Widget build(BuildContext context) {

    final user = Provider.of<UserProvider>(context);
//    final transactions = Provider.of<TransactionsProvider>(context);



return Scaffold(
  appBar: new AppBar(
    iconTheme: IconThemeData(
        color: Colors.white
    ),
    title: InkWell(onTap:(){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Dashboard()));
      },
        child: Text('Nouvelle transaction', style: TextStyle(color: Colors.white),)),
   // backgroundColor: Colors.orange,

    actions: <Widget>[

      IconButton(icon: Icon(Icons.format_list_bulleted, color: Colors.white,), onPressed: (){
         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Dashboard()));
      }
      ),
    ],
  ),
  body: Center(
    child:    Form(
      key: _transactionFormKey,
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child:Column(
            children: <Widget>[
              StreamBuilder<QuerySnapshot>(
                  stream: Firestore.instance.collection('categories').where('user_id', isEqualTo:user.user.uid).where('deleted', isEqualTo: "non").snapshots(), builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Center(
                    child: CircularProgressIndicator(),
                  );

                return Container(
                  padding: EdgeInsets.only(bottom: 16.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          flex: 2,
                          child: Container(
                            padding: EdgeInsets.fromLTRB(0.0, 10.0, 10.0, 10.0),
                            child: Text(
                              "Catégorie",
                            ),
                          )),
                       Expanded(
                        flex: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DropdownButton(
                            value: _currentCategory,
                            isDense: true,
                            onChanged: (valueSelectedByUser) async{
                              await  _onShopDropItemSelected(valueSelectedByUser);
                            },
                            hint: Text('Choisissez la catégorie'),
                            items: snapshot.data.documents.map((DocumentSnapshot document) {
                              return DropdownMenuItem<String>(
                                value: document.data['title'],
                                child: Text(document.data['title']
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),

              TextFormField(
                controller: titleController,
                validator: (value){
                  if(value.isEmpty){
                    return 'title cannot be empty';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    hintText: "add title"
                ),
              ),

              TextFormField(
                controller: amountController,
                keyboardType: TextInputType.number,
                validator: (value){
                  if(value.isEmpty){
                    return 'amount cannot be empty';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    hintText: "add amount"
                ),
              ),
              Divider(),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 70,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          _selectedDate == null
                              ? 'No Date Chosen!'
                              : 'Picked Date: ${DateFormat.yMd().format(_selectedDate)}',
                        ),
                      ),
                      CustomFlatButton(text: 'Choose Date', handler:  _presentDatePicker,),
                    ],
                  ),
                ),
              ),

              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                child: RaisedButton(
                  onPressed: ()async {
                      if(titleController.text.trim().isNotEmpty && amountController.text.trim().isNotEmpty && _selectedDate != null){
                        _transactionsController.createTransaction(_currentCategory == null? "default": _currentCategory, user.user.uid, titleController.text.trim(), double.parse(amountController.text.trim()), _selectedDate);
                        Fluttertoast.showToast(msg: "Transaction recorded successfully");
                      }
                      else{
                        Fluttertoast.showToast(msg: "You must fill all field and select date");
                      }
                  },
                  child: Text(
                    "Ajouter",
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  color: Colors.deepOrange,
                  textColor: Colors.white,
                ),
              ),


            ],
          ),
      ),
    ),
  ),
  floatingActionButton: FloatingActionButton.extended(
    onPressed: () {
      _categoryAlert(user.user.uid);
    //  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyAddAddress(product: widget.product, color: widget.color, size: widget.size, quantity: widget.quantity, action: widget.action, products_list: widget.products_list,)));
    },
    label: Text('Ajouter Categorie'),
    icon: Icon(Icons.add, color: Colors.white,),
     backgroundColor: Colors.blueGrey,
  ),
  floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

);


  }

  void _categoryAlert(String id) {
    var alert = new AlertDialog(
      content: Form(
        key: _categoryFormKey,
        child: TextFormField(
          controller: categoryController,
          validator: (value){
            if(value.isEmpty){
              return 'category cannot be empty';
            }
            return null;
          },
          decoration: InputDecoration(
              hintText: "add category"
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton(
            onPressed: (){
              if(categoryController.text != null){
                _categoriesController.createCategory(id, categoryController.text,);
              }
              Fluttertoast.showToast(msg: 'category created');
               Navigator.pop(context);
               Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));

            },
            child: Text('ADD')
        ),
        FlatButton(
          onPressed: (){
            Navigator.pop(context);
          },
          child: Text('CANCEL'),
        ),

      ],
    );

    showDialog(context: context, builder: (_) => alert);
  }


  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
    print('...');
  }

  Future <void> _onShopDropItemSelected(String newValueSelected) async{
    setState(() {
      this._currentCategory = newValueSelected;
    });
    print(_currentCategory);
// _currentCategoryName = _categoryService.getCategoriesById(_currentCategory).data["category"];

  }



}