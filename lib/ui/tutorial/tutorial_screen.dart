import 'package:flutter/material.dart';
import 'package:ritmo_mortal_application/ui/tutorial/Tutopag1.dart';
import 'package:ritmo_mortal_application/ui/tutorial/Tutopag2.dart';
import 'package:ritmo_mortal_application/ui/tutorial/Tutopag3.dart';
import 'package:ritmo_mortal_application/ui/tutorial/Tutopag4.dart';
import 'package:ritmo_mortal_application/ui/tutorial/Tutopag5.dart';

class TutorialScreen extends StatelessWidget {
  const TutorialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: const [
          Tutopag1(),
          Tutopag2(),
          Tutopag3(),
          Tutopag4(),
          Tutopag5(),
       
        ],
      ),
    );
  }
}
