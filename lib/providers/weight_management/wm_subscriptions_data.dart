import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/api_url.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/wm/wm_subscription.dart';
import 'package:http/http.dart' as http;

class WmSubscriptionsData with ChangeNotifier {
  List<WmSubscription> _subsData = [];
  List<WmSubscription> get subsData {
    return [..._subsData];
  }

  Future<void> getSubsData(String params) async {
    String url = '${ApiUrl.wm}get/wmSubscription?$params';

    log(url);

    final List<WmSubscription> loadedData = [];
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );

      // log(response.body.toString());

      final responseBody = json.decode(response.body);

      if (response.statusCode >= 400) {
        log(responseBody["error"]);
        throw HttpException(responseBody["message"]);
      }

      if (responseBody['status'] == 1) {
        final responseData =
            json.decode(response.body)['data'] as List<dynamic>;

        for (var element in responseData) {
          loadedData.add(
            WmSubscription(
                id: element['_id'],
                expertId: element['expertId'],
                userId: element['userId'],
                packageId: element['packageId'],
                startDate: element['startDate'],
                grossAmount: element['grossAmount'],
                gstAmount: element['gstAmount'],
                discount: element['discount'],
                netAmount: element['netAmount'],
                status: element['status'],
                startTime: element["startTime"],
                // isActive: element["isActive"] ?? "false",
                packageName: element['packageName']),
          );
        }
        if (response.statusCode >= 400) {
          throw HttpException(responseBody["message"]);
        }
        _subsData = loadedData;
        // log(_loadedData[0].grossAmount.toString());
        // log('Fetched subscription data');
      } else {
        throw HttpException(responseBody["message"]);
      }
    } catch (e) {
      _subsData.clear();
      log(e.toString());
    }
  }
}
