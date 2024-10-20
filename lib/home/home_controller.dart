import 'dart:convert';
import 'dart:io';

import 'package:carousel_slider/carousel_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api_modal.dart';
import 'home_repository.dart';
import 'search_modal.dart';

class ImageController extends GetxController {
  var images = <dynamic>[].obs;
  var searchImage = <Results>[].obs;
  int? prevIndex;

  var isLoading = false.obs;
  var carouselController = CarouselSliderController();
  final TextEditingController searchController = TextEditingController();
  RxInt selectedTab = 1.obs;
  int? index;
  late ProductRes res;
  RxList<Product> productList = <Product>[].obs;
  RxList<Product> orginalProductList = <Product>[].obs;
  RxList<Product> addProductList = <Product>[].obs;
  RxList numberOfProduct = [].obs;
  Map<int, int> mapOfIds = {};
  RxBool isFav = false.obs;
  RxList<int> favList = <int>[].obs;

  @override
  void onInit() {
    super.onInit();
    getDataMethod();
  }

  addProducttoCard(int? id) {
    numberOfProduct.add(id);
  }

  Future<void> searchProduct() async {
    if (selectedTab.value == 1) {
      List<Product> result = [];
      for (int i = 0; i < orginalProductList.length; i++) {
        if (orginalProductList[i]
            .name!
            .toLowerCase()
            .contains(searchController.text)) {
          result.add(orginalProductList[i]);
        }
      }
      productList.value = [...result];
    } else {
      List<Product> result = [];
      for (int i = 0; i < orginalProductList.length; i++) {
        if (favList.contains(orginalProductList[i].id) &&
            orginalProductList[i]
                .name!
                .toLowerCase()
                .contains(searchController.text)) {
          result.add(orginalProductList[i]);
        }
      }
      productList.value = [...result];
    }
  }

  Future<void> filterFavProduct() async {
    searchController.text = "";
    List<Product> fav = [];
    if (selectedTab.value == 2) {
      print("2___$productList");
      print("2___");
      for (int i = 0; i < orginalProductList.length; i++) {
        if (favList.contains(orginalProductList[i].id)) {
          fav.add(orginalProductList[i]);
          print("2___");
        }
      }
      print("2___$fav");
      productList.value = [...fav];
      print("2___$productList");
    } else {
      print("1___");
      productList.value = [...orginalProductList.value];
    }
  }

  Future<void> getDataMethod() async {
    try {
      var result = await productRepository.getProductData();
      if (result['result'] == "success") {
        res = ProductRes.fromJson(result);
        orginalProductList.value = res.product ?? [];
        productList.value = res.product ?? [];
      }
      print(res);
    } catch (e) {
      print("dhbfbdh$e");
    }
  }

  Future<void> fetchImages() async {
    try {
      isLoading.value = true;
      final response = await http.get(
        Uri.parse('https://api.npoint.io/44baf1cec4126a8046b6'),
      );

      if (response.statusCode == 200) {
        var res = json.decode(response.body.toString());
        var newImages = res.map((item) => ProductRes.fromJson(item)).toList();
        print(newImages);
        images.value = newImages;
      } else {
        Get.snackbar("Error", "Sorry Cannot Get data",
            backgroundColor: Colors.black, colorText: Colors.white);
      }
      isLoading.value = false;
    } catch (e) {
      Get.snackbar("Error", "${e}",
          backgroundColor: Colors.black, colorText: Colors.white);
    }
  }

  Future<void> saveSearchQuery(String query) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString("token") ?? "";
    if (userId != "") {
      await FirebaseFirestore.instance.collection('searchHistory').add({
        'query': query,
        'userId': userId,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } else {
      if (kDebugMode) {
        print("=========No User Id Data Found");
      }
    }
  }

  var profileImage = Rx<File?>(null);
  var name = "John Doe".obs;
  var place = "New York, USA".obs;

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      profileImage.value = File(pickedFile.path);
    }
  }

  void showLogoutDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text(
          'Logout',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        content: const Text(
          'Are you sure you want to logout?',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.red[700],
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    Get.back();
                  },
                  child: const Text(
                    'No',
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.blueGrey[700],
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    Get.back();
                    logout();
                  },
                  child: const Text(
                    'Yes',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void logout() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await FirebaseAuth.instance.signOut();
      bool isCleared = await prefs.clear();
      if (isCleared) {
        Get.offAllNamed('/');
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error logging out: $e");
      }
    }
  }
}
