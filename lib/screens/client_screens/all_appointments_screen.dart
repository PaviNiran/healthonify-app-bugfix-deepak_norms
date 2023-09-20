import 'dart:developer';
import "package:flutter/material.dart";
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/func/loading_dialog_container.dart';
import 'package:healthonify_mobile/func/string_date_format.dart';
import 'package:healthonify_mobile/models/consultation.dart';
import 'package:healthonify_mobile/models/health_care/hc_consultations_model.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/wm/wm_consultation.dart';
import 'package:healthonify_mobile/providers/all_consultations_data.dart';
import 'package:healthonify_mobile/providers/health_care/health_care_provider.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/screens/client_screens/physio/view_appointments/consultation_details_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/weight_management/wm_consultation_details.dart';
import 'package:healthonify_mobile/screens/video_call.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:url_launcher/url_launcher.dart';

class AllAppointmentsScreen extends StatefulWidget {
  const AllAppointmentsScreen({Key? key}) : super(key: key);

  @override
  State<AllAppointmentsScreen> createState() => _AllAppointmentsScreenState();
}

class _AllAppointmentsScreenState extends State<AllAppointmentsScreen> {
  bool _isLoading = false;
  List<WmConsultation> data = [];
  var snackBar = const SnackBar(
    content: Padding(
      padding: EdgeInsets.symmetric(vertical: 15.0),
      child: Text('No more Appointments!'),
    ),
    duration: Duration(milliseconds: 1000),
  );
  int currentPage = 0;

  final RefreshController _refreshController = RefreshController();

  @override
  void initState() {
    //added the pagination function with listener

    super.initState();
    getConsultations();
  }

  @override
  void dispose() {
    super.dispose();
    _refreshController.dispose();
  }

