import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:soloforte_app/features/occurrences/presentation/widgets/occurrence_list_view.dart';

class OccurrenceListScreen extends StatelessWidget {
  const OccurrenceListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Ocorrências'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Navigate to New Occurrence
              context.push('/occurrences/new');
            },
          ),
        ],
      ),
      body: const OccurrenceListView(),
    );
  }
}
