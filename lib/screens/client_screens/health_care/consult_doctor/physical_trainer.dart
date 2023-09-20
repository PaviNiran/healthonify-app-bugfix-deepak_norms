import 'package:flutter/material.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appBar.dart';

class PhysicalTrainerConsultation extends StatefulWidget {
  const PhysicalTrainerConsultation({Key? key}) : super(key: key);

  @override
  State<PhysicalTrainerConsultation> createState() => _PhysicalTrainerConsultationState();
}

class _PhysicalTrainerConsultationState extends State<PhysicalTrainerConsultation> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(appBarTitle: 'PhysicalTrainer Consultation'),
    );
  }
}
