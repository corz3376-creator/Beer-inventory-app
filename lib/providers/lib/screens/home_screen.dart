import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/inventory_provider.dart';
import '../models/inventory_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedCategory = 'All';
  final List<String> _categories = ['All', 'beer', 'wine', 'spirits'];

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<InventoryProvider>();
    final filteredItems = provider.getItemsByCategory(_selectedCategory);

    return Scaffold(
      appBar: AppBar(
        title: Text('Beer Inventory'),
      ),
      body: Column(
        children: [
          _buildCategoryFilter(),
          Expanded(
            child: filteredItems.isEmpty
              ? Center(child: Text('Tap + to add beers'))
              : ListView.builder(
                itemCount: filteredItems.length,
                itemBuilder: (context, index) {
                  final item = filteredItems[index];
                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: item.isLowStock ? Colors.red : Colors.brown,
                        child: Icon(Icons.beer, color: Colors.white),
                      ),
                      title: Text(item.name),
                      subtitle: Text('${item.brand} - Stock: ${item.currentStock}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.minus),
                            onPressed: () => provider.updateStock(item.id, item.currentStock - 1),
                          ),
                          IconButton(
                            icon: Icon(Icons.plus),
                            onPressed: () => provider.updateStock(item.id, item.currentStock + 1),
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
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16),
        color: Colors.brown.shade100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text('Total: ${provider.items.length}'),
            Text('Low Stock: ${provider.lowStockCount}', style: TextStyle(color: Colors.red)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context, provider),
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return Container(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: _categories.map((cat) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: ChoiceChip(
              label: Text(cat.toUpperCase()),
              selected: _selectedCategory == cat,
              onSelected: (selected) {
                if (selected) setState(() => _selectedCategory = cat);
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  void _showAddDialog(BuildContext context, InventoryProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Beer'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(decoration: InputDecoration(labelText: 'Name')),
            TextField(decoration: InputDecoration(labelText: 'Brand')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Add')),
        ],
      ),
    );
  }
}
