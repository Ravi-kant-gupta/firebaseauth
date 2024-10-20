class ProductRes {
  String? result;
  List<Product>? product;

  ProductRes({this.result, this.product});

  ProductRes.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    if (json['product'] != null) {
      product = <Product>[];
      json['product'].forEach((v) {
        product!.add(new Product.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    if (this.product != null) {
      data['product'] = this.product!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Product {
  int? id;
  String? name;
  String? imageUrl;
  String? category;
  String? price;
  String? description;
  String? rating;

  Product(
      {this.id,
      this.name,
      this.imageUrl,
      this.category,
      this.rating,
      this.description,
      this.price});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    imageUrl = json['image_url'];
    category = json['category'];
    price = json['price'];
    description = json['description'];
    rating = json['rating'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image_url'] = this.imageUrl;
    data['category'] = this.category;
    data['price'] = this.price;
    data['description'] = this.description;
    data['rating'] = this.rating;
    return data;
  }
}
