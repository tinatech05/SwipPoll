import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:swipedetector/swipedetector.dart';
import 'package:vote/Model/poll.dart';
import 'package:vote/Service/dbservice.dart';
import 'package:vote/view/AllpollsVote.dart';
import 'package:vote/view/HomePage.dart';

// ignore: must_be_immutable
class WidgetVote extends StatefulWidget {
  Poll something;
  List<Poll> somethings;
  // WidgetVote(this.pathup,this.pathdown);
  WidgetVote(this.something, this.somethings);
  @override
  State<StatefulWidget> createState() {
    // return WidgetVoteState(this.pathup,this.pathdown);
    return WidgetVoteState(this.something, this.somethings);
  }
}

class WidgetVoteState extends State<WidgetVote> {
  List<Poll> somethings;
  Poll something;
  Db db = new Db();
  WidgetVoteState(this.something, this.somethings);
  // PollVoteState(this.pathup,this.pathdown);
  final FirebaseAuth auth = FirebaseAuth.instance;
  String userId;
  bool existe = false;
  String creatorId;
  List<dynamic> picPoll;
  List<String> votedfor;
  List<double> picCont;
  String urlUp, urlDown;
  double voteup = 0, votedown = 0;
  String textUp, textDown;
  double initup = 0, initdown = 0;
  int creditUser, creditCreator;
  int newcredit;
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
    QuerySnapshot _myDoc2 = await Firestore.instance
        .collection('users')
        .where("id", isEqualTo: creatorId)
        .getDocuments();
    votedfor = List<String>.from(_myDoc1.documents[0].data['votedfor']);
    if (votedfor.contains(something.id)) {
      existe = true;
    }

