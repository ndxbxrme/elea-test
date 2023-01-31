import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EleaLogo extends StatelessWidget {
  const EleaLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.fromLTRB(40.0, 0.0, 40.0, 40.0),
        child: SvgPicture.asset('assets/elea-logo-darkgreen.svg', width: 200));
  }
}
