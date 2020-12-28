import 'package:chat_app/Chat/message_bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'message_bubble.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseAuth.instance.currentUser(),
        builder: (ctx, futuresnap) {
          if (futuresnap.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return StreamBuilder(
              stream: Firestore.instance
                  .collection('chat')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (ctx, snap) {
                if (snap.connectionState == ConnectionState.waiting)
                  return Center(
                    child: CircularProgressIndicator(),
                  );

                final chatdoc = snap.data.documents;
                return ListView.builder(
                    reverse: true,
                    itemCount: chatdoc.length,
                    itemBuilder: (ctx, idx) {
                      return MessageBubble(
                        chatdoc[idx]['text'],
                        chatdoc[idx]['username'],
                        chatdoc[idx]['userimage'],
                        chatdoc[idx]['userId'] == futuresnap.data.uid,
                        key: ValueKey(chatdoc[idx].documentID),
                      );
                    });
              });
        });
  }
}
