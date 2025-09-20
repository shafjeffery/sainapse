import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<Post> _posts = [...dummyPosts]; // keep posts locally

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showCreatePostScreen() async {
    final newPost = await Navigator.push<Post>(
      context,
      MaterialPageRoute(builder: (context) => const CreatePostScreen()),
    );
    if (newPost != null) {
      setState(() {
        _posts.insert(0, newPost); // add new post at top
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF9DB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF4E342E)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Community',
          style: GoogleFonts.museoModerno(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF4E342E),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.redAccent),
            onPressed: () {},
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFF4E342E),
          unselectedLabelColor: Colors.grey,
          labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          indicatorColor: const Color(0xFFFFE066),
          indicatorSize: TabBarIndicatorSize.label,
          dividerColor: Colors.transparent,
          tabs: const [
            Tab(text: 'Community'),
            Tab(text: 'Activities'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          CommunityPostsTab(posts: _posts),
          const ActivitiesTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreatePostScreen,
        backgroundColor: const Color(0xFFFFE066),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: const Icon(
          Icons.add_rounded,
          color: Color(0xFF4E342E),
          size: 32,
        ),
      ),
    );
  }
}

// ------------------ Community Tab ------------------
class CommunityPostsTab extends StatefulWidget {
  final List<Post> posts;
  const CommunityPostsTab({super.key, required this.posts});

  @override
  State<CommunityPostsTab> createState() => _CommunityPostsTabState();
}

class _CommunityPostsTabState extends State<CommunityPostsTab> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: widget.posts.length,
      itemBuilder: (context, index) {
        return PostCard(
          post: widget.posts[index],
          onUpdate: (updatedPost) {
            setState(() {
              widget.posts[index] = updatedPost;
            });
          },
          onDelete: () {
            setState(() {
              widget.posts.removeAt(index);
            });
          },
        );
      },
    );
  }
}

// ------------------ Activities Tab ------------------
class ActivitiesTab extends StatelessWidget {
  const ActivitiesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: dummyEvents.length,
      itemBuilder: (context, index) => ActivityCard(event: dummyEvents[index]),
    );
  }
}

// ------------------ Post Card ------------------
class PostCard extends StatefulWidget {
  final Post post;
  final ValueChanged<Post> onUpdate;
  final VoidCallback onDelete;

