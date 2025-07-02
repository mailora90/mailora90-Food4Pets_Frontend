import 'package:flutter/material.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  // Dummy data for demo purposes
  List<Map<String, dynamic>> posts = List.generate(50, (index) {
    return {
      'userName': 'User $index',
      'profilePic': 'https://via.placeholder.com/150',
      'description': 'This is a sample post description for user $index.',
      'likes': 0,
      'dislikes': 0,
    };
  });

  void _incrementLike(int index) {
    setState(() {
      posts[index]['likes']++;
    });
  }

  void _incrementDislike(int index) {
    setState(() {
      posts[index]['dislikes']++;
    });
  }

  void _viewPost(int index) {
    // Just for demo, you can show a dialog or navigate to a new screen
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(posts[index]['userName']),
        content: Text(posts[index]['description']),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Close")),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];

        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Profile Info
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(post['profilePic']),
                      radius: 24,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      post['userName'],
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                /// Description
                Text(
                  post['description'],
                  style: const TextStyle(fontSize: 14),
                ),

                const SizedBox(height: 12),

                /// Like, Dislike, View, Comment Buttons
                Wrap(
                  spacing: 10,
                  runSpacing: 8,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => _incrementLike(index),
                      icon: const Icon(Icons.thumb_up),
                      label: Text('Like (${post['likes']})'),
                     // style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => _incrementDislike(index),
                      icon: const Icon(Icons.thumb_down),
                      label: Text('Dislike (${post['dislikes']})'),
                     // style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => _viewPost(index),
                      icon: const Icon(Icons.remove_red_eye),
                      label: const Text('View'),
                     // style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => _viewPost(index),
                      //icon: const Icon(Icons.add),
                      label: const Text('Add'),
                     // style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    ),
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.comment),
                      label: const Text('Comment'),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
