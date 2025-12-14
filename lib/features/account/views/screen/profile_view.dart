import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sukun/core/responsive/responsive.dart';
import 'package:sukun/core/theme/app_colors.dart';
import 'package:sukun/features/about_us/views/screens/about_us_view.dart';
import 'package:sukun/features/auth/views/screens/sing_up_screen.dart';
import 'package:sukun/features/contact_us/views/screens/contact_us_view.dart';
import 'package:sukun/features/faq/views/screens/faq_view.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);
    final textThem = Theme.of(context).textTheme;

    return Scaffold(
      // ! Right side drawer
      endDrawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              // ! Drawer Header
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(r.hMedium),
                decoration: BoxDecoration(color: AppColors.primaryGreen),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundColor: AppColors.accentYellow,
                      radius: r.w * 0.1,
                      child: Icon(CupertinoIcons.person, size: r.w * 0.08),
                    ),
                    SizedBox(height: r.hSmall),
                    Text(
                      'Muhammed Noorullah VP',
                      style: textThem.titleMedium?.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Nooru@gmail.com',
                      style: textThem.bodySmall?.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                  ],
                ),
              ),

              //!  Drawer Menu Items
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    ListTile(
                      leading: Icon(Icons.person),
                      title: Text('Edit Profile'),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: Icon(Icons.settings),
                      title: Text('Settings'),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: Icon(Icons.notifications),
                      title: Text('Notifications'),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: Icon(Icons.help),
                      title: Text('Help & Support'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ContactUsView(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.privacy_tip),
                      title: Text('Privacy Policy'),
                      onTap: () {
                        Navigator.pop(context);
                        // Navigate to privacy policy
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.question_answer),
                      title: Text('Faq'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => FaqView()),
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.details),
                      title: Text('About Us'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AboutUsView(),
                          ),
                        );
                      },
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.logout, color: Colors.red),
                      title: Text(
                        'Logout',
                        style: TextStyle(color: Colors.red),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        // Handle logout
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      body: DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
            // colorFilter: ColorFilter.mode(
            //   const Color.fromARGB(255, 29, 50, 29),
            //   BlendMode.color,
            // ),
            image: AssetImage('assets/profile_bg.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Menu button at top right
                Positioned(
                  top: 10,
                  right: 10,
                  child: Builder(
                    builder: (context) => IconButton(
                      icon: Icon(Icons.menu, color: AppColors.white, size: 30),
                      onPressed: () {
                        Scaffold.of(context).openEndDrawer();
                      },
                    ),
                  ),
                ),

                SizedBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // User Image
                      Stack(
                        alignment: Alignment.bottomLeft,
                        children: [
                          CircleAvatar(
                            backgroundColor: AppColors.accentYellow,
                            radius: r.w * 0.15,
                            child: Icon(CupertinoIcons.person, size: r.w * 0.1),
                          ),
                          Positioned(
                            child: IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SingUpScreen(),
                                  ),
                                );
                              },
                              icon: Icon(
                                Icons.edit,
                                color: AppColors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                      // ! User Details
                      SizedBox(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SizedBox(height: r.hMedium),
                            Text(
                              'Muhammed Noorullah VP',
                              style: textThem.titleMedium?.copyWith(
                                color: AppColors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Nooru@gmail.com',
                              style: textThem.titleSmall?.copyWith(
                                color: AppColors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: r.fieldHeight),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
