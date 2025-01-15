import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'diversityPage.dart';
import 'explorePage.dart';


class AboutPage extends StatefulWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  int _selectedIndex = 0; // Initially set to 0 for the "About App" page

  void _onItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigate to the appropriate page based on the index
    switch (index) {
      case 0:
        // Stay on the current page
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ExplorePage()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DiversityPage()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFFEFF6FC), // Light Purple Background
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false, 
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0077B6), Color(0xFF00B4D8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Text(
          'BioSplash',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 100),
              child: Column(
                children: [
                  Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 180,
                          height: 180,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const RadialGradient(
                              colors: [Color(0xFF0077B6), Color(0xFFEFF6FC)],
                              center: Alignment.center,
                              radius: 0.9,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 15,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: CircleAvatar(
                            radius: 70,
                            backgroundColor: Colors.white,
                            child: ClipOval(
                              child: Image.asset(
                                'assets/icon.png',
                                fit: BoxFit.contain,
                                width: 100,
                                height: 100,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Welcome to BioSplash',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey.shade700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Version 1.0.0',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF0077B6),
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    'BioSplash is an innovative marine biodiversity tracking app designed to empower users with insights into the health and patterns of marine ecosystems. Developed to address the growing need for conservation and sustainable practices, BioSplash leverages cutting-edge data analytics and AI-driven image classification to help users track, analyze, and protect marine life.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF023E8A),
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 40),
                  _buildFeatureCards(context),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,  // Pass the selected index
        onItemSelected: _onItemSelected,  // Pass the callback function
      ),
    );
  }

  Widget _buildFeatureCards(BuildContext context) {
    final features = [
      {
        'icon': Icons.analytics,
        'title': 'Marine Insights',
        'description': 'Explore health and behavior of marine life.',
        'color': const Color(0xFF0096C7)
      },
      {
        'icon': Icons.camera_alt,
        'title': 'AI Image Recognition',
        'description': 'Classify fish species with advanced AI.',
        'color': const Color(0xFF00B4D8)
      },
      {
        'icon': Icons.eco,
        'title': 'Conservation Support',
        'description': 'Promote sustainable marine practices.',
        'color': const Color(0xFF48CAE4)
      },
    ];

    return Column(
      children: features.map((feature) {
        return Container(
          margin: const EdgeInsets.only(bottom: 20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [
                (feature['color'] as Color).withOpacity(0.2),
                Colors.white,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: (feature['color'] as Color).withOpacity(0.5),
                child: Icon(
                  feature['icon'] as IconData,
                  size: 30,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      feature['title'] as String,
                      style: const TextStyle(
                        color: Color(0xFF023E8A),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      feature['description'] as String,
                      style: const TextStyle(
                        color: Color(0xFF6C757D),
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class CustomBottomNavigationBar extends StatefulWidget {
  final int selectedIndex;
  final void Function(int) onItemSelected;

  const CustomBottomNavigationBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemSelected,
  }) : super(key: key);

  @override
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState
    extends State<CustomBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.info_outline, "About App", 0),
          _buildNavItem(Icons.explore, "Explore", 1),
          _buildNavItem(Icons.grain, "Fish Diversity", 2),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = widget.selectedIndex == index;

    return GestureDetector(
      onTap: () {
        widget.onItemSelected(index);  // Notify parent about the selection
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isSelected)
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF0077B6),
              ),
              child: Center(
                child: Icon(
                  icon,
                  size: 28,
                  color: Colors.white,
                ),
              ),
            )
          else
            Icon(
              icon,
              size: 28,
              color: Colors.grey.shade500,
            ),
          const SizedBox(height: 5),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? const Color(0xFF0077B6) : Colors.grey.shade500,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: isSelected ? 14 : 12,
            ),
          ),
        ],
      ),
    );
  }
}
