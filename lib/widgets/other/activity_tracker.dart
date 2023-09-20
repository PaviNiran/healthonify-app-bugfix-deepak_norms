import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/func/trackers/step_tracker.dart';
import 'package:healthonify_mobile/func/trackers/steps_tracker_func.dart';
import 'package:healthonify_mobile/main.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/shared_pref_manager.dart';
import 'package:healthonify_mobile/providers/trackers/all_tracker_data.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/screens/client_screens/trackers/sleep/sleep_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/trackers/step_tracker/steps_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/trackers/watertracker/water_screen.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

class ActivityTracker extends StatefulWidget {
  const ActivityTracker({Key? key}) : super(key: key);

  @override
  State<ActivityTracker> createState() => _ActivityTrackerState();
}

class _ActivityTrackerState extends State<ActivityTracker> {
  StepTrackerData stepsData = StepTrackerData();
  bool flag = false;
  bool onLoadFail = false;

  @override
  void initState() {
    super.initState();
    // getAllTrackers(context);
    print(
        "IS GOOGLE REQUEST :${kSharedPreferences.getBool("isGoogleRequest")}");
  }

  Future<void> getAllTrackers(
      BuildContext context, VoidCallback onSuccess) async {
    String? userId = Provider.of<UserData>(context, listen: false).userData.id;
    try {
      await Provider.of<AllTrackersData>(context, listen: false)
          .getAllTrackers(userId!);

      SharedPrefManager prefManager = SharedPrefManager();
      bool test = await prefManager.getStepTrackerEnabled();
      if (test == true) {
        DateTime startDate = DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day);
        stepsData = await StepTracker().initHealth(1, startDate);
        if (stepsData.stepCount != null && stepsData.stepCount != "null") {
          onSuccess.call();
        }
      }
    } on HttpException catch (e) {
      log(e.toString());
      // Fluttertoast.showToast(msg: e.message);
      onLoadFail = true;
    } catch (e) {
      log("Error something went wrong $e");
      onLoadFail = true;

      // Fluttertoast.showToast(msg: "Unable to fetch water intake data");
    } finally {
      flag = true;
    }
  }

  void waterGlassCount(String glass) {
    log("water glass $glass");
  }

  Future<void> empty() async {}

  @override
  Widget build(BuildContext context) {
    // Duration hrDiff;
    // String hrsSlept;
    // String hours;
    // String minutes;
    // String userWake = Provider.of<UserData>(context).userData.wakeupTime!;
    // String userSleep = Provider.of<UserData>(context).userData.sleepTime!;
    return FutureBuilder(
      future: flag
          ? empty()
          : getAllTrackers(context, () {
              StepsTrackerFunc().updateSteps(
                  context,
                  stepsData.stepsData!,
                  () => StepsTrackerFunc().updateSteps(
                      context,
                      stepsData.stepsData!,
                      () => Provider.of<AllTrackersData>(context, listen: false)
                          .localUpdateSteps(int.parse(stepsData.stepCount!))));
              Provider.of<AllTrackersData>(context, listen: false)
                  .localUpdateSteps(int.parse(stepsData.stepCount!));
            }),
      builder: (context, snapshot) => Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Track your activity',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 10),
                      kSharedPreferences.getBool("isGoogleRequest") == true ||
                              kSharedPreferences.getBool("isGoogleRequest") ==
                                  null
                          ? const SizedBox()
                          : GestureDetector(
                              onTap: () async {
                                kSharedPreferences.setBool(
                                    "isGoogleRequest", true);
                                DateTime startDate = DateTime(
                                    DateTime.now().year,
                                    DateTime.now().month,
                                    DateTime.now().day);
                                stepsData = await StepTracker()
                                    .initHealth(1, startDate);

                                setState(() {});
                                print(
                                    "IS GOOGLE REQUEST :${kSharedPreferences.getBool("isGoogleRequest")}");
                              },
                              child: const Text(
                                "To track steps select or add google account >>>",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: orange,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
              Consumer<AllTrackersData>(builder: (context, data, child) {
                // log(data.allTrackersData.waterProgress.toString());

                Map<String, dynamic> trackerData = setData(snapshot, data);

                print("Tracker Data11111111111111111 : ${trackerData}");

                List<Map<String, dynamic>> listData = [
                  {
                    "title": "Steps",
                    "subtitle": trackerData["stepsCount"],
                    "goal": "${trackerData["totalStepsGoal"]} steps",
                   // "goal": "${trackerData["stepsCount"]} steps",
                    "icon": const Icon(
                      Icons.directions_walk_outlined,
                      size: 22,
                      color: Colors.white,
                    ),
                    "screen": const StepsScreen(),
                    "color": Colors.red,
                    "percent": trackerData["stepsPercentage"],
                  },
                  {
                    "title": 'Sleep',
                    "subtitle": trackerData["userSleepCount"],
                    "goal": "${trackerData["sleepGoal"]}",
                    "icon": const Icon(
                      Icons.bedtime_outlined,
                      size: 22,
                      color: Colors.white,
                    ),
                    "screen": const SleepScreen(),
                    "color": Colors.blueGrey.shade800,
                    "percent": trackerData["sleepPercentage"],
                  },
                  {
                    "title": 'Water',
                    "subtitle": trackerData["glasses"],
                    "goal": '${trackerData["watergoal"]} glasses',
                    "icon": const Icon(
                      Icons.water_drop_outlined,
                      size: 22,
                      color: Colors.white,
                    ),
                    "screen": const WaterTrackerScreen(
                        // returnWaterGlass: waterGlassCount
                        ),
                    "color": Colors.blue,
                    "percent": trackerData["waterPercentage"],
                  },
                ];
                return SizedBox(
                  height: MediaQuery.of(context).size.width >= 900 ? 300 : 180,
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: listData.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: InkWell(
                          onTap: () {
                            // Navigator.push(context,
                            //     MaterialPageRoute(builder: (context) {
                            //   return _data[index]["screen"];
                            // }));
                            Navigator.of(
                              context, /*rootnavigator: true*/
                            ).push(MaterialPageRoute(builder: (context) {
                              return listData[index]["screen"];
                            })).then((value) {
                              // if (index == 2) {
                              //   log("hey");
                              //   setState(() {});
                              // }
                            });
                          },
                          borderRadius: BorderRadius.circular(10),
                          child: Column(
                            //crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 22),
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(15),
                                      topLeft: Radius.circular(15)),
                                  color: index == 0
                                      ? Colors.red
                                      : index == 1
                                          ? Colors.blue.shade200
                                          : Colors.blue,
                                ),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 7),
                                      child: Row(
                                        children: [
                                          listData[index]["icon"],
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 8),
                                            child: Text(
                                              listData[index]["title"],
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelMedium,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 3),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 14),
                                      child: Text(
                                        listData[index]["goal"],
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall!
                                            .copyWith(
                                              color: Colors.grey[400],
                                            ),
                                      ),
                                    ),

                                    circularWidget(
                                      context,
                                      listData[index]["subtitle"],
                                      listData[index]['percent'],
                                      listData[index]["color"],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget circularWidget(
    BuildContext context,
    String subTitle,
    double percentage,
    Color percentColor,
  ) {
    return CircularPercentIndicator(
      radius: MediaQuery.of(context).size.width >= 900 ? 150 : 46,
      lineWidth: 8,
      animation: true,
      percent: percentage,
      progressColor: percentColor,
      circularStrokeCap: CircularStrokeCap.round,
      center: Text(subTitle, style: Theme.of(context).textTheme.bodySmall),
    );
  }

  Map<String, dynamic> setData(AsyncSnapshot snapshot, AllTrackersData data) {
    int waterGoal, glasses;
    String totalSleepGoal = "0h", goalSleep = "0h";
    double waterPercentage, sleepPercentage, stepsPercentage = 0;
    String totalStepsGoal = "", stepsCount = "";

    if (snapshot.connectionState == ConnectionState.waiting) {
      waterGoal = glasses = 0;
      waterPercentage = sleepPercentage = 0;
    } else {
      //set water data
      waterGoal = data.allTrackersData.totalWaterGoal ?? 0;
      glasses = data.allTrackersData.userWaterGlassCount ?? 0;
      waterPercentage = glasses == 0
          ? 0
          : glasses > waterGoal
              ? 1
              : glasses / waterGoal;

      totalStepsGoal = data.allTrackersData.totalStepsGoal!.toString();
      stepsCount = data.allTrackersData.userStepsCount!.toString();

      stepsPercentage = data.allTrackersData.userStepsCount == 0
          ? 0
          : data.allTrackersData.userStepsCount! >
                  data.allTrackersData.totalStepsGoal!
              ? 1
              : data.allTrackersData.userStepsCount! /
                  data.allTrackersData.totalStepsGoal!;

      // log("steps percentage " + stepsPercentage.toString());

      //set sleep data

      int totalSleepHrs = (data.allTrackersData.totalSleepGoal! ~/ 3600);
      int totalSleepMins =
          (data.allTrackersData.totalSleepGoal!.remainder(3600) ~/ 60);
      if (totalSleepMins != 0 && totalSleepHrs != 0) {
        totalSleepGoal = "${totalSleepHrs}h ${totalSleepMins}m";
      } else if (totalSleepMins != 0 && totalSleepHrs == 0) {
        totalSleepGoal = "$totalSleepMins m";
      } else {
        totalSleepGoal = "$totalSleepHrs h";
      }

      // log(totalSleepMins.toString());

      int goalSleepMins =
          data.allTrackersData.userSleepCount!.remainder(3600) ~/ 60;
      int goalSleepHrs = data.allTrackersData.userSleepCount! ~/ 3600;

      if (goalSleepMins != 0 && goalSleepHrs != 0) {
        goalSleep = "${goalSleepHrs}h ${goalSleepMins}m";
      } else if (goalSleepMins != 0 && goalSleepHrs == 0) {
        goalSleep = "$goalSleepMins m";
      } else {
        goalSleep = "${goalSleepHrs}h";
      }

      sleepPercentage = data.allTrackersData.userSleepCount == 0
          ? 0
          : data.allTrackersData.userSleepCount! >
                  data.allTrackersData.totalSleepGoal!
              ? 1
              : data.allTrackersData.userSleepCount! /
                  data.allTrackersData.totalSleepGoal!;
      // log("sleep " + sleepPercentage.toString());
      // setState(() {});
    }

    return {
      "watergoal": waterGoal.toString(),
      "glasses": glasses.toString(),
      "waterPercentage": waterPercentage,
      "sleepGoal": totalSleepGoal,
      "userSleepCount": goalSleep,
      "sleepPercentage": sleepPercentage,
      "totalStepsGoal": totalStepsGoal,
      "stepsCount": stepsCount,
      "stepsPercentage": stepsPercentage,
    };
  }
}
