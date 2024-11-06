import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jobility/constants/app_constants.dart';
import 'package:jobility/models/response/jobs/jobs_response.dart';
import 'package:jobility/services/helpers/jobs_helper.dart';
import 'package:jobility/views/common/loader.dart';
import 'package:jobility/views/screens/jobs/widgets/JobsVerticalTile.dart';
import 'package:jobility/views/screens/search/widget/custom_field.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(kLight.value),
        automaticallyImplyLeading: false,
        elevation: 0,
        title: ClipRRect(
            borderRadius: BorderRadius.all(
              Radius.circular(25.w),
            ),
            child: CustomField(
              controller: controller,
              onTap: () {
                setState(() {});
              },
            )),
      ),
      body: controller.text.isNotEmpty
          ? Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.w),
              child: FutureBuilder<List<JobsResponse>>(
                  future: JobsHelper.searchJobs(controller.text),
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
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          var job = jobs[index];
                          return JobsVerticalTile(
                            job: job,
                          );
                        },
                      );
                    }
                  }))
          : const NoSearchResults(text: 'Start Searching...'),
    );
  }
}
