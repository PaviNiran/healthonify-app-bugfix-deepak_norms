// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/client/home_client/home_top_dropdown.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/live_well/live_well_models.dart';
import 'package:healthonify_mobile/providers/live_well_providers/live_well_provider.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/screens/client_screens/blogs/blogs_widget.dart';
import 'package:healthonify_mobile/screens/client_screens/consult_experts.dart';
import 'package:healthonify_mobile/screens/client_screens/fitness_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/health_care/health_care.dart';
import 'package:healthonify_mobile/screens/client_screens/live_well/browse_livewell_plans.dart';
import 'package:healthonify_mobile/screens/client_screens/live_well/sub_categories.dart';
import 'package:healthonify_mobile/screens/client_screens/live_well/sub_category_scroller.dart';
import 'package:healthonify_mobile/screens/client_screens/physio/packages_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/physio/physiotherapy_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/weight_management/manage_weight_screen.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:healthonify_mobile/widgets/other/horiz_list_view/home_top_list_buttons.dart';
import 'package:provider/provider.dart';
import 'package:healthonify_mobile/widgets/other/carousel_slider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../func/loading_dialog_container.dart';
import '../../../models/health_care/health_care_expert/health_care_expert.dart';
import '../../../models/user.dart';
import '../../../providers/experts_data.dart';
import '../../../providers/physiotherapy/enquiry_form_data.dart';
import '../../../widgets/buttons/custom_buttons.dart';
import '../../../widgets/text fields/support_text_fields.dart';
import '../../main_screen.dart';
import '../../notifications_screen.dart';
import '../reminders/reminders_screen.dart';

class LiveWellScreen extends StatefulWidget {
  LiveWellScreen({Key? key, this.category}) : super(key: key);
  int? category;

  @override
  State<LiveWellScreen> createState() => _LiveWellScreenState();
}

class _LiveWellScreenState extends State<LiveWellScreen> {
  bool isLoading = true;
  List<LiveWellCategories> liveWellCategories = [];
  List<LiveWellCategories> liveWellSubCategories = [];
  int? selectedCategoryValue;
  List<Category> categoryData = [];
  List options = [
    "Physiotherapy",
    "Weight Management",
    "Fitness",
    "Travel",
    "Health Care",
    "Auyrveda",
    "De-stress",
    "Others"
  ];
  final _form = GlobalKey<FormState>();
  final Map<String, String> data = {
    "name": "",
    "email": "",
    "contactNumber": "",
    "userId": "",
    "enquiryFor": "",
    "message": "",
    "category": "",
  };

