import 'package:flutter/material.dart';
import '../../colors.dart';
import '../../models/user.dart';
import '../../widgets/shared/search_bar.dart';

class GroupsView extends StatelessWidget {
  const GroupsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Groupes')),
      body: Column(
        children: [
          CustomSearchBar(hint: 'Rechercher un groupe...'),
          Expanded(
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) => ListTile(
                leading: UserAvatar(name: 'Groupe $index', size: 48),
                title: Text('Groupe $index'),
                subtitle: Text('${index * 123} membres'),
                trailing: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                  ),
                  child: const Text('Rejoindre'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}