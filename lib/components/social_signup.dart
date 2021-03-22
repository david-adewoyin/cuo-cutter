import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SocialSignup extends StatelessWidget {
  const SocialSignup({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        Text("Sign in with"),
        SizedBox(
          height: 30,
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Material(
              color: Colors.transparent,
              child: InkWell(
                child: IconButton(
                  icon: FaIcon(FontAwesomeIcons.google),
                  onPressed: () {
                    print("Pressed");
                  },
                ),
              ),
            ),
            Material(
              color: Colors.transparent,
              child: InkWell(
                child: IconButton(
                  icon: FaIcon(FontAwesomeIcons.apple),
                  onPressed: () {
                    print("Pressed");
                  },
                ),
              ),
            ),
            Material(
              color: Colors.transparent,
              child: InkWell(
                child: IconButton(
                  icon: FaIcon(
                    FontAwesomeIcons.facebook,
                  ),
                  onPressed: () {
                    print("Pressed");
                  },
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
