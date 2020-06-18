import 'package:cached_network_image/cached_network_image.dart';
import 'package:epocket/providers/user_provider.dart';
import 'package:epocket/screens/Login.dart';
import 'package:epocket/screens/dashboard.dart';
import 'package:epocket/screens/homepage.dart';
import 'package:epocket/screens/select_period.dart';
import 'package:epocket/screens/stats_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//void main() {
//  runApp(MyApp());
//}


 void main() => runApp(
     ChangeNotifierProvider(create:(_)=>UserProvider.initialize(),

/*     MultiProvider(providers: [
       ChangeNotifierProvider.value(value: UserProvider.initialize()),
       ChangeNotifierProvider.value(value: TransactionsProvider()),
     ] ,

 */

child: MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primaryColor: Colors.blueGrey,
    ),
    home: ScreensController(),
  ),
)
);

class ScreensController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);

    switch(user.status){
      case Status.Uninitialized: return SplashScreen();
      case Status.Authenticating: return  Login();
      case Status.Unauthenticated: return  Login();
      case Status.Authenticated: return Dashboard();
      default: return Login();
    }
  }
}



class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'E-Pocket',
      theme: ThemeData(
          primarySwatch: Colors.blueGrey,
          accentColor: Colors.black,
          textTheme: ThemeData.light().textTheme.copyWith(
            title: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
            button: TextStyle(color: Colors.white),
          ),
          appBarTheme: AppBarTheme(
            textTheme: ThemeData.light().textTheme.copyWith(
              title: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          )),
      home: HomePage(),
    );
  }}
  
  class SplashScreen extends StatefulWidget {
    @override
    _SplashScreenState createState() => _SplashScreenState();
  }
  
  class _SplashScreenState extends State<SplashScreen> {
    @override
    Widget build(BuildContext context) {
      return Center(
        child: Column(
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
            Container(
              child: Text("Initialisation"),
            ),
            Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          ],
        ),
      );
    }
  }
  
