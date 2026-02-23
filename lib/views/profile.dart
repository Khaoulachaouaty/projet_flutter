import 'package:flutter/material.dart';
import '../../widgets/shared/post_card.dart';
import '../colors.dart';
import '../models/post.dart';
import '../models/user.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryDark],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const UserAvatar(name: 'Mon Profil', size: 80, showBorder: true),
                    const SizedBox(height: 12),
                    const Text(
                      'Mon Nom',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'Développeur Flutter',
                      style: TextStyle(color: AppColors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _StatColumn(label: 'Publications', value: '42'),
                  _StatColumn(label: 'Abonnés', value: '1.2k'),
                  _StatColumn(label: 'Abonnements', value: '380'),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => PostCard(
                post: PostModel(
                  id: 'p$index',
                  userId: 'me',
                  userName: 'Mon Profil',
                  content: 'Ma publication $index',
                  createdAt: DateTime.now().subtract(Duration(days: index)),
                  likes: index * 5,
                ),
                onUpdate: (_) {},
              ),
              childCount: 5,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  final String label;
  final String value;

  const _StatColumn({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: AppColors.textSecondary)),
      ],
    );
  }
}