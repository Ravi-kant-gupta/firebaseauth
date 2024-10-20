import 'package:firebaseauth/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../product screen/product_detail_screen.dart';
import 'home_controller.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final ImageController imageController = Get.put(ImageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Get.to(() => ProfileScreen());
          },
          child: Obx(() {
            return CircleAvatar(
              radius: 60,
              backgroundColor: Colors.grey[200],
              child: imageController.profileImage.value == null
                  ? Icon(
                      Icons.person,
                      size: 40,
                      color: Colors.grey,
                    )
                  : ClipOval(
                      child: Image.file(
                        imageController.profileImage.value!,
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
            );
          }),
        ),
        title: const Text('Home'),
        actions: [
          IconButton(
              onPressed: () async {
                imageController.showLogoutDialog();
              },
              icon: const Icon(Icons.logout))
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: Container(
            margin: const EdgeInsets.all(8.0),
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Column(
              children: [
                TextField(
                  controller: imageController.searchController,
                  onChanged: (val) {
                    imageController.searchProduct();
                  },
                  decoration: InputDecoration(
                    hintText: 'Search for Product...',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.cancel),
                      padding: const EdgeInsets.all(15),
                      constraints: const BoxConstraints(),
                      splashColor: Colors.blueAccent.withOpacity(0.3),
                      highlightColor: Colors.blueAccent.withOpacity(0.2),
                      onPressed: () {
                        imageController.filterFavProduct();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    imageController.selectedTab.value = 1;
                    imageController.filterFavProduct();
                  },
                  child: Obx(() {
                    return Container(
                      color: imageController.selectedTab.value == 1
                          ? const Color.fromARGB(255, 236, 242, 236)
                          : Color.fromARGB(255, 255, 255, 255),
                      child: Column(
                        children: [
                          Icon(
                            Icons.home,
                            color: Colors.teal,
                            size: 30,
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Home',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    imageController.productList.value = [];
                    imageController.selectedTab.value = 2;
                    imageController.filterFavProduct();
                  },
                  child: Obx(() {
                    return Container(
                      color: imageController.selectedTab.value == 2
                          ? const Color.fromARGB(255, 236, 242, 236)
                          : Color.fromARGB(255, 255, 255, 255),
                      child: Column(
                        children: [
                          Icon(
                            Icons.favorite,
                            color: Colors.redAccent,
                            size: 30,
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Favourite',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.redAccent,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
          Obx(() {
            if (imageController.productList.length > 0) {
              return Expanded(
                child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      childAspectRatio: 0.6,
                      maxCrossAxisExtent: 300,
                      crossAxisSpacing: 5.0,
                      mainAxisSpacing: 0.0,
                    ),
                    itemCount: imageController.productList.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Get.to(() => ProductDetailPage(
                              item: imageController.productList[index]));
                        },
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                          child: Material(
                            color: const Color.fromARGB(255, 222, 227, 230),
                            borderOnForeground: false,
                            borderRadius: BorderRadius.circular(10),
                            elevation: 1,
                            child: Column(children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: SizedBox(
                                    height: MediaQuery.of(context).size.height /
                                        4.5,
                                    child: Image.network(
                                        fit: BoxFit.fill,
                                        "${imageController.productList[index].imageUrl}"),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${imageController.productList[index].name}",
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: const TextStyle(),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                              ),
                            ]),
                          ),
                        ),
                      );
                    }),
              );
            } else {
              return Center(
                  child: Column(
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  Text("No Product Found"),
                ],
              ));
            }
          }),
        ],
      ),
    );
  }
}
