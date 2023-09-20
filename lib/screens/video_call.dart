import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:omni_jitsi_meet/jitsi_meet.dart';
// import 'package:jitsi_meet/feature_flag/feature_flag.dart';
// import 'package:jitsi_meet/jitsi_meet.dart';
import 'package:provider/provider.dart';

class VideoCall extends StatelessWidget {
  final String? meetingId;
  final Function onVideoCallEnds;
  const VideoCall({Key? key, required this.onVideoCallEnds, this.meetingId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    log(meetingId!);
    var data = Provider.of<UserData>(context).userData;
    _joinMeeting(meetingId!, data.firstName!, context);
    return const Scaffold();
  }

  _joinMeeting(String id, String name, BuildContext context) async {
    log(id);
    log("joined here");
    try {
      // FeatureFlag featureFlag = FeatureFlag();
      // featureFlag.welcomePageEnabled = false;
      // featureFlag.resolution = FeatureFlagVideoResolution
      //     .MD_RESOLUTION; // Limit video resolution to 360p

      var options = JitsiMeetingOptions(
          room: meetingId!,
          serverURL: "https://meet.jit.si/",
          subject: "Meeting with Expert",
          userDisplayName: name,
          userAvatarURL:
              "https://images.unsplash.com/photo-1453728013993-6d66e9c9123a?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8dmlld3xlbnwwfHwwfHw%3D&w=1000&q=80" // or .png
          ,
          audioMuted: true);
      try {
        var _ = await JitsiMeet.joinMeeting(
          options,
          listener: JitsiMeetingListener(
            onConferenceTerminated: (url, error) {
              Navigator.of(context).pop();
              onVideoCallEnds();
            },
            // onConferenceJoined: (message) {
            // try {
            //   UpdateConsultationDetails.updateJitsiLink(
            //     {
            //       "set": {
            //         "meetingLink": message["url"].toString(),
            //         "status": "meetingLinkGenerated"
            //       }
            //     },
            //     consultationId!,
            //   );
            //   log("Pushed meeting link");
            // } on HttpException catch (e) {
            //   log(e.toString());
            //   Fluttertoast.showToast(msg: e.message);
            // } catch (e) {
            //   log("Error pushing meeting link " + e.toString());
            //   Fluttertoast.showToast(msg: "Not able to connect to expert");
            //   Navigator.of(context).pop();
            // }
            // log(message["url"].toString());
            // },
          ),
        );
      } catch (e) {
        log(e.toString());
      }
    } catch (error) {
      log("error: $error");
    }
  }
}
