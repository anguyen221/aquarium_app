// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Color selectedColor = Colors.blue;
  double selectedSpeed = 1.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Virtual Aquarium")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: Colors.lightBlue.shade100,
                border: Border.all(color: Colors.blue, width: 2),
              ),
              child: Center(child: Text("Aquarium", style: TextStyle(fontSize: 20))),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Placeholder for now
              },
              child: Text("Add Fish"),
            ),
            SizedBox(height: 10),
            Text("Select Fish Color:"),
            DropdownButton<Color>(
              value: selectedColor,
              onChanged: (Color? newColor) {
                if (newColor != null) {
                  setState(() => selectedColor = newColor);
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
                setState(() => selectedSpeed = newSpeed);
              },
            ),
          ],
        ),
      ),
    );
  }
}
