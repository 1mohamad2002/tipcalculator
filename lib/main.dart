import 'dart:math'; // Import to use Random

import 'package:flutter/material.dart';

void main() {
  runApp(TipCalculatorApp());
}

class TipCalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TipCalculator(),
    );
  }
}

class TipCalculator extends StatefulWidget {
  @override
  _TipCalculatorState createState() => _TipCalculatorState();
}

class _TipCalculatorState extends State<TipCalculator> {
  final TextEditingController costController = TextEditingController();
  final TextEditingController groupController = TextEditingController();
  bool winner = false; // Changed variable name to 'winner' for readability
  double result = 0.0;
  int winnerNumber = -1; // Winner's random number (this will be the number of the person who doesn't pay)
  Random random = Random();

  // Function to calculate the tip and determine the winner
  void calculateTip(double percentage) {
    double cost = double.tryParse(costController.text) ?? 0;
    int group = int.tryParse(groupController.text) ?? 1;

    double tip = cost * (percentage / 100);
    double total = cost + tip;

    // Generate a random number between 1 and group only if the 'winner' checkbox is checked
    if (winner) {
      winnerNumber = random.nextInt(group) + 1;  // Random number from 1 to group
      result = total / (group - 1); // One person doesn't pay
    } else {
      result = total / group; // Everyone pays equally
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tip Calculator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: costController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Total Cost',
              ),
            ),
            TextField(
              controller: groupController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Number of People',
              ),
            ),
            Row(
              children: [
                Checkbox(
                  value: winner,
                  onChanged: (value) {
                    setState(() {
                      winner = value!;
                    });
                  },
                ),
                Text("One person doesn't pay (guessed the number)"),
              ],
            ),
            SizedBox(height: 16),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () => calculateTip(0),
                      child: Text('Bad (0%)'),
                    ),
                    ElevatedButton(
                      onPressed: () => calculateTip(5),
                      child: Text('Good (5%)'),
                    ),
                  ],
                ),
                SizedBox(height: 16), // Space between rows
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () => calculateTip(15),
                      child: Text('Very Good (15%)'),
                    ),
                    ElevatedButton(
                      onPressed: () => calculateTip(20),
                      child: Text('Excellent (20%)'),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'Amount per person: \$${result.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            // Show the winner's random number
            if (winner && winnerNumber != -1)
              Text(
                'The winner is person number: $winnerNumber\nThey do not have to pay!',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green),
              ),
          ],
        ),
      ),
    );
  }
}
