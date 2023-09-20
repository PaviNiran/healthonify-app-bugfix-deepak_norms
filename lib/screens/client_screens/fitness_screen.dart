import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/client/home_client/home_top_dropdown.dart';
import 'package:healthonify_mobile/screens/client_screens/consult_experts.dart';
import 'package:healthonify_mobile/screens/client_screens/fitness_tools/browse_fitness_plans.dart';
import 'package:healthonify_mobile/screens/client_screens/health_care/health_care.dart';
import 'package:healthonify_mobile/screens/client_screens/live_well/live_well_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/physio/physiotherapy_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/reminders/reminders_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/weight_management/manage_weight_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/weight_management/quick_actions/browse_plans.dart';
import 'package:healthonify_mobile/screens/client_screens/weight_management/weight_loss_enquiry.dart';
import 'package:healthonify_mobile/widgets/cards/activity_card.dart';
import 'package:healthonify_mobile/widgets/cards/batches_card.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:healthonify_mobile/widgets/cards/fitness_log_cards.dart';
import 'package:healthonify_mobile/widgets/cards/fitness_tools_card.dart';
import 'package:healthonify_mobile/widgets/cards/health_app_sync_card.dart';
import 'package:healthonify_mobile/widgets/cards/home_cards.dart';
import 'package:healthonify_mobile/widgets/cards/quick_actions_card.dart';
import 'package:healthonify_mobile/widgets/cards/steps_card.dart';
import 'package:healthonify_mobile/widgets/fitness/fitness_centre_nearme_button.dart';
import 'package:healthonify_mobile/widgets/other/carousel_slider.dart';
import 'package:healthonify_mobile/widgets/other/horiz_list_view/home_top_list_buttons.dart';
import 'package:healthonify_mobile/widgets/wm/wm_my_appointments_card.dart';
import 'package:url_launcher/url_launcher.dart';
import '../main_screen.dart';
import '../notifications_screen.dart';
import 'blogs/blogs_widget.dart';

class FitnessScreen extends StatefulWidget {
  FitnessScreen({Key? key,this.category}) : super(key: key);
  int? category;
  @override
  State<FitnessScreen> createState() => _FitnessScreenState();
}

class _FitnessScreenState extends State<FitnessScreen> {
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
      // appBar: AppBar(
      //   elevation: 0,
      //   shadowColor: Colors.transparent,
      //   leading: IconButton(
      //     onPressed: () {
      //       Navigator.pop(context);
      //     },
      //     icon: const Icon(
      //       Icons.chevron_left_rounded,
      //       size: 32,
      //       color: Colors.grey,
      //     ),
      //   ),
      //   title: Text(
      //     'Fitness',
      //     style: Theme.of(context).textTheme.headlineSmall,
      //   ),
      // ),
      body: NestedScrollView(
        headerSliverBuilder: (context, value) {
          return [
            // const FlexibleAppBar(
            //   title: 'Fitness',
            //   listItems: FitnessTopList(),
            // ),
            flexibleAppBar(context),
          ];
        },
        body: fitnessContent(context),
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
                    // else if (selectedValue == 7) {
                    //   launchUrl(Uri.parse("https://healthonify.com/Shop"));
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

  Widget fitnessContent(context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // const FitnessTopList(),
          const FitnessTopList(),
          CustomCarouselSlider(
            imageUrls: [
              // 'assets/images/Picture12.png',
              {
                'image': 'assets/images/livewell/livebanner1.jpg',
                'route': () {},
              },
              {
                'image': 'assets/images/livewell/livebanner2.jpg',
                'route': () {},
              },
              {
                'image': 'assets/images/livewell/livebanner3.jpg',
                'route': () {},
              },
            ],
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.end,
          //   children: [
          //     Padding(
          //       padding: const EdgeInsets.only(right: 8, bottom: 12),
          //       child: Container(
          //         height: 36,
          //         decoration: BoxDecoration(
          //           color: Colors.orange,
          //           borderRadius: BorderRadius.circular(8),
          //         ),
          //         child: TextButton(
          //           onPressed: () {},
          //           child: const Padding(
          //             padding: EdgeInsets.symmetric(horizontal: 4),
          //             child: Text(
          //               'Fitness centre near me',
          // //               style: Theme.of(context)
          //                   .textTheme
          //                   .labelMedium!
          //                   .copyWith(
          //                     color: whiteColor
          //                   ),
          //             ),
          //           ),
          //         ),
          //       ),
          //     )
          //   ],
          // ),
          const FitnessCenterNearmeButton(),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) {
                          return const BrowseFitnessPlans();
                        }),
                      );
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
          const ChallengesScroller(),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              TotalWorkoutHours(),
            ],
          ),
          const StepsCard(),
          const Center(child: ActivityCard()),
          WMMyAppoinmentsCard(
            onRequest: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const WeightLossEnquiry(isFitnessFlow: true);
              }));
              // showDatePicker(
              //   context: context,
              //   builder: (context, child) {
              //     return Theme(
              //       data: MediaQuery.of(context).platformBrightness ==
              //               Brightness.dark
              //           ? datePickerDarkTheme
              //           : datePickerLightTheme,
              //       child: child!,
              //     );
              //   },
              //   initialDate: DateTime.now(),
              //   firstDate: DateTime(1800),
              //   lastDate: DateTime(2200),
              // ).then((value) =>
              //     Navigator.push(context, MaterialPageRoute(builder: (context) {
              //       return const AppointmentScreen();
              //     })));
            },
          ),
          CustomCarouselSlider(
            imageUrls: [
              // 'assets/images/Picture14.png',
              // 'assets/images/Picture15.png',
              // 'assets/images/banner9-03.png',
              {
                'image': 'assets/images/livewell/livebanner4.jpg',
                'route': () {},
              },
              {
                'image': 'assets/images/livewell/livebanner5.jpg',
                'route': () {},
              },
              {
                'image': 'assets/images/livewell/livebanner6.jpg',
                'route': () {},
              },
            ],
          ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(vertical: 4),
          //   child: Center(
          //     child: SizedBox(
          //       height: 175,
          //       width: MediaQuery.of(context).size.width * 0.98,
          //       child: ClipRRect(
          //         borderRadius: BorderRadius.circular(8),
          //         child: Image.asset(
          //           'assets/images/Picture14.jpg',
          //           fit: BoxFit.cover,
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
            child: Text(
              'Quick Actions',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          const Center(
            child: QuickActionCard2(),
          ),
          const Center(child: BatchesCard()),
          const BlogsWidget(expertiseId: "63ef2333eef2ad2bdf410333"),
          const HomeCard(),
          const Center(child: FitnessToolsCard()),
          const SyncHealthAppCard(),
          CustomCarouselSlider(
            imageUrls: [
              // 'assets/images/Picture14.png',
              // 'assets/images/Picture15.png',
              // 'assets/images/banner9-03.png',
              {
                'image': 'assets/images/livewell/livebanner7.jpg',
                'route': () {},
              },
              {
                'image': 'assets/images/livewell/livebanner8.jpg',
                'route': () {},
              },
              {
                'image': 'assets/images/livewell/livebanner9.jpg',
                'route': () {},
              },
              {
                'image': 'assets/images/livewell/livebanner10.jpg',
                'route': () {},
              },
            ],
          ),
        ],
      ),
    );
  }
}
