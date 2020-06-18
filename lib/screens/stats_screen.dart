import 'package:cached_network_image/cached_network_image.dart';
import 'package:epocket/controllers/categores_controller.dart';
import 'package:epocket/controllers/transactionscontroller.dart';
import 'package:epocket/models/category.dart';
import 'package:epocket/models/transaction.dart';
import 'package:epocket/providers/user_provider.dart';
import 'package:epocket/screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'homepage.dart';
class StatsScreen extends StatefulWidget {
  @override
  _StatsScreenState createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  TransactionsController _transactionsController = TransactionsController();
  CategoriesController _categoriesController = CategoriesController();
  List<ETransaction> trans_list = [];
List<Category> cat_list = [];

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: new AppBar(
        iconTheme: IconThemeData(
            color: Colors.white
        ),
        title: InkWell(
          onTap:(){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
          },
          child: Text('Mes dépenses', style: TextStyle(color: Colors.white),),
        ),
        // backgroundColor: Colors.orange,

        actions: <Widget>[
          IconButton(icon: Icon(Icons.pie_chart, color: Colors.white,), onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => Dashboard()));
          }
          ),
        ],
      ),
      body: FutureBuilder(
          future: _categoriesController.getCategoriesByUser(user.user.uid),
          builder: (context,  snapshot){
            if(snapshot.hasData){
              print("================= snapshot.hasData  trans_list.length: ${snapshot.data.length}");

              //  return Text("transaction lenght is: ${snapshot.data.length}");
              cat_list = snapshot.data;
              //   print("==========================trans_mlist.dateis: ${trans_list[0].category}");
              if (snapshot.data.length >0) {
                return  Stack(
                  children: <Widget>[

                    Container(
                      padding: const EdgeInsets.fromLTRB(5.0, 10.0, 8.0, 0.0),

                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                        itemCount: cat_list.length,
                        itemBuilder: (BuildContext context, int index){
                          print("==========================trans_mlist.dateis: ${cat_list[0].title}");
                          return  Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              child: ListTile(
                                  title: FlatButton.icon(
                                      onPressed: null,
                                      icon: Icon(Icons.category),
                                      label: Text("${cat_list[index].title}",overflow: TextOverflow.ellipsis, style: TextStyle(),
                                      ),
                                  ),

                                  subtitle: FutureBuilder(
                                      future: _transactionsController.getCategoryETransactionByUser(user.user.uid, cat_list[index].title),
                                      builder: (context,  snaps){
                                      if(snaps.hasData) {
                                        trans_list = snaps.data;
                                        if(trans_list.length>0){
                                          double valuess = 0;
                                          for(int i=0; i< trans_list.length; i++ ){
                                            valuess+= trans_list[i].amount;
                                          }

                                          return Text(
                                            'XOF ${valuess}',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(color: Colors.deepOrange, fontSize: 20.0),
                                          );
                                        }
                                        else{
                                          return Text("XOF 0");
                                        }
                                      }
                                      else{
                                        return Text("XOF 0");
                                      }
    }

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
                      child: Text("Aucune Catégorie enregistrée !", style: TextStyle(color: Colors.red),),
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


    );
  }
}
