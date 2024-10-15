import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../core/constant/constants.dart';
import '../../data/firebase/firebase_services.dart';
import '../../zetaproc/data/zfirebase_service.dart';
import '../widgets/profile/follow_button.dart';


class WorkSampletDesktopPage extends StatefulWidget {
  final String workSampleId;

  const WorkSampletDesktopPage({super.key, required this.workSampleId});

  @override
  WorkSampletPageState createState() => WorkSampletPageState();
}

class WorkSampletPageState extends State<WorkSampletDesktopPage> with TickerProviderStateMixin {
  var workSampleData = {};
  int favourites = 0;
  int followers = 0;
  int relation = 0;
  int salavat = 0;
  int fatehe = 0;

  var salavatPlay = false;
  var fatehePlay = false;

  bool isFollowing = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var workSampleSnap = await FirebaseFirestore.instance.collection('workSamples').doc(widget.workSampleId).get();

      if (!mounted) return;

      setState(() {
        workSampleData = workSampleSnap.data()!;
      });
    } catch (e) {
      if (mounted) {
        // showSnackBar(
        //   context,
        //   e.toString(),
        // );
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void _navigateToSignInDesktopPage() {
    if (!mounted) return;

    // Navigator.of(context).pushReplacement(
    //   MaterialPageRoute(
    //     builder: (context) => SignInDesktopPage(),
    //   ),
    // );
  }

  Future<void> _handleSignOut() async {
    await ZFirebaseServices.signOut();
    _navigateToSignInDesktopPage();
  }

  Future<void> _handleFollowUser() async {
    await FirebaseServices.followUser(
      FirebaseAuth.instance.currentUser!.uid,
      workSampleData['uid'],
    );

    if (mounted) {
      setState(() {
        isFollowing = true;
        followers++;
      });
    }
  }

  Future<void> _handleUnfollowUser() async {
    await FirebaseServices.unfollowUser(
      FirebaseAuth.instance.currentUser!.uid,
      workSampleData['uid'],
    );

    if (mounted) {
      setState(() {
        isFollowing = false;
        followers--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    TabController tabController = TabController(length: 2, vsync: this);
    return isLoading
        ? const Center(
      child: CircularProgressIndicator(),
    )
        : Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Text(
          workSampleData['description'] ?? 'WorkSample',
        ),
        centerTitle: false,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, top: 5, right: 10, bottom: 5),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          buildStatColumn(followers, "followers"),
                          const SizedBox(height: 40),
                          buildStatColumn(salavat, "salavat"),
                          const SizedBox(height: 10),
                          IconButton(
                            icon: salavatPlay
                                ? const Icon(
                              Icons.pause_circle_outline,
                              size: 50.0,
                            )
                                : const Icon(Icons.play_circle_outline, size: 50.0),
                            onPressed: () {
                              setState(() {
                                salavatPlay = !salavatPlay;
                                if (salavatPlay) fatehePlay = false;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.grey,
                      backgroundImage: NetworkImage(
                        workSampleData['workSampleUrl'] ?? '',
                      ),
                      radius: MediaQuery.of(context).size.width / 4,
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          buildStatColumn(followers, "followers"),
                          const SizedBox(height: 40),
                          buildStatColumn(salavat, "salavat"),
                          const SizedBox(height: 10),
                          IconButton(
                            icon: fatehePlay
                                ? const Icon(
                              Icons.pause_circle_outline,
                              size: 50.0,
                            )
                                : const Icon(Icons.play_circle_outline, size: 50.0),
                            onPressed: () {
                              setState(() {
                                fatehePlay = !fatehePlay;
                                if (fatehePlay) salavatPlay = false;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FirebaseAuth.instance.currentUser!.uid == widget.workSampleId
                        ? FollowButton(
                      text: 'Sign Out',
                      backgroundColor: mobileBackgroundColor,
                      textColor: primaryColor,
                      borderColor: Colors.grey,
                      function: _handleSignOut,
                    )
                        : isFollowing
                        ? FollowButton(
                      text: 'Unfollow',
                      backgroundColor: Colors.white,
                      textColor: Colors.black,
                      borderColor: Colors.grey,
                      function: _handleUnfollowUser,
                    )
                        : FollowButton(
                      text: 'Follow',
                      backgroundColor: Colors.blue,
                      textColor: Colors.white,
                      borderColor: Colors.blue,
                      function: _handleFollowUser,
                    )
                  ],
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(top: 15),
                  child: Text(
                    workSampleData['username'] ?? '',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          TabBar(
            tabs: const [
              Tab(child: Text('Mazars')),
              Tab(child: Text('Favourites')),
            ],
            controller: tabController,
          ),
          Container(
            width: double.maxFinite,
            height: double.maxFinite,
            color: Colors.blue,
            child: TabBarView(
              controller: tabController,
              children: [
                FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('workSamples')
                      .where('favourites', arrayContains: widget.workSampleId)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return GridView.builder(
                      shrinkWrap: true,
                      itemCount: (snapshot.data! as dynamic).docs.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 1.5,
                        childAspectRatio: 1,
                      ),
                      itemBuilder: (context, index) {
                        DocumentSnapshot snap = (snapshot.data! as dynamic).docs[index];

                        return InkWell(
                          onTap: () {},
                          child: Image(
                            image: NetworkImage(snap['workSampleUrl']),
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    );
                  },
                ),
                const Scaffold(),
              ],
            ),
          )
        ],
      ),
    );
  }

  Column buildStatColumn(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
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
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}
