import 'package:flutter/material.dart';
import 'package:product_catalog_app/constants/app_constants.dart';
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
        title: const Text(AppConstants.productDetailsTitle),
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
            Container(
              width: double.infinity,
              height: AppConstants.detailImageHeight,
              child: Image.network(
                widget.product.image,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => 
                    const Center(child: Icon(Icons.error, size: 50)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.name,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: AppConstants.smallPadding),
                  Text(
                    widget.product.formattedPrice,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (widget.product.description != null) ...[
                    const SizedBox(height: AppConstants.defaultPadding),
                    Text(
                      AppConstants.description,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppConstants.smallPadding),
                    Text(widget.product.description!),
                  ],
                  if (widget.product.category != null) ...[
                    const SizedBox(height: AppConstants.defaultPadding),
                    Text(
                      AppConstants.category,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppConstants.smallPadding),
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