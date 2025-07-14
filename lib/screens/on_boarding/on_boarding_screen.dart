import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kuuwaa/common/app_colors.dart';
import 'package:kuuwaa/common/common_button.dart';
import 'package:kuuwaa/common/common_widget.dart';
import 'package:kuuwaa/common/image_path.dart';
import 'package:kuuwaa/common/page_slider.dart';
import 'package:kuuwaa/responsive/responsive_flutter.dart';
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
      title: "Bienvenue sur KuuWaa!",
      description: "Découvrez une nouvelle façon simple et éfficace de gérer et d'organiser vos événements.",
      image: ImagePath.logo,
      firstPage: true,
    ),
    PageSlider(
      title: "Des modèles pour chaque événement ",
      description: "Plusieurs templates élégants à personnaliser selon votre style.",
      image: "assets/on_boarding/2.png",
      templates: true,
      firstPage: false,
    ),
    PageSlider(
        title: "Gérez facilement vos invités",
        description: "QR code sécurisé, confirmation de présence, et navigation GPS intégrée avec Google Maps.",
        image: "assets/on_boarding/invite.png"
    ),
    PageSlider(
      title: "Comptez les jours",
      description: "Un compte à rebours dans chaque invitation pour ne rien oublier avant le jour J.",
      image: "assets/on_boarding/count.png",
    ),
    PageSlider(
      title: "Faites vibrer vos invités",
      description: "Intégrez des jeux interactifs et laissez vos invités proposer leurs musiques.",
      image: "assets/on_boarding/music.png",
    ),
    PageSlider(
      title: "Créez des souvenirs inoubliables",
      description: "Livre d'or audio et écrit, album photo partagé entre vous et vos invités.",
      image: "assets/on_boarding/book.png",
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
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: Color(0xFFFDF2F8),
          systemNavigationBarIconBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
          statusBarBrightness: Brightness.light, // For iOS (dark icons)
          systemNavigationBarDividerColor: Color(0xFFFDF2F8)
      ),
    );
    Color dotsColor = appColors.btnColor;
    return Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFE6E6FA),
                Color(0xFFFDF2F8),
              ],
              stops: [0.0, 1.0],
            ),
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
                        width: (index == _currentPage) ? 20: 10,
                        margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 30),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: (index == _currentPage) ? dotsColor: appColors.mediumGrayColor.withOpacity(.5)
                        ),
                      );
                    }
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: _currentPage == 0 ? null : () {
                          _controller.previousPage(
                              duration: const Duration(milliseconds: 800),
                              curve: Curves.easeInOutQuint
                          );
                        },
                        child: const Icon(Icons.chevron_left, color: Colors.black,),
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(16), // Le padding fait le cercle
                          backgroundColor: Colors.white, // Facultatif
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (_currentPage == _pages.length - 1)
                          {
                            Navigator.pushAndRemoveUntil(
                              context, MaterialPageRoute(builder: (route) => LoginScreen()), (route) => false
                            );
                          } else {
                            _controller.nextPage(
                                duration: const Duration(milliseconds: 800),
                                curve: Curves.easeInOutQuint
                            );
                          }
                        },
                        child: _currentPage == _pages.length - 1 ?
                        Row(
                          children: [
                            MyTextView(
                              "Commencer",
                              textAligntNew: TextAlign.center,
                              maxLinesNew: 5,
                              styleNew: MyTextStyle(
                                colorNew: appColors.lightColor,
                                fontWeightNew: FontWeight.w500,
                                size: ResponsiveFlutter.of(context).fontSize(1.7),
                              ),
                            ),
                            const SizedBox(width: 5,),
                            const Icon(Icons.chevron_right, color: Colors.black),
                          ],
                        )
                        : const Icon(Icons.chevron_right, color: Colors.black),
                        style: ElevatedButton.styleFrom(
                          shape: _currentPage == _pages.length - 1 ? null : const CircleBorder(),
                          padding: const EdgeInsets.all(16), // Le padding fait le cercle
                          backgroundColor: Colors.white, // Facultatif
                        ),
                      ),
                    ],
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