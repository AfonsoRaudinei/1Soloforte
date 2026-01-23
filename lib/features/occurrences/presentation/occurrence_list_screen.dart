import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:soloforte_app/features/occurrences/presentation/widgets/occurrence_list_view.dart';

class OccurrenceListScreen extends StatelessWidget {
  const OccurrenceListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[50],
      child: SafeArea(child: const OccurrenceListView()),
    );
  }
}
