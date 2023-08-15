import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart_app/consts/consts.dart';
import 'package:emart_app/services/firestore_services.dart';
import 'package:emart_app/views/orders_screen/orders_details.dart';
import 'package:emart_app/widgets_common/loading_indicator.dart';
import 'package:get/get.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: Text("My Orders",
            style: TextStyle(color: darkFontGrey, fontFamily: semibold)),
      ),
      body: StreamBuilder(
        stream: FirestoreServices.getAllOrders(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: loadingIndicator());
          } else if (snapshot.data!.docs.isEmpty) {
            return Text("No order placed yet!",
                    style: TextStyle(color: darkFontGrey))
                .centered();
          } else {
            var data = snapshot.data!.docs;

            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: Text("${index + 1}",
                      style: TextStyle(
                          color: darkFontGrey, fontFamily: bold, fontSize: 24)),
                  tileColor: lightGrey,
                  title: Text(data[index]['order_code'].toString(),
                      style: TextStyle(
                          color: redColor, fontFamily: semibold, fontSize: 18)),
                  subtitle: Text(data[index]['total_amount'].toString(),
                      style: TextStyle(fontFamily: bold, fontSize: 16)),
                  trailing: IconButton(
                    onPressed: () {
                      // Navigate to OrdersDetails page with the specific order data
                      Get.to(() => OrdersDetails(data: data[index]));
                    },
                    icon: Icon(Icons.arrow_forward_ios_rounded,
                        color: darkFontGrey),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
