import 'package:flutter/material.dart';
import 'package:pinput/pin_put/pin_put.dart';

import '../../main.dart';

class PinPage extends StatefulWidget {

  @override
  _PinPageState createState() => _PinPageState();
}

class _PinPageState extends State<PinPage> {
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();

  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      border: Border.all(color: Colors.deepPurpleAccent),
      borderRadius: BorderRadius.circular(15),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pincode"),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).accentColor
              ],
            ),
          ),
        ),
      ),
      body: Builder(
        builder: (context) {
          return Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    color: Colors.white,
                    margin: EdgeInsets.all(20),
                    padding: EdgeInsets.all(20),
                    child: PinPut(
                      fieldsCount: 5,
                      onSubmit: (String pin) => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyHomePage()
                        ),
                      ),
                      focusNode: _pinPutFocusNode,
                      controller: _pinPutController,
                      submittedFieldDecoration: _pinPutDecoration.copyWith(
                          borderRadius: BorderRadius.circular(20)),
                      selectedFieldDecoration: _pinPutDecoration,
                      followingFieldDecoration: _pinPutDecoration.copyWith(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: Colors.deepPurpleAccent.withOpacity(.5),
                        ),
                      ),
                    ),
                  ),
//                  SizedBox(height: 30),
//                  Divider(),
//                  Row(
//                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                    children: <Widget>[
//                      FlatButton(
//                        child: Text('Focus'),
//                        onPressed: () => _pinPutFocusNode.requestFocus(),
//                      ),
//                      FlatButton(
//                        child: Text('Unfocus'),
//                        onPressed: () => _pinPutFocusNode.unfocus(),
//                      ),
//                      FlatButton(
//                        child: Text('Clear All'),
//                        onPressed: () => _pinPutController.text = '',
//                      ),
//                    ],
//                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showSnackBar(String pin, BuildContext context) {
    final snackBar = SnackBar(
      duration: Duration(seconds: 3),
      content: Container(
          height: 80.0,
          child: Center(
            child: Text(
              'Pin Submitted. Value: $pin',
              style: TextStyle(fontSize: 25.0),
            ),
          )),
      backgroundColor: Colors.deepPurpleAccent,
    );
    Scaffold.of(context).hideCurrentSnackBar();
    Scaffold.of(context).showSnackBar(snackBar);
  }
}