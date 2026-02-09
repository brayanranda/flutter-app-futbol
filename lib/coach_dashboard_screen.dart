import 'package:flutter/material.dart';
import 'widgets/header_section.dart';
import 'widgets/stats_card.dart';
import 'widgets/quick_action_card.dart';
import 'widgets/bottom_nav_bar.dart';

class CoachDashboardScreen extends StatelessWidget {
  const CoachDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HeaderSection(),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Manage your teams and players',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 25),
              
              // Stats Cards Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: const [
                    StatsCard(
                      title: '235 Followers',
                      imageUrl: 'https://images.unsplash.com/photo-1574629810360-7efbbe195018?q=80&w=600&auto=format&fit=crop',
                      icon: Icons.people,
                    ),
                    StatsCard(
                      title: 'Events',
                      imageUrl: 'https://images.unsplash.com/photo-1504450758481-7338eba7524a?q=80&w=600&auto=format&fit=crop',
                      icon: Icons.calendar_today,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 30),
              
              // Quick Actions Section
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Quick Actions',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 0.9,
                  children: [
                    QuickActionCard(
                      title: 'Schedule Event',
                      description: 'Setup new sessions',
                      icon: Icons.add_circle_outline,
                      backgroundColor: Colors.orange[800]!,
                      onTap: () {},
                    ),
                    QuickActionCard(
                      title: 'Manage Teams',
                      description: 'View and edit roster',
                      icon: Icons.group_outlined,
                      onTap: () {},
                    ),
                    QuickActionCard(
                      title: 'View Schedule',
                      description: 'Check your agenda',
                      icon: Icons.event_note_outlined,
                      onTap: () {},
                    ),
                    QuickActionCard(
                      title: 'Create new team',
                      description: 'Add a new group',
                      icon: Icons.add_box_outlined,
                      onTap: () {},
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }
}
