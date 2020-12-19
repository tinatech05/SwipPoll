import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crossplat_objectid/crossplat_objectid.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:vote/Service/dbservice.dart';
import 'package:vote/view/HomePage.dart';

class AddNew extends StatefulWidget {
  @override
  _AddNewState createState() => _AddNewState();
}

class _AddNewState extends State<AddNew> {
  String userId;
  Db db = new Db();
  ObjectId up = ObjectId();
  ObjectId id = ObjectId();
  ObjectId down = ObjectId();
  final FirebaseAuth auth = FirebaseAuth.instance;
  int ids = 1;
  List<String> picPoll;
  List<String> votedfor;
  List<dynamic> picPoll2;
  List<double> picCont = [0, 0];
  File fileup;
  File filedown;
  int creditUser;
  double voteup = 0, votedown = 0;
  String pathup, pathdown, radioButtonItem = 'Up';
  pickImageFromGalleryup(ImageSource source) async {
    // ignore: deprecated_member_use
    var image1 = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      // ignore: deprecated_member_use
      fileup = image1;
      pathup = 'Poll/${up.toHexString()}' + '.jpg';
      picPoll = [pathup];
      print(fileup);
    });
  }

  pickImageFromGallerydown(ImageSource source) async {
    // ignore: deprecated_member_use
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    final FirebaseUser user = await auth.currentUser();
    userId = user.uid;

    setState(() {
      // ignore: deprecated_member_use
      filedown = image;

      pathdown = 'Poll/${down.toHexString()}' + '.jpg';
      picPoll.add(pathdown);
      userId = userId;
    });
  }

  uploadPic(id, String path, File file) {
    final StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(path);
    firebaseStorageRef.putFile(file);
  }

  users() async {
    final FirebaseUser user = await auth.currentUser();
    setState(() {
      userId = user.uid;
    });
  }

  credit() async {
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
              height: MediaQuery.of(context).size.height / 2.1,
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height / 2.8,
                    width: MediaQuery.of(context).size.width / 2,
                    child: (fileup != null)
                        ? Image.file(
                            fileup,
                            fit: BoxFit.fill,
                          )
                        : Text(''),
                  ),
                  //  showImageup(),
                  GestureDetector(
                    onTap: () async => {
                      pickImageFromGalleryup(ImageSource.gallery),
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0)),
                      child: Padding(
                        padding: EdgeInsets.all(2.0),
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.camera,
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
            ),
            Container(
              height: MediaQuery.of(context).size.height / 2.1,
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height / 2.8,
                    width: MediaQuery.of(context).size.width / 2,
                    child: (filedown != null)
                        ? Image.file(
                            filedown,
                            fit: BoxFit.fill,
                          )
                        : Text(''),
                  ),

                  //   showImagedown(),
                  GestureDetector(
                    onTap: () async => {
                      pickImageFromGallerydown(ImageSource.gallery),
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0)),
                      child: Padding(
                        padding: EdgeInsets.all(2.0),
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.camera,
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
            ),
            //   radio(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () async => {
                    if (pathdown != null && pathup != null)
                      {
                        db.addPoll(
                            id: id.toHexString(),
                            creatorid: userId,
                            urlpic: picPoll,
                            vote: picCont,
                            type: 'pic'),
                        if (votedfor == null)
                          {
                            votedfor = [id.toHexString()],
                          }
                        else
                          {
                            votedfor.add(id.toHexString()),
                          },
                        uploadPic(id.toHexString(), pathdown, filedown),
                        uploadPic(id.toHexString(), pathup, fileup),
                        /*   db.updateUser2(
                            id: userId,
                            credit: creditUser - 1,
                            votedfor: votedfor),*/
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Poll"),
                                content: Text('Your poll is uploaded'),
                              );
                            }),
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeView())),
                      }
                    else
                      {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Warning"),
                                content: Text("You have to pic 2 pic"),
                              );
                            }),
                      }
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
                            size: 35.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
