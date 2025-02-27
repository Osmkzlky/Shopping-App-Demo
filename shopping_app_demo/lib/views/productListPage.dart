// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:shopping_app_demo/components/customCard.dart';
import 'package:shopping_app_demo/models/Product.dart';

import 'package:shopping_app_demo/services/firebase_services.dart';
import 'package:shopping_app_demo/theme/colors.dart';

class ProductListPage extends StatelessWidget {
  final List product_ids;
  final String title;
  const ProductListPage({
    Key? key,
    required this.product_ids,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkWhite,
      appBar: AppBar(
        title: Text(title),
      ),
      body: FutureBuilder<Products>(
          future: FirebaseServices().getAllProducts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasData) {
              Products products = snapshot.data!;
              return GridView.builder(
                  itemCount: product_ids.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, childAspectRatio: 0.85),
                  itemBuilder: (context, index) {
                    Product product =
                        products.products[int.parse(product_ids[index])];
                    final formatPrice = NumberFormat.currency(
                            locale: "tr_Tr", symbol: "", decimalDigits: 0)
                        .format(int.parse(product.product_prices.values.first));
                    return CustomCard(
                        product: product, formatPrice: formatPrice);
                  });
            } else {
              return const Text("Veri Bulunamadı");
            }
          }),
    );
  }
}
