import 'package:flutter/material.dart';
import '../../settings/colors.dart';
class CustomTextButton extends StatelessWidget {

  String text = "";
  CustomTextButton({required this.text});
  @override
  Widget build(BuildContext context) {
    return TextButton(onPressed: (){}, child: Text(text,  style: TextStyle(
        fontSize: 18,color: colors.white,decoration: TextDecoration.underline
    ),));
  }
}
