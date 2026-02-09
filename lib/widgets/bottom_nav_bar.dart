import 'package:flutter/material.dart';
import 'custom_bottom_sheet.dart';
import 'role_selection_content.dart';

class CustomBottomNavBar extends StatefulWidget {
  const CustomBottomNavBar({super.key});

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    if (index == 4) {
      // Last icon (Shield) opens the Role Selection Modal
      CustomBottomSheet.show(
        context: context,
        showFloatingIcon: true,
        floatingIcon: Icons.shield,
        content: const RoleSelectionContent(),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: const Color(0xFF0D0D0D),
        border: Border(
          top: BorderSide(
            color: Colors.white.withOpacity(0.1),
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(0, Icons.home_outlined, Icons.home),
          _buildNavItem(1, Icons.people_outline, Icons.people),
          _buildNavItem(2, Icons.calendar_today_outlined, Icons.calendar_today),
          _buildNavItem(3, Icons.chat_bubble_outline, Icons.chat_bubble),
          _buildNavItem(4, Icons.shield_outlined, Icons.shield),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData outlineIcon, IconData solidIcon) {
    bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isSelected ? solidIcon : outlineIcon,
            color: isSelected ? Colors.orange[400] : Colors.grey[600],
            size: 26,
          ),
          if (isSelected)
            Container(
              margin: const EdgeInsets.only(top: 4),
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.orange[400],
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }
}
