import 'dart:developer';
import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/client/home_client/home_top_dropdown.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/providers/expertise/expertise_data.dart';
import 'package:healthonify_mobile/screens/client_screens/appointment_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/blogs/blogs_widget.dart';
import 'package:healthonify_mobile/screens/client_screens/consult_experts.dart';
import 'package:healthonify_mobile/screens/client_screens/expert_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/fitness_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/health_care/health_care.dart';
import 'package:healthonify_mobile/screens/client_screens/live_well/live_well_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/weight_management/manage_weight_screen.dart';
import 'package:healthonify_mobile/screens/main_screen.dart';
import 'package:healthonify_mobile/widgets/buttons/custom_buttons.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:healthonify_mobile/widgets/cards/fitness_tools_card.dart';
import 'package:healthonify_mobile/widgets/cards/health_app_sync_card.dart';
import 'package:healthonify_mobile/widgets/cards/home_cards.dart';
import 'package:healthonify_mobile/widgets/physio/physio_my_appointments_card.dart';
import 'package:healthonify_mobile/widgets/cards/quick_actions_card.dart';
import 'package:healthonify_mobile/widgets/other/carousel_slider.dart';
import 'package:healthonify_mobile/widgets/other/shop_list.dart';
import 'package:healthonify_mobile/widgets/physio/physio_top_list.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../models/user.dart';
import '../../../providers/user_data.dart';
import '../../../widgets/other/horiz_list_view/home_top_list_buttons.dart';
import '../../notifications_screen.dart';
import '../reminders/reminders_screen.dart';

class PhysiotherapyScreen extends StatefulWidget {
  PhysiotherapyScreen({Key? key, this.category}) : super(key: key);
  int? category;

  @override
  State<PhysiotherapyScreen> createState() => _PhysiotherapyScreenState();
}

class _PhysiotherapyScreenState extends State<PhysiotherapyScreen> {
  final List? expNames = [];

  bool isloading = true;

  List<User> experts = [];
  int? selectedValue;
  List<Category> categoryData = [];
  String? id;

