import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:healthonify_mobile/models/health_care/ayurveda_models/ayurveda_plans_model.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/health_care/ayurveda_provider/ayurveda_provider.dart';
import 'package:healthonify_mobile/screens/client_screens/health_care/ayurveda/buy_ayurveda_plan.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:provider/provider.dart';

class AyurvedaConditionsScreen extends StatelessWidget {
  final String? condition;
  final String? conditionId;
  AyurvedaConditionsScreen(
      {required this.condition, required this.conditionId, Key? key})
      : super(key: key);
  List<AyurvedaPlansModel> ayurvedaConditions = [];

  Future<void> fetchAyurvedaConditions(BuildContext context) async {
    try {
      ayurvedaConditions =
          await Provider.of<AyurvedaProvider>(context, listen: false)
              .getAyurvedaPlans("?conditionId=$conditionId");

      log('fetched ayurveda conditions');
    } on HttpException catch (e) {
      log(e.toString());
    } catch (e) {
      log('Error fetching ayurveda conditions');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(appBarTitle: "$condition"),
      body: FutureBuilder(
          future: fetchAyurvedaConditions(context),
          builder: (context, snapshot) =>
              snapshot.connectionState == ConnectionState.waiting
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : plansList(context)),
    );
  }

  Widget plansList(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.end,
        //   children: [
        //     Padding(
        //       padding: const EdgeInsets.only(right: 4),
        //       child: IconButton(
        //         onPressed: () {
        //           Navigator.pop(context);
        //         },
        //         icon: const Icon(
        //           Icons.close_rounded,
        //           size: 28,
        //           color: orange,
        //         ),
        //         splashRadius: 20,
        //       ),
        //     ),
        //   ],
        // ),
        ayurvedaConditions.isEmpty
            ? const Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("No plans available"),
                ),
              )
            : ListView.separated(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: ayurvedaConditions.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      '${ayurvedaConditions[index].name}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    trailing: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return BuyAyurvedaPlan(
                            plan: ayurvedaConditions[index],
                          );
                        }));
                      },
                      child: Text(
                        'View Plan',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return const Divider(color: Colors.grey);
                },
              ),
        const SizedBox(height: 20),
      ],
    );
  }

  // void showPlans(context) {
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     builder: (context) {
  //       return plansList();
  //     },
  //   );
  // }
}
