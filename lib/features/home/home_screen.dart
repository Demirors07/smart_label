import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const Color primaryColor = Color(0xFF247A58);
  static const Color textColor = Color(0xFF18352A);
  static const Color secondaryTextColor = Color(0xFF68766F);

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature will be available in a future update.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.eco_outlined, color: primaryColor, size: 28),
            SizedBox(width: 10),
            Text(
              'Smart Label',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => _showComingSoon(context, 'Settings'),
            tooltip: 'Settings',
            icon: const Icon(Icons.settings_outlined),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          children: [
            _buildWelcomeSection(),
            const SizedBox(height: 24),
            _buildScanCard(context),
            const SizedBox(height: 28),
            _buildSectionTitle(
              title: 'Your preferences',
              actionText: 'Edit',
              onAction: () => _showComingSoon(context, 'Preference management'),
            ),
            const SizedBox(height: 12),
            _buildPreferencesCard(),
            const SizedBox(height: 28),
            _buildSectionTitle(
              title: 'Recent analyses',
              actionText: 'View all',
              onAction: () => _showComingSoon(context, 'Analysis history'),
            ),
            const SizedBox(height: 12),
            _buildEmptyHistoryCard(),
            const SizedBox(height: 24),
            const Center(
              child: Text(
                'Make informed choices, wherever you shop.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: secondaryTextColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Know what you eat.',
          style: TextStyle(
            fontSize: 28,
            height: 1.2,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Check food ingredients against your personal '
          'allergies and dietary preferences.',
          style: TextStyle(
            fontSize: 15,
            height: 1.5,
            color: secondaryTextColor,
          ),
        ),
      ],
    );
  }

  Widget _buildScanCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.document_scanner_outlined,
            size: 38,
            color: Colors.white,
          ),
          const SizedBox(height: 18),
          const Text(
            'Scan a food label',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Discover ingredients that may conflict with '
            'your preferences — even offline.',
            style: TextStyle(fontSize: 14, height: 1.5, color: Colors.white),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () => _showComingSoon(context, 'Product scanning'),
              icon: const Icon(Icons.camera_alt_outlined),
              label: const Text('Scan product'),
              style: FilledButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 15),
                textStyle: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle({
    required String title,
    required String actionText,
    required VoidCallback onAction,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        TextButton(onPressed: onAction, child: Text(actionText)),
      ],
    );
  }

  Widget _buildPreferencesCard() {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: Color(0xFFE7ECE8)),
      ),
      child: const Padding(
        padding: EdgeInsets.all(18),
        child: Column(
          children: [
            _PreferenceRow(
              icon: Icons.health_and_safety_outlined,
              title: 'Allergies',
              subtitle: 'Manage your allergen profile',
            ),
            Divider(height: 28),
            _PreferenceRow(
              icon: Icons.restaurant_outlined,
              title: 'Dietary preferences',
              subtitle: 'Vegan, vegetarian, gluten-free and more',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyHistoryCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 26),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE7ECE8)),
      ),
      child: const Column(
        children: [
          Icon(Icons.history, size: 34, color: secondaryTextColor),
          SizedBox(height: 12),
          Text(
            'No analyses yet',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Your recent product analyses will appear here.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: secondaryTextColor),
          ),
        ],
      ),
    );
  }
}

class _PreferenceRow extends StatelessWidget {
  const _PreferenceRow({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: const Color(0xFFEAF4EE),
            borderRadius: BorderRadius.circular(13),
          ),
          child: Icon(icon, color: HomeScreen.primaryColor),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: HomeScreen.textColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: HomeScreen.secondaryTextColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
