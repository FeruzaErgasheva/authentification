import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:lesson54_authentication/models/product.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductsHttpServices {
  Future<List<Product>> getProducts() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userId = sharedPreferences.getString("userId");

    Uri url = Uri.parse(
        'https://dars46-7f132-default-rtdb.firebaseio.com/products.json?orderBy="userId"&equalTo="$userId"');

    final response = await http.get(url);
    final data = jsonDecode(response.body);
    List<Product> products = [];

    if (data != null) {
      data.forEach((key, value) {
        products.add(
          Product(
            id: key,
            title: value['title'],
            userId: value['userId'],
          ),
        );
      });
    }

    return products;
  }

  Future<void> addProduct(String title) async {
    Uri url = Uri.parse(
        "https://dars46-7f132-default-rtdb.firebaseio.com/products.json");
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userId = sharedPreferences.getString("userId");

    final response = await http.post(
      url,
      body: jsonEncode(
        {
          "title": title,
          "userId": userId,
        },
      ),
    );

    print(response.body);
  }
}
