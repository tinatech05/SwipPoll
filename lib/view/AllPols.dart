import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vote/Model/poll.dart';
import 'package:vote/Service/dbservice.dart';
import 'package:vote/view/AllpollsVote.dart';

class AllPoll extends StatefulWidget {
  @override
  _AllPollState createState() => _AllPollState();
}

class _AllPollState extends State<AllPoll> {
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

  int something;
  int vare;
  Db db = new Db();
  List<Poll> poll = [];
  List<String> votedfor;
  List<double> vote = [];

  Future prodlist2() async {
    final FirebaseUser user = await auth.currentUser();
    setState(() {
      userId = user.uid;
    });
    QuerySnapshot _myDoc1 = await Firestore.instance
        .collection('users')
        .where("id", isEqualTo: userId)
        .getDocuments();
   votedfor = List<String>.from(_myDoc1.documents[0].data['votedfor']);
    QuerySnapshot _myDoc2 =
        await Firestore.instance.collection('poll').getDocuments();

    for (int i = 0; i < _myDoc2.documents.length; i++)
     { if (_myDoc2.documents[i].data['creatorid'] != userId) {
        QuerySnapshot _myDoc3 = await Firestore.instance
            .collection('users')
            .where("id", isEqualTo: _myDoc2.documents[i].data['creatorid'])
            .getDocuments();
            print( _myDoc2.documents[i].data['creatorid']);
            print(_myDoc3.documents[0].data['credit'].toString());
        if (_myDoc3.documents[0].data['credit'] > 0) {
          if (votedfor.contains(_myDoc2.documents[i].data['id']) == false) {
            poll.add(Poll(
              id: _myDoc2.documents[i].data['id'],
              // vote: _myDoc2.documents[i].data['vote'],
              urlpic: List<String>.from(_myDoc2.documents[i].data['urlpic']),
              vote: List<double>.from(_myDoc2.documents[i].data['vote']),
              type: _myDoc2.documents[i].data['type'],
              creatorid: _myDoc2.documents[i].data['creatorid'],
            ));
          }
        }
      }}
    
    setState(() {
      poll = poll;
      vare = poll.length;
      print(vare);
    });
  }

  
  void initState() {
    super.initState();
    credit();
    prodlist2();
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
              Card(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                    Container(
                      child: Text(
                        'Your credit is :' + creditUser.toString(),
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                    Container(
                      padding: EdgeInsets.all(16),
                      child: RaisedButton(
                          padding: EdgeInsets.fromLTRB(40, 15, 40, 15),
                          color: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadiusDirectional.circular(30),
                          ),
                          onPressed: () {
                            prodlist2();
                            setState(() {
                              vare = poll.length;
                              print(vare);
                            });
                            //  if (vare != 0) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ALLPollVote(poll)));
                            // }
                            /*  if (vare == 0) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("report"),
                                    content:
                                        Text("You can't vote there is no vote"),
                                  );
                                },
                              );
                            },
                        */
                          },
                          child: Text(
                            'Vote',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          )),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.2,
                    ),
                  ],
                ),
                elevation: 20,
                shape: BeveledRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(150),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
