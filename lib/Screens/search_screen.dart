import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone_flutter/Constant/pallete.dart';
import 'package:instagram_clone_flutter/Screens/profile_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool showUsers = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: showUsers
            ? FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('Users')
                    .where('username',
                        isGreaterThanOrEqualTo: _searchController.text)
                    .get(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text(
                        'No users found',
                        style: TextStyle(color: Pallete.textColor),
                      ),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  }
                  return Column(
                    children: [
                      Container(
                        width: double.infinity,
                        color: Colors.black,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 15),
                          child: Container(
                            width: double.infinity - 30,
                            height: 45,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7),
                              color: Pallete.textFieldFillColor,
                            ),
                            child: TextFormField(
                              onFieldSubmitted: (value) {
                                setState(() {
                                  showUsers = true;
                                });
                              },
                              controller: _searchController,
                              decoration: InputDecoration(
                                hintText: 'Search',
                                hintStyle: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                    color: Pallete.textColor.withOpacity(0.5)),
                                border: InputBorder.none,
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: Pallete.textColor.withOpacity(0.8),
                                ),
                              ),
                              style: const TextStyle(color: Pallete.textColor),
                              cursorColor: Pallete.textColor.withOpacity(0.3),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.separated(
                          itemCount: snapshot.data!.docs.length,
                          separatorBuilder: (context, index) => const SizedBox(
                            height: 8,
                          ),
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProfileScreen(
                                      uid: snapshot.data!.docs[index]['uid'],
                                    ),
                                  )),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Pallete.textFieldFillColor,
                                  radius: 25,
                                  backgroundImage: NetworkImage(
                                      snapshot.data!.docs[index]['photoUrl']),
                                ),
                                title: Text(
                                  snapshot.data!.docs[index]['username'],
                                  style: const TextStyle(
                                    color: Pallete.textColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              )
            : FutureBuilder(
                future: FirebaseFirestore.instance.collection('Posts').get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return Column(children: [
                    Container(
                      width: double.infinity,
                      color: Colors.black,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 15),
                        child: Container(
                          width: double.infinity - 30,
                          height: 45,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                            color: Pallete.textFieldFillColor,
                          ),
                          child: TextField(
                            onSubmitted: (value) {
                              setState(() {
                                showUsers = true;
                              });
                            },
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: 'Search',
                              hintStyle: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  color: Pallete.textColor.withOpacity(0.5)),
                              border: InputBorder.none,
                              prefixIcon: Icon(
                                Icons.search,
                                color: Pallete.textColor.withOpacity(0.8),
                              ),
                            ),
                            style: const TextStyle(color: Pallete.textColor),
                            cursorColor: Pallete.textColor.withOpacity(0.3),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.black,
                        child: GridView.builder(
                          controller: ScrollController(),
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 2,
                                  mainAxisSpacing: 2),
                          itemBuilder: (_, index) => Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(
                                    snapshot.data!.docs[index]['postURL'],
                                  ),
                                  fit: BoxFit.cover),
                            ),
                          ),
                          itemCount: snapshot.data!.docs.length,
                        ),
                      ),
                    ),
                  ]);
                },
              ));
  }
}
