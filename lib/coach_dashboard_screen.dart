import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'create_team_screen.dart';
import 'widgets/header_section.dart';
import 'widgets/stats_card.dart';
import 'widgets/quick_action_card.dart';
import 'widgets/bottom_nav_bar.dart';
import 'widgets/team_card.dart';
import 'widgets/custom_bottom_sheet.dart';
import 'services/auth_service.dart';

class CoachDashboardScreen extends StatefulWidget {
  const CoachDashboardScreen({super.key});

  @override
  State<CoachDashboardScreen> createState() => _CoachDashboardScreenState();
}

class _CoachDashboardScreenState extends State<CoachDashboardScreen> {
  List<dynamic> _teams = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTeams();
  }

  Future<void> _fetchTeams() async {
    setState(() => _isLoading = true);
    try {
      final response = await http.get(
        Uri.parse('http://192.168.1.9:8080/teams'),
        headers: {
          'Authorization': 'Bearer ${AuthService().token}',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          _teams = jsonDecode(response.body);
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
        _showError('Error fetching teams: ${response.statusCode}');
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showError('Connection error: $e');
    }
  }

  Future<void> _deleteTeam(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('http://192.168.1.9:8080/teams/$id'),
        headers: {
          'Authorization': 'Bearer ${AuthService().token}',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        _fetchTeams(); // Refresh list
        if (mounted) Navigator.pop(context); // Close modal
      } else {
        _showError('Error deleting team: ${response.statusCode}');
      }
    } catch (e) {
      _showError('Connection error: $e');
    }
  }

  void _showDeleteConfirmation(int id, String name) {
    CustomBottomSheet.show(
      context: context,
      customHeader: Column(
        children: [
          const Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 50),
          const SizedBox(height: 10),
          Text(
            'Delete $name',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      content: Column(
        children: [
          const Text(
            'Are you sure you want to delete this team? This action cannot be undone.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black87, fontSize: 16),
          ),
          const SizedBox(height: 30),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.grey),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: const Text('Cancel', style: TextStyle(color: Colors.black87)),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _deleteTeam(id),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: const Text('Confirm', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

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
              
              // Your Teams Section
              if (_teams.isNotEmpty || _isLoading) ...[
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Your teams',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  height: 160,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator(color: Colors.orange))
                      : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _teams.length,
                          itemBuilder: (context, index) {
                            final team = _teams[index];
                            return TeamCard(
                              name: team['name'] ?? 'No Name',
                              sportType: team['sportType'] ?? 'No Type',
                              onDelete: () => _showDeleteConfirmation(team['id'], team['name']),
                              gradientColors: index % 2 == 0 
                                ? [const Color(0xFFFF6D1F), const Color(0xFFC04E00)]
                                : [const Color(0xFF2B50AA), const Color(0xFF1E3A8A)],
                            );
                          },
                        ),
                ),
                const SizedBox(height: 30),
              ],
              
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
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const CreateTeamScreen()),
                        ).then((_) => _fetchTeams()); // Refresh on return
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 120), // Added padding for bottom nav
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }
}
