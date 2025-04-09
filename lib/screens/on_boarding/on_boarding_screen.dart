import 'package:flutter/material.dart';
import 'package:kuuwaa/common/app_colors.dart';
import 'package:kuuwaa/common/common_button.dart';
import 'package:kuuwaa/common/image_path.dart';
import 'package:kuuwaa/common/page_slider.dart';
import 'package:kuuwaa/screens/auth/login_screen.dart';

class OnBoardingView extends StatefulWidget {
  const OnBoardingView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => OnBoardingViewState();
}

class OnBoardingViewState extends State<OnBoardingView> {
  int _currentPage = 0;
  bool isLast = false;
  AppColors appColors = AppColors();
  ImagePath imagePath = ImagePath();

  final PageController _controller = PageController();

  final List<Widget> _pages = [
    PageSlider(
        title: "Bienvenue dans KuuWaa !",
        description: "Découvrez une nouvelle façon simple et éfficace de gérer et d'organiser vos événements.",
        image: ImagePath.logo
    ),
    PageSlider(
        title: "Invitations électroniques",
        description: "Créez et envoyez des invitations électroniques élégantes à vos invités en quelques clics.",
        image: "assets/on_boarding/2.png"
    ),
    PageSlider(
      title: "Billeterie en ligne",
      description: "Vendez vos billets en ligne et gérez facilement les réservations pour vos événements.",
      image: "assets/on_boarding/3.png",
    ),
  ];

  _onChanged(int index) {
    setState(() {
      _currentPage = index;
      if (index == _pages.length - 1) {
        isLast = true;
      } else {
        isLast = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Color dotsColor = appColors.btnColor;
    return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            color: appColors.appMediumColor,
          ),
          child: Stack(
            children: <Widget>[
              PageView.builder(
                scrollDirection: Axis.horizontal,
                controller: _controller,
                itemCount: _pages.length,
                onPageChanged:_onChanged,
                itemBuilder: (context, int index) {
                  return _pages[index];
                },
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List<Widget>.generate(_pages.length, (int index) {
                      return Container(
                        height: 10,
                        width: (index == _currentPage) ? 30: 10,
                        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 30),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: (index == _currentPage) ? dotsColor: dotsColor.withOpacity(0.5)
                        ),
                      );
                    }
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (!isLast) {
                        _controller.nextPage(
                            duration: const Duration(milliseconds: 800),
                            curve: Curves.easeInOutQuint
                        );
                      } else {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
                              (route) => false,
                        );
                      }
                    },
                    child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: CommonButton(
                        context: context,
                        title:  (_currentPage == (_pages.length - 1)? "Commencer" : "Suivant"),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  )
                ],
              )

            ],
          ),
        )
    );
  }
}