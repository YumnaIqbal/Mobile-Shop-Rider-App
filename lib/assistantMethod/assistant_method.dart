import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobileshop_rider_app/global/global.dart';



separateOrdersItemIDs(orderIDs)
{
  List<String> separateItemIDsList=[], defaultItemList=[];


  defaultItemList = List<String>.from(orderIDs);

  for(int i=0; i<defaultItemList.length; i++)
  {
    //56557657:7
    String item = defaultItemList[i].toString();    //assign the number of item to the item variable
    var pos = item.lastIndexOf(":");

    //56557657
    String getItemId = (pos != -1) ? item.substring(0, pos) : item;

    if (kDebugMode) {
      print("\nThis is itemID now = $getItemId");
    }

    separateItemIDsList.add(getItemId);
  }

  print("\nThis is Items List now = ");
  print(separateItemIDsList);

  return separateItemIDsList;
}

separateItemIDs()
{
  List<String> separateItemIDsList=[], defaultItemList=[];
  int i=0;

  defaultItemList = sharedPreferences!.getStringList("userCart")!;  //contains item which are already in the cart

  for(i; i<defaultItemList.length; i++)
  {
    //56557657:7
    String item = defaultItemList[i].toString();    //assign the number of item to the item variable
    var pos = item.lastIndexOf(":");

    //56557657
    String getItemId = (pos != -1) ? item.substring(0, pos) : item;

    print("\nThis is itemID now = " + getItemId);

    separateItemIDsList.add(getItemId);
  }

  print("\nThis is Items List now = ");
  print(separateItemIDsList);

  return separateItemIDsList;
}





separateOrderItemQuantities(orderIDs)
{
  List<String> separateItemQuantitysList=[];
  List<String> defaultItemList=[];
  int i=1;

  defaultItemList = List<String>.from(orderIDs);

  for(i; i<defaultItemList.length; i++)
  {
    //56557657:7
    String item = defaultItemList[i].toString();    //assign the number of item to the item variable
    //7
    List<String> listItemCharacters= item.split(":").toList();
    var quanNumber = int.parse(listItemCharacters[1].toString());

    print("\nThis is itemID now = " + quanNumber.toString());

    separateItemQuantitysList.add(quanNumber.toString());
  }

  print("\nThis is Quantity List now = ");
  print(separateItemQuantitysList);

  return separateItemQuantitysList;
}

separateItemQuantities()
{
  List<int> separateItemQuantitysList=[];
  List<String> defaultItemList=[];
  int i=1;

  defaultItemList = sharedPreferences!.getStringList("userCart")!;  //contains item which are already in the cart

  for(i; i<defaultItemList.length; i++)
  {
    //56557657:7
    String item = defaultItemList[i].toString();    //assign the number of item to the item variable
    //7
    List<String> listItemCharacters= item.split(":").toList();
    var quanNumber = int.parse(listItemCharacters[1].toString());

    print("\nThis is itemID now = " + quanNumber.toString());

    separateItemQuantitysList.add(quanNumber);
  }

  print("\nThis is Quantity List now = ");
  print(separateItemQuantitysList);

  return separateItemQuantitysList;
}

clearCartNow(context)
{
  sharedPreferences!.setStringList("userCart", ['garbageValue']);
  List<String>? emptyList = sharedPreferences!.getStringList("userCart");

  FirebaseFirestore.instance.collection("users").doc(firebaseAuth.currentUser!.uid)
  .update({"userCart": emptyList}).then((value)
  {
    sharedPreferences!.setStringList("userCart", emptyList!);

    

  });
}