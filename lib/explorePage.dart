import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:csv/csv.dart';
import 'aboutPage.dart';
import 'DiversityPage.dart';
import 'dart:math';

class ExplorePage extends StatefulWidget {
  const ExplorePage({Key? key}) : super(key: key);

  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  int _selectedIndex = 1;
  final TextEditingController _searchController = TextEditingController();
  Map<String, dynamic>? _searchResult;
  bool _isLoading = false;
  List<String> _recentSearches = [];
  List<String> _popularFish = [
    'Tuna',
    'Salmon',
    'Sole',
    'Mackerel',
    'Char'
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

    Future<void> _searchFish(String name) async {
  if (name.isEmpty) return;

  setState(() {
    _isLoading = true;
    _searchResult = null;
  });

  try {
    final String fileContent = await rootBundle.loadString('assets/fish_data.csv');
    List<List<dynamic>> csvTable = const CsvToListConverter().convert(fileContent);
    
    var fishData = csvTable.skip(1).firstWhere(
      (row) => row[0].toString().toLowerCase() == name.toLowerCase(),
      orElse: () => [],
    );

    if (fishData.isNotEmpty) {
      Map<String, dynamic> result = {
        'Fish Name': fishData[0],
        'Fish Family': fishData[1],
        'Region': fishData[2],
        'Season': fishData[3],
        'Is Sustainable': fishData[4],
        'Best Month': fishData[5],
        'Worst Month': fishData[6],
        'Number of Fish per m2': fishData[7],
        'Population Number': fishData[8],
        'Fish Consumption Rate': fishData[9],
        'Mortality Rate': fishData[10],
        'Cause of Threatening': fishData[11],
        'Threatened': fishData[12],
        'Pollution Level': fishData[13],
        'Threat Level Percentage': fishData[14],
      };
      
      setState(() {
        _searchResult = result;
        if (!_recentSearches.contains(name)) {
          _recentSearches.insert(0, name);
          if (_recentSearches.length > 5) {
            _recentSearches.removeLast();
          }
        }
      });
    } else {
      // Set empty map to indicate no data found
      setState(() {
        _searchResult = {};
      });
    }
  } catch (e) {
    print('Error loading or parsing CSV: $e');
    // Set empty map in case of error
    setState(() {
      _searchResult = {};
    });
  } finally {
    setState(() {
      _isLoading = false;
    });
  }
}
  Widget _buildSearchBar() {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(30),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 10,
          offset: const Offset(0, 5),
        ),
      ],
    ),
    child: TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: 'Search for a fish species...',
        prefixIcon: const Icon(Icons.search, color: Color(0xFF0077B6)),
        suffixIcon: IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            _searchController.clear();
            setState(() {
              _searchResult = null;
            });
          },
        ),
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      ),
      onSubmitted: _searchFish,
    ),
  );
}

  Widget _buildExploreSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_recentSearches.isNotEmpty) ...[
          const Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              'Recent Searches',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0077B6),
              ),
            ),
          ),
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              itemCount: _recentSearches.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: ActionChip(
                    label: Text(_recentSearches[index]),
                    onPressed: () => _searchFish(_recentSearches[index]),
                    backgroundColor: const Color(0xFF00B4D8).withOpacity(0.1),
                  ),
                );
              },
            ),
          ),
        ],
        const Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            'Popular Species',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0077B6),
            ),
          ),
        ),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: _popularFish.map((fish) => ActionChip(
            label: Text(fish),
            onPressed: () => _searchFish(fish),
            backgroundColor: const Color(0xFF00B4D8).withOpacity(0.1),
          )).toList(),
        ),
      ],
    );
  }

  Widget _buildSearchResult() {
  if (_isLoading) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  if (_searchResult == null) {
    return _buildExploreSection();
  }

  // Check if _searchResult is empty (no fish found)
  if (_searchResult!.isEmpty) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No fish data found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try searching for a different species',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 24),
          TextButton(
            onPressed: () {
              setState(() {
                _searchResult = null;
                _searchController.clear();
              });
            },
            child: const Text('Return to Explore'),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF0077B6),
            ),
          ),
        ],
      ),
    );
  }

  return SingleChildScrollView(
    padding: const EdgeInsets.all(20),
    child: Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _searchResult!['Fish Name'].toString(),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0077B6),
                        ),
                      ),
                      Text(
                        _searchResult!['Fish Family'].toString(),
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _searchResult!['Is Sustainable'].toString().toLowerCase() == 'yes'
                        ? Colors.green.withOpacity(0.1)
                        : Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _searchResult!['Is Sustainable'].toString(),
                    style: TextStyle(
                      color: _searchResult!['Is Sustainable'].toString().toLowerCase() == 'yes'
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 30),
            _buildInfoSection('Location & Season', [
              _searchResult!['Region'].toString(),
              'Season: ${_searchResult!['Season']}',
              'Best Month: ${_searchResult!['Best Month']}',
              'Worst Month: ${_searchResult!['Worst Month']}',
            ]),
            _buildInfoSection('Population Statistics', [
              'Density: ${_searchResult!['Number of Fish per m2']} per m²',
              'Population: ${_searchResult!['Population Number']}',
              'Consumption Rate: ${_searchResult!['Fish Consumption Rate']} kg/year',
              'Mortality Rate: ${_searchResult!['Mortality Rate']}%',
            ]),
            _buildInfoSection('Environmental Status', [
              'Threatened: ${_searchResult!['Threatened']}',
              'Cause: ${_searchResult!['Cause of Threatening']}',
              'Pollution Level: ${_searchResult!['Pollution Level']}',
              'Threat Level: ${_searchResult!['Threat Level Percentage']}%',
            ]),
          ],
        ),
      ),
    ),
  );
}
  Widget _buildInfoSection(String title, List<String> details) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF023E8A),
          ),
        ),
        const SizedBox(height: 10),
        ...details.map((detail) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Text(
            detail,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF6C757D),
            ),
          ),
        )),
        const SizedBox(height: 20),
      ],
    );
  }

  void _onItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AboutPage()),
        );
        break;
      case 1:
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DiversityPage()),
        );
        break;
    }
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () => _onItemSelected(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isSelected)
            Container(
              width: 60,
              height: 60,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF0077B6),
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


