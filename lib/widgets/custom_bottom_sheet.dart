import 'package:flutter/material.dart';

class CustomBottomSheet {
  static void show({
    required BuildContext context,
    required Widget content,
    IconData? headerIcon,
    Widget? customHeader,
    bool showFloatingIcon = false,
    IconData floatingIcon = Icons.shield,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(32),
                topRight: Radius.circular(32),
              ),
            ),
            padding: EdgeInsets.only(top: showFloatingIcon ? 40 : 0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!showFloatingIcon) ...[
                  // Default Header
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 15, 10, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (headerIcon != null)
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              shape: BoxShape.circle,
                            ),
                            child: Icon(headerIcon, color: Colors.black, size: 24),
                          ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.black, size: 28),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                ] else ...[
                  // Minimal Header for Floating Style
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10, right: 10),
                      child: IconButton(
                        icon: const Icon(Icons.close, color: Colors.black, size: 28),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                ],
                // Content
                Padding(
                  padding: const EdgeInsets.fromLTRB(25, 0, 25, 40),
                  child: content,
                ),
              ],
            ),
          ),
          if (showFloatingIcon)
            Positioned(
              top: -35,
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: const BoxDecoration(
                  color: Color(0xFF2B50AA), // Blue color from image
                  shape: BoxShape.circle,
                ),
                child: Icon(floatingIcon, color: Colors.white, size: 40),
              ),
            ),
        ],
      ),
    );
  }
}
