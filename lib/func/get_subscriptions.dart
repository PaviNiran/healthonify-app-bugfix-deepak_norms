import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/experts/subscriptions_data.dart';
import 'package:healthonify_mobile/providers/weight_management/wm_subscriptions_data.dart';
import 'package:provider/provider.dart';

class GetSubscription {
  Future<bool> getPhysioSubs(BuildContext context, String params) async {
    try {
      await Provider.of<SubscriptionsData>(context, listen: false)
          .getSubsData(params);
      return false;
    } on HttpException catch (e) {
      log(e.toString());
      // Fluttertoast.showToast(msg: e.message);
      return true;
    } catch (e) {
      log("Error get orders widget $e");
      // Fluttertoast.showToast(msg: "Unable to fetch orders");
      return true;
    }
  }

  // Future<bool> getPhysioSubs(BuildContext context, String params) async {
  //   try {
  //     await Provider.of<SubscriptionsData>(context, listen: false)
  //         .getSubsData(params);
  //     return false;
  //   } on HttpException catch (e) {
  //     log(e.toString());
  //     // Fluttertoast.showToast(msg: e.message);
  //     return true;
  //   } catch (e) {
  //     log("Error get orders widget $e");
  //     // Fluttertoast.showToast(msg: "Unable to fetch orders");
  //     return true;
  //   }
  // }

  Future<bool> getFitnessSubs(BuildContext context, String params) async {
    try {
      await Provider.of<SubscriptionsData>(context, listen: false)
          .getSubsFitnessData(params);
      return false;
    } on HttpException catch (e) {
      log(e.toString());
      // Fluttertoast.showToast(msg: e.message);
      return true;
    } catch (e) {
      log("Error get orders widget $e");
      // Fluttertoast.showToast(msg: "Unable to fetch orders");
      return true;
    }
  }

  Future<bool> getHcSubs(BuildContext context, String params) async {
    try {
      await Provider.of<SubscriptionsData>(context, listen: false)
          .getHcSubs(params);
      return false;
    } on HttpException catch (e) {
      log(e.toString());
      // Fluttertoast.showToast(msg: e.message);
      return true;
    } catch (e) {
      log("Error get orders widget $e");
      // Fluttertoast.showToast(msg: "Unable to fetch orders");
      return true;
    }
  }

  Future<bool> getWmSubs(BuildContext context, String params) async {
    try {
      await Provider.of<WmSubscriptionsData>(context, listen: false)
          .getSubsData(params);
      return false;
    } on HttpException catch (e) {
      log(e.toString());
      // Fluttertoast.showToast(msg: e.message);
      return true;
    } catch (e) {
      log("Error get orders widget $e");
      // Fluttertoast.showToast(msg: "Unable to fetch orders");
      return true;
    }
  }

}
