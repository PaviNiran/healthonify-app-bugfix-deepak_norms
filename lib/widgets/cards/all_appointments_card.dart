import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/func/pointy_castle_test.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/user.dart';
import 'package:healthonify_mobile/providers/physiotherapy/enquiry_form_data.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/providers/weight_management/weight_mangement_enq.dart';
import 'package:healthonify_mobile/screens/client_screens/all_appointments_screen.dart';
import 'package:healthonify_mobile/widgets/buttons/custom_buttons.dart';
import 'package:healthonify_mobile/widgets/text%20fields/support_text_fields.dart';
import 'package:provider/provider.dart';

class AllAppoinmentsCard extends StatefulWidget {
  final Function onRequest;
  const AllAppoinmentsCard({required this.onRequest, Key? key})
      : super(key: key);

  @override
  State<AllAppoinmentsCard> createState() => _AllAppoinmentsCardState();
}

class _AllAppoinmentsCardState extends State<AllAppoinmentsCard> {
  final Map<String, String> data = {
    "name": "",
    "email": "",
    "contactNumber": "",
    "userId": "",
    "enquiryFor": "",
    "message": "",
    "category": "",
  };

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

  void getMessage(String message) => data["message"] = message;

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

  void setData(User userData) {
    data["name"] = userData.firstName!;
    data["email"] = userData.email!;
    data["contactNumber"] = userData.mobile ?? "";
    data["enquiryFor"] = "generalEnquiry";
    data["category"] = "Physiotherapy";
    data["userId"] = userData.id!;
  }

  @override
  Widget build(BuildContext context) {
    User userData = Provider.of<UserData>(context).userData;
    setData(userData);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.98,
          child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                            Navigator.of(
                              context, /*rootnavigator: true*/
                            ).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    const AllAppointmentsScreen(),
                              ),
                            );
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
                      // TextButton.icon(
                      //   onPressed: () {
                      //     widget.onRequest();
                      //   },
                      //   // check this api. Some changes have been done
                      //   // _showBottomSheet(userData, getMessage, _form);

                      //   //making button tap dynamic to allow different functionalities on different screens.
                      //   // showDatePicker(
                      //   //   context: context,
                      //   //   initialDate: DateTime.now(),
                      //   //   firstDate: DateTime(1800),
                      //   //   lastDate: DateTime(2200),
                      //   // ),
                      //   icon: const Icon(
                      //     Icons.add,
                      //     color: Colors.white,
                      //   ),
                      //   label: Text(
                      //     'Request',
                      //     style: Theme.of(context)
                      //         .textTheme
                      //         .labelMedium!
                      //         .copyWith(color: whiteColor),
                      //   ),
                      //   style: TextButton.styleFrom(
                      //     backgroundColor: const Color(0xFF8E4CED),
                      //     shape: RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.circular(10),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String? selectedValue;

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
