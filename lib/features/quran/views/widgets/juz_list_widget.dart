import 'package:flutter/material.dart';
import 'package:sukun/features/quran/models/juz_model.dart';

// ! =======(AGAIN ANOTHER SOMETHING) ========
class JuzList extends StatelessWidget {
  final List<Juz> juz;
  const JuzList({super.key, required this.juz});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: juz.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final j = juz[index];
        return ListTile(
          leading: CircleAvatar(child: Text('${j.number}')),
          title: Text(j.name),
          subtitle: Text('${j.start} → ${j.end}'), // map from data
          onTap: () {
            // open reader at first ayah of this juz
          },
        );
      },
    );
  }
}
