import 'package:flutter/material.dart';

import 'package:petaproc/zetaproc/constant/ztheme_styles.dart';

class GoogleWidgetButtonContainer extends StatelessWidget {
  final double? width;
  final double? height;
  final String title;
  final VoidCallback? onTap;
  final bool? hasIcon;
  final Widget? icon;
  const GoogleWidgetButtonContainer({super.key, this.width=double.infinity, this.height=40, required this.title, this.onTap, this.hasIcon=false, this.icon});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: 45,
        decoration: BoxDecoration(
          border: Border.all(width: 1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: hasIcon == true? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon!,
              const SizedBox(width: 5,),
              Text(title, style: const TextStyle(color: zlinkedInBlack000000, fontWeight: FontWeight.bold),),
            ],
          ) : Text(title, style: const TextStyle(color: zlinkedInBlack000000, fontWeight: FontWeight.bold),),
        ),
      ),
    );
  }
}
