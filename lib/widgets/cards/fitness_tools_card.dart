import 'package:flutter/material.dart';
import 'package:healthonify_mobile/screens/client_screens/fitness_tools/bmi_details.dart';
import 'package:healthonify_mobile/screens/client_screens/fitness_tools/bmr_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/fitness_tools/body_fat_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/fitness_tools/ideal_weight_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/fitness_tools/lean_body_mass.dart';
import 'package:healthonify_mobile/screens/client_screens/fitness_tools/macros_calc.dart';
import 'package:healthonify_mobile/screens/client_screens/fitness_tools/rmr_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/fitness_tools/set_calories_target.dart';

class FitnessToolsCard extends StatelessWidget {
  const FitnessToolsCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> gridItems = [
      {
        'title': 'BMI',
        'onClick': () {
          Navigator.of(
            context, /*rootnavigator: true*/
          ).push(MaterialPageRoute(builder: (context) {
            return BmiDetailsScreen();
          }));
        },
        'icon': 'assets/icons/bmi.png'
      },
      {
        'title': 'BMR',
        'onClick': () {
          Navigator.of(
            context, /*rootnavigator: true*/
          ).push(MaterialPageRoute(builder: (context) {
            return const BMRScreen();
          }));
        },
        'icon': 'assets/icons/bmr.png'
      },
      {
        'title': 'Calorie Intake',
        'onClick': () {
          Navigator.of(
            context, /*rootnavigator: true*/
          ).push(MaterialPageRoute(builder: (context) {
            return const SetCaloriesTarget();
          }));
        },
        'icon': 'assets/icons/calories.png'
      },
      {
        'title': 'Ideal Weight',
        'onClick': () {
          Navigator.of(
            context, /*rootnavigator: true*/
          ).push(MaterialPageRoute(builder: (context) {
            return const IdealWeightScreen();
          }));
        },
        'icon': 'assets/icons/weigh_machine.png'
      },
      {
        'title': 'Body Fat',
        'onClick': () {
          Navigator.of(
            context, /*rootnavigator: true*/
          ).push(MaterialPageRoute(builder: (context) {
            return const BodyFatScreen();
          }));
        },
        'icon': 'assets/icons/body_fat.png'
      },
      {
        'title': 'Lean Body Mass',
        'onClick': () {
          Navigator.of(
            context, /*rootnavigator: true*/
          ).push(MaterialPageRoute(builder: (context) {
            return const LeanBodyMassScreen();
          }));
        },
        'icon': 'assets/icons/body_mass.png'
      },
      {
        'title': 'Macro Calculator',
        'onClick': () {
          Navigator.of(
            context, /*rootnavigator: true*/
          ).push(MaterialPageRoute(builder: (context) {
            return const MacrosCalculatorScreen();
          }));
        },
        'icon': 'assets/icons/calculator.png'
      },
      {
        'title': 'RMR',
        'onClick': () {
          Navigator.of(
            context, /*rootnavigator: true*/
          ).push(MaterialPageRoute(builder: (context) {
            return const RMRscreen();
          }));
        },
        'icon': 'assets/icons/rmr.png',
      }
    ];
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16, bottom: 8),
              child: Text(
                'Fitness tools',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.98,
                child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisExtent: 100,
                      ),
                      itemCount: 8,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: gridItems[index]['onClick'],
                          borderRadius: BorderRadius.circular(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                gridItems[index]["icon"],
                                height: 40,
                                width: 40,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                gridItems[index]["title"],
                                style: Theme.of(context).textTheme.labelSmall,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        // child: InkWell(
        //   onTap: () {
        //     // showBottomSheet(context);
        //     modalSheet(context);
        //   },
        //   borderRadius: BorderRadius.circular(8),
        //   child: Container(
        //     height: 56,
        //     width: MediaQuery.of(context).size.width * 0.95,
        //     decoration: BoxDecoration(
        //       color: Colors.white,
        //       borderRadius: BorderRadius.circular(8),
        //     ),
        //     child: Padding(
        //       padding: const EdgeInsets.symmetric(horizontal: 8),
        //       child: Row(
        //         children: [
        //           const Text(
        //             'Fitness Tools',
        //             style: Theme.of(context).textTheme.bodyLarge,
        //           ),
        //           Padding(
        //             padding: const EdgeInsets.only(left: 8),
        // child: Image.asset(
        //   'assets/icons/weight.png',
        //   height: 28,
        //   width: 28,
        // ),
        //           ),
        //         ],
        //       ),
        //     ),
        //   ),
        // ),
      ),
    );
  }
}
