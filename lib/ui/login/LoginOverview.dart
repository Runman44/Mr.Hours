import 'package:avatar_glow/avatar_glow.dart';
import 'package:eventtracker/components/DelayedAnimation.dart';
import 'package:eventtracker/components/Loading.dart';
import 'package:eventtracker/service/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final int delayedAmount = 500;
  double _scale;
  AnimationController _controller;
  final AuthService _auth = AuthService();
  bool loading = false;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 200,
      ),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final color = Colors.white;
    _scale = 1 - _controller.value;

    return  Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).accentColor
            ],
          ),
        ),
        child: loading? SpinKitChasingDots(
          color: Colors.white,
          size: 40.0,
        ) : Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Spacer(),
              AvatarGlow(
                endRadius: 90,
                duration: Duration(seconds: 2),
                glowColor: Colors.white24,
                repeat: true,
                repeatPauseDuration: Duration(seconds: 2),
                startDelay: Duration(seconds: 1),
                child: Material(
                    shape: CircleBorder(),
                    child: CircleAvatar(
                      backgroundColor: Colors.grey[100],
                      child: Image.asset('assets/images/ic_launcher.png'),
                      radius: 55.0,
                    )),
              ),
              Spacer(),
              DelayedAnimation(
                child: Text(
                  "Hallo",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 35.0,
                      color: color),
                ),
                delay: delayedAmount + 1000,
              ),
              DelayedAnimation(
                child: Text(
                  "Wij zijn Pyre",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 35.0,
                      color: color),
                ),
                delay: delayedAmount + 2000,
              ),
              Spacer(),
              DelayedAnimation(
                child: Text(
                  "Je nieuw persoonlijke",
                  style: TextStyle(fontSize: 20.0, color: color),
                ),
                delay: delayedAmount + 3000,
              ),
              DelayedAnimation(
                child: Text(
                  "urenregistratie tool",
                  style: TextStyle(fontSize: 20.0, color: color),
                ),
                delay: delayedAmount + 3000,
              ),
              Spacer(),
              DelayedAnimation(
                child: Transform.scale(scale: _scale, child: _animatedButtonUI),
                delay: delayedAmount + 4000,
              ),
              Spacer()
            ],
          ),
        ),
      ),
    );
  }

  Widget get _animatedButtonUI => OutlineButton(
        splashColor: Colors.grey,
        onPressed: _launchURL,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        highlightElevation: 0,
        borderSide: BorderSide(color: Colors.white),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(
                  image: AssetImage("assets/images/google_logo.png"),
                  height: 35.0),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  'Sign in with Google',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  _launchURL() async {
    setState(() {
      loading = true;
    });
    dynamic results = await _auth.signInWithGoogle();
    if (results == null) {
      setState(() {
        loading = false;
      });
    }
  }
}
