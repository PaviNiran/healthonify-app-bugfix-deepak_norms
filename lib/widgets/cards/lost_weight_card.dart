import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:healthonify_mobile/models/wm/goals_model.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:healthonify_mobile/screens/client_screens/my_goals/my_goals.dart';

class WeightLostCard extends StatefulWidget {
  final Function updateWeight;
  final WeightGoalModel weightGoalData;
  const WeightLostCard(
      {required this.weightGoalData, Key? key, required this.updateWeight})
      : super(key: key);

  @override
  State<WeightLostCard> createState() => _WeightLostCardState();
}

class _WeightLostCardState extends State<WeightLostCard> {
  double? toLoseWeight;
  double? weightLost;
  double? weightPercent;
  bool isWeightLost = false;

  void calculateWeights() {
    if (widget.weightGoalData.startingWeight == null ||
        widget.weightGoalData.goalWeight == null) {
      Navigator.of(context).pop();
      Future.delayed(
        Duration.zero,
        () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const MyGoalsScreen(),
          ));
        },
      );
      return;
    }

    print("Starting : ${widget.weightGoalData.startingWeight}");
    print("goalWeight : ${widget.weightGoalData.goalWeight}");
    print("currentWeight : ${widget.weightGoalData.currentWeight}");

    toLoseWeight = double.parse(widget.weightGoalData.startingWeight ?? "0") -
        double.parse(widget.weightGoalData.currentWeight ?? "0");
    log(toLoseWeight.toString());

    weightLost = double.parse(widget.weightGoalData.startingWeight ?? "0") -
        double.parse(widget.weightGoalData.currentWeight ?? "0");

    isWeightLost = weightLost!.isNegative;

    weightPercent = weightLost! / toLoseWeight!;
  }

  @override
  void initState() {
    super.initState();
    calculateWeights();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.96,
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(13),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${weightLost!.abs()} kg',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall!
                                      .copyWith(color: const Color(0xFFE80945)),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  !isWeightLost
                                      ? 'out of $toLoseWeight kg lost'
                                      : 'Gained',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 8, bottom: 8, right: 25),
                              child: CircularPercentIndicator(
                                radius: 54,
                                animation: true,
                                animationDuration: 2000,
                                progressColor: const Color(0xFFE80945),
                                backgroundColor: Colors.white,
                                center: const Icon(
                                  Icons.accessibility_new_rounded,
                                  color: Color(0xFFE80945),
                                  size: 32,
                                ),
                                lineWidth: 17,
                                percent: !isWeightLost ? weightPercent ?? 0 : 1,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Row(
                  //   children: [
                  //     TextButton(
                  //       onPressed: () {},
                  //       child: Text(
                  //         'Edit',
                  //         style: Theme.of(context).textTheme.labelMedium,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 5,
          right: 5,
          child: IconButton(
              onPressed: () {
                Navigator.of(
                  context, /*rootnavigator: true*/
                ).push(MaterialPageRoute(builder: (context) {
                  return const MyGoalsScreen();
                })).then((value) {
                  if (value == true) {
                    widget.updateWeight();
                    calculateWeights();
                    setState(() {});
                  }
                });
              },
              icon: const Icon(
                Icons.edit,
                size: 20,
              )),
        ),
      ],
    );
  }
}
