import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../data/product.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {

  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    getProducts();
  }

  void getProducts() async {
    products.clear();
    Response response =
        await get(Uri.parse('https://crud.teamrabbil.com/api/v1/ReadProduct'));
    final Map<String, dynamic> decodedResponse = jsonDecode(response.body);
    // print(decodedResponse['data'].length);

    if(response.statusCode == 200 && decodedResponse['status'] == 'success') {
      // decodedResponse['data'].forEach((e){
      for(var e in decodedResponse['data']) {
        products.add(
          Product.toJson(e)
        );
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CRUD'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              getProducts();
            },
            icon: const Icon(Icons.refresh)
          )
        ],
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          return ListTile(
            contentPadding: const EdgeInsets.all(12),
            title: Text(products[index].productName),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Product Code: ${products[index].productCode}'),
                Text('Qty: ${products[index].qty}'),
              ],
            ),
            leading: Image.network(
              products[index].img, width: 50,
              errorBuilder: (_, __, ___) {
                return const Icon(
                  Icons.image,
                  size: 32,
                );
              },
            ),
            trailing: Text('${products[index].unitPrice}/='),
          );
        },
      ),
    );
  }
}
