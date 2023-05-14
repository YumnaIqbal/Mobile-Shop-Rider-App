import 'package:cloud_firestore/cloud_firestore.dart';

class Products{
  String? productID;
  String? sellerID;
  String? productTitle;
  String? productInfo;
  Timestamp? publishedDate;
  String? thumbnailUrl;
  String? status;

  Products({
    this.productID,
    this.productInfo,
    this.productTitle,
    this.publishedDate,
    this.sellerID,
    this.status,
    this.thumbnailUrl,
});

  Products.fromJson(Map<String, dynamic> json){
    productID = json["productID"];
    sellerID = json["sellerID"];
    productTitle = json["productTilte"];
    productInfo = json["productInfo"];
    publishedDate = json["publishedDate"];
    thumbnailUrl = json["thumbnailUrl"];
    status = json["status"];
  }
  Map<String, dynamic> toJson(){
    final   Map<String, dynamic> data =<String, dynamic>{};
    data["productID"]= productID;
    data['sellerID']= sellerID;
    data['productTitle']= productTitle;
    data['productInfo']= productInfo;
    data['publishedDate']= publishedDate;
    data['thumbnailUrl']= thumbnailUrl;
    data['status']= status;

    return data;

    }


}