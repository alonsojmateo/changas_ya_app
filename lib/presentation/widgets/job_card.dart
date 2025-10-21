import 'package:changas_ya_app/Domain/Job/job.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class JobCard extends StatelessWidget {
  final Job job;
  const JobCard({required this.job});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: ListTile(
        title: Text(
          job.title, 
          style: const TextStyle(fontWeight: FontWeight.bold)
        ),
        
        subtitle: Text(
          'Publicado: ${job.datePosted}',
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
        
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        
        onTap: () {
          context.push('/jobs/${job.id}'); 
        },
      ),
    );
  }
}