import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Mock user data
  String name = "John Doe";
  String email = "john.doe@example.com";
  String location = "Unknown";
  String coverPhotoUrl = "https://via.placeholder.com/600x200";
  String profilePhotoUrl = "https://via.placeholder.com/150";

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

  void _getLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) return;

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

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
            TextField(controller: nameController, decoration: InputDecoration(labelText: "Name")),
            TextField(controller: emailController, decoration: InputDecoration(labelText: "Email")),
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
    // MediaQuery sizes
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenWidth < 600;

    return Scaffold(
      appBar: AppBar(
        title: Text("Profile Page"),
        backgroundColor: Colors.teal,
      ),
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
                child: Text("Posts", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
                      child: Text(post),
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

