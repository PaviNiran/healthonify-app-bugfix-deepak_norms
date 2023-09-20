import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/api_url.dart';
import 'package:healthonify_mobile/models/consultation.dart';
import 'package:healthonify_mobile/models/health_care/hc_consultations_model.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/wm/wm_consultation.dart';
import "package:http/http.dart" as http;

class AllConsultationsData with ChangeNotifier {
  List<Consultation> _physioConsultation = [];
  List<WmConsultation> _wmConsultation = [];
  List<HealthCareConsultations> _healthCareConsultation = [];

  List<Consultation> get physioConsultation {
    return [..._physioConsultation];
  }

  List<WmConsultation> get wmConsultation {
    return [..._wmConsultation];
  }

  List<HealthCareConsultations> get healthCareConsultation {
    return [..._healthCareConsultation];
  }

  Future<void> getAllConsultationsData(String userId,
      {String status = ""}) async {
    String url = "${ApiUrl.url}user/consultations/fetchAllTypes?userId=$userId";

    if (status == "scheduled") {
      url =
          "${ApiUrl.url}user/consultations/fetchAllTypes?userId=$userId&status=scheduled";
    }

    log("fetch all consultations url $url");

    final List<Consultation> _physio = [];
    final List<WmConsultation> _wm = [];
    final List<HealthCareConsultations> _hc = [];

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );
      final responseData = json.decode(response.body);
      // log(responseData.toString());
      if (response.statusCode >= 400) {
        throw HttpException(responseData["message"]);
      }
      if (responseData['status'] == 1) {
        final data = json.decode(response.body)['data'] as Map<String, dynamic>;
        // log(data.toString());
        final physioConsultationsData =
            data["physioConsultationsData"] as List<dynamic>;
        final wmConsultationsData =
            data["wmConsultationsData"] as List<dynamic>;

        final healthCareConsultationsData =
            data["hcConsultationsData"] as List<dynamic>;

        // log(healthCareConsultationsData.toString());

        for (var ele in physioConsultationsData) {
          // log(ele.toString());
          if (ele["status"] == "initiated") {
            // log("hey");
            _physio.add(
              Consultation(
                id: ele["_id"],
                expertiseId: ele["expertiseId"] != null
                    ? List<dynamic>.from(ele["expertiseId"].map((x) => x))
                    : [],
                user: List<dynamic>.from(ele["userId"].map((x) => x)),
                startTime: ele["startTime"],
                startDate: ele["startDate"],
                status: ele["status"],
              ),
            );
          } else {
            log("hey");
            _physio.add(
              Consultation(
                id: ele["_id"],
                expertiseId: ele["expertiseId"] != null
                    ? List<dynamic>.from(ele["expertiseId"].map((x) => x))
                    : [],
                expertId: ele["expertId"] == null
                    ? {}
                    : ele["expertId"][0] as Map<String, dynamic>,
                startTime: ele["startTime"],
                user: List<dynamic>.from(ele["userId"].map((x) => x)),
                startDate: ele["startDate"],
                status: ele["status"] ?? "",
              ),
            );
          }
        }

        for (var ele in wmConsultationsData) {
          _wm.add(
            WmConsultation(
              id: ele["_id"],
              expert: ele["expertId"] != null
                  ? List<dynamic>.from(ele["expertId"].map((x) => x))
                  : [],
              userId: List<dynamic>.from(ele["userId"].map((x) => x)),
              startTime: ele["startTime"],
              startDate: ele["startDate"],
              status: ele["status"],
              durationInMinutes: ele["durationInMinutes"],
              type: ele["type"],
            ),
          );
        }

        for (var element in healthCareConsultationsData) {
          _hc.add(
            HealthCareConsultations(
              id: element["_id"],
              expertiseId: List<ExpertiseId>.from(
                  element["expertiseId"].map((x) => ExpertiseId.fromJson(x))),
              startDate: element["startDate"],
              startTime: element["startTime"],
              userId:
                  List<Id>.from(element["userId"].map((x) => Id.fromJson(x))),
              description: element["description"],
              expertId: element["expertId"] == null
                  ? []
                  : List<Id>.from(
                      element["expertId"].map((x) => Id.fromJson(x))),
              startTimeMiliseconds: element["startTimeMiliseconds"],
              status: element["status"],
              meetingLink: element["meetingLink"],
              isActive: element["isActive"],
            ),
          );
        }

        log("len " + _hc.length.toString());

        _physioConsultation = _physio;
        _wmConsultation = _wm;
        _healthCareConsultation = _hc;

        // log(data.toString());
        log('fetched weight logs');
      } else {
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
