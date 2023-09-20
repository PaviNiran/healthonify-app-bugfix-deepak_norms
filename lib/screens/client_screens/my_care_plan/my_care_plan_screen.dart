// ignore_for_file: use_build_context_synchronously
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:healthonify_mobile/func/get_subscriptions.dart';
import 'package:healthonify_mobile/models/experts/subscriptions.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/wm/diet_plan_model.dart';
import 'package:healthonify_mobile/providers/experts/subscriptions_data.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/providers/weight_management/diet_plan_provider.dart';
import 'package:healthonify_mobile/providers/weight_management/wm_subscriptions_data.dart';
import 'package:healthonify_mobile/screens/client_screens/fitness_tools/browse_fitness_plans.dart';
import 'package:healthonify_mobile/screens/client_screens/health_care/ayurveda/browse_plans/browse_hc_plans.dart';
import 'package:healthonify_mobile/screens/client_screens/live_well/browse_livewell_plans.dart';
import 'package:healthonify_mobile/screens/client_screens/physio/subscriptions/physio_viewall_subscriptions.dart';
import 'package:healthonify_mobile/screens/client_screens/weight_management/quick_actions/browse_plans.dart';
import 'package:healthonify_mobile/screens/client_screens/weight_management/wm_subscriptions.dart';
import 'package:healthonify_mobile/screens/expert_screens/home/diet/my_diet_plans/my_diet_plans_screen.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:provider/provider.dart';

class MyCarePlanScreen extends StatefulWidget {
  final String title;
  const MyCarePlanScreen({Key? key, this.title = "My care plan"})
      : super(key: key);

  @override
  State<MyCarePlanScreen> createState() => _MyCarePlanScreenState();
}

class _MyCarePlanScreenState extends State<MyCarePlanScreen> {
  bool noContent = false;
  bool isLoading = false;
  List<DietPlan> dietPlans = [];
  List<Subscriptions> subPlan = [];

  Future<void> getFitness(BuildContext context, String id) async {
    noContent = await GetSubscription()
        .getFitnessSubs(context, "userId=$id&isActive=true&flow=fitness");
  }

  Future<void> getManageWeight(BuildContext context, String id) async {
    noContent = await GetSubscription()
        .getPhysioSubs(context, "userId=$id&isActive=true&flow=manageweight");
  }

  Future<void> getLiveWell(BuildContext context, String id) async {
    noContent = await GetSubscription()
        .getPhysioSubs(context, "userId=$id&isActive=true&flow=livewell");
  }

  Future<void> getAyurveda(BuildContext context, String id) async {
    noContent = await GetSubscription()
        .getPhysioSubs(context, "userId=$id&isActive=true&flow=healthCare");
  }

  Future<void> getSub(BuildContext context, String id) async {
    noContent = await GetSubscription()
        .getPhysioSubs(context, "userId=$id&isActive=true&flow=physio");
  }

  Future<void> getHcSubs(BuildContext context, String id) async {
    noContent = await GetSubscription()
        .getHcSubs(context, "userId=$id&flow=healthcare&isActive=true");
  }

  Future<void> getWmSubs(BuildContext context, String id) async {
    noContent =
        await GetSubscription().getWmSubs(context, "userId=$id&isActive=true");
  }

  Future<void> getDietPlans(BuildContext context, String id) async {
    try {
      dietPlans = await Provider.of<DietPlanProvider>(context, listen: false)
          .getUserDietPlans("?userId=$id");
    } on HttpException catch (e) {
      log(e.toString());
      // Fluttertoast.showToast(msg: "Something went wrong");
    } catch (e) {
      log("Error getting diet details $e");
      // Fluttertoast.showToast(msg: "Something went wrong");
    } finally {}
  }

