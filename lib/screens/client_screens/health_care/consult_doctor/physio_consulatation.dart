import 'package:flutter/material.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appBar.dart';

class PhysioConsultation extends StatefulWidget {
  const PhysioConsultation({Key? key}) : super(key: key);

  @override
  State<PhysioConsultation> createState() => _PhysioConsultationState();
}

class _PhysioConsultationState extends State<PhysioConsultation> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(appBarTitle: 'PhysioTherapy Consultation'),
    );
  }
}