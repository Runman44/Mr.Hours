import 'package:flutter/material.dart';
import 'package:pinput/pin_put/pin_put.dart';

import '../../main.dart';

class PinPage extends StatefulWidget {

  @override
  _PinPageState createState() => _PinPageState();
}

class _PinPageState extends State<PinPage> {
  final TextEditingController _pinPutController = TextEditingController();

  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      color: Colors.deepPurple,
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
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        color: Colors.white,
                        margin: EdgeInsets.all(20),
                        padding: EdgeInsets.all(10),
                        child: PinPut(
                          fieldsCount: 5,
                          onSubmit: (String pin) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MyHomePage(),
                              ),
                            );
                          },
                          controller: _pinPutController,
                          preFilledChar: "-",
                          preFilledCharStyle: TextStyle(fontSize: 28, color: Colors.white),
                          textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
                          submittedFieldDecoration: _pinPutDecoration.copyWith(
                              borderRadius: BorderRadius.circular(20)),
                          selectedFieldDecoration: BoxDecoration(
                            color: Colors.purple,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          followingFieldDecoration: _pinPutDecoration.copyWith(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.blue,
                  child:  Column(
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _pinNumber(1),
                            _pinNumber(2),
                            _pinNumber(3),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _pinNumber(4),
                            _pinNumber(5),
                            _pinNumber(6),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _pinNumber(7),
                            _pinNumber(8),
                            _pinNumber(9),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _emptyButton(),
                            _pinNumber(0),
                            _backButton(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _pinNumber(int number) {
    return Expanded(
      child: Material(
        child: InkWell(
          onTap: (){
            _pinPutController.text = _pinPutController.text + number.toString();
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white
              ),
            ),
            child: Center(child: Text(number.toString(), style: TextStyle(fontSize: 28), textAlign: TextAlign.center,)),
          ),
        ),
      ),
    );
  }

  Widget _emptyButton() {
    return Expanded(
      child: Material(
        child: InkWell(
          onTap: (){},
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                  color: Colors.white
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _backButton() {
    return Expanded(
      child: Material(
        child: InkWell(
          onTap: (){
            _pinPutController.text = _pinPutController.text.substring(0, _pinPutController.text.length -1);
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                  color: Colors.white
              ),
            ),
            child: Center(child: Icon(Icons.backspace)),
          ),
        ),
      ),
    );
  }

}