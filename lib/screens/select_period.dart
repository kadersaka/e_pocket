import 'package:epocket/controllers/transactionscontroller.dart';
import 'package:epocket/providers/user_provider.dart';
import 'package:epocket/screens/dashboard.dart';
import 'package:epocket/screens/homepage.dart';
import 'package:epocket/screens/search_result.dart';
import 'package:epocket/widgets/customflatButton.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
class SelectPeriod extends StatefulWidget {
  @override
  _SelectPeriodState createState() => _SelectPeriodState();
}

class _SelectPeriodState extends State<SelectPeriod> {
  DateTime _startDate;
  DateTime _endtDate;
  TransactionsController _transactionsController = TransactionsController();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: new AppBar(
        iconTheme: IconThemeData(
            color: Colors.white
        ),
        title: InkWell(onTap:(){
          Navigator.push(context, MaterialPageRoute(builder: (context) => Dashboard()));
        },
            child: Text('Statistiques', style: TextStyle(color: Colors.white),)),
        // backgroundColor: Colors.orange,

        actions: <Widget>[

          IconButton(icon: Icon(Icons.add, color: Colors.white,), onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
          }
          ),
        ],
      ),

      body: SafeArea(
        child: Center(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 100.0,
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        _startDate == null
                            ? 'No Start Date Chosen!'
                            : 'Start Date: ${DateFormat.yMd().format(_startDate)}',
                      ),
                    ),
                    // CustomFlatButton(text: 'Choose starting Date', handler:  _presentDatePicker(),),
                    RaisedButton(
                      child: Text("Choose date"),
                      onPressed: (){
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
                            _startDate = pickedDate;
                          });
                        });
                      },
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        _endtDate == null
                            ? 'No end Date Chosen!'
                            : 'End Date: ${DateFormat.yMd().format(_endtDate)}',
                      ),
                    ),
                  //  CustomFlatButton(text: 'Choose starting Date', handler:  _presentDatePicker(_endtDate),),
                    RaisedButton(
                      child: Text("Choose date"),
                      onPressed: (){
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
                            _endtDate = pickedDate;
                          });
                        });
                      },
                    ),
                  ],
                ),
              ),


              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                child: RaisedButton(
                  onPressed: ()async {
                    if(_startDate != null && _endtDate != null){
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SearchResult(start: _startDate, end: _endtDate,)));
                     //_transactionsController.getETransactionByUserPeriod(user.user.uid, _startDate, _endtDate);
                     // Fluttertoast.showToast(msg: "Transaction recorded successfully");
                    }
                    else{
                      Fluttertoast.showToast(msg: "You must  select start and end ");
                    }
                  },
                  child: Text(
                    "VOIR",
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
    );
  }

   _presentDatePicker() {
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
        _startDate = pickedDate;
      });
    });
    print('...');
  }

}
