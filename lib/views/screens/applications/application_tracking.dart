import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jobility/constants/app_constants.dart';
import 'package:jobility/views/common/reusable_text.dart';
import 'package:jobility/views/common/styled_container.dart';
import '../../common/BackBtn.dart';

class TrackApplicationScreen extends StatelessWidget {
  const TrackApplicationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(kNewBlue.value),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.h),
        child: AppBar(
          backgroundColor: Color(kNewBlue.value),
          leading: const BackBtn(color: Colors.white),
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 15.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20.w),
                  topLeft: Radius.circular(20.w),
                ),
                color: Color(kGreen.value),
              ),
              child: buildStyleContainer(
                context,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        color: Colors.red.shade50,
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.white,
                              backgroundImage: AssetImage('assets/jollibee_logo.png'), // Replace with your asset
                              radius: 30,
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'Cashier',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                Text('Jollibee'),
                                Text(
                                  'PHP 15,000/m',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text('KCC Branch, Koronadal City'),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Track Application',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            Expanded(
                              child: ListView(
                                children: [
                                  _buildTimelineItem(
                                    title: 'Offer letter',
                                    subtitle: 'Not yet',
                                    isActive: false,
                                  ),
                                  _buildTimelineItem(
                                    title: 'Team matching',
                                    subtitle: '29/06/22 02:00 pm',
                                    isActive: true,
                                  ),
                                  _buildTimelineItem(
                                    title: 'Final HR interview',
                                    subtitle: '21/06/22 04:00 pm',
                                    isActive: true,
                                  ),
                                  _buildTimelineItem(
                                    title: 'Technical interview',
                                    subtitle: '12/06/22 10:00 am',
                                    isActive: true,
                                  ),
                                  _buildTimelineItem(
                                    title: 'Screening interview',
                                    subtitle: '05/06/22 11:00 am',
                                    isActive: true,
                                  ),
                                  _buildTimelineItem(
                                    title: 'Reviewed by Jollibee team',
                                    subtitle: '25/05/22 09:00 am',
                                    isActive: true,
                                  ),
                                  _buildTimelineItem(
                                    title: 'Application submitted',
                                    subtitle: '17/05/22 11:00 am',
                                    isActive: true,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem({required String title, required String subtitle, required bool isActive}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Icon(
              isActive ? Icons.check_circle : Icons.radio_button_unchecked,
              color: isActive ? Colors.green : Colors.grey,
            ),
            Container(
              height: 40,
              width: 2,
              color: Colors.grey.shade300,
            ),
          ],
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isActive ? Colors.black : Colors.grey,
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(
                color: isActive ? Colors.black : Colors.grey,
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ],
    );
  }
}