import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:swipedetector/swipedetector.dart';
import 'package:vote/Service/dbservice.dart';

// ignore: must_be_immutable
class PollVote extends StatefulWidget {
 String text, something;
  // PollVote(this.pathup,this.pathdown);
  PollVote(this.something, this.text);
  @override
  State<StatefulWidget> createState() {
    // return PollVoteState(this.pathup,this.pathdown);
    return PollVoteState(this.something, this.text);
  }
}

class PollVoteState extends State<PollVote> {

  String  something, text;
  Db db = new Db();
  PollVoteState(this.something, this.text);
  // PollVoteState(this.pathup,this.pathdown);
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool up = false, down = false;
  String userId;
  List<dynamic> picPoll;
  List<double> picCont = [0, 0];
  String urlUp, urlDown;
  String textUp, textDown;
  double voteup = 0, votedown = 0;
  double position, position2;

  Future prodlist2() async {
    final FirebaseUser user = await auth.currentUser();
    userId = user.uid;
    QuerySnapshot _myDoc2 = await Firestore.instance
        .collection('poll')
        .where("id", isEqualTo: something)
        .getDocuments();
    if (text == 'pic') {
      picPoll = _myDoc2.documents[0].data['urlpic'];
      var up = FirebaseStorage.instance.ref().child(picPoll[0]);
      var urlup = await up.getDownloadURL();
      urlUp = urlup.toString();
      print(urlUp);
      print(urlDown);
      var down = FirebaseStorage.instance.ref().child(picPoll[1]);
      var urldown = await down.getDownloadURL();
      urlDown = urldown.toString();
      //  urlUp = await _reference.child(picPoll[0]).getDownloadURL();
//urlDown = await _reference.child(picPoll[1]).getDownloadURL();
      setState(() {
        urlUp = urlUp;
        urlDown = urlDown;
      });
    } else {
      picPoll = _myDoc2.documents[0].data['urlpic'];
      textUp = picPoll[0].toString();
      textDown = picPoll[1].toString();
      setState(() {
        textUp = textUp;
        textDown = textDown;
        picPoll = picPoll;
      });
    }
  }

 

