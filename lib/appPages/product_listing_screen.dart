import 'dart:convert';
import 'package:ecommerceapp/models/product_model.dart';
import 'package:ecommerceapp/appPages//cartItems.dart';
import 'package:ecommerceapp/appPages/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ecommerceapp/appComponents/product_details.dart';

class MyProduct extends StatefulWidget {
  const MyProduct({Key? key}) : super(key: key);

  @override
  State<MyProduct> createState() => _MyProductState();
}

class _MyProductState extends State<MyProduct> {
  bool _prodLoading = true;

  void _productDetailPage(Product product) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProductDetailPage(product: product),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  MyProducts? dataFromAPI;
  _getData() async {
    try {
      String endpoint = "https://dummyjson.com/products";
      http.Response res = await http.get(Uri.parse(endpoint));
      if (res.statusCode == 200) {
        dataFromAPI =  MyProducts.fromJson(json.decode(res.body));
        _prodLoading = false;
        setState(() {});
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

/* Widget build goes after this */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        centerTitle: true,
        leading: IconButton(
          highlightColor: Colors.transparent,
          icon: const Icon(Icons.person),
          splashRadius: 15,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Profile(),
              ),
            );
          },
        ),
        actions: [
          IconButton(
            highlightColor: Colors.transparent,
            icon: const Icon(Icons.shopping_cart),
            splashRadius: 15,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MyCart(),
                ),
              );
            },
          ),
        ],
      ),
      backgroundColor: Colors.grey,
      body: _prodLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : dataFromAPI == null
              ? const Center(
                  child: Text("Failed to load data"),
                )
              : GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemCount: dataFromAPI!.products.length,
                  itemBuilder: (context, index) {
                    final product = dataFromAPI!.products[index];
                    return InkWell(
                      onTap: () {
                        _productDetailPage(product);
                      },
                      child: Container(
                          height: 150,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(
                                color: Colors.black,
                                width: 2,
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 0,
                                  spreadRadius: 1,
                                )
                              ]),
                          margin: const EdgeInsets.all(8.0),
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.network(
                                product.thumbnail,
                                height: 200,
                              ),
                              const SizedBox(height: 10),
                              Text(product.title),
                              const SizedBox(height: 5),
                              Text("\$${product.price.toString()}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                            ],
                          )),
                    );
                  },
              ),
    );
  }
}

