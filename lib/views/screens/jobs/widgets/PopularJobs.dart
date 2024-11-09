import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobility/constants/app_constants.dart';
import 'package:jobility/controllers/jobs_provider.dart';
import 'package:jobility/models/response/jobs/jobs_response.dart';
import 'package:jobility/views/screens/jobs/job_details_page.dart';
import 'package:jobility/views/screens/jobs/widgets/JobsHorizotalTile.dart';
import 'package:provider/provider.dart';

class PopularJobs extends StatelessWidget {
  const PopularJobs({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<JobsNotifier>(
      builder: (context, jobsNotifier, child) {
        jobsNotifier.getJobs();
        return SizedBox(
          height: hieght * 0.24,
          child: FutureBuilder<List<JobsResponse>>(
              future: jobsNotifier.jobList,
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
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        var job = jobs[index];
                        return JobHorizontalTile(
                          job: job,
                          onTap: () {
                            Get.to(() =>  JobDetails(id: job.id,title: job.title,company: job.company,));
                          },
                        );
                      });
                }
              }),
        );
      },
    );
  }
}
