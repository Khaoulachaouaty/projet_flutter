import 'package:flutter/material.dart';
import '../../widgets/shared/bottom_nav_bar.dart';
import '../../widgets/shared/create_post_sheet.dart';
import '../groups/groups.dart';
import '../messages/messages.dart';
import '../profile.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _currentIndex = 0;
  final _pages = const [FeedView(), GroupsView(), MessagesView(), ProfileView()];

  void _showCreatePost() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CreatePostSheet(
        onClose: () => Navigator.pop(context),
        onSubmit: (content, media, type) => debugPrint('Post: $content'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreatePost,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}