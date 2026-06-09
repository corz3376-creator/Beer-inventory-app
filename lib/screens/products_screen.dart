ListTile(
  title: Text(product.name),
  subtitle: Text(
    'Category: ${product.category}
'
    'Brand: ${product.brand}',
  ),
  trailing: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      IconButton(
        icon: const Icon(Icons.edit),
        onPressed: () {
          // edit product
        },
      ),
      IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () {
          // delete product
        },
      ),
    ],
  ),
)
