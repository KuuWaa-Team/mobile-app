import 'package:kuuwaa/common/app_colors.dart';
import 'package:kuuwaa/common/common_button.dart';
import 'package:kuuwaa/common/common_widget.dart';
import 'package:kuuwaa/common/image_path.dart';
import 'package:kuuwaa/model/event/event_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kuuwaa/resource/config/app_url.dart';
import 'package:kuuwaa/responsive/responsive_flutter.dart';
import 'package:kuuwaa/view_model/invitation/invitation_view_model.dart';
import 'package:kuuwaa/view_model/table/table_view_model.dart';

class BookScreen extends StatefulWidget {
  EventModel event;
  BookScreen({Key? key, required this.event}) : super(key: key);

  @override
  _BookScreenState createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {
  AppColors appColors = AppColors();
  InvitationViewModel invitationViewModel = InvitationViewModel();
  bool loaded = false;

  int step = 0;

  final PageController _controller = PageController();

  _onChanged(int index) {
    setState(() {
      step = index;
    });
  }

  bool loading = false;
  bool sending = false;

  TableViewModel tableViewModel = TableViewModel();
  List<Widget> books = [];


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!loaded) {
      setState(() {
        loaded = true;
      });
      widget.event.books?.forEach((element) {
        books.add(Container(
          height: MediaQuery.of(context).size.height * 0.6,
          margin: EdgeInsets.only(left: ResponsiveFlutter.of(context).moderateScale(20), right: ResponsiveFlutter.of(context).moderateScale(20), bottom: ResponsiveFlutter.of(context).moderateScale(20)),
          color: appColors.white,
          padding: EdgeInsets.symmetric(vertical: ResponsiveFlutter.of(context).moderateScale(40), horizontal: ResponsiveFlutter.of(context).moderateScale(20)),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset("assets/images/quote.png", width: 30,),
                Container(
                  width: 250,
                  margin: const EdgeInsets.only(left: 20, top: 10),
                  child: Text(element.message!, style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: appColors.black
                  )),
                ),
                const SizedBox(height: 30,),
                Text("${element.invitation!.civility!} ${element.invitation!.name}", style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 10,
                    fontStyle: FontStyle.italic
                ),)
              ],
            ),
          ),
        ));
      });
    }
    final List<Widget> _pages = [
      Container(
        height: MediaQuery.of(context).size.height * 0.6,
        margin: EdgeInsets.only(left: ResponsiveFlutter.of(context).moderateScale(20), right: ResponsiveFlutter.of(context).moderateScale(20), bottom: ResponsiveFlutter.of(context).moderateScale(20)),
        color: appColors.white,
        padding: EdgeInsets.only(
          top: ResponsiveFlutter.of(context).moderateScale(40),
          bottom: ResponsiveFlutter.of(context).moderateScale(20),
          left: ResponsiveFlutter.of(context).moderateScale(20),
          right: ResponsiveFlutter.of(context).moderateScale(20)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text("LIVRE D'OR", style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 30,
            ),),
            SizedBox(height: ResponsiveFlutter.of(context).moderateScale(10),),
            SizedBox(
              width: ResponsiveFlutter.of(context).moderateScale(200),
              child: Text("Ils étaient là et vous ont laissé un mot en guise de leur amour pour vous.", style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 10,
                  color: appColors.black.withOpacity(.4)
              ), textAlign: TextAlign.center,),
            ),
            SizedBox(height: ResponsiveFlutter.of(context).moderateScale(30),),
            Container(
              width: ResponsiveFlutter.of(context).moderateScale(150),
              height: ResponsiveFlutter.of(context).moderateScale(150),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(200),
                  image: DecorationImage(
                      image: NetworkImage(AppUrl.domainName + widget.event.imagePath!),
                      fit: BoxFit.cover
                  )
              ),
            ),
            const SizedBox(height: 30,),
            SizedBox(
              width: ResponsiveFlutter.of(context).moderateScale(200),
              child: Text(widget.event.name!, style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: appColors.btnColor
              ), textAlign: TextAlign.center,),
            ),
            const SizedBox(height: 3,),
            SizedBox(
              width: ResponsiveFlutter.of(context).moderateScale(200),
              child: Text(widget.event.category!.name!, style: TextStyle(
                // fontWeight: FontWeight.w700,
                  fontSize: 10,
                  color: appColors.black.withOpacity(.4)
              ), textAlign: TextAlign.center,),
            ),
            SizedBox(height: ResponsiveFlutter.of(context).moderateScale(50),),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(ImagePath.logo, width: ResponsiveFlutter.of(context).moderateScale(12),),
                SizedBox(width: ResponsiveFlutter.of(context).moderateScale(5),),
                const Text("KuuWaa", style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 10
                ),),
              ],
            ),
            const SizedBox(height: 2,),
            Text("www.kuuwaa.com", style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 8,
              color: appColors.black.withOpacity(.4)
            ),),
          ],
        ),
      ),
      ...books
    ];
    return SafeArea(
      bottom: false,
      top: false,
      child: Scaffold(
        backgroundColor: appColors.appMediumColor,
        body: Column(
          children: [
            commonAppBar(
              context: context,
              title: "Livre d'or",
              backArrow: true,
            ),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: PageView.builder(
                      scrollDirection: Axis.horizontal,
                      controller: _controller,
                      itemCount: _pages.length,
                      onPageChanged:_onChanged,
                      itemBuilder: (context, int index) {
                        return _pages[index];
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text((step + 1).toString(), style: const TextStyle(
                          color: Colors.white,
                          fontSize: 25
                      ),),
                      Text("/${_pages.length}", style: TextStyle(
                          color: Colors.white.withOpacity(.5)
                      ),),
                    ],
                  ),
                  SizedBox(height: ResponsiveFlutter.of(context).moderateScale(20),),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (step > 0) {
                            _controller.previousPage(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeInOutQuint
                            );
                          }
                        },
                        child: Container(
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                              color: (step > 0 ) ? appColors.btnColor: appColors.appLightColor,
                              borderRadius: BorderRadius.circular(40)
                          ),
                          child: Icon(CupertinoIcons.chevron_left, color: step > 0 ? Colors.white : Colors.white.withOpacity(.3), size: 15,),
                        ),
                      ),
                      const SizedBox(width: 10,),
                      GestureDetector(
                        onTap: () {
                          if (step + 1 < _pages.length) {
                            _controller.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOutQuint
                            );
                          }
                        },
                        child: Container(
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                              color: (step + 1 < _pages.length) ? appColors.btnColor: appColors.appLightColor,
                              borderRadius: BorderRadius.circular(40)
                          ),
                          child: Icon(CupertinoIcons.chevron_right, color: (step + 1 < _pages.length) ? Colors.white : Colors.white.withOpacity(.3), size: 15,),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30,),
            if (widget.event.books!.isNotEmpty)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: ResponsiveFlutter.of(context).moderateScale(20)),
              child: CommonButton(
                title: "Télécharger",
              ),
            ),
            if (widget.event.books!.isEmpty)
              Container(
                height: ResponsiveFlutter.of(context).scale(40),
                decoration: BoxDecoration(
                    color: appColors.appLightColor,
                    borderRadius: BorderRadius.circular(10)
                ),
                margin: const EdgeInsets.only(
                    left: 20, right: 20, top: 20
                ),
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.block_outlined, color: appColors.lightColor.withOpacity(.2),),
                    const SizedBox(width: 10,),
                    MyTextView(
                      "Livre d'or actuellement vide",
                      textAligntNew: TextAlign.start,
                      maxLinesNew: 3,
                      styleNew: MyTextStyle(
                        colorNew: appColors.lightColor.withOpacity(.2),
                        fontWeightNew: FontWeight.w400,
                        size: ResponsiveFlutter.of(context).fontSize(1.8),
                      ),
                    ),
                  ],
                ),
              ),
            SizedBox(height: ResponsiveFlutter.of(context).moderateScale(30),),
          ],
        ),
      ),
    );
  }
}