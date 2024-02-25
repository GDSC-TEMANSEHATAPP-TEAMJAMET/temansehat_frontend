
import 'package:flutter/material.dart';
import 'package:temansehat_app/styles/color.dart';

final ButtonStyle buttonPrimary = OutlinedButton.styleFrom(
  minimumSize: const Size(259, 42),
  foregroundColor: bluePrimary,
  backgroundColor: bgColor,
  side: BorderSide(color: bluePrimary, width: 3),
  elevation: 0,
);

final ButtonStyle buttonProfile = OutlinedButton.styleFrom(
  minimumSize: const Size(152, 30),
  foregroundColor: bluePrimary,
  backgroundColor: bgColor,
  side: BorderSide(color: bluePrimary, width: 2),
  elevation: 0,
);

final ButtonStyle buttonSecondary = ElevatedButton.styleFrom(
  minimumSize: const Size(259, 42),
  backgroundColor: bluePrimary,
  elevation: 0,
);

final ButtonStyle buttonSubmit = ElevatedButton.styleFrom(
  minimumSize: const Size(150, 40),
  backgroundColor: bluePrimary,
  elevation: 0,
);

ButtonStyle getButtonHome(BuildContext context) {
  return OutlinedButton.styleFrom(
    minimumSize: Size(
      MediaQuery.of(context).size.width * 0.25, // 25% of screen width
      MediaQuery.of(context).size.height * 0.053, // 5.3% of screen height
    ),
    backgroundColor: bgColor,
    side: BorderSide(color: bluePrimary, width: 3),
    elevation: 0,
  );
}

ButtonStyle buttonAppBar(BuildContext context) {
  return ElevatedButton.styleFrom(
    minimumSize: Size(
      MediaQuery.of(context).size.width * 0.85, // 25% of screen width
      47,
    ),
    backgroundColor: bgColor,
    side: BorderSide(color: bluePrimary, width: 3),
    elevation: 0,
  );
}

ButtonStyle postAppBar(BuildContext context) {
  return ElevatedButton.styleFrom(
    minimumSize: Size(
      MediaQuery.of(context).size.width * 0.85, // 25% of screen width
      47,
    ),
    backgroundColor: bluePrimary,
    side: BorderSide(color: bluePrimary, width: 3),
    elevation: 0,
  );
}

ButtonStyle backButton(BuildContext context) {
  return ElevatedButton.styleFrom(
    minimumSize: Size(
      MediaQuery.of(context).size.width * 0.04, // 25% of screen width
      MediaQuery.of(context).size.height * 0.04,
    ),
    backgroundColor: forumDark,
    elevation: 0,
  );
}
