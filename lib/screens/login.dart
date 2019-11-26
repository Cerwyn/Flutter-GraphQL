import 'package:flutter/material.dart';
import "package:graphql_flutter/graphql_flutter.dart";
import '../graphql/queryMutation.dart';
import '../graphql/graphqlConf.dart';
import '../globalstate.dart';

class Login extends StatefulWidget{
  @override
  _LoginState createState() => new _LoginState();
}

class _LoginState extends State<Login>{
  TextEditingController email, pass;
  bool isProgress = false;
  String notes = '';

  GlobalState _store = GlobalState.instance;

  @override
  void initState() {
    email = new TextEditingController();
    pass = new TextEditingController();
  }

  void loginUser() async{
    QueryMutation queryMutation = QueryMutation();
    GraphQLClient _client = GraphQLConfiguration.clientToQuery();

    QueryResult result = await _client.query(
      QueryOptions(
        document: queryMutation.loginUser(email.text, pass.text),
      ),
    );

    if(result.hasErrors){
      print(result.errors[0].message);
      setState(() {
        isProgress = false;
        notes = result.errors[0].message;
      });
    }else{
      print(result.data["login"]["token"]);
      _store.set('token', result.data["login"]["token"]);
      _store.set('userid', result.data["login"]["userId"]);
      Navigator.pushNamedAndRemoveUntil(context, '/Dashboard', (Route<dynamic> route) => false);
    }
  }

  void _checkForm(){
    setState(()=>isProgress = true);
    bool emailValid = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email.text);
    if(!emailValid){
      setState(() {
        isProgress = false;
        notes = 'Email not valid';
      });
    }else{
      loginUser();
    }
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        actions: <Widget>[
        ],
      ),
      body: new SingleChildScrollView(
        child: new Container(
          color: Colors.white,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: new EdgeInsets.all(24.0),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Container(
                margin: new EdgeInsets.only(top: 8.0),
                child: new Text('DEMO Flutter - Graphql', style: new TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff143345)
                ),
                ),
              ),
              new Container(
                margin: new EdgeInsets.only(top: 8.0),
                child: new Text('Login', style: new TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff143345)
                ),
                ),
              ),
              new Container(
                margin: new EdgeInsets.only(top: 32.0),
                child: new TextField(
                  decoration: new InputDecoration(
                    labelText: "Email",
                    hintText: 'Email',
                    hintStyle: TextStyle(color: Color(0xffd0d6d9), fontSize: 16.0),
                  ),
                  controller: email,
                  keyboardType: TextInputType.text,
                  style: new TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Color(0xff143345)),
                  onTap: (){},
                ),
              ),
              new Container(
                margin: new EdgeInsets.only(top: 16.0),
                child: new TextField(
                  decoration: new InputDecoration(
                    labelText: "Password",
                    hintText: 'Password',
                    hintStyle: TextStyle(color: Color(0xffd0d6d9), fontSize: 16.0),
                  ),
                  obscureText: true,
                  controller: pass,
                  keyboardType: TextInputType.text,
                  style: new TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Color(0xff143345)),
                  onTap: (){},
                ),
              ),
              new Padding(padding: new EdgeInsets.all(4.0)),
              new Text('${notes}', style: new TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent
              ),
              ),
              new GestureDetector(
                onTap: isProgress? (){} : _checkForm,
                child: new Container(
                  margin: new EdgeInsets.only(top: 4.0),
                  width: 272.0,
                  height: 48.0,
                  decoration: new BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      color: isProgress? Colors.grey : Color(0xff39998e)
                  ),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      new Text('Login', style: new TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                      ),
                      ),
                    ],
                  ),
                ),
              ),
              new GestureDetector(
                onTap: ()=>Navigator.pushNamedAndRemoveUntil(context, '/SignUp', (Route<dynamic> route) => false),
                child: new Container(
                  margin: new EdgeInsets.only(top: 4.0),
                  width: 272.0,
                  height: 48.0,
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      new Text('Demo Sign Up here', style: new TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff39998e)
                      ),
                      ),
                    ],
                  ),
                ),
              ),
              new Padding(padding: new EdgeInsets.all(8.0)),
            ],
          ),
        ),
      ),
    );
  }

}