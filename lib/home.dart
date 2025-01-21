import 'package:flutter/cupertino.dart';
import 'package:kavach_admin/helpline_list.dart';
import 'package:kavach_admin/main.dart';
import 'package:kavach_admin/user_feedback.dart';
import 'package:kavach_admin/userlist.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'articles_added_list.dart';
import 'elaerning_added_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final linkController = TextEditingController();
  final nameController = TextEditingController();
  final  descriptionController = TextEditingController();


  void logoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Logout"),
          content: Text("Are you sure you want to logout?"),
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
                // backgroundColor: Colors.purple.shade50,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: Text(
                "Yes",
                style: TextStyle(color: Color(0xFF4C2559)),
              ),
              onPressed: () {
                logout(); // Call logout method if user chooses Yes
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MyApp())); // Dismiss the dialog
              },
            ),
          ],
        );
      },
    );
  }

  void _showAddArticleDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, setState) {
            return AlertDialog(
              title: Text('Add Article'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(),
                        ),
                        labelText: 'Article Name',
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: descriptionController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(),
                        ),
                        labelText: 'Article Description',
                      ),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Color(0xFF4C2559)),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF4C2559),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: () {
                    String name = nameController.text.trim();
                    String description = descriptionController.text.trim();

                    if (name.isEmpty || description.isEmpty) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Error'),
                            content: Text('Please fill in all fields.'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      addArticle();
                      Navigator.of(context).pop();
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Success'),
                            content: Text('Article added successfully.'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  child: Text(
                    'Add',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void addArticle() {
    String name = nameController.text.trim();
    String description = descriptionController.text.trim();

    // Add the article to Firestore
    FirebaseFirestore.instance.collection('articles').add({
      'name': name,
      'description': description,
      'imageUrl': 'assets/images/protection.png', // Assuming you have a default image for all articles
    });

    // Clear the text fields
    nameController.clear();
    descriptionController.clear();

    // Show a snackbar to indicate the article is added
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Article Added Successfully'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void logout() async {
    await FirebaseAuth.instance.signOut();
    //showToast("Logged out successfully");
    Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp()));
    // Navigate back to the login screen or any other screen as needed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
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
            child: Row(
              children: [
                Text(
                  'Home Page',
                  style: TextStyle(
                    fontSize: 21,
                    color: Colors.white,
                  ),
                ),
                Spacer(),
                PopupMenuButton<String>(
                  iconColor: Colors.white,
                  onSelected: (String choice) {
                    switch (choice) {
                      case 'Articles':
                        Navigator.push(context, MaterialPageRoute(builder: (Builder) => ArticleChaptersScreen()));
                        break;
                      case 'E-Learning':
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => VideoList()),
                        );
                        break;
                      case 'National Helpline':
                        Navigator.push(context, MaterialPageRoute(builder: (Builder) => HelplineList()));
                        break;
                      case 'User List':
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => UserListPage()),
                        );
                      case 'User Feedback':
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => user_feedback()),
                        );
                      case 'Log-out':
                        logoutConfirmation(context);
                        break;
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return [
                      PopupMenuItem<String>(
                        value: 'Articles',
                        child: Text('Articles'),
                      ),
                      PopupMenuItem<String>(
                        value: 'E-Learning',
                        child: Text('E-Learning'),
                      ),
                      PopupMenuItem<String>(
                        value: 'National Helpline',
                        child: Text('National Helpline'),
                      ),
                      PopupMenuItem<String>(
                        value: 'User List',
                        child: Text('User List'),
                      ),
                      PopupMenuItem<String>(
                        value: 'User Feedback',
                        child: Text('User Feedback'),
                      ),
                      PopupMenuItem<String>(
                        value: 'Log-out',
                        child: Text('Log-out'),
                      ),

                    ];
                  },
                ),

              ],
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.11,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: const EdgeInsets.only(right: 14),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child:
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Center(
                            child: Container(
                              height: 260,width: 260,
                              child: Image.asset("assets/images/6075327-removebg-preview.png"),
                            ),
                          ),
                          SizedBox(height: 30,),
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Welcome to kavach",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22,color: Color(0xFF4C2559)),),
                                Padding(
                                  padding: const EdgeInsets.only(left: 15,right: 15,top: 15),
                                  child: Text("Welcome to KAVACH , kavach is women safety app which follow the mechanism ' Your safety our priority ' kavach gives the functionality for sending the SOS alerts for your personal safety , you can also send the SMS via voice detection, it also include the E-learning for the awareness of the womens who does't have that much knowledge about such situations.",
                                    style: TextStyle(color: Color(0xFF4C2559)),
                                  ),
                                ),
                                SizedBox(height: 30,),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF4C2559),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          MediaQuery.of(context).size.width * 0.04),
                                    ),
                                    minimumSize: Size(
                                      MediaQuery.of(context).size.width * 0.50,
                                      MediaQuery.of(context).size.height * 0.07,
                                    ),
                                  ),
                                  onPressed: () {
                                    showModalBottomSheet(

                                      context: context,
                                      builder: (BuildContext context) {
                                        return Container(
                                          width: double.infinity,
                                          height: 190,
                                          child: Wrap(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.all(10.0),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children: <Widget>[
                                                    Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          showDialog(
                                                            context: context,
                                                            builder: (BuildContext context) {
                                                              String title = '';
                                                              String description = '';

                                                              return StatefulBuilder(
                                                                builder: (context, setState) {
                                                                  return AlertDialog(
                                                                    title: Text('Add Helpline'),
                                                                    content: Column(
                                                                      mainAxisSize: MainAxisSize.min,
                                                                      children: <Widget>[
                                                                        TextFormField(
                                                                          onChanged: (value) {
                                                                            setState(() {
                                                                              title = value;
                                                                            });
                                                                          },
                                                                          decoration: InputDecoration(
                                                                            border: OutlineInputBorder(
                                                                              borderRadius: BorderRadius.circular(15),
                                                                              borderSide: BorderSide(),
                                                                            ),
                                                                            labelText: 'Helpline Number',
                                                                          ),
                                                                        ),
                                                                        SizedBox(height: 10),
                                                                        TextFormField(
                                                                          onChanged: (value) {
                                                                            setState(() {
                                                                              description = value;
                                                                            });
                                                                          },
                                                                          decoration: InputDecoration(
                                                                            border: OutlineInputBorder(
                                                                              borderRadius: BorderRadius.circular(15),
                                                                              borderSide: BorderSide(),
                                                                            ),
                                                                            labelText: 'Helpline Name',
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    actions: <Widget>[
                                                                      ElevatedButton(
                                                                        style: ElevatedButton.styleFrom(
                                                                          backgroundColor: Colors.white,
                                                                          shape: RoundedRectangleBorder(
                                                                            borderRadius: BorderRadius.circular(
                                                                                MediaQuery.of(context).size.width *
                                                                                    0.04),
                                                                          ),
                                                                        ),
                                                                        onPressed: () {
                                                                          Navigator.of(context).pop();
                                                                        },
                                                                        child: Text('Cancel',style: TextStyle(color: Color(0xFF4C2559)),),
                                                                      ),
                                                                      ElevatedButton(
                                                                        style: ElevatedButton.styleFrom(
                                                                          backgroundColor: Color(0xFF4C2559),
                                                                          shape: RoundedRectangleBorder(
                                                                            borderRadius: BorderRadius.circular(
                                                                                MediaQuery.of(context).size.width *
                                                                                    0.04),
                                                                          ),
                                                                        ),
                                                                        onPressed: () {
                                                                          if (title.trim().isEmpty || description.trim().isEmpty) {
                                                                            showDialog(
                                                                              context: context,
                                                                              builder: (BuildContext context) {
                                                                                return AlertDialog(
                                                                                  title: Text('Error'),
                                                                                  content: Text('Both fields are required.'),
                                                                                  actions: <Widget>[
                                                                                    ElevatedButton(
                                                                                      style: ElevatedButton.styleFrom(
                                                                                        backgroundColor: Color(0xFF4C2559),
                                                                                        shape: RoundedRectangleBorder(
                                                                                          borderRadius: BorderRadius.circular(
                                                                                              MediaQuery.of(context).size.width *
                                                                                                  0.04),
                                                                                        ),
                                                                                      ),
                                                                                      onPressed: () {
                                                                                        Navigator.of(context).pop();
                                                                                      },
                                                                                      child: Text('OK',style: TextStyle(color: Colors.white),),
                                                                                    ),
                                                                                  ],
                                                                                );
                                                                              },
                                                                            );
                                                                          } else {
                                                                            FirebaseFirestore.instance.collection('helplines').add({
                                                                              'title': title,
                                                                              'description': description,
                                                                            });
                                                                            Navigator.of(context).pop();
                                                                          }
                                                                        },
                                                                        child: Text('Add Helpline',style: TextStyle(color: Colors.white),),
                                                                      ),
                                                                    ],
                                                                  );
                                                                },
                                                              );
                                                            },
                                                          );
                                                        },
                                                        child: Container(
                                                          height: 60,
                                                          width: 170,
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(15),
                                                            color: Colors.white,
                                                          ),
                                                          child: ListTile(
                                                            title: Text("Helpline"),
                                                            leading: Padding(
                                                              padding: const EdgeInsets.only(top: 8, bottom: 8),
                                                              child: Image.asset("assets/helpline (1).png"),
                                                            ),
                                                          ),
                                                        ),
                                                      ),


                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: GestureDetector(
                                                        onTap: (){
                                                          _showAddArticleDialog(context);
                                                        },
                                                        child: Container(
                                                          height: 60,width: 170,
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(15),
                                                              color: Colors.white
                                                          ),
                                                          child: ListTile(
                                                            title: Text("Articles"),
                                                            leading: Padding(
                                                              padding: const EdgeInsets.only(top: 8,bottom: 8),
                                                              child: Image.asset("assets/article.png"),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: <Widget>[
                                                  Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: GestureDetector(
                                                      onTap: (){
                                                        {
                                                          showDialog(
                                                            context: context,
                                                            builder: (BuildContext context) {
                                                              return AlertDialog(
                                                                title: Text("Add E-learning"),
                                                                content: Container(
                                                                  height: 300,
                                                                  width: 70,
                                                                  child: Column(
                                                                    children: [
                                                                      SizedBox(
                                                                        height: 15,
                                                                      ),
                                                                      TextFormField(
                                                                        style:
                                                                        TextStyle(height: 1.2, color: Colors.black),
                                                                        controller: nameController,
                                                                        cursorColor: Colors.black,
                                                                        decoration: InputDecoration(
                                                                            border: OutlineInputBorder(
                                                                              borderRadius: BorderRadius.circular(
                                                                                  MediaQuery.of(context).size.width *
                                                                                      0.04),
                                                                              borderSide: BorderSide.none,
                                                                            ),
                                                                            contentPadding: EdgeInsets.symmetric(
                                                                                vertical:
                                                                                MediaQuery.of(context).size.height *
                                                                                    0.020,
                                                                                horizontal:
                                                                                MediaQuery.of(context).size.width *
                                                                                    0.045),
                                                                            hintText: "name",
                                                                            hintStyle: TextStyle(fontSize: 14),
                                                                            fillColor: Colors.grey.shade200,
                                                                            filled: true,
                                                                            prefixIcon: Icon(Icons.library_add)),
                                                                        keyboardType: TextInputType.text,
                                                                      ),
                                                                      SizedBox(
                                                                        height: 20,
                                                                      ),
                                                                      TextFormField(
                                                                        style:
                                                                        TextStyle(height: 1.2, color: Colors.black),
                                                                        controller: linkController,
                                                                        cursorColor: Colors.black,
                                                                        decoration: InputDecoration(
                                                                            border: OutlineInputBorder(
                                                                              borderRadius: BorderRadius.circular(
                                                                                  MediaQuery.of(context).size.width *
                                                                                      0.04),
                                                                              borderSide: BorderSide.none,
                                                                            ),
                                                                            contentPadding: EdgeInsets.symmetric(
                                                                                vertical:
                                                                                MediaQuery.of(context).size.height *
                                                                                    0.020,
                                                                                horizontal:
                                                                                MediaQuery.of(context).size.width *
                                                                                    0.045),
                                                                            hintText: "LINK",
                                                                            hintStyle: TextStyle(fontSize: 14),
                                                                            fillColor: Colors.grey.shade200,
                                                                            filled: true,
                                                                            prefixIcon: Icon(Icons.link)),
                                                                        keyboardType: TextInputType.url,
                                                                      ),
                                                                      SizedBox(
                                                                        height: 20,
                                                                      ),
                                                                      ElevatedButton(
                                                                        onPressed: () {
                                                                          FocusScope.of(context)
                                                                              .requestFocus(new FocusNode());
                                                                          bool isURLValid =
                                                                              Uri.parse(linkController.text)
                                                                                  .host
                                                                                  .isNotEmpty;
                                                                          if (isURLValid) {
                                                                            CollectionReference collref =
                                                                            FirebaseFirestore.instance
                                                                                .collection('elearning');

                                                                            Map<String, dynamic> data = {
                                                                              'name': nameController.text,
                                                                              'link': linkController.text
                                                                            };
                                                                            Fluttertoast.showToast(
                                                                              msg: "Successfully Added",
                                                                            );
                                                                            nameController.clear();
                                                                            linkController.clear();
                                                                            // Add a single document with both 'name' and 'link'
                                                                            collref.add(data);
                                                                            Navigator.push(
                                                                                context,
                                                                                MaterialPageRoute(
                                                                                  builder: (context) => HomePage(),
                                                                                ));
                                                                          } else {
                                                                            Fluttertoast.showToast(
                                                                              msg: "url is not valid",
                                                                            );
                                                                          }
                                                                        },
                                                                        style: ElevatedButton.styleFrom(
                                                                          backgroundColor: Color(0xFF4C2559),
                                                                          shape: RoundedRectangleBorder(
                                                                            borderRadius: BorderRadius.circular(
                                                                                MediaQuery.of(context).size.width *
                                                                                    0.04),
                                                                          ),
                                                                          minimumSize: Size(
                                                                            MediaQuery.of(context).size.width * 0.90,
                                                                            MediaQuery.of(context).size.height * 0.06,
                                                                          ),
                                                                        ),
                                                                        child: Text(
                                                                          "ADD",
                                                                          style: TextStyle(
                                                                            color: Colors.white,
                                                                            fontSize: 17,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          );
                                                        }
                                                      },
                                                      child: Container(
                                                        height: 60,width: 360,
                                                        decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(15),
                                                            color: Colors.white
                                                        ),
                                                        child: Align(
                                                          alignment: Alignment.center,
                                                          child: ListTile(
                                                            title: Text("E-learning"),
                                                            leading: Padding(
                                                              padding: const EdgeInsets.all(8.0),
                                                              child: Image.asset("assets/online-learning.png"),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),

                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: Text(
                                    "Show Lists",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),

                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),

    );
  }
}
