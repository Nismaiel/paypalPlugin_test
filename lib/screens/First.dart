import 'package:flutter/material.dart';
import 'package:paybal_integragtion/screens/home.dart';

class First extends StatefulWidget {
  @override
  _FirstState createState() => _FirstState();
}

class _FirstState extends State<First> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            RaisedButton(
              onPressed: (){

                // make PayPal payment
                Navigator.push(context, MaterialPageRoute(builder: (ctx)=>Home(onFinish: (number)async{
                  print("payment ID: "+number.toString());
                },)));


              },

              child: Text('pay with Paypal'),

            )
          ],
        ),
      ),
    );
  }
}
