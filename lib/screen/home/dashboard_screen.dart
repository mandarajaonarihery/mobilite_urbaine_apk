// lib/screen/home/dashboard_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Portail des projets'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildProjectCard(
              context,
              title: 'Mobilité Urbaine',
              icon: Icons.directions_bus,
              route: '/mobilite_urbaine',
            ),
            const SizedBox(height: 16),
            _buildProjectCard(
              context,
              title: 'Participation Citoyenne',
              icon: Icons.people,
              route: '/participation_citoyenne',
            ),
            const SizedBox(height: 16),
            _buildProjectCard(
              context,
              title: 'Recette Locale',
              icon: Icons.monetization_on,
              route: '/recette_locale',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectCard(BuildContext context, {
    required String title,
    required IconData icon,
    required String route,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () => context.go(route),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Row(
            children: [
              Icon(icon, size: 40, color: Theme.of(context).primaryColor),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}