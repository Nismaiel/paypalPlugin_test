import 'package:flutter/material.dart';
import 'package:paybal_integragtion/screens/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Paybal',
        home: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text(
              'Paypal Demo',
              style: TextStyle(color: Colors.white),
            ),
            centerTitle: true,
          ),
          body: Container(
//          width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //making the payment
                RaisedButton(onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context)=>Home(onFinish: (number)async{
                    print('order id: '+number );
                  },))

                  );
                }, child: Text('pay with Paypal'),

                )
              ],
            ),
          ),
        ));
  }
}
