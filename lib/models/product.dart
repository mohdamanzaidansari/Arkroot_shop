class Product {
  String id;
  String title;
  String description;
  double price;
  String image;
  List<Variants> variants;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.image,
    required this.variants,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['price'] = this.price;
    data['image'] = this.image;
    data['variants'] = this.variants.map((v) => v.toJson()).toList();

    return data;
  }
}

class Variants {
  String? variantCategory;
  String? variantTitle;
  double? variantAdditionalPrice;

  Variants({
    this.variantCategory,
    this.variantTitle,
    this.variantAdditionalPrice,
  });

  Variants.fromJson(Map<String, dynamic> json) {
    variantCategory = json["variantCategory"];
    variantTitle = json['variantTitle'];
    variantAdditionalPrice = json['variantAdditionalPrice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['variantCategory'] = this.variantCategory;
    data['variantTitle'] = this.variantTitle;
    data['variantAdditionalPrice'] = this.variantAdditionalPrice;
    return data;
  }
}
