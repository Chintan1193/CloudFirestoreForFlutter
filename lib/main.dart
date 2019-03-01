import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new CrudSampleState();
  }
}

class CrudSampleState extends State<MyApp> {
  final DocumentReference documentReference =
      Firestore.instance.collection("myData").document("info");
  StreamSubscription<DocumentSnapshot> subscription;

  String message = "";

  void _add() {
    Map<String, String> data = <String, String>{
      "name": "Chintan",
      "city": "Vadodara"
    };

    documentReference.setData(data).whenComplete(() {
      setState(() {
        message = "Data inserted.";
      });
    }).catchError((e) => print(e));
  }

  void _update() {
    Map<String, String> data = <String, String>{
      "name": "Chintan Shah",
      "city": "Ahmedabad"
    };

    documentReference.setData(data).whenComplete(() {
      setState(() {
        message = "Data updated.";
      });
    }).catchError((e) => print(e));
  }

  void _delete() {
    documentReference.delete().whenComplete(() {
      setState(() {
        message = "Data deleted.";
      });
    }).catchError((e) => print(e));
  }

  void _fetch() {
    documentReference.get().then((documentSnapshot) {
      if (documentSnapshot.exists) {
        setState(() {
          message = documentSnapshot.data['city'];
        });
      } else {
        setState(() {
          message = "No data found.";
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();

    subscription = documentReference.snapshots().listen((documentSnapshot) {
      if (documentSnapshot.exists) {
        setState(() {
          message = documentSnapshot.data['city'];
        });
      } else {
        setState(() {
          message = "No data found.";
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();

    subscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Cloud Firestore",
        home: new Scaffold(
            appBar: new AppBar(
              title: new Text("Cloud Firestore"),
            ),
            body: new Padding(
              padding: const EdgeInsets.all(20.0),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  new RaisedButton(
                    onPressed: _add,
                    child: new Text("Add"),
                    color: Colors.green,
                  ),
                  new Padding(padding: const EdgeInsets.all(10.0)),
                  new RaisedButton(
                    onPressed: _update,
                    child: new Text("Update"),
                    color: Colors.orange,
                  ),
                  new Padding(padding: const EdgeInsets.all(10.0)),
                  new RaisedButton(
                    onPressed: _delete,
                    child: new Text("Delete"),
                    color: Colors.red,
                  ),
                  new Padding(padding: const EdgeInsets.all(10.0)),
                  new RaisedButton(
                    onPressed: _fetch,
                    child: new Text("Fetch"),
                    color: Colors.yellow,
                  ),
                  new Padding(padding: const EdgeInsets.all(10.0)),
                  new Text(
                    message == null ? "" : message,
                    style: TextStyle(fontSize: 20.0),
                  )
                ],
              ),
            )));
  }
}
