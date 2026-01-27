import 'package:flutter/material.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class PageModel {
  final String image;
  final String text;
  PageModel({required this.image, required this.text});
}

List<PageModel> pagesData = [
  PageModel(image: "assets/onBoarding/1.png", text: "Seamlessly integrate and operate your medical robot from your mobile device with real-time monitoring and precision control"),
  PageModel(image:"assets/onBoarding/2.png", text: "Track robot status in real-time, execute procedures with precision, and receive instant alerts for safe and efficient operations"),
  PageModel(image:"assets/onBoarding/3.png", text: "Your connection is encrypted and HIPAA-compliant. Complete the quick setup to start controlling your medical robot safely"),
];

final PageController _pageController = PageController();
int _currentPage = 0;

void _goToPage(int index) {
  if (index >= 0 && index < pagesData.length) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}

class _OnBoardingState extends State<OnBoarding> {
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                physics: NeverScrollableScrollPhysics(),
                controller: _pageController,
                itemCount: pagesData.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (_, index) => Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .5,
                      child: Image.asset(
                        pagesData[index].image,),
                    ),
                    Container(
                      padding: const EdgeInsets.all(16),
                      height:
                          MediaQuery.of(context).size.height * .5-
                          MediaQuery.of(context).padding.top,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            pagesData[index].text,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              if (index > 0)
                                GestureDetector(
                                  onTap: () => _goToPage(index - 1),
                                  child: Text(
                                    "Previous",
                                    style: TextStyle(fontSize: 22),
                                  ),
                                )
                              else
                                const SizedBox(width: 100),
                              Expanded(
                                child: Center(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: List.generate(
                                      pagesData.length,
                                      (dotIndex) => Container(
                                        margin: const EdgeInsets.symmetric(
                                          horizontal: 4,
                                        ),
                                        width: 10,
                                        height: 10,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: dotIndex == _currentPage
                                              ? Colors.blue
                                              : Colors.grey[400],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              if (index < pagesData.length - 1)
                                GestureDetector(
                                  onTap: () => _goToPage(index + 1),
                                  child: Text(
                                    "Next",
                                    style: TextStyle(fontSize: 22),
                                  ),
                                )
                              else
                                const SizedBox(width: 100),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
