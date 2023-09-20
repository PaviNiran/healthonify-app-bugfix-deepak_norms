import 'dart:developer';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:healthonify_mobile/models/expertise/expertise.dart';
import 'package:healthonify_mobile/models/user.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/screens/client_screens/upload_profile_image.dart';
import 'package:healthonify_mobile/screens/edit_profile_screens.dart/sub_screens/edit_about_screen.dart';
import 'package:healthonify_mobile/screens/edit_profile_screens.dart/sub_screens/edit_address_screen.dart';
import 'package:healthonify_mobile/screens/edit_profile_screens.dart/sub_screens/edit_city_screen.dart';
import 'package:healthonify_mobile/screens/edit_profile_screens.dart/sub_screens/edit_consultation_charge_screen.dart';
import 'package:healthonify_mobile/screens/edit_profile_screens.dart/sub_screens/edit_country_screen.dart';
import 'package:healthonify_mobile/screens/edit_profile_screens.dart/sub_screens/edit_dob_screen.dart';
import 'package:healthonify_mobile/screens/edit_profile_screens.dart/sub_screens/edit_expertise.dart';
import 'package:healthonify_mobile/screens/edit_profile_screens.dart/sub_screens/edit_first_name.dart';
import 'package:healthonify_mobile/screens/edit_profile_screens.dart/sub_screens/edit_gender_screen.dart';
import 'package:healthonify_mobile/screens/edit_profile_screens.dart/sub_screens/edit_last_name.dart';
import 'package:healthonify_mobile/screens/edit_profile_screens.dart/sub_screens/edit_pincode_screen.dart';
import 'package:healthonify_mobile/screens/edit_profile_screens.dart/sub_screens/edit_state_screen.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:provider/provider.dart';

class YourProfileScreen extends StatefulWidget {
  const YourProfileScreen({Key? key}) : super(key: key);

  @override
  State<YourProfileScreen> createState() => _YourProfileScreenState();
}

class _YourProfileScreenState extends State<YourProfileScreen> {
  String dateConvertTextFormat(String d) {
    DateTime tempDate = DateFormat("MM/dd/yyyy").parse(d);
    String date = DateFormat("EEE, MMM d ''yy").format(tempDate);
    log(date);

    return date;
  }

  String dateConvertNumberFormat(String d) {
    DateTime tempDate = DateFormat("MM/dd/yyyy").parse(d);
    String date = DateFormat("MM/dd/yyyy").format(tempDate);
    log(date);

    return date;
  }

