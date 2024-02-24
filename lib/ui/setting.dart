
import 'package:flutter/material.dart';
import 'package:temansehat_app/styles/button.dart';
import 'package:temansehat_app/styles/color.dart';
import 'package:temansehat_app/ui/editprofile.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120),
        child: Container(
          decoration: BoxDecoration(
              color: bluePrimary,
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20))),
          height: 120,
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: bluePrimary,
              shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(20))),
              title: ElevatedButton.icon(
                  style: buttonAppBar(context),
                  icon: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: bluePrimary,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  label: Text(
                    "Settings",
                    style: TextStyle(
                        color: bluePrimary,
                        fontSize: width * 0.0475,
                        fontWeight: FontWeight.bold),
                  )),
              centerTitle: true,
            ),
          ),
        ),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.only(top: 50),
          width: width * 0.76,
          child: ListView(
            children: <Widget>[
              Text(
                'General',
                style: TextStyle(color: grey, fontSize: 14),
              ),
              ListTile(
                title: const Text('About'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AboutPage()),
                  );
                },
              ),
              Divider(color: bluePrimary, thickness: 3),
              Text(
                'Account Setting',
                style: TextStyle(color: grey, fontSize: 14),
              ),
              ListTile(
                title: const Text('Delete Account'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {},
              ),
              ListTile(
                title: const Text('Log out'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120),
        child: Container(
          decoration: BoxDecoration(
              color: bluePrimary,
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20))),
          height: 120,
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: bluePrimary,
              shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(20))),
              title: ElevatedButton.icon(
                  style: buttonAppBar(context),
                  icon: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: bluePrimary,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  label: Text(
                    "About",
                    style: TextStyle(
                        color: bluePrimary,
                        fontSize: width * 0.0475,
                        fontWeight: FontWeight.bold),
                  )),
              centerTitle: true,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(children: [
          Image.asset(
            'assets/completelogo.png',
            width: width * 0.7,
            height: width * 0.7,
          ),
          Text(
            'TemanSehat is a community mental health app dedicated to providing a safe space for individuals to express their thoughts and feelings.',
            textAlign: TextAlign.center, style: TextStyle(fontSize: 13),
          ),
          SizedBox(height: 10),
          Text(
            'With a focus on attentive listening and fostering positive support, the app allows users to open up without fear in a nurturing environment. ',
            textAlign: TextAlign.center, style: TextStyle(fontSize: 13),
          ),
          SizedBox(height: 10),
          Text(
            'Discover comfort in sharing experiences with others, build meaningful connections, and attain improved mental well-being through the caring community of Teman Sehat.',
            textAlign: TextAlign.center, style: TextStyle(fontSize: 13),
          )
        ]),
      ),
    );
  }
}
