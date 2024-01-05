import "dart:convert";

import "package:flutter/material.dart";
import "package:http/http.dart" as http;

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  bool isOn = false;

  Future<http.Response> switchLed() {
    return http.get(Uri.parse(
        isOn ? "http://192.168.1.15:8080/off" : "http://192.168.1.15:8080/on"));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple)),
      home: Scaffold(
        backgroundColor: isOn ? Colors.black45 : Colors.blue,
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text(
            "I-K(***)Y - IoT",
            style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
          ),
        ),
        body: Center(
          child: ElevatedButton(
              onPressed: () async {
                try {
                  http.Response response = await switchLed();
                  // Handle the response as needed
                  Map<String, dynamic> data = json.decode(response.body);
                  setState(() {
                    isOn = data["ledState"];
                  });
                } catch (e) {
                  print("Error: $e");
                  // Handle the error gracefully
                }
              },
              child: Text(isOn ? "TURN ON" : "TURN OFF")),
        ),
      ),
    );
  }
}
