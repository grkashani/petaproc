import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/themes/styles.dart';
import '../../providers/user_provider.dart';

PreferredSizeWidget appBarWidget(
{required BuildContext context,
  VoidCallback? onLeadingTapClickListener,
  String? title,
  bool? isJobsTab,
  required WidgetRef ref,
}) {
  return AppBar(
    backgroundColor: linkedInWhiteFFFFFF,
    elevation: 0,
    leading: GestureDetector(
      onTap: onLeadingTapClickListener,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(
          radius: 50,
          backgroundImage: MemoryImage(ref.watch(userProvider).image),
        ),
      ),
    ),
    title: Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: linkedInLightGreyCACCCE.withOpacity(0.5),
          borderRadius: BorderRadius.circular(10)),
      child: TextFormField(
        decoration: InputDecoration(
            hintText: "$title", border: InputBorder.none, prefixIcon: const Icon(Icons.search)),
      ),
    ),
    actions: [
      isJobsTab == false
          ? GestureDetector(
              onTap: () {},
              child: const Icon(
                Icons.message_outlined,
                size: 35,
                color: linkedInMediumGrey86888A,
              ),
            )
          : const Row(
              children: [
                Icon(
                  Icons.more_vert,
                  size: 35,
                  color: linkedInMediumGrey86888A,
                ),
                SizedBox(
                  width: 10,
                ),
                Icon(
                  Icons.message_outlined,
                  size: 35,
                  color: linkedInMediumGrey86888A,
                )
              ],
            ),
      const SizedBox(
        width: 10,
      )
    ],
  );
}
