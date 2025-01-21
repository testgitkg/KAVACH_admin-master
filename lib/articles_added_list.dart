

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ArticleChaptersScreen extends StatefulWidget {
  @override
  _ArticleChaptersScreenState createState() => _ArticleChaptersScreenState();
}

class _ArticleChaptersScreenState extends State<ArticleChaptersScreen> {
  late StreamController<List<ArticleChapter>> _controller;
  late Stream<List<ArticleChapter>> _stream;

  @override
  void initState() {
    super.initState();
    _controller = StreamController<List<ArticleChapter>>();
    _stream = _controller.stream;
    fetchArticles();
  }

  void fetchArticles() async {
    // Load default articles
    // List<ArticleChapter> defaultArticles = [
    //   ArticleChapter(
    //     name: 'Default Article 1',
    //     imageUrl: 'assets/images/protection.png',
    //     description: "Women's awareness begins with understanding their legal rights.",
    //   ),
    //   ArticleChapter(
    //     name: 'Default Article 2',
    //     imageUrl: 'assets/images/protection.png',
    //     description: 'Description for Default Article 2',
    //   ),
    // ];

    // Fetch articles from Firestore
    List<ArticleChapter> firestoreArticles = await getArticlesFromFirestore();

    // Merge default articles with articles from Firestore
    List<ArticleChapter> articles = [];
    //articles.addAll(defaultArticles);
    articles.addAll(firestoreArticles);

    // Add the merged list of articles to the stream
    _controller.add(articles);
  }

  Future<List<ArticleChapter>> getArticlesFromFirestore() async {
    QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance.collection('articles').get();
    List<ArticleChapter> articles = [];
    querySnapshot.docs.forEach((doc) {
      articles.add(ArticleChapter(
        name: doc['name'],
        imageUrl: doc['imageUrl'],
        description: doc['description'],
        docId: doc.id, // Storing document ID for deletion
      ));
    });
    return articles;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Article Chapters'),
        backgroundColor: Color(0xFF4C2559),
      ),
      body: StreamBuilder<List<ArticleChapter>>(
        stream: _stream,
        builder: (BuildContext context, AsyncSnapshot<List<ArticleChapter>> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          List<ArticleChapter> articles = snapshot.data ?? [];

          return ListView.builder(
            itemCount: articles.length,
            itemBuilder: (BuildContext context, int index) {
              ArticleChapter chapter = articles[index];
              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                  height: 90,
                  width: 350,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.grey.shade100,
                  ),
                  child: Center(
                    child: ListTile(
                      title: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          chapter.name,
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                        ),
                      ),
                      leading: Icon(Icons.bookmark_add_sharp),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ArticleDescriptionScreen(chapter: chapter),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF4C2559),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                MediaQuery.of(context).size.width * 0.04),
          ),
          minimumSize: Size(
            MediaQuery.of(context).size.width * 0.20,
            MediaQuery.of(context).size.height * 0.06,
          ),
        ),
        onPressed: () {
          showDeleteArticleDialog();
        },
        child: Text("Delete",style: TextStyle(color: Colors.white),),
      ),
    );
  }

  void showDeleteArticleDialog() async {
    List<ArticleChapter> articles = await getArticlesFromFirestore();
    List<PopupMenuItem<String>> choices = articles
        .map((article) => PopupMenuItem<String>(
      value: article.docId!,
      child: Text(article.name),
    ))
        .toList();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Choose Article to Delete"),
          content: SingleChildScrollView(
            child: ListBody(
              children: choices,
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF4C2559),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      MediaQuery.of(context).size.width * 0.04),
                ),
              ),
              child: Text('Cancel',style: TextStyle(color: Colors.white),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    ).then((selectedDocId) {
      if (selectedDocId != null) {
        showConfirmationDialog(selectedDocId);
      }
    });
  }

  void showConfirmationDialog(String docId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Deletion"),
          content: Text("Are you sure you want to delete this article?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                deleteArticle(docId);
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteArticle(String docId) async {
    try {
      await FirebaseFirestore.instance.collection('articles').doc(docId).delete();
      fetchArticles(); // Refresh articles list after deletion
      Navigator.of(context).pop(); // Close the confirmation dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Success"),
            content: Text("Article deleted successfully."),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the success dialog
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete article.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }
}

class ArticleDescriptionScreen extends StatelessWidget {
  final ArticleChapter chapter;

  const ArticleDescriptionScreen({required this.chapter});

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
                'Discription Articles',
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
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Center(
                          child: Container(
                            height: 150,width: 150,
                            child: Image.asset("assets/protection.png"),
                          ),
                        ),
                        SizedBox(height: 30,),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15,right: 15,top: 15),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(chapter.name,style:TextStyle(fontWeight: FontWeight.bold,fontSize: 22,color: Color(0xFF4C2559)),),
                                Padding(
                                  padding: const EdgeInsets.only(left: 15,right: 15,top: 15),
                                  child: Text(chapter.description,
                                    style: TextStyle(color: Color(0xFF4C2559),fontSize: 17),
                                  ),
                                ),
                                SizedBox(height: 30,),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                ),
              ),
            )
          ],
        ),
      ),

    );
  }
}

class ArticleChapter {
  final String name;
  final String imageUrl;
  final String description;
  final String? docId; // Document ID in Firestore

  ArticleChapter({
    required this.name,
    required this.imageUrl,
    required this.description,
    this.docId,
  });
}

void main() {
  runApp(MaterialApp(
    home: ArticleChaptersScreen(),
  ));
}


