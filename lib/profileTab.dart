import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class Profiletab extends StatefulWidget {
  const Profiletab({super.key});

  @override
  State<Profiletab> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<Profiletab> {
  // Mock user data
  String name = "mr abc";
  String email = "abc.doe@example.com";
  String location = "Unknown";
  String coverPhotoUrl =
      "https://statics.mylandingpages.co/static/aaanxdmf26c522mp/image/600e9f59166b4a0591ad427cc66e9ed2.webp";
  String profilePhotoUrl =
      "https://images.ctfassets.net/h6goo9gw1hh6/2sNZtFAWOdP1lmQ33VwRN3/24e953b920a9cd0ff2e1d587742a2472/1-intro-photo-final.jpg?w=1200&h=992&q=70&fm=webp";

  // Post controller
  TextEditingController postController = TextEditingController();
  List<String> posts = [];

  void _addPost() {
    final text = postController.text;
    if (text.isNotEmpty) {
      setState(() {
        posts.insert(0, text);
        postController.clear();
      });
    }
  }

  void _editPost(int index) {
    TextEditingController editController =
        TextEditingController(text: posts[index]);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Edit Post"),
        content: TextField(
          controller: editController,
          maxLines: 3,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: "Edit your post",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                posts[index] = editController.text;
              });
              Navigator.pop(context);
            },
            child: Text("Save"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
        ],
      ),
    );
  }

  void _deletePost(int index) {
    setState(() {
      posts.removeAt(index);
    });
  }

  void _getLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) return;

    Position position =
        await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    setState(() {
      location = "${position.latitude}, ${position.longitude}";
    });
  }

  void _editDetails() {
    TextEditingController nameController = TextEditingController(text: name);
    TextEditingController emailController = TextEditingController(text: email);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Edit Details"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: "Name"),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: "Email"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                name = nameController.text;
                email = emailController.text;
              });
              Navigator.pop(context);
            },
            child: Text("Save"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenWidth < 600;

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.04),
          child: Column(
            children: [
              // Cover & Profile Photo
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: screenHeight * 0.25,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(coverPhotoUrl),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  Positioned(
                    bottom: -screenWidth * 0.10,
                    left: 16,
                    child: CircleAvatar(
                      radius: screenWidth * 0.12,
                      backgroundImage: NetworkImage(profilePhotoUrl),
                    ),
                  ),
                ],
              ),

              SizedBox(height: screenHeight * 0.08),

              // User Details
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Name: $name", style: TextStyle(fontSize: isSmallScreen ? 16 : 20)),
                  SizedBox(height: 6),
                  Text("Email: $email", style: TextStyle(fontSize: isSmallScreen ? 14 : 18)),
                  SizedBox(height: 6),
                  Text("Location: $location", style: TextStyle(fontSize: isSmallScreen ? 14 : 18)),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _editDetails,
                          child: Text("Edit Details"),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _getLocation,
                          child: Text("Add Location"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: 20),
              Divider(),

              // Add Post Section
              Column(
                children: [
                  TextField(
                    controller: postController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: "What's on your mind?",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _addPost,
                      child: Text("Post"),
                    ),
                  ),
                ],
              ),

              Divider(height: 40),

              // Posts List
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Posts",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              SizedBox(height: 10),

              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  final post = posts[index];
                  return Card(
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(post),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () => _editPost(index),
                                child: Text("Edit"),
                              ),
                              TextButton(
                                onPressed: () => _deletePost(index),
                                child: Text("Delete", style: TextStyle(color: Colors.red)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
