import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobileshop_rider_app/assistantMethod/get_current_location.dart';
import 'package:mobileshop_rider_app/global/global.dart';
import 'package:mobileshop_rider_app/mainScreens/parcel_delivering.dart';
import 'package:mobileshop_rider_app/maps/map_utils.dart';
import 'package:mobileshop_rider_app/services/order_service.dart';

class ParcelPickingScreen extends StatefulWidget
{
  String? purchaserId;
  String? sellerId;
  String? getOrderID;
  String? purchaserAddress;
  double? purchaserLat;
  double? purchaserLng;
  String? userPhone;

  ParcelPickingScreen({
    this.purchaserId,
    this.sellerId,
    this.getOrderID,
    this.purchaserAddress,
    this.purchaserLat,
    this.purchaserLng,
    this.userPhone,
  });

  @override
  _ParcelPickingScreenState createState() => _ParcelPickingScreenState();
}



class _ParcelPickingScreenState extends State<ParcelPickingScreen>
{
  double? sellerLat, sellerLng;
  String? userPhone;
  getSellerData() async
  {
    FirebaseFirestore.instance.collection("sellers")
        .doc(widget.sellerId).get().then((DocumentSnapshot)
    {
          sellerLat =DocumentSnapshot.data()!["lat"];
          sellerLng = DocumentSnapshot.data()!["lng"];
    });
  }
  getUserData() async
  {
    FirebaseFirestore.instance.collection("users")
        .doc(widget.purchaserId).collection('userAddress')
        .doc(widget.purchaserId).get().then((DocumentSnapshot)
    {
      setState(() {
        userPhone = DocumentSnapshot.data()!["phoneNumber"];
        print('.............$userPhone');
      });
    });
  }
  DocumentSnapshot? documentSnapshot;
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    getUserData();
    super.initState();
    getSellerData();
  }
  confirmParcelHasBeenPicked(getOrderId,sellerId,purchaserId,purchaserAddress, purchaserLat,purchaserLng)
  {
    FirebaseFirestore.instance.collection("orders").doc(getOrderId).update({
      "status": "delivering",
      "address": completeAddress,
      "lat": position!.latitude,
      "lng": position!.longitude,
    });
    Navigator.push(context, MaterialPageRoute(builder: (c)=> ParcelDeliveringScreen(
      purchaserId: purchaserId,
      purchaserAddress: purchaserAddress,
      purchaserLat: purchaserLat,
      purchaserLng: purchaserLng,
      sellerId: sellerId,
      getOrderId: getOrderId,
    )));

  }
  OrderService orderService = OrderService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("images/confirm1.png",
          width:350,
          ),
          SizedBox(height: 5,),
          GestureDetector(
            onTap: (){
              MapUtils.lauchMapFromSourceToDestination(position!.latitude,position!.longitude,sellerLat, sellerLng);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("images/restaurant.png",
                width: 50,
                ),
               const SizedBox(width: 7,),
               Column(
                 children: const[
                    SizedBox(height: 13,),
                    Text("Show Shop Location",
                    style: TextStyle(
                      fontFamily: "Signatra",
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),),
                 ],
               )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: InkWell(
                onTap: ()
                {
                  UserLocation uLocation = UserLocation();
                  uLocation.getCurrentLocation();

                  //confirmed - that rider has picked parcel from seller
                  confirmParcelHasBeenPicked(
                      widget.getOrderID,
                      widget.sellerId,
                      widget.purchaserId,
                      widget.purchaserAddress,
                      widget.purchaserLat,
                      widget.purchaserLng
                  );

                },
                child: Container(
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.teal,
                          Colors.white,
                        ],
                        begin:  FractionalOffset(0.0, 0.0),
                        end:  FractionalOffset(1.0, 0.0),
                        stops: [0.0, 1.0],
                        tileMode: TileMode.clamp,
                      )
                  ),
                  width: MediaQuery.of(context).size.width - 90,
                  height: 50,
                  child: const Center(
                    child: Text(
                      "Order has been picked --Confirmed",
                      style: TextStyle(color: Colors.white, fontSize: 15.0),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 10,),
          TextButton(
              onPressed: (){
                orderService.textMe(context: context,
                    text: "text", number: '$userPhone');
                },
              child: Text(
              "Chat with Customer",
          )),
          SizedBox(height: 10,),
          TextButton(
              onPressed: (){
                orderService.launchUrl("tel:$userPhone");
              },
              child: Text(
                "Call Customer",
              )),
        ],
      ),
    );
  }
}
