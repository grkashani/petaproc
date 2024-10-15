import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../post/desktop_work_sample_page.dart';




class WorkSampletGrid extends StatefulWidget {
  final dynamic snapshot;

  const WorkSampletGrid({
    super.key,
    required this.snapshot,
  });

  @override
  State<WorkSampletGrid> createState() => _WorkSampletGridState();
}

class _WorkSampletGridState extends State<WorkSampletGrid> {
  @override
  Widget build(BuildContext context) {
    
    

    return GridView.builder(
      shrinkWrap: true,
      itemCount: (widget.snapshot.data! as dynamic).docs.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 5,
        mainAxisSpacing: 1.5,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        DocumentSnapshot snap = (widget.snapshot.data! as dynamic).docs[index];

        return InkWell(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => WorkSampletDesktopPage(
                workSampleId: (widget.snapshot.data! as dynamic).docs[index]['workSampleId'],
              ),
            ),
          ),
          child: Image(
            image: NetworkImage(snap['workSampleUrl']),
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }
}