  const PostCard({
    super.key,
    required this.post,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  late Post post;
  final TextEditingController _commentController = TextEditingController();
  bool _showComments = false;

  @override
  void initState() {
    super.initState();
    post = widget.post;
  }

  void _toggleLike() {
    setState(() {
      post.isLiked = !post.isLiked;
      post.likes += post.isLiked ? 1 : -1;
    });
    widget.onUpdate(post);
  }

  void _addComment() {
    if (_commentController.text.isNotEmpty) {
      setState(() {
        post.comments.add(
          Comment(
            username: "You",
            avatarColor: Colors.orange[300]!,
            content: _commentController.text,
          ),
        );
      });
      widget.onUpdate(post);
      _commentController.clear();
    }
  }

  void _deletePost() {
    widget.onDelete();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: CircleAvatar(
              backgroundColor: post.avatarColor,
              radius: 24,
              child: Text(
                post.username[0],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              post.username,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            subtitle: Text(
              post.timeAgo,
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: _deletePost,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(post.content, style: GoogleFonts.poppins(fontSize: 15)),
          ),
          if (post.image != null)
            Container(
              height: 200,
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  image: post.image!.startsWith('data:image')
                      ? MemoryImage(base64Decode(post.image!.split(',')[1]))
                      : post.image!.startsWith('http')
                      ? NetworkImage(post.image!) as ImageProvider
                      : AssetImage(post.image!) as ImageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _ActionButton(
                  icon: post.isLiked ? Icons.favorite : Icons.favorite_border,
                  label: '${post.likes}',
                  onTap: _toggleLike,
                  iconColor: post.isLiked ? Colors.red : null,
                ),
                const SizedBox(width: 24),
                _ActionButton(
                  icon: Icons.chat_bubble_outline,
                  label: '${post.comments.length}',
                  onTap: () {
                    setState(() => _showComments = !_showComments);
                  },
                ),
              ],
            ),
          ),
          if (_showComments) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  ...post.comments.map(
                    (comment) => Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          backgroundColor: comment.avatarColor,
                          radius: 16,
                          child: Text(
                            comment.username[0],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                comment.username,
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                comment.content,
                                style: GoogleFonts.poppins(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _commentController,
                          decoration: InputDecoration(
                            hintText: 'Add a comment...',
                            border: InputBorder.none,
                            hintStyle: GoogleFonts.poppins(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.send_rounded),
                        color: const Color(0xFFFFE066),
                        onPressed: _addComment,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ------------------ Create Post ------------------
class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController _postController = TextEditingController();

  void _createPost() {
    if (_postController.text.isEmpty) return;

    final newPost = Post(
      username: 'You',
      avatarColor: Colors.orange[300]!,
      timeAgo: 'Just now',
      content: _postController.text,
      image: null,
      likes: 0,
      isLiked: false,
      comments: [],
      timestamp: DateTime.now(),
    );

    Navigator.pop(context, newPost);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF9DB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Color(0xFF4E342E)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Create Post',
          style: GoogleFonts.museoModerno(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF4E342E),
          ),
        ),
        actions: [
          TextButton(
            onPressed: _createPost,
            child: Text(
              'Post',
              style: GoogleFonts.poppins(
                color: const Color(0xFFFFE066),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: TextField(
          controller: _postController,
          maxLines: 5,
          decoration: InputDecoration(
            hintText: "What's on your mind?",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            hintStyle: GoogleFonts.poppins(
              color: Colors.grey[400],
              fontSize: 16,
            ),
          ),
          style: GoogleFonts.poppins(fontSize: 16),
        ),
      ),
    );
  }
}

// ------------------ Models ------------------
class Post {
  String username;
  Color avatarColor;
  String timeAgo;
  String content;
  String? image;
  int likes;
  bool isLiked;
  List<Comment> comments;
  DateTime timestamp;

  Post({
    required this.username,
    required this.avatarColor,
    required this.timeAgo,
    required this.content,
    this.image,
    required this.likes,
    required this.isLiked,
    required this.comments,
    required this.timestamp,
  });
}

class Comment {
  String username;
  Color avatarColor;
  String content;

  Comment({
    required this.username,
    required this.avatarColor,
    required this.content,
  });
}

class Event {
  final String title;
  final String dateTime;
  final String emoji;
  final String image;

  const Event({
    required this.title,
    required this.dateTime,
    required this.emoji,
    required this.image,
  });
}

// ------------------ Activity Card ------------------
class ActivityCard extends StatelessWidget {
  final Event event;

  const ActivityCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(
              image: event.image.startsWith('data:image')
                  ? MemoryImage(base64Decode(event.image.split(',')[1]))
                  : event.image.startsWith('http')
                  ? NetworkImage(event.image) as ImageProvider
                  : AssetImage(event.image) as ImageProvider,
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Text(event.emoji, style: const TextStyle(fontSize: 24)),
          ),
        ),
        title: Text(
          event.title,
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(
          event.dateTime,
          style: TextStyle(color: Colors.grey[600], fontSize: 14),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: Colors.grey[400],
          size: 16,
        ),
        onTap: () {
          // Handle event tap
        },
      ),
    );
  }
}

// ------------------ Action Button ------------------
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? iconColor;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: iconColor ?? Colors.grey[600], size: 20),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.poppins(color: Colors.grey[600], fontSize: 14),
          ),
        ],
      ),
    );
  }
}

// ------------------ Dummy Data ------------------
final List<Post> dummyPosts = [
  Post(
    username: 'Hafiz Fauzi',
    avatarColor: Colors.blue[300]!,
    timeAgo: '2 hours ago',
    content:
        'Just visited the Sultan Abdullah Mosque! The architecture is breathtaking 😍 #PekanHeritage',
    image: 'assets/images/test.png',
    likes: 42,
    isLiked: false,
    comments: [
      Comment(
        username: 'Sarah',
        avatarColor: Colors.pink[200]!,
        content: 'Beautiful shot! ✨',
      ),
      Comment(
        username: 'Ahmad',
        avatarColor: Colors.green[300]!,
        content: 'One of the best preserved sites!',
      ),
    ],
    timestamp: DateTime.now().subtract(const Duration(hours: 2)),
  ),
];

final List<Event> dummyEvents = [
  Event(
    title: 'Pekan Food Fest',
    dateTime: 'Sat, 20 May • 10:00 AM',
    emoji: '🍢',
    image: 'assets/images/test.png',
  ),
  Event(
    title: 'Heritage Walk Tour',
    dateTime: 'Sun, 21 May • 9:00 AM',
    emoji: '🏛️',
    image: 'assets/images/test.png',
  ),
];
