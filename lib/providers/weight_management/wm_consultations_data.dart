import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/api_url.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/wm/wm_consultation.dart';
import 'package:http/http.dart' as http;

class WmConsultationData with ChangeNotifier {
  List<WmConsultation> _wmConsultationData = [];
  List<WmConsultation> get wmConsultationData {
    return [..._wmConsultationData];
  }

  Future<List<WmConsultation>> getConsultation(String? id, String page) async {
    String url = '${ApiUrl.wm}get/wmConsultation?$id&limit=20&page=$page';

    List<WmConsultation> loadedData = [];

    log(url);

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );

      final responseData = json.decode(response.body);
      log(response.body);

      if (response.statusCode >= 400) {
        throw HttpException(responseData["message"]);
      }
      if (responseData['status'] == 1) {
        if (responseData["dataCount"] == 0) {
          throw HttpException("No data available");
        }
        final data = responseData['data'] as List<dynamic>;
        // log(data.toString());

        for (var ele in data) {
          // log(ele.toString());
          // if (ele["status"] == "initiated") {
          loadedData.add(
            WmConsultation(
              id: ele["_id"],
              expert: ele["expertId"] != null
                  ? List<dynamic>.from(ele["expertId"].map((x) => x))
                  : [],
              userId: List<dynamic>.from(data[0]["userId"].map((x) => x)),
              startTime: ele["startTime"],
              startDate: ele["startDate"],
              status: ele["status"],
              durationInMinutes: ele["durationInMinutes"],
              type: ele["type"],
            ),
          );
          // }
          // else {
          //   loadedData.add(
          //     Consultation(
          //       id: ele["_id"],
          //       expertiseId: ele["expertiseId"] != null
          //           ? List<dynamic>.from(ele["expertiseId"].map((x) => x))
          //           : [],
          //       expertId: ele["expertId"] as Map<String, dynamic>,
          //       startTime: ele["startTime"],
          //       user: List<dynamic>.from(data[0]["userId"].map((x) => x)),
          //       startDate: ele["startDate"],
          //       status: ele["status"] ?? "",
          //     ),
          //   );
          // }
        }

        _wmConsultationData = loadedData;
        log("fetched wm consultation list");
        return _wmConsultationData;
      } else {
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      // _wmConsultationData.clear();
      log(e.toString());
      rethrow;
    }
  }
}
