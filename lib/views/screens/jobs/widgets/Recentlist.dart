import 'package:flutter/material.dart';
import 'package:jobility/constants/app_constants.dart';
import 'package:jobility/controllers/jobs_provider.dart';
import 'package:jobility/models/response/jobs/jobs_response.dart';
import 'package:jobility/views/screens/jobs/widgets/JobsVerticalTile.dart';
import 'package:provider/provider.dart';

class RecentJobs extends StatelessWidget {
  const RecentJobs({super.key});

  @override
   Widget build(BuildContext context) {
    return Consumer<JobsNotifier>(
      builder: (context, jobsNotifier, child) {
        jobsNotifier.getRecent();
        return SizedBox(
          height: hieght * 0.28,
          child: FutureBuilder<List<JobsResponse>>(
              future: jobsNotifier.recentJob,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator.adaptive());
                } else if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                } else if (snapshot.data!.isEmpty) {
                  return const Text("No Jobs Available");
                } else {
                  final jobs = snapshot.data;

                  return ListView.builder(
                      itemCount: jobs!.length,
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        var job = jobs[index];
                        return  JobsVerticalTile(job: job,);
                        
                      });
                }
              }),
        );
      },
    );
  }
}