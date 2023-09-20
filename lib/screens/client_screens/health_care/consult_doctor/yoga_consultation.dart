import 'package:flutter/material.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appBar.dart';

class YogaConsultation extends StatefulWidget {
  const YogaConsultation({Key? key}) : super(key: key);

  @override
  State<YogaConsultation> createState() => _YogaConsultationState();
}

class _YogaConsultationState extends State<YogaConsultation> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(appBarTitle: 'Yoga Consultation'),
    );
  }
}