import 'package:flutter/material.dart';

import 'package:petaproc/zetaproc/constant/ztheme_styles.dart';

class WidgetButtonContainer extends StatelessWidget {
  final double? width;
  final double? height;
  final String title;
  final VoidCallback? onTap;
  final bool? hasIcon;
  final IconData? icon;
  const WidgetButtonContainer({super.key, this.width=double.infinity, this.height=40, required this.title, this.onTap, this.hasIcon=false, this.icon});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: 45,
        decoration: BoxDecoration(
          color: zlinkedInBlue0077B5,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              offset: Offset(0, 3),
              spreadRadius: 0.5,
              blurRadius: 4.5,
              color: zlinkedInLightGreyCACCCE
            )
          ]
        ),
        child: Center(
          child: hasIcon == true? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(title, style: const TextStyle(color: zlinkedInWhiteFFFFFF, fontWeight: FontWeight.bold),),
              const SizedBox(width: 5,),
              Icon(icon, color: zlinkedInWhiteFFFFFF, size: 15,),
            ],
          ) : Text(title, style: const TextStyle(color: zlinkedInWhiteFFFFFF, fontWeight: FontWeight.bold),),
        ),
      ),
    );
  }
}
