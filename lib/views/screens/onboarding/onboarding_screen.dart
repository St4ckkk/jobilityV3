import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jobility/controllers/onboarding_provider.dart';
import 'package:jobility/views/common/exports.dart';
import 'package:jobility/views/screens/onboarding/widget/PageOne.dart';
import 'package:jobility/views/screens/onboarding/widget/PageThree.dart';
import 'package:jobility/views/screens/onboarding/widget/PageTwo.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  PageController pageController = PageController();

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Consumer<OnBoardNotifier>(
      builder: (context, onBoardNotifier, child) {
        return Stack(
          children: [
            PageView(
              controller: pageController,
              physics: onBoardNotifier.isLastPage
                  ? const NeverScrollableScrollPhysics()
                  : const AlwaysScrollableScrollPhysics(),
              onPageChanged: (page) {
                onBoardNotifier.isLastPage = page == 2;
              },
              children: const [PageOne(), PageTwo(), PageThree()],
            ),
            onBoardNotifier.isLastPage
                ? const SizedBox.shrink()
                : Positioned(
                    bottom: hieght * 0.12,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: SmoothPageIndicator(
                        controller: pageController,
                        count: 3,
                        effect: WormEffect(
                            dotColor: Color(kLight.value),
                            activeDotColor: Color(kDarkBlue.value),
                            dotHeight: 12,
                            dotWidth: 12,
                            spacing: 10),
                      ),
                    )),
            
            onBoardNotifier.isLastPage
                ? const SizedBox.shrink():
                Positioned(
                child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        pageController.jumpToPage(2);
                      },
                      child: ReusableText(
                          text: 'Skip',
                          style: appStyle(
                              16, Color(kDark.value), FontWeight.normal)),
                    ),
                    GestureDetector(
                      onTap: () {
                        pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.ease);
                      },
                      child: ReusableText(
                          text: 'Next',
                          style: appStyle(
                              16, Color(kDark.value), FontWeight.normal)),
                    )
                  ],
                ),
              ),
            ))
          ],
        );
      },
    ));
  }
}