  @override
  Widget build(BuildContext context) {
    User userData = Provider.of<UserData>(context).userData;

    String date =
        userData.dob != null ? dateConvertTextFormat(userData.dob!) : "";
    String dateNumber =
        userData.dob != null ? dateConvertNumberFormat(userData.dob!) : "";
    String mobileNumber = userData.mobile ?? "";
    String gndr = userData.gender ?? "select";

    log(dateNumber);
    log(userData.id!);
    return Scaffold(
      appBar: const CustomAppBar(
        appBarTitle: 'Your Profile',
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const UploadProfileImage();
                      }));
                    },
                    borderRadius: BorderRadius.circular(62),
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            CircleAvatar(
                              backgroundColor: const Color(0xFFff7f3f),
                              radius: 68,
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 64,
                                child: userData.imageUrl == null ||
                                        userData.imageUrl!.isEmpty
                                    ? const CircleAvatar(
                                        backgroundImage: AssetImage(
                                          'assets/icons/pfp_placeholder.jpg',
                                        ),
                                        radius: 60,
                                      )
                                    : CircleAvatar(
                                        backgroundImage:
                                            NetworkImage(userData.imageUrl!),
                                        radius: 60,
                                      ),
                              ),
                            ),
                          ],
                        ),
                        const Positioned(
                          top: 100,
                          left: 95,
                          child: CircleAvatar(
                            backgroundColor: Color(0xFFff7f3f),
                            radius: 18,
                            child: Icon(
                              Icons.edit_outlined,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              editField(context, "First Name", userData.firstName!, () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => EditFirstName(
                      title: "First Name",
                      value: userData.firstName,
                    ),
                  ),
                );
              }),
              const SizedBox(height: 12),
              editField(context, "Last Name", userData.lastName!, () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => EditLastName(
                      title: "Last Name",
                      value: userData.lastName,
                    ),
                  ),
                );
              }),
              const SizedBox(height: 12),
              editField(context, "Mobile",
                  userData.mobile != null ? mobileNumber : userData.mobile, () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => EditGenderScreen(
                      title: "Gender",
                      value: userData.gender != null ? gndr : userData.gender,
                    ),
                  ),
                );
              }),
              const SizedBox(height: 12),
              editField(context, "Gender",
                  userData.gender != null ? gndr : userData.gender, () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => EditGenderScreen(
                      title: "Gender",
                      value: userData.gender != null ? gndr : userData.gender,
                    ),
                  ),
                );
              }),
              const SizedBox(height: 12),
              editField(context, "DOB", userData.dob != null ? date : "", () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => EditDobScreen(
                      title: "DOB",
                      value: userData.dob != null ? dateNumber : "",
                    ),
                  ),
                );
              }),
              const SizedBox(height: 12),
              editField(context, "Address", userData.address ?? "", () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => EditAddressScreen(
                      title: "Address",
                      value: userData.address ?? "",
                    ),
                  ),
                );
              }),
              const SizedBox(height: 12),
              editField(context, "City", userData.city ?? "", () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => EditCityScreen(
                      title: "City",
                      value: userData.city ?? "",
                    ),
                  ),
                );
              }),
              const SizedBox(height: 12),
              editField(context, "State", userData.state ?? "", () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => EditStateScreen(
                      title: "State",
                      value: userData.state ?? "",
                    ),
                  ),
                );
              }),
              const SizedBox(height: 12),
              editField(context, "Pincode", userData.pincode.toString(), () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => EditPincodeScreen(
                      title: "Pincode",
                      value: userData.pincode.toString(),
                    ),
                  ),
                );
              }),
              const SizedBox(height: 12),
              editField(
                context,
                "Country",
                userData.country ?? "",
                () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) => EditCountryScreen(
                        title: "Country",
                        value: userData.country ?? "",
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              if (userData.roles![0]["name"] == "expert")
                editField(
                  context,
                  "About",
                  userData.about ?? "",
                  () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => EditAboutScreen(
                          title: "About",
                          value: userData.about ?? "",
                        ),
                      ),
                    );
                  },
                ),
              const SizedBox(height: 12),
              if (userData.roles![0]["name"] == "expert")
                editField(context, "Consultation Charges",
                    userData.consultationCharge ?? "", () {
                  // Navigator.of(context).push(
                  //   MaterialPageRoute(
                  //     builder: (ctx) => EditConsultationChargeScreen(
                  //       title: "About",
                  //       value: userData.consultationCharge ?? "",
                  //     ),
                  //   ),
                  // );
                }),
              const SizedBox(height: 12),
              if (userData.roles![0]["name"] == "expert")
                editField(
                    context,
                    "Expertise",
                    userData.expertise!.isEmpty
                        ? ""
                        : userData.expertise![0]['name'], () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) => EditExpertise(
                        title: "About",
                        value: userData.expertise!.isEmpty
                            ? ""
                            : userData.expertise![0]['name'],
                      ),
                    ),
                  );
                }),
              userData.topLevelExpId == "6343acb2f427d20b635ec853"
                  ? editField(
                      context,
                      "Registration Number",
                      userData.expertise!.isEmpty
                          ? ""
                          : userData.registrationNumber,
                      () {})
                  : SizedBox()
            ],
          ),
        ),
      ),
    );
  }

  Widget editField(
      BuildContext context, String title, String? value, Function onClick) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          children: [
            SizedBox(
              width: 110,
              child: Text(
                title,
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ),
            const Divider(
              color: Colors.transparent,
            )
          ],
        ),
        const SizedBox(width: 10),
        Expanded(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => onClick(),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value ?? "",
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  const Divider(
                    color: Colors.teal,
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