  Future<void> getCategories() async {
    try {
      liveWellCategories =
          await Provider.of<LiveWellProvider>(context, listen: false)
              .getLiveWellCategories("master=1");
      log('fetched live well categories');

      log("${liveWellCategories[0].parentCategoryId}");
      liveWellSubCategories =
          await Provider.of<LiveWellProvider>(context, listen: false)
              .getLiveWellCategories(
                  "parentCategoryId=${liveWellCategories[0].parentCategoryId}");
      log('fetched live well sub categories');
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.message);
    } catch (e) {
      log("Error getting live well categories: $e");
      Fluttertoast.showToast(msg: "Unable to fetch live well categories");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  late String userName;
  String? description;
  Map<String, dynamic> requestAppointment = {};
  List<HealthCareExpert> expertData = [];
  late String userId;
  TextEditingController descController = TextEditingController();

  String? selectedValue;

  Future<void> getExperts() async {
    try {
      // expertData = await Provider.of<ExpertsData>(context, listen: false)
      //     .fetchHealthCareExpertsData(widget.expertId!);
    } on HttpException catch (e) {
      log(e.toString());
    } catch (e) {
      log("Error get fetch experts $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    userName =
        Provider.of<UserData>(context, listen: false).userData.firstName!;
    userId = Provider.of<UserData>(context, listen: false).userData.id!;
    getCategories();
    selectedCategoryValue = widget.category;
    setState(() {
      categoryData = homeTopList;
    });
  }

  @override
  Widget build(BuildContext context) {
    User userData = Provider.of<UserData>(context).userData;
    setData(userData);
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
        body: liveWellContent(context),
      ),
      // appBar: AppBar(
      //   elevation: 0,
      //   shadowColor: Colors.transparent,
      //   leading: IconButton(
      //     onPressed: () {
      //       Navigator.pop(context);
      //     },
      //     icon: Icon(
      //       Icons.arrow_back_ios,
      //       color: Theme.of(context).colorScheme.onBackground,
      //       size: 25,
      //     ),
      //   ),
      //   title: flexibleAppBar(context),
      // ),
      // body:
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
                value: selectedCategoryValue,
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
                    selectedCategoryValue = value as int;

                    if (selectedCategoryValue == 1) {
                      Navigator.of(
                        context, /*rootnavigator: true*/
                      ).pushReplacement(MaterialPageRoute(builder: (context) {
                        return HealthCareScreen(category: 1);
                      }));
                    } else if (selectedCategoryValue == 2) {
                      Navigator.of(
                        context, /*rootnavigator: true*/
                      ).pushReplacement(MaterialPageRoute(builder: (context) {
                        return ManageWeightScreen(category: 2);
                      }));
                    } else if (selectedCategoryValue == 3) {
                      Navigator.of(
                        context, /*rootnavigator: true*/
                      ).pushReplacement(MaterialPageRoute(builder: (context) {
                        return FitnessScreen(category: 3);
                      }));
                    } else if (selectedCategoryValue == 4) {
                      Navigator.of(
                        context, /*rootnavigator: true*/
                      ).pushReplacement(MaterialPageRoute(builder: (context) {
                        return PhysiotherapyScreen(category: 4);
                      }));
                    } else if (selectedCategoryValue == 5) {
                      Navigator.of(
                        context, /*rootnavigator: true*/
                      ).pushReplacement(MaterialPageRoute(builder: (context) {
                        return ConsultExpertsScreen(category: 5);
                      }));
                    } else if (selectedCategoryValue == 6) {
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

  Widget liveWellContent(context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const LiveWellTopList(),
                CustomCarouselSlider(imageUrls: [
                  {
                    'image': 'assets/images/livewell/livewell1.jpg',
                    'route': () {},
                  },
                  {
                    'image': 'assets/images/livewell/livewell2.jpg',
                    'route': () {},
                  },
                  {
                    'image': 'assets/images/livewell/livewell3.jpg',
                    'route': () {},
                  },
                  {
                    'image': 'assets/images/livewell/livewell4.jpg',
                    'route': () {},
                  },
                ]),
                // Stack(
                //   children: [
                //     Container(
                //       height: 300,
                //       decoration: const BoxDecoration(
                //         color: Colors.blueAccent,
                //         image: DecorationImage(
                //           image: NetworkImage(
                //               'https://imgs.search.brave.com/KnYsqVp8kaH7mTNkpOsqZBeUWrL_PFBcd5RlR3lOtwY/rs:fit:509:339:1/g:ce/aHR0cHM6Ly9tZWRp/YS5pc3RvY2twaG90/by5jb20vcGhvdG9z/L25pYWdhcmEtZmFs/bHMtcGljdHVyZS1p/ZDUwODM0NTI1Mj9r/PTYmbT01MDgzNDUy/NTImcz0xNzA2Njdh/Jnc9MCZoPWJmR2FC/c0w4VmZCVExxSnhG/UHdtOGNYR2FaTHNn/TDM0R2E0SlNyaFR0/TjA9'),
                //           fit: BoxFit.cover,
                //         ),
                //       ),
                //     ),
                //     Container(
                //       height: 300,
                //       decoration: const BoxDecoration(
                //         gradient: LinearGradient(
                //           colors: [
                //             Colors.transparent,
                //             Colors.black,
                //           ],
                //           begin: Alignment.topCenter,
                //           end: Alignment.bottomCenter,
                //         ),
                //       ),
                //     ),
                //     Positioned(
                //       bottom: 70,
                //       left: 20,
                //       child: Row(
                //         children: [
                //           Text(
                //             'Welcome $userName',
                //             style: Theme.of(context).textTheme.headlineSmall,
                //           ),
                //           const SizedBox(width: 100),
                //           SizedBox(
                //             height: 140,
                //             width: 90,
                //             child: Column(
                //               children: [
                //                 ClipRRect(
                //                   borderRadius: BorderRadius.circular(10),
                //                   child: Image.network(
                //                     'https://imgs.search.brave.com/I3a3Q76pBHHovEy_O1-BP9Xgeb4TAP2hXh8Aatb0XvQ/rs:fit:1200:1200:1/g:ce/aHR0cHM6Ly9iZXN0/cHJvZmlsZXBpY3R1/cmVzLmNvbS93cC1j/b250ZW50L3VwbG9h/ZHMvMjAyMS8wOC9B/bWF6aW5nLVByb2Zp/bGUtUGljdHVyZS1m/b3ItRmFjZWJvb2su/anBn',
                //                     fit: BoxFit.cover,
                //                   ),
                //                 ),
                //                 Text(
                //                   'Remember to breathe well',
                //                   style:
                //                       Theme.of(context).textTheme.bodySmall,
                //                 ),
                //               ],
                //             ),
                //           ),
                //         ],
                //       ),
                //     ),
                //   ],
                // ),
                Padding(
                  padding: const EdgeInsets.all(4),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Your Appointments",
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Book and view your consultations here',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                constraints:
                                const BoxConstraints(minWidth: 70, minHeight: 40),
                                decoration: BoxDecoration(
                                  gradient: purpleGradient,
                                  borderRadius:
                                  const BorderRadius.all(Radius.circular(10.0)),
                                ),
                                child: InkWell(
                                  onTap: () {

                                  },
                                  borderRadius: BorderRadius.circular(10),
                                  child: Center(
                                    child: Text(
                                      'View',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium!
                                          .copyWith(color: whiteColor),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                constraints:
                                const BoxConstraints(minWidth: 90, minHeight: 40),
                                decoration: BoxDecoration(
                                  gradient: purpleGradient,
                                  borderRadius:
                                  const BorderRadius.all(Radius.circular(10.0)),
                                ),
                                child: InkWell(
                                  onTap: () {
                                    _showBottomSheet();
                                  },
                                  borderRadius: BorderRadius.circular(10),
                                  child: Padding(
                                    padding:
                                    const EdgeInsets.symmetric(horizontal: 10.0),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.add,
                                          color: Colors.white,
                                        ),
                                        Text(
                                          'Request',
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelMedium!
                                              .copyWith(color: whiteColor),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                //   children: [
                //     SizedBox(
                //       width: 200,
                //       child: ElevatedButton(
                //         onPressed: () {
                //           Navigator.of(context).push(MaterialPageRoute(
                //             builder: (context) => const BrowseLiveWellPlans(),
                //           ));
                //         },
                //         child: Text(
                //           "View Plans",
                //           style: Theme.of(context).textTheme.labelSmall,
                //         ),
                //       ),
                //     ),
                //     ElevatedButton(
                //       onPressed: () {
                //         _showBottomSheet();
                //       },
                //       child: Text(
                //         'Request Appointment',
                //         style: Theme.of(context).textTheme.labelSmall,
                //       ),
                //     ),
                //   ],
                // ),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: liveWellCategories.length,
                  itemBuilder: (context, verticalIndex) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                liveWellCategories[verticalIndex].name!,
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                              TextButton(
                                onPressed: () {
                                  log(liveWellCategories[verticalIndex]
                                      .parentCategoryId!);
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return SubCategoriesScreen(
                                      screenTitle:
                                          liveWellCategories[verticalIndex]
                                              .name!,
                                      parentCategoryId:
                                          liveWellCategories[verticalIndex]
                                              .parentCategoryId!,
                                    );
                                  }));
                                },
                                child: const Text('show all'),
                              ),
                            ],
                          ),
                        ),
                        SubCategoryScroller(
                          parentCategoryId: liveWellCategories[verticalIndex]
                              .parentCategoryId!,
                        ),
                      ],
                    );
                  },
                ),
                const BlogsWidget(expertiseId: ""),
              ],
            ),
          );
  }

  void popFunction() {
    Navigator.pop(context);
  }

  bool isFormSubmitting = false;

  Future<void> submitForm() async {
    try {
      await Provider.of<EnquiryData>(context, listen: false)
          .submitEnquiryForm(data);
      Fluttertoast.showToast(
          msg: "Appointment Requested, an expert will get back to you soon");
    } on HttpException catch (e) {
      log(e.toString());
      // Fluttertoast.showToast(msg: e.message);
    } catch (e) {
      log("Error login auth widget $e");
      // Fluttertoast.showToast(msg: "Not able to submit your request");
    } finally {
      Navigator.of(context).pop();
    }
  }

  void setData(User userData) {
    data["name"] = userData.firstName!;
    data["email"] = userData.email!;
    data["contactNumber"] = userData.mobile ?? "";
    data["enquiryFor"] = "generalEnquiry";
    data["category"] = "Physiotherapy";
    data["userId"] = userData.id!;
  }

  void onSubmit() {
    if (!_form.currentState!.validate()) {
      // setState(() => isLoading = false);
      return;
    }
    if (selectedValue == null) {
      Fluttertoast.showToast(msg: "Please choose a value from the dropdown");
    }
    data["category"] = selectedValue!;
    _form.currentState!.save();
    log(data.toString());
    submitForm();
  }

  void _showBottomSheet() {
    showModalBottomSheet(
        elevation: 10,
        isScrollControlled: true,
        context: context,
        builder: (ctx) => SingleChildScrollView(
              child: GestureDetector(
                onTap: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                child: Form(
                  key: _form,
                  child: Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(ctx).viewInsets.bottom + 1),
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: const Icon(Icons.close),
                          ),
                        ],
                      ),
                      Center(
                        child: Text(
                          "Request Appointment",
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Explain your issue",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            IssueField(getValue: (value) {
                              data["message"] = value;
                            }),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                      StatefulBuilder(
                        builder: (context, newState) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: DropdownButtonFormField(
                            isDense: true,
                            items:
                                options.map<DropdownMenuItem<String>>((value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        color: Colors.grey,
                                      ),
                                ),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              newState(() {
                                selectedValue = newValue!;
                              });
                            },
                            value: selectedValue,
                            style: Theme.of(context).textTheme.bodyMedium,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Colors.grey,
                                  width: 1.25,
                                ),
                              ),
                              constraints: const BoxConstraints(
                                maxHeight: 56,
                              ),
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                            ),
                            icon: const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: Colors.grey,
                            ),
                            borderRadius: BorderRadius.circular(8),
                            hint: Text(
                              'Select',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(color: Colors.grey),
                            ),
                          ),
                        ),
                      ),
                      Center(
                          child: SaveButton(
                        isLoading: false,
                        submit: onSubmit,
                        title: "Request Now",
                      )),
                    ]),
                  ),
                ),
              ),
            ));
  }
}
