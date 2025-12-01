// ignore_for_file: deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sukun/features/auth/views/screens/log_in_screen.dart';

class SingUpScreen extends StatelessWidget {
  const SingUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Image.asset('assets/sukun_logo.png', width: size * 0.3),
        backgroundColor: Colors.white,
      ),
      body: DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg_sign_up_image.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Container(
            width: 342,
            height: 564,
            decoration: BoxDecoration(
              color: Color(0xFFFFC107),
              borderRadius: BorderRadius.circular(15),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: size * 0.03),
                  Text(
                    'CREATE AN \nACCOUNT',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: size * 0.04,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: size * 0.02),
                  // ! User Name Text Form Field
                  SizedBox(
                    width: size * 0.7,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 5,
                      children: [
                        Text('Username'),
                        TextFormField(
                          onChanged: (value) {},
                          decoration: InputDecoration(
                            hintText: 'Enter Your Name...',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              ),
                            ),
                            prefixIcon: Icon(CupertinoIcons.person),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: size * 0.02),

                  // ! Phone Number TextForm Field
                  SizedBox(
                    width: size * 0.7,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 5,
                      children: [
                        Text('Phone'),
                        TextFormField(
                          onChanged: (value) {},
                          decoration: InputDecoration(
                            hintText: 'Enter Phone Number...',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              ),
                            ),
                            prefixIcon: Icon(CupertinoIcons.phone),
                          ),
                        ),
                        SizedBox(height: size * 0.01),
                        // ! Accept Check Box With Terms & condition
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Checkbox(
                              fillColor: MaterialStateProperty.all(
                                Colors.white,
                              ),
                              side: BorderSide(color: Colors.white),
                              checkColor: Colors.black,
                              value: true,
                              onChanged: (value) {},
                            ),
                            Text('Accept Terms & conditions'),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // ! Sign Up Button
                  Container(
                    width: size * 0.7,
                    height: size * 0.09,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Sign Up',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: size * 0.02),
                  dividerOr(),
                  SizedBox(height: size * 0.02),
                  GoogleAuth(ontap: () {}),
                  SizedBox(height: size * 0.02),
                  // ! If User Already Registered got to sing in
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Already have an accoun?'),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LogInScreen(),
                            ),
                          );
                        },
                        child: Text(
                          'Login',
                          style: GoogleFonts.openSans(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ! Divider With Or
dividerOr() {
  return Padding(
    padding: const EdgeInsets.only(left: 20, right: 20),
    child: Row(
      children: [
        Expanded(child: Divider(thickness: 1, color: Colors.black)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Text('or', style: TextStyle(fontSize: 20)),
        ),
        Expanded(child: Divider(thickness: 1, color: Colors.black)),
      ],
    ),
  );
}

// ! Google User Sign In Button
class GoogleAuth extends StatelessWidget {
  final VoidCallback? ontap;
  const GoogleAuth({super.key, required this.ontap});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: ontap,
      child: Container(
        width: size * 0.7,
        height: size * 0.1,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/google_Icon.png', width: size * 0.08),

            SizedBox(width: size * 0.05),
            Text(
              'Signup  with Google',
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
