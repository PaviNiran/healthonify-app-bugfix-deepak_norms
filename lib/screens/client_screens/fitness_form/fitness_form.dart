import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/func/forms/fitness_form_func.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:healthonify_mobile/widgets/text%20fields/fitness_form_fields.dart';
import 'package:provider/provider.dart';

class FitnessForm extends StatefulWidget {
  const FitnessForm({Key? key}) : super(key: key);

  @override
  State<FitnessForm> createState() => _FitnessFormState();
}

class _FitnessFormState extends State<FitnessForm> {
  List<FitnessFormData> fitnesFormData = [];

  Future<void> getMedicalFormQuestions() async {
    try {
      fitnesFormData = await FitnessFormFunc().fetchFitnessQuestions();
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.message);
    } catch (e) {
      log("Error submitting fitness form $e");
      Fluttertoast.showToast(msg: "unable to get questions");
    }
  }

  int searchIndex(int index) {
    for (var element in fitnesFormData) {
      // log(e.lement.order.toString());
      if (element.order == index) {
        return fitnesFormData.indexOf(element);
      }
    }
    return -1;
  }

  @override
  Widget build(BuildContext context) {
    var userId = Provider.of<UserData>(context).userData.id;

    return Scaffold(
      appBar: const CustomAppBar(
        appBarTitle: 'Fitness Form',
      ),
      body: FutureBuilder(
        future: getMedicalFormQuestions(),
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : fitnesFormData.isEmpty
                    ? const Center(
                        child: Text("No questions available"),
                      )
                    : SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Column(
                            children: [
                              const SizedBox(height: 20),
                              WeightTextField(
                                getEmail: () {},
                                text: "Please enter your weight",
                                userId: userId!,
                                qId: fitnesFormData[searchIndex(1)].id!,
                                hintText: "Please enter your weight",
                                title: "Enter your weight in kg",
                              ),
                              const SizedBox(height: 20),
                              WeightTextField(
                                getEmail: () {},
                                text: "Your height in cm",
                                userId: userId,
                                qId: fitnesFormData[searchIndex(2)].id!,
                                hintText: "Please enter your height",
                                title: "Enter your height in cm",
                              ),
                              const SizedBox(height: 20),
                              WeightTextField(
                                getEmail: () {},
                                text: "Your Waist in inches",
                                userId: userId,
                                qId: fitnesFormData[searchIndex(3)].id!,
                                hintText: "Your Waist in inches",
                                title: "Enter your waist in inches",
                              ),
                              // WaistTextField(getEmail: () {}),
                              const SizedBox(height: 20),
                              FitnessGoalDropDown(
                                qid: fitnesFormData[searchIndex(4)].id!,
                                userId: userId,
                              ),
                              const SizedBox(height: 20),
                              FitnessLevelDropDown(
                                qid: fitnesFormData[searchIndex(4)].id!,
                                userId: userId,
                              ),
                              const SizedBox(height: 20),
                              WeightTextField(
                                getEmail: () {},
                                text: "Enter description",
                                userId: userId,
                                qId: fitnesFormData[searchIndex(6)].id!,
                                hintText: "Enter description",
                                textInputType: TextInputType.text,
                                title:
                                    "What diet are you following right now? Describe in detail your current eating habits?",
                              ),
                              // DescriptionTextField(getEmail: () {}),
                              const SizedBox(height: 20),

                              WeightTextField(
                                getEmail: () {},
                                text: "Enter description",
                                userId: userId,
                                qId: fitnesFormData[searchIndex(7)].id!,
                                hintText: "Enter description",
                                textInputType: TextInputType.text,
                                title:
                                    "What is your current/previous exercise routine?",
                              ),
                              const SizedBox(height: 20),

                              WeightTextField(
                                getEmail: () {},
                                text: "Enter description",
                                userId: userId,
                                qId: fitnesFormData[searchIndex(8)].id!,
                                hintText: "Enter description",
                                textInputType: TextInputType.text,
                                title:
                                    'Are you taking any over the counter or prescription medication or drugs? If Yes, please list them.',
                              ),
                              const SizedBox(height: 20),
                              WeightTextField(
                                getEmail: () {},
                                text: "Enter description",
                                userId: userId,
                                qId: fitnesFormData[searchIndex(9)].id!,
                                hintText: "Enter description",
                                textInputType: TextInputType.text,
                                title:
                                    'Any heart condition? If Yes, please explain.',
                              ),
                              const SizedBox(height: 20),
                              CheckListTile(
                                  qId: fitnesFormData[searchIndex(10)].id!,
                                  userId: userId,
                                  checkTitle:
                                      'Any pain in the chest when you do a physical activity?'),
                              const SizedBox(height: 20),
                              CheckListTile(
                                  qId: fitnesFormData[searchIndex(11)].id!,
                                  userId: userId,
                                  checkTitle:
                                      'Any pain in the chest when you were not doing any physical activity?'),
                              const SizedBox(height: 20),
                              CheckListTile(
                                  qId: fitnesFormData[searchIndex(12)].id!,
                                  userId: userId,
                                  checkTitle:
                                      'Do you lose your balance because of dizziness or do you ever lose conciousness?'),
                              CheckListTile(
                                  userId: userId,
                                  qId: fitnesFormData[searchIndex(14)].id!,
                                  checkTitle:
                                      'Do you have a bone or joint problem that could be made worse by a change in your physical activity?'),
                              const SizedBox(height: 20),
                              CheckListTile(
                                  qId: fitnesFormData[searchIndex(15)].id!,
                                  userId: userId,
                                  checkTitle:
                                      'Is your doctor currently prescribing drugs for blood pressure or heart condition?'),
                              const SizedBox(height: 20),

                              WeightTextField(
                                getEmail: () {},
                                text: "Enter description",
                                userId: userId,
                                qId: fitnesFormData[searchIndex(16)].id!,
                                hintText: "Enter description",
                                textInputType: TextInputType.text,
                                title:
                                    'Do you know of any other reason why you should not do physical activity?',
                              ),
                              const SizedBox(height: 20),
                              CheckListTile(
                                checkTitle: 'Smoking',
                                userId: userId,
                                qId: fitnesFormData[searchIndex(17)].id!,
                              ),
                              const SizedBox(height: 20),
                              CheckListTile(
                                checkTitle: 'Alcohol',
                                qId: fitnesFormData[searchIndex(18)].id!,
                                userId: userId,
                              ),
                              const SizedBox(height: 20),
                              WeightTextField(
                                getEmail: () {},
                                text: "Enter description",
                                userId: userId,
                                qId: fitnesFormData[searchIndex(19)].id!,
                                hintText: "Enter description",
                                textInputType: TextInputType.text,
                                title: 'Any medicine(If Yes, please explain)',
                              ),
                              const SizedBox(height: 20),
                              WeightTextField(
                                getEmail: () {},
                                text: "Enter description",
                                userId: userId,
                                qId: fitnesFormData[searchIndex(20)].id!,
                                hintText: "Enter description",
                                textInputType: TextInputType.text,
                                title:
                                    'Any surgery in the past 12 months? If Yes, please explain',
                              ),
                              const SizedBox(height: 20),

                              const SizedBox(height: 20),
                              WeightTextField(
                                getEmail: () {},
                                text: "Enter description",
                                userId: userId,
                                qId: fitnesFormData[searchIndex(21)].id!,
                                hintText: "Enter description",
                                textInputType: TextInputType.text,
                                title:
                                    'Any pre existing injuries or physical restrictions that may limit your ability to exerise? If Yes, please explain',
                              ),
                              const SizedBox(height: 20),

                              WeightTextField(
                                getEmail: () {},
                                text: "Enter water intake",
                                userId: userId,
                                qId: fitnesFormData[searchIndex(22)].id!,
                                hintText: "Enter water intake",
                                title:
                                    'What is your daily water intake of water in glasses of 250 ml?',
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  'SUBMIT',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .copyWith(color: whiteColor),
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
      ),
    );
  }
}
