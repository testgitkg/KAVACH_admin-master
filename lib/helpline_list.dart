import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HelplineList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              color: Color(0xFF4C2659),
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.05,
              left: 15,
              right: 0,
              child: Text(
                'Helplines',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.12,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.89,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection('helplines').snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }

                      final helplines = snapshot.data!.docs;

                      return ListView.builder(
                        itemCount: helplines.length,
                        itemBuilder: (context, index) {
                          final helpline = helplines[index].data() as Map<String, dynamic>;
                          return Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Container(
                              height: 90,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Center(
                                child: ListTile(
                                  leading: Image(image: AssetImage("assets/helpline.png")), // Icon
                                  title: Text(helpline['title']),
                                  subtitle: Text(helpline['description']),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF4C2559),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                MediaQuery.of(context).size.width *
                    0.04),
          ),
          minimumSize: Size(
            MediaQuery.of(context).size.width * 0.30,
            MediaQuery.of(context).size.height * 0.06,
          ),
        ),
        onPressed: () {
          _showDeleteDialog(context);
        },
        child: Text("Delete",style: TextStyle(color: Colors.white),),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Choose Helpline"),
          content: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('helplines').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }

              final helplines = snapshot.data!.docs;
              return SingleChildScrollView(
                child: Column(
                  children: helplines.map((DocumentSnapshot document) {
                    final helpline = document.data() as Map<String, dynamic>;
                    return ListTile(
                      title: Text(helpline['description']),
                      onTap: () {
                        _showConfirmationDialog(context, document.id, helpline['description']);
                       // Navigator.pop(context);
                      },
                    );
                  }).toList(),
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _showConfirmationDialog(BuildContext context, String documentId, String helplineDescription) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Deletion"),
          content: Text("Are you sure you want to delete the helpline with description: $helplineDescription?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                _deleteHelpline(documentId);
                Navigator.of(context).pop();
                _showSuccessMessage(context);
              },
              child: Text("Yes"),
            ),
          ],
        );
      },
    );
  }

  void _deleteHelpline(String documentId) {
    FirebaseFirestore.instance.collection('helplines').doc(documentId).delete();
  }

  void _showSuccessMessage(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Success"),
          content: Text("Helpline deleted successfully!"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }
}

