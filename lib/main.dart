import 'package:flutter/material.dart';
import "package:graphql_flutter/graphql_flutter.dart";
import './graphql/graphqlConf.dart';
import 'screens/login.dart';
import 'screens/signup.dart';
import 'screens/dashboard.dart';

GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    GraphQLProvider(
      client: graphQLConfiguration.client,
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Demo Flutter - GraphQL',
      routes: <String, WidgetBuilder>{
        //All Routes Goes Here
        '/Login' : (BuildContext context) => new Login(),
        '/SignUp' : (BuildContext context) => new SignUp(),
        '/Dashboard' : (BuildContext context) => new Dashboard(),
      },
      home: new Login(),
    );
  }
}