// import 'package:dio/dio.dart';
// //import '../data_source/photo_cached_data_source.dart';
// import '../models/product_model.dart';

// class ProductService {
//   String endpoint = "https://dummyjson.com/products";

//   Future<List<Product>> getProducts() async {
//     List<Product> products = [];
//     try {
//       var response = await Dio().get(endpoint);
//       var data = response.data;
//       print('Data type: ${data.runtimeType}');
//       Product product = Product.fromJson(data);
//       products.add(product);
//       print('Product added: ${products.length}');
//     } catch (e) {
//       print('Error fetching products: $e');
//     }
//     return products;
//   }
// }

// import 'package:dio/dio.dart';
// import '../models/product_model.dart';

// class ProductService {
//   String endpoint = "https://dummyjson.com/products";

//   Future<List<Product>> getProducts() async {
//     List<Product> products = [];
//     try {
//       var response = await Dio().get(endpoint);
//       var data = response.data;
//       if (data is Map<String, dynamic> && data.containsKey('products')) {
//         List<dynamic> productsData = data['products'];
//         products = productsData
//             .map((productData) => Product.fromJson(productData))
//             .toList();
//       }
//     } catch (e) {
//       print('Error fetching products: $e');
//     }
//     return products;
//   }
// }
