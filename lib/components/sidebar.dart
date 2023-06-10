import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Sidebar extends StatelessWidget {
  final String username;
  final IconData profileIcon;
  final List<String> categories;
  final String selectedCategory;
  final Function(String) onCategoryChanged;

  const Sidebar({
    Key? key,
    required this.username,
    required this.profileIcon,
    required this.categories,
    required this.selectedCategory,
    required this.onCategoryChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        primaryColor: Colors.purple,
        canvasColor: Colors.purple.shade100,
      ),
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.purple,
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 30,
                    child: Icon(
                      profileIcon,
                      size: 40,
                      color: Colors.purple,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    username,
                    style: GoogleFonts.roboto(
                      fontSize: 23,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5),
            const Divider(),
            const ListTile(
              title: Text(
                'Categories',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ...categories.map(
              (category) => ListTile(
                title: Text(
                  category,
                  style: TextStyle(
                    // fontSize: 18,
                    color: category == selectedCategory
                        ? Colors.purple
                        : Colors.black,
                  ),
                ),
                onTap: () => onCategoryChanged(category),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
