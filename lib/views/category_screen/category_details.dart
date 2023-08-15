import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart_app/consts/consts.dart';
import 'package:emart_app/services/firestore_services.dart';
import 'package:emart_app/views/category_screen/item_details.dart';
import 'package:emart_app/widgets_common/bg_widget.dart';
import 'package:get/get.dart';

import '../../controller/product_controller.dart';

class CategoryDetails extends StatelessWidget {
  final String? title;
  const CategoryDetails({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<ProductController>();

    return bgWidget(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            title!,
            style: TextStyle(fontFamily: bold, color: Colors.white),
          ),
        ),
        body: StreamBuilder(
          stream: FirestoreServices.getproducts(title),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text(
                  "No products found!",
                  style: TextStyle(color: darkFontGrey),
                ),
              );
            } else {
              var data = snapshot.data!.docs;
              return Container(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(
                          controller.subcat.length,
                          (index) => Text(
                            "${controller.subcat[index]}",
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: semibold,
                              color: darkFontGrey,
                            ),
                          )
                              .box
                              .makeCentered()
                              .box
                              .white
                              .rounded
                              .size(120, 60)
                              .margin(EdgeInsets.symmetric(horizontal: 4))
                              .make(),
                        ),
                      ),
                    ),

                    //items container

                    20.heightBox,

                    Expanded(
                      child: GridView.builder(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: data.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisExtent: 250,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                        ),
                        itemBuilder: (context, index) {
                          var product = snapshot.data!.docs[index];
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.network(data[index]['p_imgs'][0],
                                  height: 150, width: 200, fit: BoxFit.cover),
                              Text(
                                "${data[index]['p_name']}",
                                style: TextStyle(
                                    fontFamily: semibold, color: darkFontGrey),
                              ),
                              10.heightBox,
                              Text(
                                "Rs "+
                                 "${data[index]['p_price']}".numCurrency,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: bold,
                                    fontSize: 16),
                              ),
                            ],
                          )
                              .box
                              .white
                              .margin(const EdgeInsets.symmetric(horizontal: 4))
                              .roundedSM
                              .outerShadowSm
                              .padding(const EdgeInsets.all(12))
                              .make()
                              .onTap(() {
                            controller.checkIfFav(data[index]);
                            Get.to(
                              () => ItemDetails(
                                title: "${data[index]['p_name']}",
                                data: data[index],
                              ),
                            );
                          });
                        },
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
