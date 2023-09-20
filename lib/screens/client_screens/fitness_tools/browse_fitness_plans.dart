import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:healthonify_mobile/models/health_care/health_care_plans/health_care_plans_model.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/fitness_tools/fitness_plans_provider.dart';
import 'package:healthonify_mobile/providers/health_care/health_care_plans/health_care_plans_provider.dart';
import 'package:healthonify_mobile/providers/physiotherapy/physio_therapy_plans_provider.dart';
import 'package:healthonify_mobile/screens/client_screens/health_care/ayurveda/browse_plans/widgets/hc_plan_card.dart';


import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:provider/provider.dart';

class BrowseFitnessPlans extends StatefulWidget {
  const BrowseFitnessPlans({Key? key}) : super(key: key);

  @override
  State<BrowseFitnessPlans> createState() => _BrowseFitnessPlansState();
}

class _BrowseFitnessPlansState extends State<BrowseFitnessPlans> {
  bool isloading = true;
  List<HealthCarePlansModel> healthCarePlans = [];

  Future<void> fetchHealthCarePlans() async {
    try {
      healthCarePlans =
      await Provider.of<FitnessPlansProvider>(context, listen: false)
          .getFitnessPlans();
    } on HttpException catch (e) {
      log(e.toString());
    } catch (e) {
      log('Error fetching plans');
    } finally {
      setState(() {
        isloading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchHealthCarePlans();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(appBarTitle: 'View Plans'),
      body: isloading
          ? const Center(child: CircularProgressIndicator())
          : healthCarePlans.isNotEmpty ? Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  'Select Services',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              ListView.builder(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: healthCarePlans.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Card(
                      child: InkWell(
                        onTap: () {},
                        borderRadius: BorderRadius.circular(10),
                        child: HcPlanCard(
                            healthCarePlansModel: healthCarePlans[index],planName: "fitness",),
                      ),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ) : const Center(
        child: Text("No packages available"),
      ),
    );
  }
}