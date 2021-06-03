import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo/allTodo.dart';

class AddTodo extends StatefulWidget {
  @override
  _AddTodoState createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  final formKey = GlobalKey<FormState>();
  var userId;
  bool uploading = false;
  TextEditingController text = TextEditingController();

  addData() async {
    setState(() {
      uploading = true;
    });
    FirebaseFirestore.instance
        .collection('Todo')
        .doc(userId)
        .collection('My todo')
        .add({
      'todo': text.text,
    }).then((value) {
      setState(() {
        uploading = false;
      });
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return AllTodo();
      }));
    });
  }

  @override
  void initState() {
    final User user = FirebaseAuth.instance.currentUser;
    setState(() {
      userId = user.uid;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        centerTitle: true,
        title: Text('Add Todo'),
      ),
      body: Form(
        key: formKey,
        child: uploading
            ? Center(child: CircularProgressIndicator())
            : Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(0.0, 1.0), //(x,y)
                            blurRadius: 6.0,
                          ),
                        ],
                      ),
                      width: width,
                      height: height / 1.7,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: width * 0.08,
                                vertical: height * 0.01),
                            child: TextFormField(
                              maxLines: 4,
                              controller: text,
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide: BorderSide(
                                      color: Colors.black, width: 1.0),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide: BorderSide(
                                      color: Colors.black, width: 1.0),
                                ),
                                hintText: "Add todo",
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide: BorderSide(
                                      color: Colors.black, width: 1.0),
                                ),
                              ),
                              validator: (v) {
                                if (v.trim().isEmpty)
                                  return 'Please enter something';
                                return null;
                              },
                            ),
                          ),
                          Container(
                            width: width / 1.3,
                            child: ElevatedButton(
                                onPressed: () {
                                  if (formKey.currentState.validate()) {
                                    addData();
                                  }
                                },
                                child: Text("Add todo")),
                          )
                        ],
                      )),
                ),
              ),
      ),
    );
  }
}
