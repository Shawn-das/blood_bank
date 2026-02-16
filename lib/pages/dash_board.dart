import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  Widget buildCard({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 12),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 8,
            )
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: const Color(0xFFE53935),
              child: Icon(icon, color: Colors.white, size: 30),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 18)
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      appBar: AppBar(
        backgroundColor: const Color(0xFFE53935),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Dashboard",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [

            // 🩸 Be a Donor
            buildCard(
              title: "Be a Donor",
              icon: Icons.favorite,
              onTap: () {
                Navigator.pushNamed(context, '/donate');
              },
            ),

            // 🚑 Ambulance
            buildCard(
              title: "Ambulance",
              icon: Icons.local_hospital,
              onTap: () {
                Navigator.pushNamed(context, '/ambulance');
              },
            ),

            // ℹ️ About Us
            buildCard(
              title: "About Us",
              icon: Icons.info,
              onTap: () {
                Navigator.pushNamed(context, '/about');
              },
            ),

            buildCard(
              title: "Admin",
              icon: Icons.admin_panel_settings_outlined,
              onTap: () {
                Navigator.pushNamed(context, '/admin_login');
              },
            ),

          ],
        ),
      ),
    );
  }
}
