// ignore_for_file: deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sukun/features/auth/views/screens/sing_up_screen.dart';

class LogInScreen extends StatelessWidget {
  const LogInScreen({super.key});

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
            image: AssetImage('assets/bg_sing_in_image.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Container(
            width: 342,
            height: 564,
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(15),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: size * 0.03),
                  Text(
                    'LOGIN NOW',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: size * 0.045,
                    ),
                    textAlign: TextAlign.center,
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
                      color: Color(0xFFFFC107),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Log In',
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
                  SizedBox(height: size * 0.04),
                  // ! If User Already Registered got to sing in
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'If dont have account with \nus please register first',
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SingUpScreen(),
                            ),
                          );
                        },
                        child: Text(
                          'Sign Up',
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
