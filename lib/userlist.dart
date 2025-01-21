import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UserListPage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void blockUser(BuildContext context, String userId, String firstName) {
    // Update user status in the database
    FirebaseFirestore.instance.collection('user_list').doc(userId).update({
      'blocked': true,
      // Assuming you have a field named 'blocked' to indicate blocked status
    }).then((_) {
      // Show toast notification
      Fluttertoast.showToast(
        msg: "$firstName is blocked",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      // Dismiss the dialog
      Navigator.of(context).pop();
    }).catchError((error) {
      // Show error toast notification if update fails
      Fluttertoast.showToast(
        msg: "Failed to block $firstName: $error",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    });
  }

  void unblockUser(BuildContext context, String userId, String firstName) {
    // Update user status in the database
    FirebaseFirestore.instance.collection('user_list').doc(userId).update({
      'blocked': false,
      // Assuming you have a field named 'blocked' to indicate blocked status
    }).then((_) {
      // Show toast notification
      Fluttertoast.showToast(
        msg: "$firstName is unblocked",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      // Dismiss the dialog
      Navigator.of(context).pop();
    }).catchError((error) {
      // Show error toast notification if update fails
      Fluttertoast.showToast(
        msg: "Failed to unblock $firstName: $error",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    });
  }

  void showBlockConfirmation(
      BuildContext context, String userId, String firstName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Block"),
          content: Text("Are you sure you want to Block this User?"),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF4C2559),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: Text(
                "No",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: Text(
                "Yes",
                style: TextStyle(color: Color(0xFF4C2559)),
              ),
              onPressed: () {
                blockUser(context, userId, firstName); // Block the user
              },
            ),
          ],
        );
      },
    );
  }

  void showUnblockConfirmation(
      BuildContext context, String userId, String firstName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Unblock"),
          content: Text("Are you sure you want to Unblock this User?"),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF4C2559),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: Text(
                "No",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: Text(
                "Yes",
                style: TextStyle(color: Color(0xFF4C2559)),
              ),
              onPressed: () {
                unblockUser(context, userId, firstName); // Unblock the user
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "User_List",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF4C2559),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: StreamBuilder<QuerySnapshot>(
          stream:
              FirebaseFirestore.instance.collection('user_list').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if (!snapshot.hasData || snapshot.data == null) {
              return Center(
                child: Text('No users found.'),
              );
            }

            return ListView(
              padding: EdgeInsets.all(9.0),
              children: snapshot.data!.docs.map((document) {
                var userData = document.data() as Map<String, dynamic>;

                String email = userData['email'] ?? '';
                String phone = userData['phone'] ?? '';
                String firstName = userData['firstname'] ?? '';
                String userId = document.id; // Extracting user ID

                if (userData['blocked'] ?? false) {
                  return Card(
                    margin: EdgeInsets.all(7),
                    elevation: 3.0,
                    color: Colors.red, // Red color for blocked users
                    child: ListTile(
                      title: Text(
                        'Email: $email',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('firstname: $firstName'),
                          Text('Phone: $phone'),
                        ],
                      ),
                      onTap: () {
                        showUnblockConfirmation(
                            context, userId, firstName); // Unblock the user
                      },
                    ),
                  );
                } else {
                  return Card(
                    margin: EdgeInsets.all(7),
                    elevation: 3.0,
                    child: ListTile(
                      title: Text(
                        'Email: $email',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('firstname: $firstName'),
                          Text('Phone: $phone'),
                        ],
                      ),
                      onTap: () {
                        showBlockConfirmation(
                            context, userId, firstName); // Block the user
                      },
                    ),
                  );
                }
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}
