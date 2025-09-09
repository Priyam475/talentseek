import 'package:flutter/material.dart';
import '../../models/user_profile.dart';
import 'package:talentseek/screens/explore/public_portfolio_view.dart';

import '../../screens/explore/public_portfolio_view.dart'; // Import the new screen

class UserProfileCard extends StatelessWidget {
  final UserProfile profile;
  const UserProfileCard({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.grey[300],
          child: const Icon(Icons.person),
        ),
        title: Text(profile.fullName, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(profile.headline, maxLines: 1, overflow: TextOverflow.ellipsis),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        // [FIX] This now navigates to the detailed portfolio view.
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              // Pass the user's ID to the new screen
              builder: (context) => PublicPortfolioView(userId: profile.uid),
            ),
          );
        },
      ),
    );
  }
}

