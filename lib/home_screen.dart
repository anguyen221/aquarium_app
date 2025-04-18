// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'fish.dart';
import 'database_helper.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  List<Fish> fishList = [];
  Color selectedColor = Colors.blue;
  double selectedSpeed = 1.0;
  late Ticker _ticker;
  final DatabaseHelper _dbHelper = DatabaseHelper(); 

  @override
  void initState() {
    super.initState();
    _ticker = Ticker(_updateFishPositions)..start();
    _loadSettings();
  }

  void _loadSettings() async {
    final settings = await _dbHelper.loadSettings();
    if (settings != null) {
      setState(() {
        selectedColor = _getColorFromString(settings['fish_color']);
        selectedSpeed = settings['fish_speed'];
      });
    }
  }

  Color _getColorFromString(String colorString) {
    switch (colorString) {
      case 'red':
        return Colors.red;
      case 'green':
        return Colors.green;
      default:
        return Colors.blue;
    }
  }

  void _addFish() {
    if (fishList.length < 10) {
      final random = Random();
      setState(() {
        fishList.add(Fish(
          color: selectedColor,
          speed: selectedSpeed,
          x: random.nextDouble() * 250,
          y: random.nextDouble() * 250,
          dx: (random.nextDouble() - 0.5) * selectedSpeed * 2,
          dy: (random.nextDouble() - 0.5) * selectedSpeed * 2,
        ));
      });
    }
  }

  void _removeFish() {
    if (fishList.isNotEmpty) {
      setState(() {
        fishList.removeLast();
      });
    }
  }

  void _updateFishPositions(Duration duration) {
    setState(() {
      for (var fish in fishList) {
        fish.x += fish.dx;
        fish.y += fish.dy;

        if (fish.x <= 0 || fish.x >= 270) fish.dx *= -1;
        if (fish.y <= 0 || fish.y >= 270) fish.dy *= -1;
      }
    });
  }

  void _saveSettings() async {
    await _dbHelper.saveSettings(fishList.length, selectedSpeed, _getStringFromColor(selectedColor));
  }

  String _getStringFromColor(Color color) {
    if (color == Colors.red) return 'red';
    if (color == Colors.green) return 'green';
    return 'blue';
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Virtual Aquarium"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    color: Colors.lightBlue.shade100,
                    border: Border.all(color: Colors.blue, width: 2),
                  ),
                ),
                for (var fish in fishList)
                  Positioned(
                    left: fish.x,
                    top: fish.y,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: fish.color,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _addFish,
                  child: Text("Add Fish"),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _removeFish,
                  child: Text("Remove Fish"),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text("Select Fish Color:"),
            DropdownButton<Color>(
              value: selectedColor,
              onChanged: (Color? newColor) {
                if (newColor != null) {
                  setState(() => selectedColor = newColor);
                  _saveSettings();
                }
              },
              items: [
                DropdownMenuItem(value: Colors.blue, child: Text("Blue")),
                DropdownMenuItem(value: Colors.red, child: Text("Red")),
                DropdownMenuItem(value: Colors.green, child: Text("Green")),
              ],
            ),
            SizedBox(height: 10),
            Text("Set Fish Speed:"),
            Slider(
              value: selectedSpeed,
              min: 0.5,
              max: 3.0,
              divisions: 5,
              label: selectedSpeed.toStringAsFixed(1),
              onChanged: (double newSpeed) {
                setState(() {
                  selectedSpeed = newSpeed;
                  _saveSettings();
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
