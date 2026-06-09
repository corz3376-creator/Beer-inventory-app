import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Automatically pulling in your existing modules
import 'providers/inventory_provider.dart'; // Verify your exact provider filename here
import 'screens/home_screen.dart';       // Verify your exact main dashboard screen filename here

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => InventoryProvider()),
      ],
      child: const BeerInventoryApp(),
    ),
  );
}

class BeerInventoryApp extends StatelessWidget {
  const BeerInventoryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Beer Inventory Tracking',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
        useMaterial3: true,
      ),
      home: const HomeScreen(), // Points directly to your interface screen
    );
  }
}

