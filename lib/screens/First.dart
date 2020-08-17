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
      backgroundColor: Colors.transparent,
      key: _scaffoldKey,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(45.0),
        child: new AppBar(
          backgroundColor: Colors.white,
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Paypal Payment Example',
                style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.red[900],
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Open Sans'),
              ),
            ],
          ),
        ),
      ),
      body:Container(
          width: MediaQuery.of(context).size.width,
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  onPressed: (){

                    // make PayPal payment

                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => PaypalPayment(
                          onFinish: (number) async {

                            // payment done
                            print('order id: '+number);

                          },
                        ),
                      ),
                    );


                  },
                  child: Text('Pay with Paypal', textAlign: TextAlign.center,),
                ),

              ],
            ),
          )
      ),
    );

  }
}
