import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class TrackerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DiaryScreen();
  }
}

class DiaryScreen extends StatefulWidget {
  @override
  _DiaryScreenState createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen> {
  final List<Map<String, dynamic>> _foodEntries = [
    {'title': 'Espresso', 'subtitle': '1 shot or solo', 'kcal': 2.7},
    {'title': 'Tesco, Semi-Skimmed Milk', 'subtitle': '1 x 100 mL', 'kcal': 49.9},
    {'title': 'Croissant, Plain', 'subtitle': '1 small', 'kcal': 191.3},
    {'title': "Starbuck's, latte, flat white, with whole milk", 'subtitle': '1 Small', 'kcal': 110.0},
    {'title': 'Dates, Medjool', 'subtitle': '1 date, pitted', 'kcal': 66.5},
    {'title': 'Snow Peas, Edible Pea Pods, Raw', 'subtitle': '12 g', 'kcal': 5.0},
    {'title': 'Mushrooms, Raw', 'subtitle': '107 g', 'kcal': 23.5},
  ];

  // Method to display the dialog and add food entry
  Future<void> _addFoodEntry() async {
    String foodName = '';
    String foodDetails = '';
    double? foodCalories;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Food Entry'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Food Name'),
                onChanged: (value) {
                  foodName = value;
                },
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Details'),
                onChanged: (value) {
                  foodDetails = value;
                },
              ),
              TextField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Calories (kcal)'),
                onChanged: (value) {
                  foodCalories = double.tryParse(value);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (foodName.isNotEmpty && foodCalories != null) {
                  setState(() {
                    _foodEntries.add({
                      'title': foodName,
                      'subtitle': foodDetails,
                      'kcal': foodCalories!,
                    });
                  });
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sep 28, 2024'),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Pie Chart Section
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      PieChartWidget(
                        label: 'Consumed',
                        value: 2354,
                        color: Colors.green,
                      ),
                      PieChartWidget(
                        label: 'Burned',
                        value: 2785,
                        color: Colors.orange,
                      ),
                      PieChartWidget(
                        label: 'Over',
                        value: 67,
                        color: Colors.red,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          // Food Entries
          Expanded(
            child: ListView.builder(
              itemCount: _foodEntries.length,
              itemBuilder: (context, index) {
                final food = _foodEntries[index];
                return foodEntry(food['title'], food['subtitle'], food['kcal']);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addFoodEntry,
        child: const Icon(Icons.add),
        backgroundColor: Colors.orange,
      ),
    );
  }

  Widget foodEntry(String title, String subtitle, double kcal) {
    return ListTile(
      leading: const Icon(Icons.apple, color: Colors.red),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Text('${kcal.toStringAsFixed(1)} kcal'),
    );
  }
}

class PieChartWidget extends StatelessWidget {
  final String label;
  final double value;
  final Color color;

  PieChartWidget(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PieChart(
          dataMap: {label: value},
          chartRadius: 80,
          chartValuesOptions: ChartValuesOptions(showChartValues: false),
          colorList: [color],
          totalValue: value,
        ),
        const SizedBox(height: 8),
        Text(
          '$value kcals',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(label),
      ],
    );
  }
}