    creditCreator = _myDoc2.documents[0].data['credit'];
    print(existe);
    print('creditCreator');
    setState(() {
      votedfor = votedfor;
      existe = existe;
      creditUser = creditUser;
      creditCreator = creditCreator;
    });
  }

  Future prodlist2() async {
    if (something.type == 'pic') {
      picPoll = something.urlpic;
      var up = FirebaseStorage.instance.ref().child(picPoll[0]);
      var urlup = await up.getDownloadURL();
      urlUp = urlup.toString();
      var down = FirebaseStorage.instance.ref().child(picPoll[1]);
      var urldown = await down.getDownloadURL();
      urlDown = urldown.toString();
      //  urlUp = await _reference.child(picPoll[0]).getDownloadURL();
//urlDown = await _reference.child(picPoll[1]).getDownloadURL();
      picCont = something.vote;
      setState(() {
        urlUp = urlUp;
        urlDown = urlDown;
        picCont = picCont;
        initdown = picCont[1];
        initup = picCont[0];
        creatorId = something.creatorid;
      });
    } else {
      picCont = something.vote;
      picPoll = something.urlpic;
      textUp = picPoll[0].toString();
      textDown = picPoll[1].toString();
      setState(() {
        textUp = textUp;
        textDown = textDown;
        picPoll = picPoll;
        picCont = picCont;
        initdown = picCont[1];
        initup = picCont[0];
        creatorId = something.creatorid;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    prodlist2();
    users();
    credit();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () async => {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("report"),
                      content: Text("You reported the content of the poll"),
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
                        Icons.report,
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
        if (something.type == 'pic')
          ((urlUp != null) && (urlDown != null))
              ? SwipeDetector(
                  onSwipeUp: () {
                    setState(() {
                      picCont[0] = picCont[0] + 1;
                    });
                    if (existe == false) {
                      db.updatePoll(
                        id: something.id,
                        vote: picCont,
                      );
                      if (votedfor == null) {
                        votedfor = [something.id];
                      } else {
                        votedfor.add(something.id);
                      }
                      db.updateUser2(
                          id: userId,
                          credit: creditUser + 1,
                          votedfor: votedfor);
                      if (creditCreator > 0) {
                        setState(() {
                          newcredit = creditCreator - 1;
                        });
                      } else {
                        setState(() {
                          newcredit = creditCreator;
                        });
                      }
                      db.updateUser(id: creatorId, credit: newcredit);
                      setState(() {
                        somethings.remove(somethings.first);
                      });

                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ALLPollVote(somethings)),
                          ModalRoute.withName("/home"));
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Poll"),
                            content: Text("UP :" +
                                picCont[0].toString() +
                                '     ' +
                                "Down :" +
                                picCont[1].toString()),
                          );
                        },
                      );
                    } else {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => HomeView()));
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Poll"),
                            content: Text('The End'),
                          );
                        },
                      );
                    }
                  },
                  onSwipeDown: () {
                    votedown++;
                    setState(() {
                      picCont[1] = picCont[1] + 1;
                    });
                    if (existe == false) {
                      setState(() {
                        existe = true;
                      });
                      db.updatePoll(
                        id: something.id,
                        vote: picCont,
                      );
                      if (votedfor == null) {
                        votedfor = [something.id];
                      } else {
                        votedfor.add(something.id);
                      }
                      db.updateUser2(
                          id: userId,
                          credit: creditUser + 1,
                          votedfor: votedfor);
                      if (creditCreator > 0) {
                        setState(() {
                          newcredit = creditCreator - 1;
                        });
                      } else {
                        setState(() {
                          newcredit = creditCreator;
                        });
                      }
                      db.updateUser(id: creatorId, credit: newcredit);
                      setState(() {
                        somethings.remove(somethings.first);
                      });

                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ALLPollVote(somethings)),
                          ModalRoute.withName("/home"));
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Poll"),
                            content: Text("UP :" +
                                picCont[0].toString() +
                                '     ' +
                                "Down :" +
                                picCont[1].toString()),
                          );
                        },
                      );
                    } else {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => HomeView()));
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Poll"),
                            content: Text('The End'),
                          );
                        },
                      );
                    }
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width - 20,
                    child: Column(
                      children: [
                        GestureDetector(
                          child: Container(
                              height: MediaQuery.of(context).size.height / 2.1,
                              width: MediaQuery.of(context).size.width,
                              child: Image.network(
                                urlUp,
                                fit: BoxFit.fill,
                              )),
                        ),
                        GestureDetector(
                          child: Container(
                            height: MediaQuery.of(context).size.height / 2.1,
                            width: MediaQuery.of(context).size.width,
                            child: Image.network(
                              urlDown,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: Center(child: CircularProgressIndicator()),
                ),
        if (something.type == 'text')
          Container(
            width: MediaQuery.of(context).size.width - 20,
            child: SwipeDetector(
              onSwipeUp: () {
                setState(() {
                  picCont[0] = picCont[0] + 1;
                });
                if (existe == false) {
                  setState(() {
                    existe = true;
                  });
                  db.updatePoll(
                    id: something.id,
                    vote: picCont,
                  );
                  if (votedfor == null) {
                    votedfor = [something.id];
                  } else {
                    votedfor.add(something.id);
                  }
                  db.updateUser2(
                      id: userId, credit: creditUser + 1, votedfor: votedfor);
                  if (creditCreator > 0) {
                    setState(() {
                      newcredit = creditCreator - 1;
                    });
                  } else {
                    setState(() {
                      newcredit = creditCreator;
                    });
                  }
                  db.updateUser(id: creatorId, credit: newcredit);
                  setState(() {
                    somethings.remove(somethings.first);
                  });

                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ALLPollVote(somethings)),
                      ModalRoute.withName("/home"));
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Poll"),
                        content: Text("UP :" +
                            picCont[0].toString() +
                            '     ' +
                            "Down :" +
                            picCont[1].toString()),
                      );
                    },
                  );
                } else {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomeView()));
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Poll"),
                        content: Text('The End'),
                      );
                    },
                  );
                }
              },
              onSwipeDown: () {
                votedown++;
                setState(() {
                  picCont[1] = picCont[1] + 1;
                });
                if (existe == false) {
                  setState(() {
                    existe = true;
                  });
                  db.updatePoll(
                    id: something.id,
                    vote: picCont,
                  );
                  if (votedfor == null) {
                    votedfor = [something.id];
                  } else {
                    votedfor.add(something.id);
                  }
                  db.updateUser2(
                      id: userId, credit: creditUser + 1, votedfor: votedfor);
                  if (creditCreator > 0) {
                    setState(() {
                      newcredit = creditCreator - 1;
                    });
                  } else {
                    setState(() {
                      newcredit = creditCreator;
                    });
                  }
                  db.updateUser(id: creatorId, credit: newcredit);
                  setState(() {
                    somethings.remove(somethings.first);
                  });

                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ALLPollVote(somethings)),
                      ModalRoute.withName("/home"));
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Poll"),
                        content: Text("UP :" +
                            picCont[0].toString() +
                            '     ' +
                            "Down :" +
                            picCont[1].toString()),
                      );
                    },
                  );
                } else {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomeView()));
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Poll"),
                        content: Text('The End'),
                      );
                    },
                  );
                }
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Container(
                      color: Colors.blueAccent,
                      alignment: Alignment.center,
                      height: MediaQuery.of(context).size.height / 2.1,
                      width: MediaQuery.of(context).size.width,
                      child: Text(textUp),
                    ),
                    Container(
                      alignment: Alignment.center,
                      height: MediaQuery.of(context).size.height / 2.1,
                      width: MediaQuery.of(context).size.width,
                      child: Text(textDown),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
