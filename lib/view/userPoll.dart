import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vote/view/HomePage.dart';
import 'package:vote/view/SignIn.dart';

class UserPoll extends StatefulWidget {
  @override
  _UserPollState createState() => _UserPollState();
}

class _UserPollState extends State<UserPoll> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseUser user;
  bool isSignedIn = false;
  String imageUrl;
  String userId = '';
  QuerySnapshot myDoc3;
  int creditUser;

  signout() async {
    _auth.signOut();
    Navigator.push(context, MaterialPageRoute(builder: (context) => SignIn()));
  }

  users() async {
    final FirebaseUser user = await auth.currentUser();
    setState(() {
      userId = user.uid;
    });
  }

  @override
  void initState() {
    super.initState();
    users();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          // List

          Container(
            child: StreamBuilder(
              stream: Firestore.instance
                  .collection('poll')
                  .where("creatorid", isEqualTo: userId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return ListView.builder(
                    padding: EdgeInsets.all(10.0),
                    itemBuilder: (context, index) => buildItem(
                        context, snapshot.data.documents[index], index),
                    itemCount: snapshot.data.documents.length,
                  );
                }
              },
            ),
          ),

          Container(
            alignment: Alignment.bottomRight,
            padding: EdgeInsets.all(20),
            child: RaisedButton(
              padding: EdgeInsets.fromLTRB(30, 15, 30, 15),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              color: Colors.blue,
              onPressed: signout,
              child: Text(
                'Log Out',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          )
          // Loading
          /*Positioned(
              child: isLoading ? const Loading() : Container(),
            )*/
        ],
      ),
    );
  }

  Widget buildItem(BuildContext context, DocumentSnapshot document, index) {
    
    if (document.data['id'] == userId) {
      return Container();
    } else {
      return Column(
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
          Row(
            children: <Widget>[
              Material(
                child: Icon(
                  Icons.list,
                  size: 50.0,
                ),
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
                clipBehavior: Clip.hardEdge,
              ),
              Flexible(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Text(
                              'Poll' + (index + 1).toString(),
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.blueAccent,
                                  fontWeight: FontWeight.w300),
                            ),
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                          ),
                          GestureDetector(
                            onTap: () => {
                              Firestore.instance
                                  .collection('poll')
                                  .document(document.data['id'])
                                  .delete(),
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomeView())),
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Delated"),
                                    content: Text("your poll is delated"),
                                  );
                                },
                              ),
                            },
                            child: Icon(
                              Icons.delete,
                              color: Colors.black,
                              size: 25.0,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            child: Text(
                              'Up:   ${(document.data['vote'][0]).toInt()}',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w200),
                            ),
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                          ),
                          Container(
                            child: Text(
                              'Down:   ${(document.data['vote'][1]).toInt()}',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w200),
                            ),
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                          ),
                        ],
                      ),
                    ],
                  ),
                  margin: EdgeInsets.only(left: 20.0),
                ),
              ),
            ],
          ),
        ],
      );
    }
  }
}
