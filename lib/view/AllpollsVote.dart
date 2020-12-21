import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vote/Model/poll.dart';
import 'package:vote/Service/dbservice.dart';
import 'package:vote/view/widgetVote.dart';

// ignore: must_be_immutable
class ALLPollVote extends StatefulWidget {
  List<Poll> somethings;
  // PollVote(this.pathup,this.pathdown);
  ALLPollVote(this.somethings);
  @override
  State<StatefulWidget> createState() {
    // return PollVoteState(this.pathup,this.pathdown);
    return ALLPollVoteState(this.somethings);
  }
}

class ALLPollVoteState extends State<ALLPollVote> {
  int something;
  int vare;
  Db db = new Db();
  List<Poll> poll = [];
  List<String> votedfor;
  List<double> vote = [];
  List<Poll> somethings;
  ALLPollVoteState(this.somethings);
  String userId = '';

  final FirebaseAuth auth = FirebaseAuth.instance;
  PageController _controller = PageController(
    initialPage: 0,
  );
  void initState() {
    super.initState();
    vare=somethings.length;
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body: PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: _controller,
          children: [
           
            if (vare != 0)
                WidgetVote(somethings.first, somethings),
                 if (vare == 0)
              AlertDialog(
                title: Text("report"),
                content: Text("You can't vote there is no vote"),
              ),
          ],       
      ),
    );
  }
}
