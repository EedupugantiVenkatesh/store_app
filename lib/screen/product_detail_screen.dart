import 'package:flutter/material.dart';
import 'package:product_catalog_app/model/catalog_model.dart';

class ProductDetailScreen extends StatefulWidget {
  final CategoryModel product;
  final List<String> favorites;
  final Function(String) onFavoriteToggle;

  const ProductDetailScreen({
    super.key,
    required this.product,
    required this.favorites,
    required this.onFavoriteToggle,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late bool isFavorite;

  @override
  void initState() {
    super.initState();
    isFavorite = widget.favorites.contains(widget.product.id);
  }

  void _toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
    });
    widget.onFavoriteToggle(widget.product.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details'),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : null,
            ),
            onPressed: _toggleFavorite,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Full size product image
            Container(
              width: double.infinity,
              height: 300,
              child: Image.network(
                widget.product.image,
                fit: BoxFit.contain,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    widget.product.name,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  SizedBox(height: 8),
                  // Price
                  Text(
                    '\$${widget.product.price}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  // Description (if available in the model)
                  if (widget.product.description != null) ...[
                    Text(
                      'Description',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    SizedBox(height: 8),
                    Text(widget.product.description!),
                    SizedBox(height: 16),
                  ],
                  // Category (if available in the model)
                  if (widget.product.category != null) ...[
                    Text(
                      'Category',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    SizedBox(height: 8),
                    Text(widget.product.category!),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 