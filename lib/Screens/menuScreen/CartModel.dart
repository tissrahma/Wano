
class CartModel {
  String? id;
  CartItem? cartItem;

  CartModel({this.id, this.cartItem});

  CartModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cartItem = json['cartItem'] != null
        ? new CartItem.fromJson(json['cartItem'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.cartItem != null) {
      data['cartItem'] = this.cartItem!.toJson();
    }
    return data;
  }
}

class CartItem {
  String? name;
  String? price;
  String? quantity;
  String? image;

  CartItem({this.name, this.price, this.quantity, this.image});

  CartItem.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    price = json['price'];
    quantity = json['quantity'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['price'] = this.price;
    data['quantity'] = this.quantity;
    data['image'] = this.image;
    return data;
  }
}
