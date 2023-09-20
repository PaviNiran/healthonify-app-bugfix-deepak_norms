import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/client/home_client/home_top_dropdown.dart';
import 'package:healthonify_mobile/screens/client_screens/blogs/blogs_widget.dart';
import 'package:healthonify_mobile/screens/client_screens/consult_experts.dart';
import 'package:healthonify_mobile/screens/client_screens/fitness_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/health_care/health_care.dart';
import 'package:healthonify_mobile/screens/client_screens/live_well/live_well_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/physio/physiotherapy_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/weight_management/quick_actions/browse_plans.dart';
import 'package:healthonify_mobile/screens/client_screens/weight_management/weight_loss_enquiry.dart';
import 'package:healthonify_mobile/widgets/cards/batches_card.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:healthonify_mobile/widgets/cards/fitness_tools_card.dart';
import 'package:healthonify_mobile/widgets/cards/health_app_sync_card.dart';
import 'package:healthonify_mobile/widgets/cards/manage_calories.dart';
import 'package:healthonify_mobile/widgets/cards/quick_actions_card.dart';
import 'package:healthonify_mobile/widgets/other/carousel_slider.dart';
import 'package:healthonify_mobile/widgets/other/diet_log_wm_card.dart';
import 'package:healthonify_mobile/widgets/other/horiz_list_view/home_top_list_buttons.dart';
import 'package:healthonify_mobile/widgets/other/manage_workout_calories.dart';
import 'package:healthonify_mobile/widgets/other/shop_list.dart';
import 'package:healthonify_mobile/widgets/wm/wm_home_card.dart';
import 'package:healthonify_mobile/widgets/wm/wm_my_appointments_card.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../main_screen.dart';
import '../../notifications_screen.dart';
import '../reminders/reminders_screen.dart';

class ManageWeightScreen extends StatefulWidget {
  ManageWeightScreen({Key? key, this.category}) : super(key: key);
  int? category;

  @override
  State<ManageWeightScreen> createState() => _ManageWeightScreenState();
}

class _ManageWeightScreenState extends State<ManageWeightScreen> {
  int? selectedValue;
  List<Category> categoryData = [];

  @override
  void initState() {
    super.initState();
    selectedValue = widget.category;
    setState(() {
      categoryData = homeTopList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, value) {
          return [
            // const FlexibleAppBar(
            //   title: 'Manage Weight',
            //   listItems: ManageWeightTopList(),
            // ),
            flexibleAppBar(context),
          ];
        },
        body: manageWeightContent(context),
      ),
    );
  }

  Widget manageWeightContent(context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          const ManageWeightTopList(),
          CustomCarouselSlider(
            imageUrls: [
              {
                'image': 'assets/images/wm/wm1.jpg',
                'route': () {},
              },
              {
                'image': 'assets/images/wm/wm2.jpg',
                'route': () {},
              },
              {
                'image': 'assets/images/wm/wm3.jpg',
                'route': () {},
              },
            ],
          ),
          // const CustomCarouselSliderWithHeader(imageUrls: [
          //   'https://images.unsplash.com/photo-1607081759141-5035e0a710a4?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80',
          //   'https://images.unsplash.com/photo-1606636660801-c61b8e97a1dc?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=387&q=80',
          //   'https://images.unsplash.com/photo-1606926693996-d1dfbed4e8c9?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80',
          //   'https://images.unsplash.com/photo-1624455806586-037944b1fa1a?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=580&q=80',
          // ], header: []),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return const WmPackagesQuickActionsScreen();
                      }));
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(10),
                      child: Text('View Plans'),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const ManageWorkoutCalories(),
          const CaloriesCard(),
          const ManageCaloriesTracker(),
          WMMyAppoinmentsCard(
            onRequest: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const WeightLossEnquiry(isFitnessFlow: false);
              }));
              // showDatePicker(
              //   context: context,
              //   builder: (context, child) {
              //     return Theme(
              //       data: datePickerDarkTheme,
              //       child: child!,
              //     );
              //   },
              //   initialDate: DateTime.now(),
              //   firstDate: DateTime.now(),
              //   lastDate: DateTime(2200),
              // ).then((value) =>
              //     Navigator.push(context, MaterialPageRoute(builder: (context) {
              //       return const AppointmentScreen();
              //     })));
            },
          ),
          const BatchesCard(),
          const QuickActionCardWM(),
          const BlogsWidget(expertiseId: "6229a968eb71920e5c85b0af"),
          const FitnessToolsCard(),
          const WmHomeCard(),
          CustomCarouselSlider(
            imageUrls: [
              // 'assets/images/banner13-01.png',
              // 'assets/images/banner13-03.png',
              {
                'image': 'assets/images/wm/wm4.jpg',
                'route': () {},
              },
              {
                'image': 'assets/images/wm/wm5.jpg',
                'route': () {},
              },
              {
                'image': 'assets/images/wm/wm6.jpg',
                'route': () {},
              },
              {
                'image': 'assets/images/wm/wm7.jpg',
                'route': () {},
              },
            ],
          ),
          const SyncHealthAppCard(),
          const ShopList(
            image:
                "https://cdn.shopify.com/s/files/1/0005/5335/3267/products/WPC_1000g_Creatine_100g_grande.jpg?v=1648204173",
          ),
        ],
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
                hint:  Row(
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
}
