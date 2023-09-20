import 'package:flutter/material.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appBar.dart';

class MindConsultation extends StatefulWidget {
  const MindConsultation({Key? key}) : super(key: key);

  @override
  State<MindConsultation> createState() => _MindConsultationState();
}

class _MindConsultationState extends State<MindConsultation> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(appBarTitle: 'Mind Consultation'),
    );
  }
}
