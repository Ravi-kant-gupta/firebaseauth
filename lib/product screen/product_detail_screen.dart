import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../home/api_modal.dart';
import '../home/home_controller.dart';

class ProductDetailPage extends StatelessWidget {
  Product item;

  ProductDetailPage({
    required this.item,
  });

  final ImageController controller = Get.find<ImageController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.center,
                height: 250,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    item.imageUrl ?? "",
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                item.name ?? "",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              SizedBox(height: 10),
              Text(
                item.description ?? "",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (controller.favList.contains(item.id)) {
            controller.favList.remove(item.id);
          } else {
            controller.favList.add(item.id!);
          }
        },
        backgroundColor: Colors.teal,
        child: Obx(() {
          return Icon(
            Icons.favorite,
            color: controller.favList.contains(item.id)
                ? Colors.red
                : Colors.white,
          );
        }),
      ),
    );
  }
}
