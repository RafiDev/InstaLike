import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/resources/auth_methods.dart';
import 'package:instagram_flutter/resources/firestore_methods.dart';
import 'package:instagram_flutter/screens/login_screen.dart';
import 'package:instagram_flutter/utils/colors.dart';
import 'package:instagram_flutter/utils/utils.dart';
import 'package:instagram_flutter/widgets/follow_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    required this.uid,
    super.key,
  });
  final String uid;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic> userData = <String, dynamic>{};
  int postLen = 0;
  int followers = 0;
  bool isFollowing = false;
  bool isLoading = false;
  final dynamic userSnap = <dynamic, dynamic>{};

  @override
  void initState() {
    super.initState();
    Future<void>.delayed(Duration.zero, () async {
      await initializeData();
    });
  }

  Future<void> initializeData() async {
    await getData();
  }

  Future<void> getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      final dynamic userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

      final dynamic postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where(
            'uid',
            isEqualTo: userSnap.id,
          )
          .get();

      postLen = postSnap.docs.length;
      userData = userSnap.data()!;
      followers = userSnap.data()!['followers'].length;
      isFollowing = userSnap
          .data()!['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);
      setState(() {});
    } catch (err) {
      showSnackBar(err.toString(), context);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              title: Text(userData['username']),
              centerTitle: false,
            ),
            body: ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          CircleAvatar(
                            backgroundColor: Colors.grey,
                            backgroundImage: NetworkImage(userData['photoUrl']),
                            radius: 40,
                          ),
                          Expanded(
                            child: Column(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    buildStatColumn(postLen, 'posts'),
                                    buildStatColumn(followers, 'followers'),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    if (FirebaseAuth
                                            .instance.currentUser!.uid ==
                                        widget.uid)
                                      FollowButton(
                                        text: 'Sign Out',
                                        backgroundColor: mobileBackgroundColor,
                                        textColor: primaryColor,
                                        borderColor: Colors.grey,
                                        function: () async {
                                          await AuthMethods().signOut();
                                          if (mounted) {
                                            await Navigator.push<void>(
                                              context,
                                              MaterialPageRoute<void>(
                                                builder:
                                                    (BuildContext context) {
                                                  return const LoginScreen();
                                                },
                                              ),
                                            );
                                          }
                                        },
                                      )
                                    else if (isFollowing)
                                      FollowButton(
                                        text: 'Unfollow',
                                        backgroundColor: Colors.white,
                                        textColor: Colors.black,
                                        borderColor: Colors.grey,
                                        function: () async {
                                          await FirestoreMethods().followUser(
                                            FirebaseAuth
                                                .instance.currentUser!.uid,
                                            userData['uid'],
                                          );
                                          setState(() {
                                            isFollowing = false;
                                            followers--;
                                          });
                                        },
                                      )
                                    else
                                      FollowButton(
                                        text: 'Follow',
                                        backgroundColor: Colors.blue,
                                        textColor: Colors.white,
                                        borderColor: Colors.blue,
                                        function: () async {
                                          await FirestoreMethods().followUser(
                                            FirebaseAuth
                                                .instance.currentUser!.uid,
                                            userData['uid'],
                                          );
                                          setState(() {
                                            isFollowing = true;
                                            followers++;
                                          });
                                        },
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(
                          top: 15,
                        ),
                        child: Text(
                          userData['username'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(
                          top: 1,
                        ),
                        child: Text(
                          userData['bio'],
                        ),
                      ),
                    ],
                  ),
                ),
                FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  future: Future<QuerySnapshot<Map<String, dynamic>>>(() async {
                    return FirebaseFirestore.instance
                        .collection('posts')
                        .where('uid', isEqualTo: widget.uid)
                        .get();
                  }),
                  builder: (
                    BuildContext context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot,
                  ) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return GridView.builder(
                      shrinkWrap: true,
                      itemCount: (snapshot.data! as dynamic).docs.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 1.5,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        final DocumentSnapshot<Map<String, dynamic>> snap =
                            (snapshot.data! as dynamic).docs[index];
                        return Image(
                          image: NetworkImage(snap['postUrl']),
                          fit: BoxFit.cover,
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          );
  }

  Column buildStatColumn(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          num.toString(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 4),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}
