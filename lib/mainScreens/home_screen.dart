import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobileshop_rider_app/assistantMethod/get_current_location.dart';
import 'package:mobileshop_rider_app/authentication/auth_screen.dart';
import 'package:mobileshop_rider_app/global/global.dart';
import 'package:mobileshop_rider_app/mainScreens/earings_screen.dart';
import 'package:mobileshop_rider_app/mainScreens/history.dart';
import 'package:mobileshop_rider_app/mainScreens/new_order_screen.dart';
import 'package:mobileshop_rider_app/mainScreens/not_yet_delivered.dart';
import 'package:mobileshop_rider_app/mainScreens/parcel_in_progress.dart';
import 'package:mobileshop_rider_app/splashScreen/splash_screen.dart';



class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Card makeDashboardItem(String title, IconData iconData, int index)
  {
    return Card(
        elevation: 2,
        margin: const EdgeInsets.all(8),
    child: Container(
    decoration: index == 0 || index == 3 || index == 4
  ? const BoxDecoration(
  gradient: LinearGradient(
  colors: [
  Colors.lightBlue,
  Colors.lightGreen,
  ],
  begin:  FractionalOffset(0.0, 0.0),
  end:  FractionalOffset(1.0, 0.0),
  stops: [0.0, 1.0],
  tileMode: TileMode.clamp,
    )
    )
        :const  BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.teal,
            Colors.lightBlueAccent,
          ],
          begin:  FractionalOffset(0.0, 0.0),
          end:  FractionalOffset(1.0, 0.0),
          stops: [0.0, 1.0],
          tileMode: TileMode.clamp,
        )
    ) ,
    child: InkWell(
      onTap: (){
        if(index==0){
          //new available order
          Navigator.push(context, MaterialPageRoute(builder: (c)=>  NewOrdersScreen()));
        }
        if(index==1){
          //percel in progress
          Navigator.push(context, MaterialPageRoute(builder: (c) => ParcelInProgressScreen()));
        }
        if(index==2){
          //not yet delivered
          Navigator.push(context, MaterialPageRoute(builder: (c) => NotYetDelivered()));
        }
        if(index==3){

          //history
          Navigator.push(context, MaterialPageRoute(builder: (c) => HistoryScreen()));
        }
        if(index==4){
          //total eerning
          Navigator.push(context, MaterialPageRoute(builder: (c) => EarningsScreen()));
        }
        if(index==5){
          //logout
          firebaseAuth.signOut().then((value){
            Navigator.push(context, MaterialPageRoute(builder: (c)=> const AuthScreen()));
          });
        }
    },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        verticalDirection: VerticalDirection.down,
        children: [
          const SizedBox(height: 50.0),
          Center(
            child: Icon(
              iconData,
              size: 40,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10.0),
          Center(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    ),
    ),
    );
  }
  restrictBlockedRiderrForUsingApp() async{
    await FirebaseFirestore.instance.collection("riders")
        .doc(firebaseAuth.currentUser!.uid)
        .get().then((snapshot){
      if(snapshot.data()!["status"]!= "approved")
      {
        Fluttertoast.showToast(msg: "You have been blocked by admin");
        firebaseAuth.signOut();
        Navigator.push(context, MaterialPageRoute(builder: (c) => MySplashScreen()));
      }
      else{
        UserLocation uLocation = UserLocation();
        uLocation.getCurrentLocation();
        getPerParcelDeliveryAmount();
        getRiderPreviousEarnings();
      }
    });

  }
  @override
  void initState() {

    super.initState();
    restrictBlockedRiderrForUsingApp();

  }
  getRiderPreviousEarnings()
  {
    FirebaseFirestore.instance
        .collection("riders")
        .doc(sharedPreferences!.getString("uid"))
        .get().then((snap)
    {
      previousRiderEarnings = snap.data()!["earnings"].toString();
    });
  }

  getPerParcelDeliveryAmount()
  {
    FirebaseFirestore.instance
        .collection("perDelivery")
        .doc("yumna438")
        .get().then((snap)
    {
      perParcelDeliveryAmount = snap.data()!["amount"].toString();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration:const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blueAccent,
                  Colors.teal,

                ],
                begin:  FractionalOffset(0.0, 0.0),
                end:  FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              )
          ),
        ),
        title: Text(
          "Welcome "+
          sharedPreferences!.getString("name")!,
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,


      ),
      body: Container(padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 1),
        child: GridView.count(
          crossAxisCount: 2,
          padding: const EdgeInsets.all(2),
          children: [
            makeDashboardItem("New Available Orders", Icons.assignment, 0),
            makeDashboardItem("Parcels in Progress", Icons.airport_shuttle, 1),
            makeDashboardItem("Not Yet Delivered", Icons.location_history, 2),
            makeDashboardItem("History", Icons.done_all, 3),
            makeDashboardItem("Total Earnings", Icons.monetization_on, 4),
            makeDashboardItem("Logout", Icons.logout, 5),
          ],
        ),
      ),
    );
  }
}
