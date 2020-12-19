import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crossplat_objectid/crossplat_objectid.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vote/Service/dbservice.dart';

import 'HomePage.dart';

class TextPoll extends StatefulWidget {
  @override
  _TextPollState createState() => _TextPollState();
}

class _TextPollState extends State<TextPoll> {
  String userId;
  int ids = 1;
  Db db = new Db();
  ObjectId id = ObjectId();
  List<String> picPoll;
  List<dynamic> picPoll2;
  List<double> picCont = [0, 0];
  List<String> votedfor;
  int creditUser = 0;
  double voteup = 0, votedown = 0;
  String pathup, pathdown, radioButtonItem = 'Up';
  final FirebaseAuth auth = FirebaseAuth.instance;
  final TextEditingController pollup = TextEditingController();
  final TextEditingController polldown = TextEditingController();
  users() async {
    final FirebaseUser user = await auth.currentUser();
    setState(() {
      userId = user.uid;
    });
  }

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
    if (_myDoc1.documents[0].data['votedfor'] != null) {
      votedfor = List<String>.from(_myDoc1.documents[0].data['votedfor']);
    }
    setState(() {
      votedfor = votedfor;
      creditUser = creditUser;
      print(creditUser);
    });
  }

  void initState() {
    super.initState();

    users();
    credit();
  }

  Widget radio() {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Text(
                'Vote:',
              ),
            ),
            Radio(
              activeColor: Colors.black,
              value: 1,
              groupValue: ids,
              onChanged: (val) {
                setState(() {
                  picCont = [1, 0];
                  voteup = 1;
                  radioButtonItem = 'Up';
                  ids = 1;
                });
              },
            ),
            Text(
              'Up',
            ),
            Radio(
              activeColor: Colors.black,
              value: 2,
              groupValue: ids,
              onChanged: (val) {
                setState(() {
                  picCont = [0, 1];
                  votedown = 1;
                  radioButtonItem = 'Down';
                  ids = 2;
                });
              },
            ),
            Text(
              'Down',
            ),
          ],
        ),
      ],
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
//      appBar: AppBar(
//        title: Text('Sign In'),
//      ),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            Container(
              color: Colors.blue,
              height: MediaQuery.of(context).size.height / 2.1,
              width: MediaQuery.of(context).size.width ,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  alignment: Alignment.centerLeft,
                  height: 60.0,
                  child: TextField(
                    // initialValue: b,
                    controller: pollup,
                    keyboardType: TextInputType.text,
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'OpenSans',
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(top: 14.0),
                      //prefixIcon: icon,
                      hintText: 'Enter text',
                    ),
                  ),
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height / 2.1,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  alignment: Alignment.centerLeft,
                  height: 60.0,
                  child: TextField(
                    // initialValue: b,
                    controller: polldown,
                    keyboardType: TextInputType.text,
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'OpenSans',
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(top: 14.0),
                      //prefixIcon: icon,
                      hintText: 'Enter text',
                    ),
                  ),
                ),
              ),
            ),
            //  radio(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () async => {
                    if (votedfor == null)
                      {
                        votedfor = [id.toHexString()],
                      }
                    else
                      {
                        votedfor.add(id.toHexString()),
                      },
                    setState(() {
                      picPoll = [pollup.text.toString()];
                      picPoll.add(polldown.text.toString());
                    }),
                    db.addPoll(
                      id: id.toHexString(),
                      creatorid: userId,
                      urlpic: picPoll,
                      vote: picCont,
                      type: 'text',
                    ),
                  /*  db.updateUser2(
                        id: userId, credit: creditUser , votedfor: votedfor),*/
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomeView())),
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Poll"),
                          content: Text("Your poll is uploaded"),
                        );
                      },
                    ),
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0)),
                    child: Padding(
                      padding: EdgeInsets.all(2.0),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.check_box,
                            color: Colors.black,
                            size: 25.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
