import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/func/loading_dialog_container.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/user.dart';
import 'package:healthonify_mobile/providers/expertise/expertise_data.dart';
import 'package:healthonify_mobile/providers/physiotherapy/enquiry_form_data.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/screens/succes_screens/successful_update.dart';
import 'package:healthonify_mobile/widgets/buttons/custom_buttons.dart';
import 'package:healthonify_mobile/widgets/text%20fields/support_text_fields.dart';
import 'package:provider/provider.dart';

class RequestAppointmentForm extends StatefulWidget {
  final String? title;
  final String? buttonTitle;
  const RequestAppointmentForm(
      {Key? key, required this.title, required this.buttonTitle})
      : super(key: key);

  @override
  State<RequestAppointmentForm> createState() => _RequestAppointmentFormState();
}

class _RequestAppointmentFormState extends State<RequestAppointmentForm> {
  final _key = GlobalKey<FormState>();
  String? dropDownValue;

  @override
  void initState() {
    super.initState();
    log("init");
    getExpertise();
  }

  Future<void> getExpertise() async {
    var topLevelExpertiseIdList =
        Provider.of<ExpertiseData>(context, listen: false)
            .topLevelExpertiseData;
    String? id;
    log("Get exp");
    for (var element in topLevelExpertiseIdList) {
      log("check");

      if (element.name == "Physiotherapy") {
        id = element.id!;
        log("physio");
      }
    }
    try {
      await Provider.of<ExpertiseData>(context, listen: false)
          .fetchExpertise(id!);
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.message);
    } catch (e) {
      log("Error get fetch expertise $e");
      Fluttertoast.showToast(msg: "Unable to fetch expertise");
    }
  }

  final Map<String, String> data = {
    "name": "",
    "email": "",
    "contactNumber": "",
    "message": "",
    "userId": "",
    "enquiryFor": "",
    "category": "",
  };

  Future<void> submitForm(VoidCallback onSuccess) async {
    LoadingDialog().onLoadingDialog("Please wait....", context);
    try {
      await Provider.of<EnquiryData>(context, listen: false)
          .submitEnquiryForm(data);
      onSuccess.call();
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.message);
      Navigator.of(context).pop();
    } catch (e) {
      log("Error request appointment $e");
      Fluttertoast.showToast(msg: "Not able to submit your request");
      Navigator.of(context).pop();
    }
  }

  void onSubmit() {
    if (!_key.currentState!.validate()) {
      // setState(() => isLoading = false);
      return;
    }
    if (dropDownValue == null) {
      Fluttertoast.showToast(
          msg: "Choose a value from the enquire now dropdown");
      return;
    }
    data["category"] = dropDownValue!;
    _key.currentState!.save();
    log(data.toString());
    submitForm(() {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => SuccessfulUpdate(
            onSubmit: (ctx) {
              Navigator.of(ctx).pop();
            },
            title:
                "Consultation Initiated. A expert will be assigned to you shortly",
            buttonTitle: "Back"),
      ));
    });
  }

  void setData(User userData) {
    data["name"] = userData.firstName!;
    data["email"] = userData.email!;
    data["contactNumber"] = userData.mobile!;
    data["userId"] = userData.id!;
    data["enquiryFor"] = "physiotherapy";
  }

  void getMessage(String message) => data["message"] = message;

  @override
  Widget build(BuildContext context) {
    User userData = Provider.of<UserData>(context).userData;
    setData(userData);
    return SingleChildScrollView(
      child: Form(
        key: _key,
        child: Padding(
          padding: EdgeInsets.only(
              top: 15,
              left: 15,
              right: 15,
              bottom: MediaQuery.of(context).viewInsets.bottom + 1),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const SizedBox(
              height: 20,
            ),
            Center(
              child: Text(
                widget.title!,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Enquiry for :'),
                  const SizedBox(
                    height: 10,
                  ),
                  Consumer<ExpertiseData>(
                    builder: (context, data, child) {
                      List<String> options = [];
                      List<String> id = [];
                      for (var element in data.expertise) {
                        options.add(element.name!);
                        id.add(element.id!);
                      }
                      return DropdownButtonFormField(
                        isDense: true,
                        items: options
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            dropDownValue = newValue!;
                          });
                        },
                        value: dropDownValue,
                        isExpanded: true,
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
                            maxHeight: 50,
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
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: const Color(0xFF959EAD),
                                  ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
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
                  IssueField(getValue: getMessage),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: GradientButton(
                      title: widget.buttonTitle,
                      func: onSubmit,
                      gradient: orangeGradient,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Center(
                  //   child: SaveButton(
                  //     isLoading: false,
                  //     submit: onSubmit,
                  //     title: widget.buttonTitle,
                  //   ),
                  // ),
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }
}
