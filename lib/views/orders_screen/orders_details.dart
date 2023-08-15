import 'package:emart_app/consts/consts.dart';
import 'package:emart_app/views/orders_screen/components/order_place_details.dart';
import 'package:emart_app/views/orders_screen/components/order_status.dart';
import 'package:intl/intl.dart' as intl;

class OrdersDetails extends StatelessWidget {
  final dynamic data;
  const OrdersDetails({Key? key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor ,
      appBar: AppBar(
        title: Text("Order Details", style: TextStyle(fontFamily: semibold)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            orderStatus(
              color: redColor,
              icon: Icons.done,
              title: "Placed",
              showDone: data['order_placed'],
            ),
            orderStatus(
              color: Colors.blue,
              icon: Icons.thumb_up,
              title: "Confirmed",
              showDone: data['order_confirmed'],
            ),
            orderStatus(
              color: Colors.yellow,
              icon: Icons.car_crash,
              title: "On Delivery",
              showDone: data['order_on_delivery'],
            ),
            orderStatus(
              color: Colors.purple,
              icon: Icons.done_all_rounded,
              title: "Delivered",
              showDone: data['order_delivered'],
            ),
            Divider(),
            SizedBox(height: 10),
            orderPlaceDetails(
              d1: data['order_code'],
              d2: data['shipping_method'],
              title1: "Order Code",
              title2: "Shipping Method",
            ),
            orderPlaceDetails(
              d1: intl.DateFormat()
                  .add_yMd()
                  .format(data['order_date'].toDate()),
              d2: data['payment_method'],
              title1: "Order Date",
              title2: "Payment Method",
            ),
            orderPlaceDetails(
              d1: "Unpaid",
              d2: "Order Placed",
              title1: "Payment Status",
              title2: "Delivery Status",
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Shipping Address",
                          style: TextStyle(fontFamily: semibold)),
                      Text("${data['order_by_name']}"),
                      Text("${data['order_by_email']}"),
                      Text("${data['order_by_address']}"),
                      Text("${data['order_by_city']}"),
                      Text("${data['order_by_state']}"),
                      Text("${data['order_by_phone']}"),
                      Text("${data['order_by_postalcode']}"),
                    ],
                  ),
                  SizedBox(
                    width: 130,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Total Amount",
                            style: TextStyle(fontFamily: semibold)),
                        Text("${data['total_amount']}",
                            style: TextStyle(color: redColor, fontFamily: bold))
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(),
            SizedBox(height: 10),
            Text(
              "Ordered Product",
              style: TextStyle(
                  fontSize: 16, color: darkFontGrey, fontFamily: semibold),
            ).text.makeCentered(),
            SizedBox(height: 10),
            ListView(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: List.generate(data['orders'].length, (index) {
                return orderPlaceDetails(
                  title1: data['orders'][index]['title'],
                  title2: data['orders'][index]['tprice'],
                  d1: "${data['orders'][index]['qty']}x",
                  d2: "Refundable",
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
