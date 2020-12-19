import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:swipedetector/swipedetector.dart';
import 'package:vote/view/TextPoll.dart';
import 'package:vote/view/newPoll.dart';

class AddPoll extends StatefulWidget {
  @override
  _AddPollState createState() => _AddPollState();
}

class _AddPollState extends State<AddPoll> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  FirebaseUser user;

  bool isSignedIn = false;

  String imageUrl;

  String userId = '';

  int creditUser;

  credit() async {
    final FirebaseUser user = await auth.currentUser();
    setState(() {
      userId = user.uid;
    });

    QuerySnapshot _myDoc1 = await Firestore.instance
        .collection('users')
        .where("id", isEqualTo: userId)
        .getDocuments();
    creditUser = _myDoc1.documents[0].data['credit'];
    setState(() {
      creditUser = creditUser;
      print(creditUser);
    });
  }

  void initState() {
    super.initState();

    credit();
  }

  Widget build(BuildContext context) {
    return Scaffold(
//      appBar: AppBar(
//        title: Text('Sign In'),
//      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20, 50, 20, 50),
        child: Center(
          child: ListView(
            children: <Widget>[
              SwipeDetector(
                onSwipeUp: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AddNew()));
                },
                onSwipeDown: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => TextPoll()));
                },
                child: Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.08),
                      Container(
                        child: Text(
                          'Your credit is :' + creditUser.toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.1),
                       Container(
                            height: MediaQuery.of(context).size.height * 0.2,
                            width: MediaQuery.of(context).size.width - 100,
                            color: Colors.blue,
                            padding: EdgeInsets.all(16),
                            child:
                      Row(
                        children: [
                          Padding(
                              padding: const EdgeInsets.all(30.0),
                              child: Text(
                                'Add a  Pic Poll',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white, fontSize: 18,fontWeight: FontWeight.bold),
                              ),
                            ),
                          
                                Material(
                child: Icon(
                  Icons.keyboard_arrow_up,
                  size: 50.0,
                ),
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
                clipBehavior: Clip.hardEdge,
              ),
                        ],
                      ),),

                       SizedBox(
                        height: MediaQuery.of(context).size.height * 0.05,
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.2,
                        width: MediaQuery.of(context).size.width - 100,
                        color: Colors.blue,
                        padding: EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(30.0),
                              child: Text(
                                'Add a  Text Poll',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white, fontSize: 18,fontWeight: FontWeight.bold),
                              ),
                            ),
                              Material(
                child: Icon(
                  Icons.keyboard_arrow_down,
                  size: 50.0,
                ),
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
                clipBehavior: Clip.hardEdge,
              ),
                        ],
                          
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.1,
                      ),
                    ],
                  ),
                  elevation: 20,
                  shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(150),
                  )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
