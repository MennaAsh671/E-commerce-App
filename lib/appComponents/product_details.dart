import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ecommerceapp/models/product_model.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          product.title,
          style: const TextStyle(
            color: Colors.grey,
          ),
        ),
        backgroundColor: Colors.cyan,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CarouselSlider(
                options: CarouselOptions(
                  height: 400,
                  enlargeCenterPage: true,
                  enableInfiniteScroll: false,
                ),
                items: product.images.map((image) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Image.network(
                        image,
                        fit: BoxFit.cover,
                      );
                    },
                  );
                }).toList(),
              ),
              Text("Product Name: ${product.title}"),
              Text("Product Price: \$${product.price.toString()}"),
              Text("Product Description: ${product.description}"),
              Text("Product Possible discount: ${product.discountPercentage}"),
              Text("Product Brand: ${product.brand}"),
              Text("Product Category: ${product.category}"),
              Text("Product Ratings: ${product.rating}"),
              ElevatedButton(
                onPressed: () {
                  addToCart(context, product);
                },
                child: const Text("Add to Cart"),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> addToCart(BuildContext context, Product product) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? cartItems = prefs.getStringList('cartItems');

    cartItems ??= [];
    Map<String, dynamic> productDetails = {
      'title': product.title,
      'price': product.price,
      'thumbnail': product.thumbnail,
    };
    String productDetailsJson = jsonEncode(productDetails);
    cartItems.add(productDetailsJson);

    await prefs.setStringList('cartItems', cartItems);

    SnackBar snackBar = const SnackBar(
      content: Text("Added successfully!"),
      duration: Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
