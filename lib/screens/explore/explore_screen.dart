import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/portfolio_provider.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/cards/user_profile_card.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Fetch the initial list of profiles when the screen loads
      context.read<PortfolioProvider>().fetchPublicProfiles();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PortfolioProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore Portfolios'),
      ),
      body: Column(
        children: [
          // --- Search Bar ---
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search by name or headline...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
              // [FIX] Call the search method on every keystroke
              onChanged: (value) {
                provider.searchPublicProfiles(value);
              },
            ),
          ),
          // --- Results List ---
          Expanded(
            child: provider.isLoading
                ? const LoadingIndicator()
            // [FIX] Check the filtered list, not the main list
                : provider.publicProfiles.isEmpty
                ? const Center(child: Text('No matching portfolios found.'))
                : RefreshIndicator(
              onRefresh: () => provider.fetchPublicProfiles(),
              child: ListView.builder(
                // [FIX] Use the filtered list for the item count
                itemCount: provider.publicProfiles.length,
                itemBuilder: (context, index) {
                  return UserProfileCard(profile: provider.publicProfiles[index]);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}