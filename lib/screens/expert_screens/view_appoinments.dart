import 'dart:developer';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:healthonify_mobile/func/string_date_format.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/wm/wm_consultation.dart';
import 'package:healthonify_mobile/providers/physiotherapy/session_data.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/providers/weight_management/wm_consultations_data.dart';
import 'package:healthonify_mobile/screens/expert_screens/appointments/wm/expert_wm_consultation_details_screen.dart';
import 'package:healthonify_mobile/screens/expert_screens/my_clients.dart';
import 'package:healthonify_mobile/widgets/cards/calendar_card.dart';
import 'package:healthonify_mobile/widgets/cards/session_card.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:provider/provider.dart';

class ViewAppointmentScreen extends StatefulWidget {
  const ViewAppointmentScreen({Key? key}) : super(key: key);

  @override
  State<ViewAppointmentScreen> createState() => _ViewAppointmentScreenState();
}

class _ViewAppointmentScreenState extends State<ViewAppointmentScreen> {
  String? date;

  void getDate(BuildContext context, String d) {
    // _getFunc(context, date!);
    setState(() {
      date = d;
    });
    log(date!);
  }

  bool _noContent = false;
  List<WmConsultation> resultData = [];

  Future<void> _getFunc(BuildContext context, String date) async {
    String id = Provider.of<UserData>(context, listen: false).userData.id!;
    String flow = Provider.of<UserData>(context).userData.topLevelExpName!;
    log(flow);

    try {
      resultData = [];
      if (flow == "Dietitian") {
        resultData =
            await Provider.of<WmConsultationData>(context, listen: false)
                .getConsultation(
          "expertId=$id&startDate=$date",
          "0",
        );
        // log("233 " + resultData.length.toString());
      } else if (flow == "Health Care") {
        // pData["type"] = "healthCare";
      } else {}
      await Provider.of<SessionData>(context, listen: false)
          .fetchUpcommingSessions("specialExpertId=$id&date=$date", flow);

      _noContent = false;
    } on HttpException catch (e) {
      log(e.toString());
      // Fluttertoast.showToast(msg: e.message);
      _noContent = true;
    } catch (e) {
      log("Error get view appointments widget $e");
      // Fluttertoast.showToast(msg: "Unable to fetch orders");
      _noContent = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        appBarTitle: '',
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 22, left: 16, bottom: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Your appointments',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  // CustomDropDownButton(),
                ],
              ),
            ),
            CalendarWidget(getDate: getDate),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Appointments',
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      const SizedBox(height: 4),
                      date != null
                          ? Text(
                              DateFormat.yMMMMd().format(
                                  DateFormat("MM/dd/yyyy").parse(date!)),
                              style: Theme.of(context).textTheme.bodySmall,
                            )
                          : Text(
                              DateFormat.yMMMMd().format(DateTime.now()),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                    ],
                  ),
                  TextButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return const MyClientScreen();
                          },
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.add,
                      color: Color(0xFFff7f3f),
                    ),
                    label: Text(
                      'Add Appointment',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                    ),
                  ),
                ],
              ),
            ),
            FutureBuilder(
              future: _getFunc(
                  context,
                  date == null
                      ? DateFormat("MM/dd/yyyy").format(DateTime.now())
                      : date!),
              builder: (context, snapshot) => snapshot.connectionState ==
                      ConnectionState.waiting
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Column(
                      children: [
                        ListView.builder(
                          padding: const EdgeInsets.only(top: 10),
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: resultData.length,
                          itemBuilder: (context, index) {
                            if (resultData[index].status == "initiated") {
                              // return expertCardFree(context, data[index]);
                              return expertCardPaid(context, resultData[index]);
                            }
                            return expertCardPaid(context, resultData[index]);

                            // return expertCardPaid(context, data[index]);
                          },
                        ),
                        _noContent
                            ? const Padding(
                                padding: EdgeInsets.only(top: 20.0),
                                child: Text("No Sessions available"),
                              )
                            : Consumer<SessionData>(
                                builder: (context, value, child) =>
                                    ListView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: value.upcomingSessions.length,
                                  itemBuilder: (context, index) {
                                    return SessionCard(
                                        data: value.upcomingSessions[index]);
                                  },
                                ),
                              ),
                      ],
                    ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget expertCardPaid(BuildContext context, WmConsultation consultationData) {
    final date =
        StringDateTimeFormat().stringtDateFormat(consultationData.startDate!);
    final time =
        StringDateTimeFormat().stringToTimeOfDay(consultationData.startTime!);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Card(
        elevation: 0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text(
                      //   consultationData.userId![0]["firstName"] ??
                      //       "" " " + consultationData.expert![0]["firstName"] ??
                      //       "",
                      //   style: Theme.of(context).textTheme.headlineSmall,
                      // ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.videocam_outlined,
                            size: 30,
                            color: Colors.orange,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            consultationData.status == "meetingLinkGenerated" ||
                                    consultationData.status == "expertAssigned"
                                ? "Scheduled"
                                : 'Meeting yet to schedule',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(
                            Icons.event_outlined,
                            size: 18,
                            color: Colors.orange,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            date,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(width: 10),
                          const Icon(
                            Icons.schedule_rounded,
                            size: 18,
                            color: Colors.orange,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            time,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.blue,
                    radius: 36,
                    backgroundImage:
                        !consultationData.expert![0].containsKey("imageUrl") ||
                                consultationData.expert![0]["imageUrl"] == ""
                            ? const AssetImage(
                                "assets/icons/user.png",
                              ) as ImageProvider
                            : NetworkImage(
                                consultationData.expert![0]["imageUrl"]!,
                              ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                consultationData.status == "completed"
                    ? TextButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return ExpertWmConsultationDetailsScreen(
                              consultationData: consultationData,
                              isCompleted: true,
                            );
                          }));
                        },
                        child: const Text('Consultation Completed'),
                      )
                    : TextButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return ExpertWmConsultationDetailsScreen(
                              consultationData: consultationData,
                            );
                          }));
                        },
                        child: const Text('View details'),
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
