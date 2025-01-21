

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class user_feedback extends StatefulWidget {
  const user_feedback({Key? key}) : super(key: key);

  @override
  State<user_feedback> createState() => _user_feedbackState();
}

class _user_feedbackState extends State<user_feedback> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'User Feedback',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF4C2559),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('feedback').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No Feedback available.'));
          }

          return ListView(
            padding: EdgeInsets.all(16.0),
            children: snapshot.data!.docs.map((document) {
              var deliveryBoyData = document.data() as Map<String, dynamic>;

              String email = deliveryBoyData['email'];
              String feedback = deliveryBoyData['feedback'];

              return Container(
                child: Center(
                  child: Card(
                    margin: EdgeInsets.all(12),
                    elevation: 3.0,
                    child: ListTile(
                      leading: Icon(Icons.favorite_outlined),
                      title: Text(
                        'Email: $email',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Feedback: $feedback'),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
