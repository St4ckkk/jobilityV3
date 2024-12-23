import 'package:flutter/material.dart';
import 'package:jobility/constants/app_constants.dart';
import 'package:jobility/views/common/app_style.dart';
import 'package:jobility/views/common/reusable_text.dart';

class EditButton extends StatelessWidget {
  const EditButton({
    super.key,
    this.onTap,
  });

  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20), // Increased padding
        decoration: BoxDecoration(
          color: Color(kOrange.value),
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(9),
            bottomLeft: Radius.circular(9),
          ),
        ),
        child: ReusableText(
          text: "Upload",
          style: appStyle(16, Color(kLight.value), FontWeight.w500), // Increased font size
        ),
      ),
    );
  }
}