  Future<void> fetchExperts() async {
    try {
      experts = await Provider.of<UserData>(context, listen: false)
          .getPhysioTherepists();
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.message);
    } catch (e) {
      log("Error getting user details : $e");
      Fluttertoast.showToast(msg: "Unable to fetch user details");
    } finally {
      setState(() {
        isloading = false;
      });
    }
  }

  @override
  void initState() {
    fetchExperts();
    super.initState();

    selectedValue = widget.category;
    setState(() {
      categoryData = homeTopList;
    });
  }

  @override
  Widget build(BuildContext context) {
    var topLevelExpertiseIdList =
        Provider.of<ExpertiseData>(context).topLevelExpertiseData;

    for (var element in topLevelExpertiseIdList) {
      if (element.name == "Physiotherapy") {
        id = element.id!;
      }
    }
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, value) {
          return [
            // FlexibleAppBar(
            //   title: 'Physiotherapy',
            //   listItems: PhysioTopList(id: id),
            // ),
            flexibleAppBar(context),
          ];
        },
        body: physioContent(context),
      ),
    );
  }

  PreferredSizeWidget flexibleAppBar(context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(56),
      child: SliverAppBar(
        pinned: true,
        floating: true,
        automaticallyImplyLeading: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context,true);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Theme.of(context).colorScheme.onBackground,
            size: 25,
          ),
        ),
        title: Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color(0xFFec6a13),
                  border: Border.all(color: Colors.black,width: 1)
              ),
              child: DropdownButton2(
                buttonHeight: 20,
                buttonWidth: 200,
                itemHeight: 45,
                underline: const SizedBox(),
                dropdownWidth: 240,
                offset: const Offset(-30, 20),
                dropdownDecoration: const BoxDecoration(
                    color: Color(0xFFec6a13),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                alignment: Alignment.topLeft,
                value: selectedValue,
                hint: Row(
                  children: [
                    Text(
                      'Choose Fitness Category',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    // Icon(
                    //   Icons.arrow_drop_down,
                    //   color: Colors.white,
                    //   size: 50,
                    // ),
                  ],
                ),
                items: categoryData.map((list) {
                  return DropdownMenuItem(
                    value: list.id,
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: list.image,
                        ),
                        Text(
                          list.title,
                          style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  );
                }).toList(),

                onChanged: (value) {
                  setState(() {
                    selectedValue = value as int;

                    if (selectedValue == 1) {
                      Navigator.of(
                        context, /*rootnavigator: true*/
                      ).pushReplacement(MaterialPageRoute(builder: (context) {
                        return HealthCareScreen(category: 1);
                      }));
                    } else if (selectedValue == 2) {
                      Navigator.of(
                        context, /*rootnavigator: true*/
                      ).pushReplacement(MaterialPageRoute(builder: (context) {
                        return ManageWeightScreen(category: 2);
                      }));
                    } else if (selectedValue == 3) {
                      Navigator.of(
                        context, /*rootnavigator: true*/
                      ).pushReplacement(MaterialPageRoute(builder: (context) {
                        return FitnessScreen(category: 3);
                      }));
                    } else if (selectedValue == 4) {
                      Navigator.of(
                        context, /*rootnavigator: true*/
                      ).pushReplacement(MaterialPageRoute(builder: (context) {
                        return PhysiotherapyScreen(category: 4);
                      }));
                    } else if (selectedValue == 5) {
                      Navigator.of(
                        context, /*rootnavigator: true*/
                      ).pushReplacement(MaterialPageRoute(builder: (context) {
                        return ConsultExpertsScreen(category: 5);
                      }));
                    } else if (selectedValue == 6) {
                      Navigator.of(
                        context, /*rootnavigator: true*/
                      ).pushReplacement(MaterialPageRoute(builder: (context) {
                        return LiveWellScreen(category: 6);
                      }));
                    }
                    else if (selectedValue == 7) {
                    //   launchUrl(Uri.parse("https://healthonify.com/Shop"));
                      Navigator.of(
                        context, /*rootnavigator: true*/
                      ).pushReplacement(MaterialPageRoute(builder: (context) {
                        return ShopScreen();
                      }));
                     }
                  });
                },

                iconSize: 20,
//                  buttonPadding: const EdgeInsets.only(left: 0,bottom: 25,top: 0),
                iconEnabledColor: Colors.black,
                iconDisabledColor: Colors.black,
              ),
            ),
          ),
        ),
        titleSpacing: 0,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(
                context, /*rootnavigator: true*/
              ).push(MaterialPageRoute(builder: (context) {
                return const RemindersScreen();
              }));
            },
            icon: Icon(
              Icons.schedule_rounded,
              color: Theme.of(context).colorScheme.onBackground,
              size: 25,
            ),
          ),
          // IconButton(
          //   onPressed: () {
          //     Share.share('Check out Healthonify');
          //     log('message shared');
          //   },
          //   icon: Icon(
          //     Icons.share_rounded,
          //     color: Theme.of(context).colorScheme.onBackground,
          //     size: 25,
          //   ),
          // ),
          IconButton(
            onPressed: () {
              Navigator.of(
                context, /*rootnavigator: true*/
              ).push(MaterialPageRoute(builder: (context) {
                return NotificationScreen();
              }));
            },
            icon: Icon(
              Icons.notifications,
              color: Theme.of(context).colorScheme.onBackground,
              size: 25,
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: const HomeTopListButtons(),
          ),
        ),
      ),
    );
  }

  Widget physioContent(context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PhysioTopList(id: id),
          CustomCarouselSlider(imageUrls: [
            {
              'image': 'assets/images/physio/physio1.jpg',
              'route': () {},
            },
            {
              'image': 'assets/images/physio/physio2.jpg',
              'route': () {},
            },
            {
              'image': 'assets/images/physio/physio3.jpg',
              'route': () {},
            },
          ]),
          const SizedBox(
            height: 25,
          ),
          PhysioMyAppoinmentsCard(
            onRequest: () {
              showDatePicker(
                context: context,
                builder: (context, child) {
                  return Theme(
                    data: MediaQuery.of(context).platformBrightness ==
                            Brightness.dark
                        ? datePickerDarkTheme
                        : datePickerLightTheme,
                    child: child!,
                  );
                },
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime(2200),
              ).then((value) =>
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const AppointmentScreen();
                  })));
            },
          ),
          const SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                Expanded(child: ConditionsButton()),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: BodyPartsButton(),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          const QuickActionCard3(),
          const SizedBox(
            height: 25,
          ),
          CustomCarouselSlider(imageUrls: [
            {
              'image': 'assets/images/physio/physio4.jpg',
              'route': () {},
            },
            {
              'image': 'assets/images/physio/physio5.jpg',
              'route': () {},
            },
          ]),
          const SizedBox(
            height: 25,
          ),
          const FitnessToolsCard(),
          const BlogsWidget(expertiseId: "6229a980305897106867f787"),
          const SizedBox(
            height: 25,
          ),
          const PhysioScreenCard(),
          const SizedBox(
            height: 5,
          ),
          const SyncHealthAppCard(),
          const SizedBox(
            height: 25,
          ),
          CustomCarouselSlider(imageUrls: [
            {
              'image': 'assets/images/physio/physio6.jpg',
              'route': () {},
            },
            {
              'image': 'assets/images/physio/physio7.jpg',
              'route': () {},
            },
            {
              'image': 'assets/images/physio/physio8.jpg',
              'route': () {},
            },
          ]),
          const SizedBox(
            height: 5,
          ),
          const ShopList(
            image:
                "https://cdn.shopify.com/s/files/1/0005/5335/3267/products/WPC_1000g_Creatine_100g_grande.jpg?v=1648204173",
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Text(
                  'Our Experts',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
              SizedBox(
                height: 110,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: experts.length > 20 ? 20 : experts.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.of(
                                context, /*rootnavigator: true*/
                              ).push(MaterialPageRoute(builder: (context) {
                                return ExpertScreen(
                                  expertId: experts[index].id!,
                                );
                              }));
                            },
                            borderRadius: BorderRadius.circular(30),
                            child: Center(
                              child: experts[index].imageUrl == null
                                  ? const CircleAvatar(
                                      radius: 30,
                                      backgroundImage: AssetImage(
                                          'assets/icons/expert_pfp.png'),
                                    )
                                  : CircleAvatar(
                                      radius: 30,
                                      backgroundImage: NetworkImage(
                                        experts[index].imageUrl!,
                                      ),
                                    ),
                            ),
                          ),
                          Text(experts[index].firstName!),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
