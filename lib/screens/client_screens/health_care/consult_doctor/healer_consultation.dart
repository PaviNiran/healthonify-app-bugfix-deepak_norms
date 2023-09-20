import 'package:flutter/material.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appBar.dart';

class HealerConsultation extends StatefulWidget {
  const HealerConsultation({Key? key}) : super(key: key);

  @override
  State<HealerConsultation> createState() => _HealerConsultationState();
}

class _HealerConsultationState extends State<HealerConsultation> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(appBarTitle: 'Healer Consultation'),
    );
  }
}