import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flashchat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class ChatScreen extends StatefulWidget {
  static String id= 'chat';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final msgcontrol = TextEditingController();
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  late User loggedinUser;
  late String messageText;

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp().whenComplete(() {
      print("completed");
      setState(() {});
    });
    getCurrentUser();
  }

  void getCurrentUser() async{
    try{
      final nowuser = await _auth.currentUser;
      if(nowuser != null){
        loggedinUser = nowuser;
        print(loggedinUser.email);
      }
    }
    catch(e){
      print(e);
    }
  }

  void messageStream() async{
    await for (var snap in _firestore.collection('messages').orderBy('timestamp').snapshots()){
      for ( var msg in snap.docs){
        print(msg.data());
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: [
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                // _auth.signOut();
                // Navigator.pop(context);
                messageStream();
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(
              height: 15,
            ),
            Expanded(
              child: StreamBuilder(
                stream: _firestore.collection('messages').orderBy('timestamp').snapshots(),
                builder: (context,snapshot){
                  if(snapshot.connectionState == ConnectionState.waiting){
                    // (snapshot.hasData)
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  else{
                    Widget space = Expanded(child: SizedBox());
                    final currentId = loggedinUser.email;
                    bool flag= true;
                    final messages = snapshot.data!.docs;
                    return ListView.builder(
                      reverse: true,
                        itemCount: messages.length,
                        itemBuilder: (context,index){
                          if(currentId==messages[messages.length-1-index]['sender']){
                            flag=true;
                            space = Expanded(child: SizedBox());
                            print(index);
                            print("length: ${messages.length}");
                          }
                          else{
                            flag=false;
                            space = SizedBox();
                          }
                          return ListTile(
                            // contentPadding: EdgeInsets.only(right: 100,left: 2),
                            subtitle:  Row(
                              children: [
                                space,
                                Container(
                                  constraints: BoxConstraints(
                                    maxWidth: 270, // set the maximum width to 500 pixels
                                  ),
                                  padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                                  child: Text(
                                    messages[messages.length-1-index]['text'],
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: flag? Colors.white:Colors.blueAccent,

                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    color: flag? Colors.blueAccent: Colors.white,
                                    borderRadius: flag? BorderRadius.only(topLeft: Radius.circular(30),bottomRight: Radius.circular(30),bottomLeft: Radius.circular(30)):BorderRadius.only(topRight: Radius.circular(30),bottomRight: Radius.circular(30),bottomLeft: Radius.circular(30)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                        offset: Offset(0, 3), // changes position of shadow
                                      ),
                                    ],
                                  ),


                                ),
                              ],
                            ),
                            title: Row(
                              children: [
                                space,
                                Text(
                                    messages[messages.length-1-index]['sender'],
                                style: TextStyle(
                                  color: Colors.grey.withOpacity(0.7),
                                  fontSize: 12,
                                  
                                ),
                                ),
                              ],
                            ),
                          );
                        });
                  }
                },

              ),
            ),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextField(
                      controller: msgcontrol,
                      onChanged: (value) {
                        messageText = value ;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      msgcontrol.clear();
                      _firestore.collection('messages').add({
                        'text': messageText ,
                        'sender': loggedinUser.email ,
                        'timestamp': DateTime.now(),
                      });
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),


          ],
        ),
      ),
    );
  }
}