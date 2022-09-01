class ProductModel {
  String? image;
  String? name;
  String? price;
  int? quantiy;
  ProductModel({this.image, this.name, this.price, this.quantiy});
  ProductModel.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    name = json['name'];
    price = json['price'];
    quantiy = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['name'] = this.name;
    data['price'] = this.price;
    data['quantity'] = this.quantiy;
    return data;
  }
}
