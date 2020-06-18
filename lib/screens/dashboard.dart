import 'package:cached_network_image/cached_network_image.dart';
import 'package:epocket/controllers/categores_controller.dart';
import 'package:epocket/controllers/transactionscontroller.dart';
import 'package:epocket/models/transaction.dart';
import 'package:epocket/providers/user_provider.dart';
import 'package:epocket/screens/homepage.dart';
import 'package:epocket/screens/select_period.dart';
import 'package:epocket/screens/stats_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  TransactionsController _transactionsController = TransactionsController();
  List<ETransaction> trans_list = [];

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: new AppBar(
        iconTheme: IconThemeData(
            color: Colors.white
        ),
        title: InkWell(onTap:(){
           Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
        },
            child: Text('Mes dépenses', style: TextStyle(color: Colors.white),)),
        // backgroundColor: Colors.orange,

        actions: <Widget>[

          IconButton(icon: Icon(Icons.pie_chart, color: Colors.white,), onPressed: (){
             Navigator.push(context, MaterialPageRoute(builder: (context) => SelectPeriod()));
          }
          ),
        ],
      ),
      body: FutureBuilder(
        future: _transactionsController.getETransactionByUser(user.user.uid),
        builder: (context,  snapshot){
          if(snapshot.hasData){
            print("================= snapshot.hasData  trans_list.length: ${snapshot.data.length}");

          //  return Text("transaction lenght is: ${snapshot.data.length}");
            trans_list = snapshot.data;
         //   print("==========================trans_mlist.dateis: ${trans_list[0].category}");
            if (snapshot.data.length >0) {
              return  Stack(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 30.0),
                          child: RaisedButton(
                            onPressed: ()async {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => StatsScreen()));
                            },
                            child: Text(
                              "CATEGORIES",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            color: Colors.deepOrange,
                            textColor: Colors.white,
                          ),
                        ),
                      ),
                      Spacer(),

                      Container(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0.0, 5.0, 15.0, 30.0),
                          child: RaisedButton(
                            onPressed: ()async {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => SelectPeriod()));
                            },
                            child: Text(
                              "STATISTIQUES",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            color: Colors.deepOrange,
                            textColor: Colors.white,
                          ),
                        ),
                      ),


                    ],
                  ),


                  Container(
                    padding: const EdgeInsets.fromLTRB(5.0, 60.0, 8.0, 0.0),
                    child: ListView.builder(
                      itemCount: trans_list.length,
                      itemBuilder: (BuildContext context, int index){
                        print("==========================trans_mlist.dateis: ${trans_list[0].date}");
                        return Padding(
                          padding: const EdgeInsets.all(4.0),
                          child:  Card(
                            elevation: 5,
                            margin: EdgeInsets.symmetric(
                              vertical: 2,
                              horizontal: 2,
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.blueGrey,
                                radius: 30,
                                child: Padding(
                                  padding: EdgeInsets.all(6),
                                  child: FittedBox(
                                    child: Text('XOF ${trans_list[index].amount}'),
                                  ),
                                ),
                              ),
                              title: Text(
                                '${trans_list[index].title.toUpperCase()}',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontWeight: FontWeight.w400, ),
                              ),
                              subtitle: Text(trans_list[index].date,
                                style: TextStyle(fontWeight: FontWeight.w300, ),
                                // DateFormat.yMMMd().add_jm().format(DateTime.parse(trans_list[index].date.toString())),
                              ),
                              trailing: MediaQuery.of(context).size.width > 460
                                  ? FlatButton.icon(
                                icon: Icon(Icons.delete),
                                label: Text('Delete'),
                                textColor: Theme.of(context).errorColor,
                                onPressed: () {
                                  _transactionsController.deleteById(trans_list[index].uid);
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Dashboard()));
                                },
                              )
                                  : IconButton(
                                icon: Icon(Icons.delete),
                                color: Theme.of(context).errorColor,
                                onPressed: () {
                                  _transactionsController.deleteById(trans_list[index].uid);
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Dashboard()));
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                ],
              );
            }
            else{
              return Column(
                children: <Widget>[
                  Container(
                    height: 250.0,
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: "https://images.artbrokerage.com/artthumb/mimo_89314_8/625x559/_MiMo_Stewey_Griffin_Family_Guy_Money_Bag_World_Takeover_Unique_2015__23x17.webp",
                      width: double.maxFinite,
                      placeholder: (context, url) => Center(child: const CircularProgressIndicator(), widthFactor: 10.0, heightFactor: 10.0,),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                      fadeOutDuration: const Duration(seconds: 1),
                      fadeInDuration: const Duration(seconds: 3),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Aucune dépense enregistrée !", style: TextStyle(color: Colors.red),),
                  ),
                ],
              );
            }

          }
          else{
            return Center(child: CircularProgressIndicator());
          }
        }
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
        },
        label: Text('Nouvelle dépense'),
        icon: Icon(Icons.add, color: Colors.white,),
        backgroundColor: Colors.blueGrey,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

    );
  }
}
