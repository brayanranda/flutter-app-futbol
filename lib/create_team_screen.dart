import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'widgets/header_section.dart';
import 'widgets/bottom_nav_bar.dart';
import 'widgets/custom_bottom_sheet.dart';
import 'coach_dashboard_screen.dart';
import 'services/auth_service.dart';

class CreateTeamScreen extends StatefulWidget {
  const CreateTeamScreen({super.key});

  @override
  State<CreateTeamScreen> createState() => _CreateTeamScreenState();
}

class _CreateTeamScreenState extends State<CreateTeamScreen> {
  bool isCustomCode = false;
  bool _isLoading = false;
  final TextEditingController _teamNameController = TextEditingController();
  final TextEditingController _inviteCodeController = TextEditingController();
  
  String? _selectedSport = 'Soccer';
  String? _selectedSportType;

  final List<String> _sportTypeOptions = [
    'FOOTBALL_11_A_SIDE',
    'FUTSAL',
    'FOOTBALL_7_A_SIDE',
    'FOOTBALL_5_A_SIDE',
    'BEACH_SOCCER',
    'INDOOR_SOCCER',
    'STREET_FOOTBALL',
  ];

  Future<void> _saveTeam() async {
    if (_teamNameController.text.isEmpty) {
      _showError('Please enter a team name');
      return;
    }
    if (_selectedSportType == null) {
      _showError('Please select a sport type');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.9:8080/teams'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${AuthService().token}',
        },
        body: jsonEncode({
          'name': _teamNameController.text.trim(),
          'sport': _selectedSport,
          'sportType': _selectedSportType,
          'inviteCode': isCustomCode ? _inviteCodeController.text.trim() : 'AUTO_GEN', // Placeholder if not custom
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Team created successfully!'), backgroundColor: Colors.green),
          );
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const CoachDashboardScreen()),
            (route) => false,
          );
        }
      } else {
        _showError('Failed to create team: ${response.statusCode}');
      }
    } catch (e) {
      _showError('Error connecting to server: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
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
              const HeaderSection(
                title: 'Your Team',
                subtitle: 'Create',
                showBackButton: true,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  'Create a new team and become its coach. You\'ll receive an invite code to share with your players.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    height: 1.4,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => _showInstructions(context),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    children: const [
                      Icon(Icons.help_outline, color: Colors.blue, size: 24),
                      SizedBox(width: 10),
                      Text(
                        'Instructions as new team',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              // Form Fields
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel('Team name'),
                    _buildTextField(
                      controller: _teamNameController,
                      hint: 'My Awesome Team',
                    ),
                    const SizedBox(height: 20),
                    
                    _buildLabel('Sport (optional)'),
                    _buildDropdown(
                      hint: 'Select a sport...',
                      value: _selectedSport,
                      items: ['Soccer', 'Basketball', 'Tennis'],
                      onChanged: (val) => setState(() => _selectedSport = val),
                    ),
                    const SizedBox(height: 20),
                    
                    _buildLabel('Sport Type'),
                    _buildDropdown(
                      hint: 'Select a soccer type...',
                      value: _selectedSportType,
                      items: _sportTypeOptions,
                      onChanged: (val) => setState(() => _selectedSportType = val),
                    ),
                    const SizedBox(height: 20),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildLabel('Invite Code'),
                        Row(
                          children: [
                            Checkbox(
                              value: isCustomCode,
                              onChanged: (val) => setState(() => isCustomCode = val!),
                              activeColor: Colors.orange,
                              side: const BorderSide(color: Colors.orange, width: 2),
                            ),
                            const Text(
                              'Custom Code',
                              style: TextStyle(color: Colors.white, fontSize: 14),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            controller: _inviteCodeController,
                            hint: '4-10 characters',
                            enabled: isCustomCode,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.orange[800],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.share, color: Colors.white),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 30),
                    
                    // Save Button
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _saveTeam,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange[800],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: _isLoading 
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'Save',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }

  void _showInstructions(BuildContext context) {
    CustomBottomSheet.show(
      context: context,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'As the team creator, you\'ll automatically be assigned as the coach. You\'ll be able to:',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 18,
              height: 1.4,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 20),
          _buildBulletPoint('Create and manage events'),
          _buildBulletPoint('Track team attendance'),
          _buildBulletPoint('Communicate with all team members'),
        ],
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 22, color: Colors.black87)),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 18,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    bool enabled = true,
  }) {
    return TextField(
      controller: controller,
      enabled: enabled,
      style: const TextStyle(color: Colors.black87),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String hint, 
    required List<String> items, 
    String? value,
    required void Function(String?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButtonFormField<String>(
          value: value,
          decoration: const InputDecoration(border: InputBorder.none),
          hint: Text(hint, style: const TextStyle(color: Colors.grey)),
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
          dropdownColor: Colors.white,
          items: items.map((String val) {
            return DropdownMenuItem<String>(
              value: val,
              child: Text(val, style: const TextStyle(color: Colors.black87)),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