  void showSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      snackBar,
    );
  }

  Future<List<HealthCarePrescription>> getHCPrescriptions(
      String consultationId, int index) async {
    LoadingDialog().onLoadingDialog("Please wait", context);
    try {
      List<HealthCarePrescription> prescriptions =
          await Provider.of<HealthCareProvider>(context, listen: false)
              .getHealthCarePrescription(consultationId);
      log('fetched user hc consultation prescriptions');
      return prescriptions;
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.message);
      return [];
    } catch (e) {
      log("Error getting user hc consultations $e");
      Fluttertoast.showToast(
          msg: "Unable to user hc consultation prescriptions");
      return [];
    } finally {
      Navigator.of(context).pop();
    }
  }

  Future<void> getConsultations() async {
    log(currentPage.toString());
    setState(() {
      _isLoading = true;
    });
    String userId = Provider.of<UserData>(context, listen: false).userData.id!;
    try {
      await Provider.of<AllConsultationsData>(context, listen: false)
          .getAllConsultationsData(userId);
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.message);
    } catch (e) {
      log("Error getting consultations $e");
      Fluttertoast.showToast(msg: "Unable to fetch consultations");
    } finally {
      // setState(() {
      //   _isPaginationLoading = false;
      // });
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(appBarTitle: "My Consultations"),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Consumer<AllConsultationsData>(
              builder: (context, value, child) =>
                  ListView(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 8.0, top: 10),
                    child: Text("Physiotherapy"),
                  ),
                  ListView.builder(
                      padding: const EdgeInsets.only(top: 10),
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: value.physioConsultation.length,
                      itemBuilder: (context, index) {
                        if (value.physioConsultation[index].status ==
                            "initiated") {
                          return expertCardFreePhysio(
                              context, value.physioConsultation[index]);
                        }
                        return expertCardPaidPhysio(
                            context, value.physioConsultation[index]);
                      }),
                  const Padding(
                    padding: EdgeInsets.only(left: 8.0, top: 10),
                    child: Text("Manage Weight"),
                  ),
                  ListView.builder(
                      padding: const EdgeInsets.only(top: 10),
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: value.wmConsultation.length,
                      itemBuilder: (context, index) {
                        log(value.wmConsultation.length.toString());
                        if (value.wmConsultation[index].status == "initiated") {
                          // return expertCardFree(context, data[index]);
                          return expertCardPaidWm(
                              context, value.wmConsultation[index]);
                        }
                        return expertCardPaidWm(
                            context, value.wmConsultation[index]);

                        // return expertCardPaid(context, data[index]);
                      }),
                  const Padding(
                    padding: EdgeInsets.only(left: 8.0, top: 10),
                    child: Text("Health Care"),
                  ),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: value.healthCareConsultation.length,
                    itemBuilder: (context, index) {
                      return consultationCard(
                        value.healthCareConsultation[index],
                        index,
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }

  Widget consultationCard(HealthCareConsultations consultation, int index) {
    final date =
        StringDateTimeFormat().stringtDateFormat(consultation.startDate!);
    final time =
        StringDateTimeFormat().stringToTimeOfDay(consultation.startTime!);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Card(
        elevation: 0,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (consultation.expertId!.isNotEmpty)
                                Text(
                                  consultation.expertId![0].firstName!,
                                  style:
                                      Theme.of(context).textTheme.headlineSmall,
                                ),
                              Text(
                                consultation.expertiseId![0].name!,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.videocam_outlined,
                                    size: 18,
                                    color: Colors.orange,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    consultation.status ==
                                                "meetingLinkGenerated" ||
                                            consultation.status ==
                                                "expertAssigned" ||
                                            consultation.status == "scheduled"
                                        ? "Scheduled"
                                        : 'Meeting yet to schedule',
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
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
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
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
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.end,
                    //   children: [
                    //     TextButton(
                    //       onPressed: () {
                    //         Navigator.push(context,
                    //             MaterialPageRoute(builder: (context) {
                    //           return HealthcareAppointmentDetails(
                    //             healthCareConsultations: consultation,
                    //           );
                    //         }));
                    //       },
                    //       child: const Text('View details'),
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
                if (consultation.expertId!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: CircleAvatar(
                      backgroundColor: Colors.blue,
                      radius: 36,
                      backgroundImage:
                          consultation.expertId![0].imageUrl == null
                              ? const AssetImage(
                                  "assets/icons/user.png",
                                ) as ImageProvider
                              : NetworkImage(
                                  consultation.expertId![0].imageUrl!,
                                ),
                    ),
                  ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () {},
                  borderRadius: BorderRadius.circular(10),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/icons/chat.png',
                          height: 46,
                          width: 46,
                        ),
                        const SizedBox(height: 10),
                        const Text('Chat'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 30),
                InkWell(
                  onTap: StringDateTimeFormat().checkForVideoCallValidation(
                          consultation.startTime!, consultation.startDate!)
                      ? () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => VideoCall(
                                meetingId: consultation.id,
                                onVideoCallEnds: () {},
                              ),
                            ),
                          );
                        }
                      : () {
                          // Navigator.of(context).push(
                          //   MaterialPageRoute(
                          //     builder: (context) => VideoCall(
                          //       meetingId: consultation.id,
                          //       onVideoCallEnds: () {
                          //         showRatingSheet(consultation.id!);
                          //       },
                          //     ),
                          //   ),
                          // );
                          Fluttertoast.showToast(
                            msg:
                                "Video call will be available 15 mins before and till 1 hour after the assigned time ",
                            toastLength: Toast.LENGTH_LONG,
                          );
                        },
                  borderRadius: BorderRadius.circular(10),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/icons/video_meeting.png',
                          height: 46,
                          width: 46,
                        ),
                        const SizedBox(height: 10),
                        const Text('Video Call'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                InkWell(
                  onTap: () async {
                    // log("${consultation.}");
                    var prescription =
                        await getHCPrescriptions(consultation.id!, index);

                    if (prescription.isNotEmpty) {
                      launchUrl(
                        Uri.parse(
                            prescription[0].healthCarePrescriptionUrl ?? ""),
                        mode: LaunchMode.externalApplication,
                      );
                    }
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/icons/prescription.png',
                          height: 46,
                          width: 46,
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Download\nPrescription',
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget expertCardPaidWm(
      BuildContext context, WmConsultation consultationData) {
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
                      Text(
                        consultationData.expert != null &&
                                consultationData.expert!.isNotEmpty
                            ? " ${consultationData.expert![0]["firstName"] ?? ""}"
                            : "",
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.videocam_outlined,
                            size: 18,
                            color: Colors.orange,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            consultationData.status == "meetingLinkGenerated" ||
                                    consultationData.status == "expertAssigned"
                                ? "Scheduled"
                                : 'Meeting yet to schedule',
                            style: Theme.of(context).textTheme.bodySmall,
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
                    backgroundImage: consultationData.expert == null ||
                            consultationData.expert!.isEmpty ||
                            !consultationData.expert![0]
                                .containsKey("imageUrl") ||
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
                TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return WmConsultationDetailsScreen(
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

  Widget expertCardFreePhysio(
      BuildContext context, Consultation consultationData) {
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
                      Text(
                        "Free Consultation",
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
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
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Text(
                    "Expert will be assigned soon",
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                )
                // TextButton(
                //   onPressed: () {
                //     Navigator.push(context,
                //         MaterialPageRoute(builder: (context) {
                //       return ConsultationDetailsScreen(
                //         consultationData: consultationData,
                //       );
                //     }));
                //   },
                //   child: const Text('View details'),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget expertCardPaidPhysio(
      BuildContext context, Consultation consultationData) {
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
                      Text(
                        consultationData.expertId!["firstName"] ?? "",
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      Text(
                        consultationData.expertiseId!.isNotEmpty
                            ? consultationData.expertiseId![0]["name"]
                            : "",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.videocam_outlined,
                            size: 18,
                            color: Colors.orange,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            consultationData.status == "meetingLinkGenerated" ||
                                    consultationData.status == "expertAssigned"
                                ? "Scheduled"
                                : 'Meeting yet to schedule',
                            style: Theme.of(context).textTheme.bodySmall,
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
                        !consultationData.expertId!.containsKey("imageUrl") ||
                                consultationData.expertId!["imageUrl"] == ""
                            ? const AssetImage(
                                "assets/icons/user.png",
                              ) as ImageProvider
                            : NetworkImage(
                                consultationData.expertId!["imageUrl"]!,
                              ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return ConsultationDetailsScreen(
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
