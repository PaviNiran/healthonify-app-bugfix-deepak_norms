import 'dart:developer';
// import 'dart:html';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:healthonify_mobile/constants/text_styles.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/auth/signup_data.dart';
import 'package:healthonify_mobile/screens/auth/otp_screen.dart';
import 'package:healthonify_mobile/widgets/buttons/custom_buttons.dart';
import 'package:healthonify_mobile/widgets/text%20fields/signup_text_fields.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

// class SignupScreen extends StatelessWidget {
//   final String? role;
//
//   const SignupScreen({Key? key, required this.role}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     return Container(
//       height: 0000,
//       width: size.width,
//       decoration: const BoxDecoration(
//         image: DecorationImage(
//           image: AssetImage("assets/images/healthonify_background.jpg"),
//           fit: BoxFit.fitHeight,
//         ),
//       ),
//       child: Scaffold(
//         backgroundColor: Colors.transparent,
//         resizeToAvoidBottomInset: true,
//         body: SingleChildScrollView( // Wrap the content with SingleChildScrollView
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 SizedBox(height: size.height * 0.3),
//                 // const AppLogoSignUp(),
//                 // appLogoSignUp,
//                 AuthSignUp(
//                   roles: role,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
class SignupScreen extends StatelessWidget {
  final String? role;

  const SignupScreen({Key? key, required this.role}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: 0000,
      width: size.width,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/healthonify_background.jpg"),
          fit: BoxFit.fitHeight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: false, // Set this to true
        body: SingleChildScrollView( // Wrap the content with SingleChildScrollView
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: size.height * 0.3),
                AuthSignUp(
                  roles: role,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class AuthSignUp extends StatefulWidget {
  final String? roles;

  const AuthSignUp({Key? key, required this.roles}) : super(key: key);

  @override
  State<AuthSignUp> createState() => _AuthSignUpState();
}

class _AuthSignUpState extends State<AuthSignUp> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  Map<String, String> _authData = {};
  final _now = DateTime.now();
  String gender = "male";
  final TextEditingController _selectDate = TextEditingController();

  @override
  void initState() {
    super.initState();

    _authData = {
      "firstName": "",
      "lastName": "",
      if (widget.roles != "corporateEmployee") "mobileNo": "",
      "email": "",
      "password": "",
      "roles": "",
      "dob": "",
      "gender": "",
    };
  }

  bool checkedValue = false;

  void getFirstName(String value) => _authData["firstName"] = value;

  void getLastName(String value) => _authData["lastName"] = value;

  void getMobileNo(String value) => _authData["mobileNo"] = value;

  void getEmail(String value) => _authData["email"] = value;

  void getPassword(String value) => _authData["password"] = value;

  void getDoB(String value) => _authData["dob"] = value;

  void getGender(String value) => _authData["gender"] = value;

  void onSubmit(BuildContext context) {
    setState(() => isLoading = true);
    if (!_formKey.currentState!.validate()) {
      // print("zHey");
      setState(() => isLoading = false);
      return;
    }

    _authData["roles"] = widget.roles!;

    if (!checkedValue) {
      Fluttertoast.showToast(msg: "Please accept the terms and conditions");
      setState(() => isLoading = false);
      return;
    }

    _formKey.currentState!.save();
    log(_authData.toString());

    signUp(context);

    setState(() => isLoading = false);
  }

  void pushOtpScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return OtpScreen(
            mobile: _authData["mobileNo"] ?? "",
            email: _authData["email"],
            roles: widget.roles!,
          );
        },
      ),
    );
  }

  Future<void> signUp(BuildContext context) async {
    try {
      await Provider.of<SignUpData>(context, listen: false).register(_authData);
      pushOtpScreen.call();
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.message);
    } catch (e) {
      log("Error login auth widget $e");
      Fluttertoast.showToast(msg: "Error : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Padding(
          //   padding: const EdgeInsets.only(bottom: 10),
          //   child: Text(
          //     'First Name',
          //     style: Theme.of(context).textTheme.bodyMedium,
          //   ),
          // ),
          SignupFirstNameTextField(
            getValue: getFirstName,
          ),
          const SizedBox(height: 20),
          // Padding(
          //   padding: const EdgeInsets.only(bottom: 10),
          //   child: Text(
          //     'Last Name',
          //     style: Theme.of(context).textTheme.bodyMedium,
          //   ),
          // ),
          SignupLastNameTextField(
            getValue: getLastName,
          ),
          const SizedBox(height: 20),
          // Padding(
          //   padding: const EdgeInsets.only(bottom: 10),
          //   child: Text(
          //     'Email Address',
          //     style: Theme.of(context).textTheme.bodyMedium,
          //   ),
          // ),
          SignupEmailTextField(getValue: getEmail),
          const SizedBox(height: 20),
          widget.roles != "corporateEmployee"
              ? Column(
                  children: [
                    SignupMobileTextField(getValue: getMobileNo),
                    const SizedBox(height: 20),
                  ],
                )
              : const SizedBox(),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                  color: Colors.grey,
                  offset: Offset(0.0, 1.0), //(x,y)
                  blurRadius: 4.0,
                ),
              ],
            ),
            height: 50,
            child: TextFormField(
              readOnly: true,
              controller: _selectDate,
              onTap: () => dateTap(context,_selectDate),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Enter your DOB',
                hintStyle: TextStyle(
                  color: Color(0xFF959EAD),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'OpenSans',
                ),
              ),
              onSaved: (value) {
                getDoB(value!);
              },
              style: Theme.of(context).textTheme.bodyMedium,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your dob';
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              const Text(
                "Gender : ",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(width: 5),
              Row(
                children: [
                  const Text("Male"),
                  Radio(
                      value: "male",
                      groupValue: gender,
                      onChanged: (value) {
                        setState(() {
                          gender = value.toString();
                        });
                        getGender(gender);
                        print("Gender : $gender");
                      }),
                ],
              ),
              const SizedBox(width: 5),
              Row(
                children: [
                  const Text("Female"),
                  Radio(
                      value: "female",
                      groupValue: gender,
                      onChanged: (value) {
                        setState(() {
                          gender = value.toString();
                        });
                        getGender(gender);
                        print("Gender : $gender");
                      }),
                ],
              ),
            ],
          ),
          const SizedBox(height: 5),
          SignupPasswordTextField(getValue: getPassword),

          const SizedBox(height: 5),
          CheckboxListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Accept terms and conditions.",
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(color: orange),
                ),
                InkWell(
                  onTap: () => launchUrl(
                    Uri.parse(
                        'https://healthonify.com/home/page/privacy_policy'),
                  ),
                  child: Text(
                    'Click here to know more',
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          decoration: TextDecoration.underline,
                          color: Colors.blue,
                        ),
                  ),
                )
              ],
            ),
            value: checkedValue,
            //checkColor: Colors.red,
            activeColor: orange,
            onChanged: (newValue) {
              setState(() {
                checkedValue = newValue!;
              });
            },
            controlAffinity:
                ListTileControlAffinity.leading, //  <-- leading Checkbox
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(child: BackToLoginButton()),
              const SizedBox(width: 5),
              Expanded(
                child: SignUpButton(
                  submit: onSubmit,
                  isLoading: isLoading,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Date Picker
  dateTap(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      String formattedDate = DateFormat('dd-MM-yyyy').format(picked);
      setState(() {
        controller.text = formattedDate;
      });
    }
  }
}
