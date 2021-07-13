import 'package:aero_meet/constant/app_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: CustomColors().mainColor(0.3),
      child: Center(
        child: SpinKitDoubleBounce(
          color: CustomColors().mainColor(1),
          size: 50.0,
        ),
      ),
    );
  }
}
