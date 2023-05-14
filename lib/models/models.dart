import 'package:cloud_firestore/cloud_firestore.dart';

class Models{
  String? productID;
  String? sellerID;
  String? modelID;
  String? title;
  String? shortInfo;
  Timestamp? publishedDate;
  String? thumbnailUrl;
  String? longDescription;
  String? status;
  int? price;

  Models({
    this.productID,
    this.sellerID,
    this.modelID,
    this.title,
    this.shortInfo,
    this.publishedDate,
    this.thumbnailUrl,
    this.longDescription,
    this.status,
});
  Models.fromJson(Map<String, dynamic> json){
    productID= json["productID"];
    sellerID= json["sellerID"];
    modelID= json["modelID"];
    title= json["tilte"];
    shortInfo= json["shortInfo"];
    publishedDate= json["publishedDate"];
    thumbnailUrl= json["thumbnailUrl"];
    longDescription= json["longDescription"];
    status= json["status"];
    price= json["price"];
  }
  Map<String, dynamic> toJson()
  {
    final Map<String, dynamic> data =Map<String, dynamic>();
    data['productID'] = productID;
    data['sellerID'] = sellerID;
    data['modelID'] = modelID;
    data['tilte'] = title;
    data['shortInfo'] = shortInfo;
    data['publishedDate'] = publishedDate;
    data['thumbnailUrl'] = thumbnailUrl;
    data['longDescription'] = longDescription;
    data['status'] = status;
    data['price'] = price;

    return data;


}


}