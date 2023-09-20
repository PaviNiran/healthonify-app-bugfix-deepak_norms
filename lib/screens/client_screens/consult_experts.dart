import 'dart:developer';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/client/home_client/home_top_dropdown.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/user.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/screens/client_screens/expert_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/fitness_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/health_care/health_care.dart';
import 'package:healthonify_mobile/screens/client_screens/live_well/live_well_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/physio/physiotherapy_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/reminders/reminders_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/weight_management/manage_weight_screen.dart';
import 'package:healthonify_mobile/widgets/physio/physio_my_appointments_card.dart';
import 'package:healthonify_mobile/widgets/other/carousel_slider.dart';
import 'package:healthonify_mobile/widgets/other/horiz_list_view/home_top_list_buttons.dart';
import 'package:healthonify_mobile/widgets/other/testimonial_scroller.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../main_screen.dart';
import '../notifications_screen.dart';
import 'enquiry/enquiry_appointments_card.dart';

class ConsultExpertsScreen extends StatefulWidget {
  ConsultExpertsScreen({Key? key,this.category}) : super(key: key);
  int? category;
  @override
  State<ConsultExpertsScreen> createState() => _ConsultExpertsScreenState();
}

class _ConsultExpertsScreenState extends State<ConsultExpertsScreen> {
  bool isloading = true;

  List<User> experts = [];
  Future<void> fetchExperts() async {
    try {
      experts =
          await Provider.of<UserData>(context, listen: false).getExperts();
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
  int? selectedValue;
  List<Category> categoryData = [];
  @override
  void initState() {
    super.initState();

    fetchExperts();
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
            // FlexibleAppBar(
            //   title: 'Physiotherapy',
            //   listItems: PhysioTopList(id: id),
            // ),
            flexibleAppBar(context),
          ];
        },
        body: consultExpertContent(context),
      ),
      // appBar: AppBar(
      //   elevation: 0,
      //   shadowColor: Colors.transparent,
      //   leading: IconButton(
      //     onPressed: () {
      //       Navigator.pop(context);
      //     },
      //     icon: const Icon(
      //       Icons.chevron_left_rounded,
      //       size: 34,
      //       color: Color(0xFF717579),
      //     ),
      //   ),
      //   title: flexibleAppBar(context),
      //   actions: [
      //     IconButton(
      //       onPressed: () {},
      //       icon: const Icon(
      //         Icons.notifications,
      //         color: Color(0xFF717579),
      //         size: 25,
      //       ),
      //     ),
      //     IconButton(
      //       onPressed: () {},
      //       icon: const Icon(
      //         Icons.schedule_outlined,
      //         color: Color(0xFF717579),
      //         size: 25,
      //       ),
      //     ),
      //     IconButton(
      //       onPressed: () {},
      //       icon: const Icon(
      //         Icons.share,
      //         color: Color(0xFF717579),
      //         size: 25,
      //       ),
      //     ),
      //   ],
      // ),
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


                      // launchUrl(Uri.parse("https://healthonify.com/Shop"));

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

  Widget consultExpertContent(context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          const ExpertsTopList(),
          CustomCarouselSlider(imageUrls: [
            {
              'image': 'assets/images/consultexp/consultexp1.jpg',
              'route': () {},
            },
            {
              'image': 'assets/images/consultexp/consultexp2.jpg',
              'route': () {},
            },
            {
              'image': 'assets/images/consultexp/consultexp3.jpg',
              'route': () {},
            },
          ]),
          EnquiryMyAppoinmentsCard(
            onRequest: () {},
          ),
          isloading
              ? const SizedBox()
              : Column(
            children: [
              const SizedBox(height: 10),
              Text(
                "Our Experts",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: GridView.builder(
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 20,
                    mainAxisExtent: 86,
                    childAspectRatio: 1 / 0.55,
                  ),
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: experts.length,
                  itemBuilder: (context, index) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) {
                                  return ExpertScreen(
                                    expertId: experts[index].id!,
                                  );
                                }));
                          },
                          child: experts[index].imageUrl == null
                              ? const CircleAvatar(
                            radius: 32,
                            backgroundImage: AssetImage(
                                'assets/icons/expert_pfp.png'),
                          )
                              : CircleAvatar(
                            radius: 32,
                            backgroundImage: NetworkImage(
                              experts[index].imageUrl!,
                            ),
                          ),
                        ),
                        Text(
                          experts[index].firstName!,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
          // ExpertsHorizontalList(
          //   title: 'Doctors',
          // ),
          // ExpertsHorizontalList(
          //   title: 'Ayurveda',
          // ),
          // ExpertsHorizontalList(
          //   title: 'Dieticians',
          // ),
          // ExpertsHorizontalList(
          //   title: 'Fitness Trainers',
          // ),
          // ExpertsHorizontalList(
          //   title: 'Yoga Trainers',
          // ),
          // ExpertsHorizontalList(
          //   title: 'Sleep Specialists',
          // ),
          // ExpertsHorizontalList(
          //   title: 'Psychiatrists',
          // ),
          // ExpertsHorizontalList(
          //   title: 'Meditation',
          // ),
          CustomCarouselSlider(imageUrls: [
            {
              'image': 'assets/images/consultexp/consultexp4.jpg',
              'route': () {},
            },
            {
              'image': 'assets/images/consultexp/consultexp5.jpg',
              'route': () {},
            },
            {
              'image': 'assets/images/consultexp/consultexp6.jpg',
              'route': () {},
            },
            {
              'image': 'assets/images/consultexp/consultexp7.jpg',
              'route': () {},
            },
          ]),
          const TestimonialScroller(),
        ],
      ),
    );
  }
}
