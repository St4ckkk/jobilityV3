import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jobility/controllers/agents_provider.dart';
import 'package:jobility/models/response/jobs/jobs_response.dart';
import 'package:jobility/views/common/pages_loader.dart';
import 'package:jobility/views/screens/jobs/widgets/uploaded_tile.dart';
import 'package:provider/provider.dart';

class AgentJobs extends StatelessWidget {
  const AgentJobs({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AgentNotifier>(
      builder: (context, agentNotifier, child) {
        agentNotifier.getAgentJobs(agentNotifier.agent!.uid);
        return FutureBuilder<List<JobsResponse>>(
            future: agentNotifier.agentJobs,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const PageLoader();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                var jobs = snapshot.data;
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 20),
                  child: ListView.builder(
                      itemCount: jobs!.length,
                      itemBuilder: (context, index) {
                        var job = jobs[index];
                        return UploadedTile(job: job, text: 'agent');
                      }),
                );
              }
            });
      },
    );
  }
}
