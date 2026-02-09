import 'package:flutter/material.dart';
import 'widgets/header_section.dart';
import 'widgets/bottom_nav_bar.dart';

class PersonalDetailsScreen extends StatelessWidget {
  const PersonalDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const HeaderSection(
                title: 'Personal details',
                showBackButton: true,
              ),
              const SizedBox(height: 10),
              
              // White Profile Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          const CircleAvatar(
                            radius: 70,
                            backgroundImage: NetworkImage(
                              'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?q=80&w=400&auto=format&fit=crop',
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.grey.withOpacity(0.2), width: 1),
                              ),
                              child: const Icon(Icons.camera_alt_outlined, color: Colors.black, size: 24),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Brayan Peñaranda',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '@brayanranda',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 30),
              
              // Input Fields List
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    _buildFieldTile(
                      label: 'Name',
                      value: 'Brayan Ismael',
                      onClear: () {},
                    ),
                    _buildFieldTile(
                      label: 'Last Name',
                      value: 'Peñaranda Rincón',
                      onClear: () {},
                    ),
                    _buildFieldTile(
                      label: 'Date of Birth',
                      value: '08/09/1996',
                      onClear: () {},
                    ),
                    _buildFieldTile(
                      label: 'Mobile Phone',
                      value: '57123456789',
                      onClear: () {},
                    ),
                    _buildFieldTile(
                      label: 'Email Address',
                      value: 'brpenaranda@gmail.com',
                      onClear: () {},
                    ),
                    _buildFieldTile(
                      label: 'Country',
                      value: 'Colombia',
                      isDropdown: true,
                      onClear: () {},
                    ),
                    _buildFieldTile(
                      label: 'Gender',
                      value: 'Male',
                      isDropdown: true,
                      onClear: () {},
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 120), // Spacing for bottom nav bar
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }

  Widget _buildFieldTile({
    required String label,
    required String value,
    bool isDropdown = false,
    VoidCallback? onClear,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            isDropdown ? Icons.keyboard_arrow_down : Icons.close,
            color: Colors.white,
            size: 24,
          ),
        ],
      ),
    );
  }
}
