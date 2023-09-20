import 'package:flutter/material.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appBar.dart';

class AyurvedaConsultation extends StatefulWidget {
  const AyurvedaConsultation({Key? key}) : super(key: key);

  @override
  State<AyurvedaConsultation> createState() => _AyurvedaConsultationState();
}

class _AyurvedaConsultationState extends State<AyurvedaConsultation> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(appBarTitle: 'Ayurveda Consultation'),
    );
  }
}
