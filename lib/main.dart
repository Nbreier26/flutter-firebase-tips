import 'package:flutter/material.dart';  
import 'package:firebase_core/firebase_core.dart';  
import 'package:firebase_database/firebase_database.dart';  

void main() async {  
  WidgetsFlutterBinding.ensureInitialized();  
  await Firebase.initializeApp(  
    options: FirebaseOptions(  
      apiKey: "AIzaSyDoVzmzbtzrlWO3ZKqcYLdEXW0FCwazyCo",  
      appId: "1:1008143527601:android:d4bba7f297b6b445737c90",  
      messagingSenderId: "1008143527601",  
      projectId: "flutter-c024f",  
      databaseURL: "https://flutter-c024f-default-rtdb.firebaseio.com/",  
    ),  
  );  
  runApp(const MyApp());  
}  

class MyApp extends StatelessWidget {  
  const MyApp({super.key});  

  @override  
  Widget build(BuildContext context) {  
    return MaterialApp(  
      title: 'Tip Calculator',  
      theme: ThemeData(primarySwatch: Colors.blue),  
      home: const TipCalculatorScreen(),  
    );  
  }  
}  

class TipCalculatorScreen extends StatefulWidget {  
  const TipCalculatorScreen({super.key});  

  @override  
  _TipCalculatorScreenState createState() => _TipCalculatorScreenState();  
}  

class _TipCalculatorScreenState extends State<TipCalculatorScreen> {  
  final TextEditingController _billController = TextEditingController();  
  double _tipPercentage = 15;  
  double _billAmount = 0;  

  double get _tipAmount => _billAmount * (_tipPercentage / 100);  
  double get _totalAmount => _billAmount + _tipAmount;  

  final DatabaseReference _database = FirebaseDatabase.instance.ref('tips');  

  void _saveTip() async {  
    if (_billAmount <= 0) return;  

    final tipData = {  
      'billAmount': _billAmount,  
      'tipPercentage': _tipPercentage,  
      'tipAmount': _tipAmount,  
      'totalAmount': _totalAmount,  
      'createdAt': DateTime.now().toIso8601String(),  
    };  

    await _database.push().set(tipData);  

    ScaffoldMessenger.of(context).showSnackBar(  
      const SnackBar(content: Text('Tip saved successfully!')),  
    );  
  }  

  @override  
  Widget build(BuildContext context) {  
    return Scaffold(  
      appBar: AppBar(title: const Text('Tip Calculator')),  
      body: Padding(  
        padding: const EdgeInsets.all(16.0),  
        child: Column(  
          crossAxisAlignment: CrossAxisAlignment.start,  
          children: [  
            TextField(  
              controller: _billController,  
              keyboardType: TextInputType.number,  
              decoration: const InputDecoration(labelText: 'Bill Amount'),  
              onChanged: (value) {  
                setState(() {  
                  _billAmount = double.tryParse(value) ?? 0;  
                });  
              },  
            ),  
            const SizedBox(height: 16),  
            Row(  
              mainAxisAlignment: MainAxisAlignment.spaceBetween,  
              children: [  
                const Text('Tip Percentage:'),  
                Text('${_tipPercentage.toStringAsFixed(0)}%'),  
              ],  
            ),  
            Slider(  
              value: _tipPercentage,  
              min: 0,  
              max: 30,  
              divisions: 30,  
              label: '${_tipPercentage.toStringAsFixed(0)}%',  
              onChanged: (value) {  
                setState(() {  
                  _tipPercentage = value;  
                });  
              },  
            ),  
            const SizedBox(height: 16),  
            Text(  
              'Tip: \$${_tipAmount.toStringAsFixed(2)}',  
              style: const TextStyle(fontSize: 18),  
            ),  
            Text(  
              'Total: \$${_totalAmount.toStringAsFixed(2)}',  
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),  
            ),  
            const SizedBox(height: 24),  
            ElevatedButton(  
              onPressed: _saveTip,  
              child: const Text('Save Tip'),  
            ),  
          ],  
        ),  
      ),  
    );  
  }  
}  
