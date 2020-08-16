import 'package:flutter/material.dart';
import 'package:paybal_integragtion/service/paypalService.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Home extends StatefulWidget {
  final Function onFinish;

  Home({this.onFinish});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String checkoutUrl;
  String executeUrl;
  String accessToken;
  PayPalService _service = PayPalService();
  Map<dynamic, dynamic> defaultCurrency = {
    "symbol": "USD ",
    "decimalDigits": 2,
    "symbolBeforeTheNumber": true,
    "currency": "EGP"
  };
  bool isEnableShipping = false;
  bool isEnableAddress = false;
  String returnURL = 'return.example.com';
  String cancelURL = 'cancel.example.com';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () async {
      try {
        accessToken = await _service.getAccessToken();
        final transactions = getOrderParams();
        final res = await _service.createPayment(transactions, accessToken);
        if (res != null) {
          setState(() {
            checkoutUrl = res['approvalUrl'];
            executeUrl = res["executeUrl"];
          });
        }
      } catch (e) {
        print('exception:' + e.toString());
        final snackBar = SnackBar(
          content: Text(e.toString()),
          duration: Duration(seconds: 10),
        );
        _scaffoldKey.currentState.showSnackBar(snackBar);
      }
    });
  }

  String itemName = 'iphone x';
  String itemPrice = '15378';
  int quantity = 1;

  Map<String, dynamic> getOrderParams() {
    List items = [
      {
        "name": itemName,
        'price': itemPrice,
        'quantity': quantity,
        'currency': defaultCurrency['currency']
      }
    ];
    // checkout invoice details
    String totalAmount = '1.99';
    String subTotalAmount = '1.99';
    String shippingCost = '0';
    int shippingDiscountCost = 0;
    String userFirstName = 'Gulshan';
    String userLastName = 'Yadav';
    String addressCity = 'Delhi';
    String addressStreet = 'Mathura Road';
    String addressZipCode = '110014';
    String addressCountry = 'India';
    String addressState = 'Delhi';
    String addressPhoneNumber = '+919990119091';
    Map<String, dynamic> temp = {
      "intent": "sale",
      "payer": {"payment_method": "paypal"},
      "transactions": [
        {
          "amount": {
            "total": totalAmount,
            "currency": defaultCurrency["currency"],
            "details": {
              "subtotal": subTotalAmount,
              "shipping": shippingCost,
              "shipping_discount": ((-1.0) * shippingDiscountCost).toString()
            }
          },
          "description": "The payment transaction description.",
          "payment_options": {
            "allowed_payment_method": "INSTANT_FUNDING_SOURCE"
          },
          "item_list": {
            "items": items,
            if (isEnableShipping && isEnableAddress)
              "shipping_address": {
                "recipient_name": userFirstName + " " + userLastName,
                "line1": addressStreet,
                "line2": "",
                "city": addressCity,
                "country_code": addressCountry,
                "postal_code": addressZipCode,
                "phone": addressPhoneNumber,
                "state": addressState
              },
          }
        }
      ],
      "note_to_payer": "Contact us for any questions on your order.",
      "redirect_urls": {"return_url": returnURL, "cancel_url": cancelURL}
    };
    return temp;
  }

  @override
  Widget build(BuildContext context) {
    print(checkoutUrl);
    if(checkoutUrl !=null){return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: WebView(
        initialUrl: checkoutUrl,
        javascriptMode: JavascriptMode.unrestricted,
        navigationDelegate: (NavigationRequest request) {
          if (request.url.contains(returnURL)) {
            final uri = Uri.parse(request.url);
            final payerId = uri.queryParameters['PayerID'];
            if (payerId != null) {
              _service
                  .executePayment(executeUrl, payerId, accessToken)
                  .then((id) {
                widget.onFinish(id);
                Navigator.of(context).pop();
              });
            }else{
              Navigator.of(context).pop();
            }
            Navigator.of(context).pop();
          }
          if(request.url.contains(cancelURL)){
            Navigator.of(context).pop();
          }
          return NavigationDecision.navigate;
        },
      ),
    );}else{
      return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(leading: IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: (){Navigator.pop(context);}),
        ),
        body:Center(child: CircularProgressIndicator(),)
      );
    }
  }
}
