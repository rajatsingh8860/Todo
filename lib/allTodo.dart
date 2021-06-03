import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:todo/AddTodo.dart';

class AllTodo extends StatefulWidget {
  @override
  AllTodoState createState() => AllTodoState();
}

class AllTodoState extends State<AllTodo> {
  TextEditingController notes = TextEditingController();

  bool uploading = false;
  var userId;
  firebase_storage.Reference ref;
  final formKey = GlobalKey<FormState>();
  var exists = true;
  var loading = true;

  @override
  void initState() {
    final User user = FirebaseAuth.instance.currentUser;
    setState(() {
      userId = user.uid;
    });
    checkIfCollectionExists();
    super.initState();
  }

  checkIfCollectionExists() async {
    setState(() {
      uploading = true;
    });
    await FirebaseFirestore.instance
        .collection('Todo')
        .doc(userId)
        .collection('My todo')
        .snapshots()
        .listen((event) {
      if (event.docs.length == 0) {
        setState(() {
          exists = false;
        });
      }
    });
    setState(() {
      uploading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () {
        SystemNavigator.pop();
      },
      child:Scaffold(
        appBar: AppBar(
          brightness: Brightness.dark,
          centerTitle: true,
          title: Text('All Todo'),
          actions: [
            IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return AddTodo();
                  }));
                })
          ],
        ),
        body: uploading ? Center(child:CircularProgressIndicator()) : !exists
              ? Center(child: Text("No data found !!")) : SingleChildScrollView(
          child: Form(
            key: formKey,
            child: uploading
                ? Container(
                    margin: EdgeInsets.only(top: height / 2.4, left: width / 2),
                    child: CircularProgressIndicator())
                : Center(
                    child: Container(
                        width: width,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SingleChildScrollView(
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Container(
                                      height: height / 1.7,
                                      child: StreamBuilder(
                                          stream: FirebaseFirestore.instance
                                              .collection('Todo')
                                              .doc(userId)
                                              .collection('My todo')
                                              .snapshots(),
                                          builder: (context, snapshot) {
                                            return !snapshot.hasData
                                                ? Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  )
                                                : Container(
                                                    padding: EdgeInsets.all(4),
                                                    child: GridView.builder(
                                                        itemCount: snapshot.data
                                                            .documents.length,
                                                        gridDelegate:
                                                            SliverGridDelegateWithFixedCrossAxisCount(
                                                                childAspectRatio:
                                                                    height /
                                                                        width *
                                                                        2,
                                                                crossAxisCount:
                                                                    1),
                                                        itemBuilder:
                                                            (context, index) {
                                                          return InkWell(
                                                            child: Card(
                                                                elevation: 3,
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          8.0),
                                                                  child: Text(
                                                                    snapshot
                                                                        .data
                                                                        .documents[
                                                                            index]
                                                                        .get(
                                                                            'todo'),
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                )),
                                                          );
                                                        }),
                                                  );
                                          })),
                                ),
                              ),
                            ),
                          ],
                        )),
                  ),
          ),
        ),
      ),
    );
  }
}
