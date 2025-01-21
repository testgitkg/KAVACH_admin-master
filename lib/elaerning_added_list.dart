import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kavach_admin/ytPlayer.dart';

class VideoList extends StatelessWidget {
  const VideoList({Key? key});

  // Function to delete video from Firestore
  Future<void> deleteVideo(BuildContext context, String videoId) async {
    await FirebaseFirestore.instance.collection('elearning').doc(videoId).delete();
    // Show success message
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Success"),
          content: Text("Video deleted successfully!"),
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
              top: MediaQuery.of(context).size.height *
                  0.05, // Adjust position as needed
              left: 15,
              right: 0,
              child: Text(
                'Chapters of E-Learning',
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
                  height: MediaQuery.of(context).size.height * 0.88,
                  child: Center(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('elearning')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        } else if (snapshot.hasData) {
                          // Display fetched data
                          List<DocumentSnapshot> videos = snapshot.data!.docs;
                          return ListView.builder(
                            itemCount: videos.length,
                            itemBuilder: (context, index) {
                              Map<String, dynamic> videoData =
                              videos[index].data() as Map<String, dynamic>;

                              String videoId = videos[index].id;
                              String videoUrl = videoData['link'] ?? '';

                              return Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.grey.shade100,
                                      borderRadius: BorderRadius.circular(15)),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: Colors.black,
                                      backgroundImage:
                                      AssetImage('assets/activist.png'), // Provide the path to your image
                                    ),
                                    title: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${videoData['name']}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17,
                                              color: Color(0xFF4C2559)),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          '$videoUrl',
                                          style: TextStyle(fontSize: 13),
                                        ),
                                      ],
                                    ),
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text("Confirmation"),
                                            content: Text("Are you sure you want to delete this video?"),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text("Cancel"),
                                              ),
                                              TextButton(
                                                onPressed: () async {
                                                  // Delete video from Firestore
                                                  await deleteVideo(context, videoId);
                                                  Navigator.of(context).popUntil((route) => route.isFirst);
                                                  // Show success message
                                                  showDialog(
                                                    context: context,
                                                    builder: (BuildContext context) {
                                                      return AlertDialog(
                                                        title: Text("Success"),
                                                        content: Text("Video deleted successfully!"),
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
                                                },
                                                child: Text("Delete"),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                              );
                            },
                          );
                        } else {
                          return Center(child: Text('No data available'));
                        }
                      },
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF4C2559),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Select Video to Delete"),
                content: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('elearning').snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasData) {
                      List<DocumentSnapshot> documents = snapshot.data!.docs;
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: documents.map((doc) {
                          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                          return Card(
                            child: ListTile(
                              title: Text(data['name']),
                              onTap: () {
                                // Delete video from Firestore
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("Confirmation"),
                                      content: Text("Are you sure you want to delete this video?"),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text("Cancel"),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            // Delete video from Firestore
                                            await deleteVideo(context, doc.id);
                                            Navigator.of(context).pop();
                                            // Show success message
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text("Success"),
                                                  content: Text("Video deleted successfully!"),
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
                                          },
                                          child: Text("Delete"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          );
                        }).toList(),
                      );
                    }
                    return SizedBox();
                  },
                ),

              );
            },
          );
        },
        child: Text(
          "Delete",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: VideoList(),
  ));
}
