import 'package:flutter/material.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(appBarTitle: 'About Us'),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.25,
          ),
          Image.asset('assets/logo/logo.png'),
          const Center(child: Text('Version 0.0.0')),
          const SizedBox(height: 8),
          const Center(
            child: Text(
              'Copyright 2022, Healthonify Pvt Ltd. All rights reserved.',
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
