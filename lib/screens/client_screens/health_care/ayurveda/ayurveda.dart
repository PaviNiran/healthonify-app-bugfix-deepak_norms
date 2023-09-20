import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/func/loading_dialog_container.dart';
import 'package:healthonify_mobile/models/health_care/ayurveda_models/ayurveda_conditions_model.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/health_care/ayurveda_provider/ayurveda_provider.dart';
import 'package:healthonify_mobile/providers/health_care/health_care_provider.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/screens/client_screens/health_care/ayurveda/conditions_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/health_care/health_care_appointments/healthcare_appointments.dart';
import 'package:healthonify_mobile/widgets/buttons/custom_buttons.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:healthonify_mobile/widgets/other/carousel_slider.dart';
import 'package:healthonify_mobile/widgets/other/horiz_list_view/home_top_list_buttons.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AyurvedaScreen extends StatefulWidget {
  const AyurvedaScreen({Key? key}) : super(key: key);

  @override
  State<AyurvedaScreen> createState() => _AyurvedaScreenState();
}

class _AyurvedaScreenState extends State<AyurvedaScreen> {
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();

  List<AyurvedaConditionsModel> ayurvedaConditions = [];

  bool isLoading = true;

  Future<void> fetchAyurvedaConditions() async {
    try {
      ayurvedaConditions =
          await Provider.of<AyurvedaProvider>(context, listen: false)
              .getAyurvedaConditions();

      log('fetched ayurveda conditions');
    } on HttpException catch (e) {
      log(e.toString());
    } catch (e) {
      log('Error fetching ayurveda conditions');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  late String userId;

  @override
  void initState() {
    super.initState();
    userId = Provider.of<UserData>(context, listen: false).userData.id!;

    fetchAyurvedaConditions().then(
      (value) {
        for (var ele in ayurvedaConditions) {
          treatmentConditions.add(ele.name);
        }
        log(treatmentConditions.toString());
      },
    );
  }

  String? requestCondition;
  List treatmentConditions = [];

  Map<String, dynamic> consultationData = {};

  Future<void> submitForm() async {
    LoadingDialog().onLoadingDialog("Please wait....", context);
    try {
      await Provider.of<HealthCareProvider>(context, listen: false)
          .consultSpecialist(consultationData);
      popFunction();
      Fluttertoast.showToast(msg: 'Consultation scheduled successfully');
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.message);
    } catch (e) {
      log("Error request appointment $e");
      Fluttertoast.showToast(msg: "Not able to submit your request");
    } finally {
      popFunction();
    }
  }

  void onSubmit() {
    consultationData['userId'] = userId;
    if (selectedTime != null) {
      consultationData['startTime'] = selectedTime;
    } else {
      Fluttertoast.showToast(msg: 'Please select a consultation time');
      return;
    }
    if (ymdFormat != null) {
      consultationData['startDate'] = ymdFormat;
    } else {
      Fluttertoast.showToast(msg: 'Please select a consultation date');
      return;
    }
    consultationData['expertiseId'] = '6368b1870a7fad5713edb4b4';

    if (description != null) {
      consultationData['description'] = description;
    } else {
      Fluttertoast.showToast(
          msg: 'Please enter a brief description for your consultation');
      return;
    }

    log(consultationData.toString());
    submitForm();
  }

  void popFunction() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, value) {
          return [
            const FlexibleAppBar(
              title: 'Ayurveda',
              listItems: AyurvedaTopButtons(),
            ),
          ];
        },
        body: pageContent(context),
      ),
    );
  }

  Widget pageContent(context) {
    List imgs = [
      // 'assets/images/Picture17.jpg',
      {
        'image': 'assets/images/Picture17.jpg',
        'route': () {},
      },
    ];

    List mostSearchedConditions = [
      'Psoriasis',
      'Eczema',
      'Hair Loss',
      'Dandruff',
      'Arthritis',
      'Diabetes',
      'Obesity',
      'Thyroid',
      'Asthma',
    ];
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomCarouselSlider(imageUrls: imgs),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    'Conditions we treat',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
                GridView.builder(
                  padding: const EdgeInsets.all(4),
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisExtent: 136,
                    crossAxisCount: 3,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                  ),
                  itemCount: ayurvedaConditions.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return AyurvedaConditionsScreen(
                              condition: ayurvedaConditions[index].name,
                              conditionId: ayurvedaConditions[index].id,
                            );
                          }));
                        },
                        // onTap: () => ayurvedaGridView[index]['onClick'](context),
                        borderRadius: BorderRadius.circular(10),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  height: 42,
                                  width: 42,
                                  child: Image.network(
                                    ayurvedaConditions[index].mediaLink!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                // Image.asset(
                                //   ayurvedaGridView[index]["icon"],
                                //   height: 40,
                                //   width: 40,
                                // ),
                                const SizedBox(height: 10),
                                Text(
                                  ayurvedaConditions[index].name!,
                                  style: Theme.of(context).textTheme.labelSmall,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(4),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Text(
                            'First consultation free !!!',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Book Appointment',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: GradientButton(
                                    title: 'View',
                                    func: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) =>
                                            const HealthCareAppointmentsScreen(
                                                isFromAyurveda: true),
                                      ));
                                    },
                                    gradient: purpleGradient,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: GradientButton(
                                    title: 'Request',
                                    func: () {
                                      requestAppointment(context);
                                    },
                                    gradient: orangeGradient,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                ),
                CustomCarouselSlider(imageUrls: imgs),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    'Most searched conditions',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
                GridView.builder(
                  padding: const EdgeInsets.all(4),
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisExtent: 40,
                    crossAxisCount: 4,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                  ),
                  itemCount: mostSearchedConditions.length,
                  itemBuilder: (context, index) {
                    return Chip(
                      backgroundColor:
                          MediaQuery.of(context).platformBrightness ==
                                  Brightness.dark
                              ? Colors.grey[700]
                              : Colors.grey[300],
                      label: Text(
                        mostSearchedConditions[index],
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 30),
              ],
            ),
    );
  }

  String? description;
  void requestAppointment(context) {
    showModalBottomSheet(
      backgroundColor: Theme.of(context).canvasColor,
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Treatment Condition',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                child: DropdownButtonFormField(
                  isDense: true,
                  items: treatmentConditions
                      .map<DropdownMenuItem<String>>((value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      requestCondition = newValue!;
                    });
                  },
                  value: requestCondition,
                  style: Theme.of(context).textTheme.bodyMedium,
                  decoration: InputDecoration(
                    fillColor: Colors.transparent,
                    enabledBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: Colors.grey,
                        width: 1.25,
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: Colors.grey,
                        width: 1.25,
                      ),
                    ),
                    constraints: const BoxConstraints(
                      maxHeight: 56,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                  icon: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(8),
                  hint: Text(
                    'Condition',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: Colors.grey),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            datePicker(dateController);
                          },
                          child: IgnorePointer(
                            child: TextFormField(
                              controller: dateController,
                              decoration: InputDecoration(
                                fillColor: Theme.of(context).canvasColor,
                                filled: true,
                                hintText: 'Date',
                                hintStyle: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                      color: const Color(0xFF717579),
                                    ),
                                suffixIcon: TextButton(
                                  onPressed: () {
                                    datePicker(dateController);
                                  },
                                  child: Text(
                                    'PICK',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall!
                                        .copyWith(color: orange),
                                  ),
                                ),
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                              ),
                              style: Theme.of(context).textTheme.bodySmall,
                              cursorColor: whiteColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            timePicker(timeController);
                          },
                          child: IgnorePointer(
                            child: TextFormField(
                              controller: timeController,
                              decoration: InputDecoration(
                                fillColor: Theme.of(context).canvasColor,
                                filled: true,
                                hintText: 'Time',
                                hintStyle: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                      color: const Color(0xFF717579),
                                    ),
                                suffixIcon: TextButton(
                                  onPressed: () {
                                    timePicker(timeController);
                                  },
                                  child: Text(
                                    'PICK',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall!
                                        .copyWith(color: orange),
                                  ),
                                ),
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                              ),
                              style: Theme.of(context).textTheme.bodySmall,
                              cursorColor: whiteColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: SizedBox(
                  child: TextFormField(
                    maxLines: 5,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      fillColor: Theme.of(context).canvasColor,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      hintText: 'Describe your issue',
                      hintStyle: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: Colors.grey),
                    ),
                    style: Theme.of(context).textTheme.bodySmall,
                    onChanged: (value) {
                      setState(() {
                        description = value;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      onSubmit();
                    },
                    child: Text(
                      'Request Appointment',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  String? selectedTime;

  void timePicker(TextEditingController controller) {
    showTimePicker(
      context: context,
      builder: (context, child) {
        return Theme(
          data: customTimePickerTheme,
          child: child!,
        );
      },
      initialTime: TimeOfDay.now(),
    ).then((value) {
      if (value == null) {
        return;
      }

      var todayDate = DateTime.now().toString().split(' ');

      log(todayDate[0]);

      log(ymdFormat.toString());
      if (ymdFormat.toString() == todayDate[0]) {
        print("ValueHour : ${value.hour}");
        if (value.hour < (DateTime.now().hour + 3)) {
          Fluttertoast.showToast(
              msg:
              'Consultation time must be atleast 3 hours after current time');

          return;
        }
      }
      setState(() {
        var format24hrTime =
            '${value.hour.toString().padLeft(2, "0")}:${value.minute.toString().padLeft(2, "0")}:00';
        selectedTime = format24hrTime;
        log('24h time: $selectedTime');
        controller.text = value.format(context);
      });
    });
  }

  DateTime? _selectedDate;
  String? formattedDate;
  String? ymdFormat;

  void datePicker(TextEditingController controller) {
    showDatePicker(
      context: context,
      builder: (context, child) {
        return Theme(
          data: MediaQuery.of(context).platformBrightness == Brightness.dark
              ? datePickerDarkTheme
              : datePickerLightTheme,
          child: child!,
        );
      },
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    ).then((value) {
      if (value == null) {
        return;
      }
      setState(() {
        // log(value.toString());
        _selectedDate = value;
        var tempDate = DateFormat.yMd().format(_selectedDate!);
        DateTime temp = DateFormat('MM/dd/yyyy').parse(tempDate);
        ymdFormat = DateFormat('yyyy-MM-dd').format(temp);
        // log(ymdFormat!);
        formattedDate = DateFormat('d MMM yyyy').format(temp);
        log(formattedDate!);
        controller.text = formattedDate!;
      });
    });
  }
}