  @override
  void initState() {
    super.initState();
    prodlist2();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      appBar: AppBar(
//        title: Text('Sign In'),
//      ),
      body: Column(
        children: [
          if (text == 'pic')
            ((urlUp != null) && (urlDown != null))
                ? SwipeDetector(
                    onSwipeUp: () {
                      voteup++;
                      setState(() {
                        voteup = voteup;
                        picCont.removeAt(0);
                        picCont.insert(0, voteup);
                      });
                      db.updatePoll(
                        id: something,
                        vote: picCont,
                      );
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
                    },
                    onSwipeDown: () {
                      votedown++;
                      setState(() {
                        votedown = votedown;
                        picCont.removeAt(1);
                        picCont.insert(1, votedown);
                      });
                      db.updatePoll(
                        id: something,
                        vote: picCont,
                      );
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
                    },
                    child: Column(
                      children: [
                        GestureDetector(
                          /*  onTap: () => {
                            voteup++,
                            setState(() {
                              voteup = voteup;
                              picCont.removeAt(0);
                              picCont.insert(0, voteup);
                            }),
                            db.updatePoll(
                              id: something,
                              vote: picCont,
                            ),
                          },*/
                          child: Container(
                              height: MediaQuery.of(context).size.height / 2,
                              width: MediaQuery.of(context).size.width,
                              child: Image.network(
                                urlUp,
                              )),
                        ),
                        GestureDetector(
                          /* onTap: () => {
                            votedown++,
                            setState(() {
                              votedown = votedown;
                              picCont.removeAt(1);
                              picCont.insert(1, votedown);
                            }),
                            db.updatePoll(
                              id: something,
                              vote: picCont,
                            ),
                          },*/
                          child: Container(
                            height: MediaQuery.of(context).size.height / 2,
                            width: MediaQuery.of(context).size.width,
                            child: Image.network(
                              urlDown,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.only(top: 40.0),
                    child: Center(child: CircularProgressIndicator()),
                  ),

          if (text == 'text')

            /* SwipeDetector(
            onSwipeDown: (){
 print('shiiiiiiiiiiiiit');
            },
            child: Column(
              children: [
                SwipeDetector(
                  onSwipeDown: (){
 print('shiiiiiiiiiiiiit');
            },
                                    child: Container(
                      alignment: Alignment.center,
                      height: MediaQuery.of(context).size.height / 2,
                      width: MediaQuery.of(context).size.width,
                      child: Text(textUp),
                    ),
                 ),
                 
               
              
               Container(
                    alignment: Alignment.center,
                    height: MediaQuery.of(context).size.height / 2,
                    width: MediaQuery.of(context).size.width,
                    child: Text(textDown),
                  ),
                 
             
              ],
            ),
          ),*/
            //  GestureDetector(
            /* onVerticalDragUpdate: (DragUpdateDetails details) {
            position =
                MediaQuery.of(context).size.height - details.globalPosition.dy;
                  position2 =
                MediaQuery.of(context).size.height/2 + details.globalPosition.dy;
            if (!position.isNegative && position < 240)
             {
                 setState(() {
                      down=true;
                      });
             }
            

                if (!position2.isNegative && position2 < 240)
             print('downnnnnnnnn');
             // controller.add(position);
            
          },
          onVerticalDragEnd: (details) {
           // controller.add(MediaQuery.of(context).size.height * 0.12);
            print('hhhhhhhhhhhhhhhhhhh');
            if(down==true){
                votedown++;
                      setState(() {
                        votedown = votedown;
                        picCont.removeAt(1);
                        picCont.insert(1, votedown);
                      });
                      db.updatePoll(
                        id: something,
                        vote: picCont,
                      );

            }
          },*/
            /* onPanUpdate: (details) {
                if (details.delta.dy > 0) {
                 print("down");
                }
                if (details.delta.dy < 0) {              
                      print("up");
                }
              },
              child:*/
            SwipeDetector(
              onSwipeUp: () {
                voteup++;
                setState(() {
                  voteup = voteup;
                  picCont.removeAt(0);
                  picCont.insert(0, voteup);
                });
                db.updatePoll(
                  id: something,
                  vote: picCont,
                );
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
              },
              onSwipeDown: () {
                votedown++;
                setState(() {
                  votedown = votedown;
                  picCont.removeAt(1);
                  picCont.insert(1, votedown);
                });
                db.updatePoll(
                  id: something,
                  vote: picCont,
                );
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
              },
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    GestureDetector(
                      child: Container(
                        color: Colors.blueAccent,
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.height / 2,
                        width: MediaQuery.of(context).size.width,
                        child: Text(textUp),
                      ),
                    ),
                    GestureDetector(
                      child: Container(
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.height / 2,
                        width: MediaQuery.of(context).size.width,
                        child: Text(textDown),
                      ),
                      onTap: () => {},
                    ),
                  ],
                ),
              ),
            ),
          //  showImageup(),

          //   showImagedown(),

          /*  Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RaisedButton(
                child: Container(
                  height: 40,
                  width: 20,
                  child: Icon(
                    Icons.check_box,
                    color: Colors.black,
                    size: 25.0,
                  ),
                ),
                onPressed: () {
                 db.addPoll(
                   id:id.toHexString() ,
                   creatorid: userId,
                   urlpic: picPoll,
                   vote: picCont,
                 );
                 uploadPic(id.toHexString(),  pathdown, filedown);
                  uploadPic(id.toHexString(), pathup, fileup);
                },
              ),
            ],
          )*/
          //  ),
        ],
      ),
    );
    /* return Scaffold(
      body: ListView(
        children: <Widget>[
          StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance
                .collection('poll')
                .where("id", isEqualTo: something)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.lightBlueAccent,
                  ),
                );
              }
              final posts = snapshot.data.documents;
              List<Widget> postWidgets = [];
              for (var post in posts) {
              
                picPoll = post.data['urlpic'];
                testFunction(picPoll[0]);
                testFunction2(picPoll[1]);
                final postWidget =  Column(
                    children: <Widget>[
                      

                      GestureDetector(
                                              child: Container(
                            height: MediaQuery.of(context).size.height / 2,
                            width: MediaQuery.of(context).size.width,
                            child: Image.network(
                              '$_downloadURL',
                              fit: BoxFit.fill,
                            )),
                      ),
                      GestureDetector(
                                              child: Container(
                          height: MediaQuery.of(context).size.height / 2,
                          width: MediaQuery.of(context).size.width,
                          child: Image.network(
                            '$_downloadURL2',
                            fit: BoxFit.fill,
                          ),
                        ),
                      )
                    ],
                  );
                
                postWidgets.add(postWidget);
              }
              return Column(
                children: postWidgets,
              );
            },
          ),
        ],
      ),
    );*/
  }
}