// Add these variables to your _ExplorePageState class
final List<String> _months = [
  'January', 'February', 'March', 'April', 'May', 'June',
  'July', 'August', 'September', 'October', 'November', 'December'
];
Map<String, List<String>> _monthlyFishReport = {};

// Add this method to analyze fish for selected month
Future<void> _analyzeFishByMonth(String selectedMonth) async {
  setState(() {
    _isLoading = true;
  });

  try {
    final String fileContent = await rootBundle.loadString('assets/fish_data_month.csv');
    List<List<dynamic>> csvTable = const CsvToListConverter().convert(fileContent);
    
    // Using Sets to automatically handle duplicates
    Set<String> bestFish = {};
    Set<String> worstFish = {};
    
    for (var row in csvTable.skip(1)) {
      // Convert to lowercase for comparison to ensure case-insensitive duplicates are caught
      if (row[4].toString().toLowerCase() == selectedMonth.toLowerCase()) {
        bestFish.add(row[0].toString());
      }
      if (row[5].toString().toLowerCase() == selectedMonth.toLowerCase()) {
        worstFish.add(row[0].toString());
      }
    }

    setState(() {
      _monthlyFishReport = {
        'Best Fish': bestFish.toList(), // Convert back to List for the report
        'Worst Fish': worstFish.toList(),
      };
    });
  } catch (e) {
    print('Error analyzing fish by month: $e');
  } finally {
    setState(() {
      _isLoading = false;
    });
  }
}
Future<void> _showMonthPicker(BuildContext context) async {
  final String? selectedMonth = await showDialog<String>(
    context: context,
    barrierColor: Colors.black54,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 10,
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Row(
                children: [
                  const Text(
                    'Select Month',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0077B6),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.grey),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Month Grid
              Container(
                constraints: const BoxConstraints(
                  maxHeight: 400,
                ),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.5,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: _months.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () => Navigator.pop(context, _months[index]),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFF0077B6).withOpacity(0.1),
                              const Color(0xFF00B4D8).withOpacity(0.1),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: const Color(0xFF0077B6).withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Stack(
                          children: [
                            // Background Icon
                            Positioned(
                              right: -10,
                              bottom: -10,
                              child: Icon(
                                Icons.calendar_today,
                                size: 50,
                                color: const Color(0xFF0077B6).withOpacity(0.1),
                              ),
                            ),
                            // Month Text
                            Center(
                              child: Text(
                                _months[index],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF0077B6),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    },
  );

  if (selectedMonth != null) {
    await _analyzeFishByMonth(selectedMonth);
    _showMonthlyReport(context, selectedMonth);
  }
}

void _showMonthlyReport(BuildContext context, String month) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Drag Handle
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        month,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0077B6),
                        ),
                      ),
                      const Text(
                        'Fish Report',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0077B6).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.calendar_today,
                      color: Color(0xFF0077B6),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildReportSection(
                      'Best Fish',
                      _monthlyFishReport['Best Fish'] ?? [],
                      Icons.thumb_up_outlined,
                      Colors.green,
                    ),
                    const SizedBox(height: 20),
                    _buildReportSection(
                      'Fish to Avoid',
                      _monthlyFishReport['Worst Fish'] ?? [],
                      Icons.thumb_down_outlined,
                      Colors.red,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

Widget _buildReportSection(String title, List<String> fishes, IconData icon, Color color) {
  return Container(
    padding: const EdgeInsets.all(15),
    decoration: BoxDecoration(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(15),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        if (fishes.isEmpty)
          Text(
            'No fish found for this month',
            style: TextStyle(
              color: Colors.grey[600],
              fontStyle: FontStyle.italic,
            ),
          )
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: fishes.map((fish) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                fish,
                style: const TextStyle(
                  color: Color(0xFF0077B6),
                  fontWeight: FontWeight.w500,
                ),
              ),
            )).toList(),
          ),
      ],
    ),
  );
}
// Add this helper method to build fish lists
Widget _buildFishList(String title, List<String> fishes) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Color(0xFF023E8A),
        ),
      ),
      const SizedBox(height: 10),
      if (fishes.isEmpty)
        const Text('No fish found for this month')
      else
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: fishes.map((fish) => Chip(
            label: Text(fish),
            backgroundColor: const Color(0xFF00B4D8).withOpacity(0.1),
          )).toList(),
        ),
    ],
  );
}
  @override
  @override
Widget build(BuildContext context) {
  return Scaffold(
    extendBodyBehindAppBar: true,
    backgroundColor: const Color(0xFFEFF6FC),
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
    body: SafeArea(
      child: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: _buildSearchResult(),
          ),
        ],
      ),
    ),
    floatingActionButton: Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [Color(0xFF0077B6), Color(0xFF00B4D8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: FloatingActionButton(
        onPressed: () => _showMonthPicker(context),
        child: const Icon(
          Icons.calendar_month,
          color: Colors.white,
        ),
        elevation: 4,
        backgroundColor: Colors.transparent,
      ),
    ),
    bottomNavigationBar: Container(
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
    ),
  );
}
}