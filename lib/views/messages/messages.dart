import 'package:flutter/material.dart';
import '../../colors.dart';
import '../../models/user.dart';
import '../../widgets/shared/search_bar.dart';

class MessagesView extends StatelessWidget {
  const MessagesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Messages')),
      body: Column(
        children: [
          CustomSearchBar(hint: 'Rechercher une conversation...'),
          Expanded(
            child: ListView.builder(
              itemCount: 15,
              itemBuilder: (context, index) => ListTile(
                leading: UserAvatar(name: 'Contact $index'),
                title: Text('Contact $index'),
                subtitle: Text('Dernier message...'),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('${index + 1}h', style: const TextStyle(fontSize: 12)),
                    if (index % 3 == 0)
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '$index',
                          style: const TextStyle(color: AppColors.white, fontSize: 10),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}