import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobileshop_rider_app/global/global.dart';
import 'package:mobileshop_rider_app/models/address.dart';
import 'package:mobileshop_rider_app/widgets/progress_bar.dart';
import 'package:mobileshop_rider_app/widgets/shipment_order_design.dart';
import 'package:mobileshop_rider_app/widgets/status_banner.dart';

class OrderDetailScreen extends StatefulWidget {
final String? orderID;
OrderDetailScreen({this.orderID});
  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  String orderStatus = "";
  String orderByUser = "";
  String sellerId = "";
  String userPhone = "";

  getOrderInfo()
  {
    FirebaseFirestore.instance
        .collection("orders")
        .doc(widget.orderID).get().then((DocumentSnapshot)
    {
      orderStatus = DocumentSnapshot.data()!["status"].toString();
      orderByUser = DocumentSnapshot.data()!["orderBy"].toString();
      sellerId = DocumentSnapshot.data()!["sellerUID"].toString();
      userPhone = DocumentSnapshot.data()!["userPhone"].toString();

    });
  }
  @override
  void initState() {

    super.initState();
    getOrderInfo();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: FutureBuilder<DocumentSnapshot?>(
          future: FirebaseFirestore
              .instance.collection("orders")
              .doc(widget.orderID)
              .get(),
          builder: (c, AsyncSnapshot<DocumentSnapshot?> snapshot){
            Map? dataMap;
            if(snapshot.hasData){
              dataMap = snapshot.data?.data() as Map<String,dynamic>;
              orderStatus =dataMap["status"].toString();
            }
            return snapshot.hasData
                ?Container(
              child: Column(
                children: [
                  StatusBanner(
                    status: dataMap!["isSuccess"],
                    orderStatus: orderStatus,
                  ),
                  SizedBox(height: 10.0,),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Rs " + dataMap["totalAmount"].toString(),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,

                      ),),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Order ID = "+widget.orderID!,
                    style: TextStyle(
                      fontSize: 16,
                    ),),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Order at: " + DateFormat("dd MMM, yyyy -hh:mm aa")
                        .format(DateTime.fromMillisecondsSinceEpoch(int.parse(dataMap["orderTime"]))),
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                    ),
                  ),
                  const Divider(thickness: 4,),
                  orderStatus == "ended" ?Image.asset("images/success.jpg")
                      :Image.asset("images/confirm_pick.png"),
                  const Divider(thickness: 4,),
                  FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance
                         .collection("users").doc(orderByUser)
                         .collection("userAddress").doc(dataMap["addressID"]).get(),
                    builder: (c, snapshot){
                      return snapshot.hasData ? ShipmentAddressDesign(
                        model: Address.fromJson(
                          snapshot.data!.data()! as Map<String, dynamic>
                        ),
                        orderStatus: orderStatus,
                        orderId: widget.orderID,
                        sellerId: sellerId,
                        orderByUser: orderByUser,

                      )
                          :Center(child: circularProgress(),);
                    },
                  )


                ],
              ),
            )
                : Center(child: circularProgress(),);
          },
        ),
      ),
    );
  }
}
