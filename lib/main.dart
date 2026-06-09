import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Fully-qualified package paths pointing directly to your architecture
import 'package:beer_inventory_app/providers/inventory_provider.dart';
import 'package:beer_inventory_app/screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.amber,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
