import 'package:flutter/material.dart';
import "package:graphql_flutter/graphql_flutter.dart";
import '../graphql/queryMutation.dart';
import '../graphql/graphqlConf.dart';
import '../globalstate.dart';
import 'dart:async';

class Dashboard extends StatefulWidget{
  @override
  _DashboardState createState() => new _DashboardState();
}

class _DashboardState extends State<Dashboard>{

  GlobalState _store = GlobalState.instance;
  String token, userid;

  static TextEditingController newTitle, newDescription;

  List<dynamic> bookList = new List<dynamic>();
  @override
  void initState() {
    newTitle = new TextEditingController();
    newDescription = new TextEditingController();
    token = _store.get('token');
    userid = _store.get('userid');
    queryBooks();
  }

  void queryBooks() async{
    QueryMutation queryMutation = QueryMutation();
    GraphQLClient _client = GraphQLConfiguration.clientToQueryWithToken(token);

    QueryResult result = await _client.query(
      QueryOptions(
        document: queryMutation.getBooks(),
      ),
    );

    if(result.hasErrors){
      print(result.errors[0].message.toString());
    }else{
      setState(()=>bookList = result.data["book"]);
      bookList = result.data["book"];
      print(bookList.length);
      print(bookList[0]["title"]);
    }
  }

  void addBook() async{
    QueryMutation queryMutation = QueryMutation();
    GraphQLClient _client = GraphQLConfiguration.clientToQueryWithToken(token);

    QueryResult result = await _client.query(
      QueryOptions(
        document: queryMutation.addBook(newTitle.text, newDescription.text),
      ),
    );

    if(result.hasErrors){
      print(result.errors[0].message.toString());
    }else{
      queryBooks();
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(elevation: 0.0,
        title: new Text('Demo Flutter - GraphQL'),
        backgroundColor: Color(0xff39998e),
      ),
      body: new Container(
        padding: new EdgeInsets.all(0.0),
        child: new Center(
          child: new ListView(
            children: <Widget>[
              new Container(
                color: Color(0xff39998e),
                child: new Container(
                    padding: new EdgeInsets.all(16.0),
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Container(
                          child: new Text('User ID: '+userid,
                          style: new TextStyle(color: Colors.white),),
                        ),
                        new Container(
                          child: new Text('Token: '+token,
                          style: new TextStyle(color: Colors.white),)
                        )
                      ],
                    )
                ),
              ),
              new Padding(padding: new EdgeInsets.all(8.0)),
              new ListView.builder(
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: bookList.length,
                  itemBuilder: ((ctx,idx){
                    return new Card(
                      elevation: 2.0,
                      child:  Container(
                        padding: new EdgeInsets.all(16.0),
                        width: MediaQuery.of(context).size.width,
                        margin: new EdgeInsets.all(2.0),
                        child: new Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Text('ID: '+bookList[idx]["_id"]),
                            new Text('Title: '+bookList[idx]["title"]),
                            new Text('Description: '+bookList[idx]["description"]),
                          ],
                        )
                      ),
                    );
                  })
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        elevation: 4.0,
        backgroundColor: Color(0xff39998e),
        icon: const Icon(Icons.add),
        label:  new Text('Add Book',style: new TextStyle(fontSize: 14.0, color: Colors.white)),
        onPressed: dialogAddBook,
      ),
      floatingActionButtonLocation:
      FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.refresh, color: Color(0xff39998e),),
              onPressed: queryBooks,
            ),
            FlatButton(
              onPressed: (){
                _store.set('token', null);
                _store.set('userid', null);
                Navigator.pushNamedAndRemoveUntil(context, '/SignUp', (Route<dynamic> route) => false);
              },
              child: new Text('Logout', style: new TextStyle(color: Colors.redAccent),),
            )
          ],
        ),
      ),
    );
  }

  Future dialogAddBook() async {
    await showDialog(
        context: context,
        child: new SimpleDialog(
          title: new Text('Add a Book'),
          children: <Widget>[
            new Padding(
                padding: EdgeInsets.only(right: 16.0, left: 16.0),
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(15.0),
                      child: new TextField(
                        decoration: new InputDecoration(
                          labelText: "Title",
                          hintText: 'Title',
                          hintStyle: TextStyle(color: Color(0xffd0d6d9), fontSize: 16.0),
                        ),
                        controller: newTitle,
                        keyboardType: TextInputType.text,
                        style: new TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Color(0xff143345)),
                        onTap: (){},
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(15.0),
                      child: new TextField(
                        decoration: new InputDecoration(
                          labelText: "Description",
                          hintText: 'Description',
                          hintStyle: TextStyle(color: Color(0xffd0d6d9), fontSize: 16.0),
                        ),
                        controller: newDescription,
                        keyboardType: TextInputType.text,
                        style: new TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Color(0xff143345)),
                        onTap: (){},
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 20.0)),
                    FlatButton(onPressed: (){
                      Navigator.of(context).pop();
                      addBook();
                    },
                        child: Text('Add Book!', style: TextStyle(color: Colors.purple, fontSize: 18.0),))
                  ],
                )
            ),
          ],
        )
    );
  }

}