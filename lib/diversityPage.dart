import 'package:flutter/material.dart';
import 'aboutPage.dart';
import 'explorePage.dart';
import 'package:fl_chart/fl_chart.dart';

class DiversityPage extends StatefulWidget {
  const DiversityPage({Key? key}) : super(key: key);

  @override
  _DiversityPageState createState() => _DiversityPageState();
}

class _DiversityPageState extends State<DiversityPage> {
  int _selectedIndex = 2;

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
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ExplorePage()),
        );
        break;
      case 2:
        break;
    }
  }

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16.0, 100.0, 16.0, 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('Fish Family Distribution', Icons.pie_chart),
            _buildCard(
              child: const Expanded(child: FishFamilyChart()),
            ),
            const SizedBox(height: 24),

            _buildSectionHeader('Regional Distribution', Icons.map),
            _buildCard(
              child: const SizedBox(height: 300, child: RegionPieChart()),
            ),
            const SizedBox(height: 24),

            _buildSectionHeader('Seasonal Distribution', Icons.calendar_today),
            _buildCard(
              child: const SizedBox(
                  height: 300, child: SeasonalDistributionChart()),
            ),
            const SizedBox(height: 24),

            _buildSectionHeader(
                'Threatening Causes', Icons.warning_amber_rounded),
            _buildCard(
              child: const SizedBox(
                  height: 300, child: ThreateningCausesHeatmap()),
            ),
            // In your DiversityPage's Column children, add:
            _buildSectionHeader(
                'Pollution Level vs Mortality Rate (%)', Icons.show_chart),
            _buildCard(
              child: Image.asset(
                'assets/pollution_mortality.jpeg', // Make sure to use your actual image path
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 24),

             _buildSectionHeader(
                'Pollution Number vs Sustainability\n Score', Icons.show_chart),
            _buildCard(
              child: Image.asset(
                'assets/Population_sustainability.jpeg', // Make sure to use your actual image path
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 24),
             _buildSectionHeader(
                'Threatened vs Non_Threatened Fish', Icons.show_chart),
            _buildCard(
              child: Image.asset(
                'assets/Threatened_NonThreatened.jpeg', // Make sure to use your actual image path
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 24),
             _buildSectionHeader(
                'Correlation Metrics', Icons.show_chart),
            _buildCard(
              child: Image.asset(
                'assets/correlation_metric.jpeg', // Make sure to use your actual image path
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 24),
             _buildSectionHeader(
                'Population Number vs Fish \n Consumption Rate', Icons.show_chart),
            _buildCard(
              child: Image.asset(
                'assets/population_consumtion.jpeg', // Make sure to use your actual image path
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemSelected: _onItemSelected,
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Icon(
            icon,
            color: const Color(0xFF0077B6),
            size: 24,
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: child,
        ),
      ),
    );
  }
}

// [Previous chart implementations remain the same]
class FishFamilyChart extends StatefulWidget {
  const FishFamilyChart({Key? key}) : super(key: key);

  @override
  State<FishFamilyChart> createState() => _FishFamilyChartState();
}

class _FishFamilyChartState extends State<FishFamilyChart> {
  int touchedIndex = -1;

  final fishData = const [
    ('Salmonidae', 142, Color(0xFF60A5FA)), // Blue
    ('Serranidae', 141, Color(0xFFC084FC)), // Purple
    ('Pleuronectidae', 138, Color(0xFF67E8F9)), // Cyan
    ('Lutjanidae', 137, Color(0xFF86EFAC)), // Green
    ('Scombridae', 135, Color(0xFFFCA5A5)), // Red
    ('Pomacentridae', 133, Color(0xFFFDBA74)), // Orange
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 220,
          child: PieChart(
            PieChartData(
              pieTouchData: PieTouchData(
                touchCallback: (FlTouchEvent event, pieTouchResponse) {
                  setState(() {
                    if (!event.isInterestedForInteractions ||
                        pieTouchResponse == null ||
                        pieTouchResponse.touchedSection == null) {
                      touchedIndex = -1;
                      return;
                    }
                    touchedIndex =
                        pieTouchResponse.touchedSection!.touchedSectionIndex;
                  });
                },
              ),
              borderData: FlBorderData(show: false),
              sectionsSpace: 2,
              centerSpaceRadius: 30,
              sections: showingSections(),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 16,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: List.generate(
            fishData.length,
            (index) => SizedBox(
              width: 120,
              child: LegendItem(
                color: fishData[index].$3,
                text: '${fishData[index].$1}\n(${fishData[index].$2})',
                isActive: touchedIndex == index,
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(fishData.length, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 16.0 : 12.0;
      final radius = isTouched ? 70.0 : 60.0;

      return PieChartSectionData(
        color: fishData[i].$3,
        value: fishData[i].$2.toDouble(),
        title: '${fishData[i].$2}',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: const [
            Shadow(
              color: Colors.black26,
              blurRadius: 2,
            ),
          ],
        ),
      );
    });
  }
}

class LegendItem extends StatelessWidget {
  final Color color;
  final String text;
  final bool isActive;

  const LegendItem({
    Key? key,
    required this.color,
    required this.text,
    required this.isActive,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withOpacity(isActive ? 1 : 0.8),
            border: Border.all(
              color: Colors.white,
              width: 1,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 12,
              height: 1.2,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              color: isActive ? Colors.black : Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}

class SeasonalDistributionChart extends StatelessWidget {
  const SeasonalDistributionChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.5,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          barGroups: [
            makeGroupData(0, 220, Colors.green.shade400), // Spring
            makeGroupData(1, 214, Colors.orange.shade400), // Fall
            makeGroupData(2, 206, Colors.yellow.shade600), // Summer
            makeGroupData(3, 186, Colors.lightBlue.shade300), // Winter
          ],
          gridData: FlGridData(
            show: true,
            drawHorizontalLine: true,
            horizontalInterval: 20,
            drawVerticalLine: false,
          ),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 80,
                getTitlesWidget: (value, meta) {
                  const seasons = ['Spring', 'Fall', 'Summer', 'Winter'];
                  const icons = ['🌱', '🍂', '☀️', '❄️'];
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Column(
                      children: [
                        Text(
                          icons[value.toInt()],
                          style: const TextStyle(fontSize: 20),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          seasons[value.toInt()],
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 50,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
                    style: const TextStyle(fontSize: 12),
                  );
                },
              ),
            ),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: Colors.grey.withOpacity(0.2)),
          ),
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              tooltipBgColor: Colors.white,
              tooltipRoundedRadius: 8,
              tooltipPadding: const EdgeInsets.all(8),
            ),
          ),
        ),
      ),
    );
  }

  BarChartGroupData makeGroupData(int x, double y, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          width: 40,
          color: color,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(6),
            topRight: Radius.circular(6),
          ),
        ),
      ],
    );
  }
}

class RegionPieChart extends StatelessWidget {
  const RegionPieChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
        sections: [
          PieChartSectionData(
            value: 410,
            title: 'West Coast\n(410)',
            color: Colors.blue,
            radius: 100,
          ),
          PieChartSectionData(
            value: 274,
            title: 'East Coast\n(274)',
            color: Colors.green,
            radius: 100,
          ),
          PieChartSectionData(
            value: 142,
            title: 'Both\n(142)',
            color: Colors.orange,
            radius: 100,
          ),
        ],
        sectionsSpace: 2,
        centerSpaceRadius: 40,
      ),
    );
  }
}

class ThreateningCausesHeatmap extends StatelessWidget {
  const ThreateningCausesHeatmap({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> causes = [
      'Pollution',
      'Climate Change',
      'Habitat Destruction',
      'Overfishing'
    ];
    final List<double> values = [216, 214, 201, 194];
    final double maxValue =
        values.reduce((curr, next) => curr > next ? curr : next);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.5,
      ),
      itemCount: causes.length,
      itemBuilder: (context, index) {
        final double opacity = values[index] / maxValue;
        return Card(
          color: Colors.blue.withOpacity(opacity),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '${causes[index]}\n(${values[index].toInt()})',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: opacity > 0.5 ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
