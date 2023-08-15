import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart_app/consts/consts.dart';
import 'package:emart_app/controller/auth_controller.dart';
import 'package:emart_app/controller/profile_controller.dart';
import 'package:emart_app/services/firestore_services.dart';
import 'package:emart_app/views/orders_screen/orders_screen.dart';
import 'package:emart_app/views/profile_screen/components/details_card.dart';
import 'package:emart_app/views/profile_screen/edit_profile_screen.dart';
import 'package:emart_app/views/wishlist_screen/wishlist_screen.dart';
import 'package:emart_app/widgets_common/bg_widget.dart';
import 'package:emart_app/widgets_common/loading_indicator.dart';
import 'package:get/get.dart';

import '../../consts/lists.dart';
import '../auth_screen/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProfileController());

    return bgWidget(
      child: Scaffold(
        body: StreamBuilder<QuerySnapshot>(
          stream: FirestoreServices.getUser(currentUser!.uid),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(blue),
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text('No data available'),
              );
            } else {
              var data = snapshot.data!.docs[0];

              return SafeArea(
                child: Column(
                  children: [
                    //edit profile button
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: GestureDetector(
                          onTap: () {
                            controller.nameController.text = data['name'];
                            Get.to(() => EditProfileScreen(data: data));
                          },
                          child: Icon(Icons.edit, color: whiteColor),
                        ),
                      ),
                    ),

                    //user details section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        children: [
                          data['imageUrl'] == ''
                              ? Image.asset(
                                  imgProfile2,
                                  width: 100,
                                  fit: BoxFit.cover,
                                ).box.roundedFull.clip(Clip.antiAlias).make()
                              : Image.network(
                                  data['imageUrl'],
                                  width: 100,
                                  fit: BoxFit.cover,
                                ).box.roundedFull.clip(Clip.antiAlias).make(),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${data['name']}",
                                  style: TextStyle(
                                      fontFamily: semibold, color: Colors.black),
                                ),
                                Text(
                                  "${data['email']}",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                                side: BorderSide(color: Colors.black)),
                            onPressed: () async {
                              await Get.put(AuthController())
                                  .signoutMethod(context);
                              Get.offAll(() => const LoginScreen());
                            },
                            child: Text(
                              'Logout',
                              style: TextStyle(
                                  fontFamily: semibold, color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                    FutureBuilder(
                        future: FirestoreServices.getCounts(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (!snapshot.hasData) {
                            return Center(child: loadingIndicator());
                          } else {
                            var countData = snapshot.data;
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                detailsCard(
                                  count: countData[0].toString(),
                                  title: "Items in cart",
                                  width: context.screenWidth / 3.4,
                                ),
                                detailsCard(
                                  count: countData[1].toString(),
                                  title: "Items in your wishlist",
                                  width: context.screenWidth / 3.4,
                                ),
                                detailsCard(
                                  count: countData[2].toString(),
                                  title: "Items you ordered",
                                  width: context.screenWidth / 3.4,
                                ),
                              ],
                            );
                          }
                        }),

                    //buttons Section
                    Expanded(
                      child: ListView.separated(
                        shrinkWrap: true,
                        separatorBuilder: (context, index) {
                          return Divider(
                            color: Colors.black26,
                          );
                        },
                        itemCount: profileButtonsList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            onTap: () {
                              switch (index) {
                                case 0:
                                  Get.to(() => OrdersScreen());
                                  break;
                                case 1:
                                  Get.to(() => WishlistScreen());
                                  break;
                                case 2:
                                  // Get.to(() => MessagesScreen());
                                  break;
                              }
                            },
                            leading: Image.asset(
                              profileButtonsIcon[index],
                              width: 22,
                            ),
                            title: Text(
                              profileButtonsList[index],
                              style: TextStyle(
                                  fontFamily: semibold, color: darkFontGrey),
                            ),
                          );
                        },
                      )
                          .box
                          .white
                          .rounded
                          .margin(const EdgeInsets.all(12))
                          .padding(const EdgeInsets.symmetric(horizontal: 16))
                          .shadowSm
                          .make(),
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