  void fetchData() async {
    setState(() {
      isLoading = true;
    });
    String id = Provider.of<UserData>(context, listen: false).userData.id!;
    await getSub(context, id);
     await getWmSubs(context, id);
    // await getDietPlans(context, id);
     await getHcSubs(context, id);
    //
     await getFitness(context, id);
     await getLiveWell(context, id);
     await getAyurveda(context, id);
    // await getManageWeight(context, id);
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(appBarTitle: widget.title),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Physiotherapy Plans",
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        const Spacer(),
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      PhysioViewAllSubscriptions(),
                                ),
                              );
                            },
                            child: const Text("View all"))
                      ],
                    ),
                    Consumer<SubscriptionsData>(
                      builder: (context, value, child) => value.subsData.isEmpty
                          ? const Text("No Plans Available")
                          : ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: value.subsData.length > 4
                                  ? 4
                                  : value.subsData.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) => Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    value.subsData[index].packageName ?? "-",
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                ),
                              ),
                            ),
                    ),
                    Row(
                      children: [
                        Text(
                          "Fitness Plan",
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        const Spacer(),
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => WmAllSubscriptions(),
                                ),
                              );
                            },
                            child: const Text("View all"))
                      ],
                    ),
                    Consumer<SubscriptionsData>(
                      builder: (context, value, child) => value.subsFitnessData.isEmpty
                          ? const Text("No Plans Available")
                          : ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: value.subsFitnessData.length > 4
                            ? 4
                            : value.subsFitnessData.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) => Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              value.subsFitnessData[index].packageName ?? "-",
                              style:
                              Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          "Diet Plan",
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        const Spacer(),
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const MyDietPlans(),
                                ),
                              );
                            },
                            child: const Text("View all"))
                      ],
                    ),
                    dietPlans.isEmpty
                        ? const Text("No Plans Available")
                        : ListView.builder(
                            itemCount:
                                dietPlans.length > 4 ? 4 : dietPlans.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) => Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  dietPlans[index].name ?? "-",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                    Row(
                      children: [
                        Text(
                          "Health Care Plans",
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const BrowseHealthCarePlans(),
                              ),
                            );
                          },
                          child: const Text("View all"),
                        ),
                      ],
                    ),
                    Consumer<SubscriptionsData>(
                      builder: (context, value, child) => value
                              .hcSubsData.isEmpty
                          ? const Text("No Plans Available")
                          : ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: value.hcSubsData.length > 4
                                  ? 4
                                  : value.hcSubsData.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) => Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    value.hcSubsData[index].packageName ?? "-",
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                ),
                              ),
                            ),
                    ),

                    Row(
                      children: [
                        Text(
                          "Ayurveda",
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const BrowseHealthCarePlans(),
                              ),
                            );
                          },
                          child: const Text("View all"),
                        ),
                      ],
                    ),
                    Consumer<SubscriptionsData>(
                      builder: (context, value, child) => value.subsData.isEmpty
                          ? const Text("No Plans Available")
                          : ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: value.subsData.length > 4
                            ? 4
                            : value.subsData.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) => Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              value.subsData[index].packageName ?? "-",
                              style:
                              Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        ),
                      ),
                    ),

                    Row(
                      children: [
                        Text(
                          'Manage Weight',
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const WmPackagesQuickActionsScreen(),
                              ),
                            );
                          },
                          child: const Text("View all"),
                        ),
                      ],
                    ),
                    Consumer<WmSubscriptionsData>(
                      builder: (context, value, child) => value.subsData.isEmpty
                          ? const Text("No Plans Available")
                          : ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: value.subsData.length > 4
                            ? 4
                            : value.subsData.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) => Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              value.subsData[index].packageName ?? "-",
                              style:
                              Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          'Live Well',
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const BrowseLiveWellPlans(),
                              ),
                            );
                          },
                          child: const Text("View all"),
                        ),
                      ],
                    ),
                    Consumer<SubscriptionsData>(
                      builder: (context, value, child) => value.subsData.isEmpty
                          ? const Text("No Plans Available")
                          : ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: value.subsData.length > 4
                            ? 4
                            : value.subsData.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) => Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              value.subsData[index].packageName ?? "-",
                              style:
                              Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget clickableCard(context, String cardName, Function onTapped) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Card(
        child: InkWell(
          onTap: () {
            onTapped();
          },
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: Text(cardName),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: Colors.grey,
                  size: 32,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
