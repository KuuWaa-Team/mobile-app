import 'package:audioplayers/audioplayers.dart';
import 'package:kuuwaa/common/app_colors.dart';
import 'package:kuuwaa/common/common_button.dart';
import 'package:kuuwaa/common/common_widget.dart';
import 'package:kuuwaa/common/image_path.dart';
import 'package:kuuwaa/common/utils.dart';
import 'package:kuuwaa/model/event/event_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kuuwaa/resource/config/app_url.dart';
import 'package:kuuwaa/responsive/responsive_flutter.dart';
import 'package:kuuwaa/view_model/book/book_view_model.dart';
import 'package:kuuwaa/view_model/event/event_view_model.dart';
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
  EventViewModel eventViewModel = EventViewModel();
  bool loaded = false;

  bool loadingDelete = false;

  BookViewModel bookViewModel = BookViewModel();
  EventModel event = EventModel();

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
  List<Widget> _pages = [];

  @override
  void initState() {
    print(event.books);
    setState(() {
      event = widget.event;
    });
    super.initState();
  }

  void loadBooks () {
    setState(() {
      books = [];
      event.books?.forEach((element) {
        books.add(
          Container(
            margin: EdgeInsets.only(
              left: ResponsiveFlutter.of(context).moderateScale(20),
              right: ResponsiveFlutter.of(context).moderateScale(20),
              bottom: ResponsiveFlutter.of(context).moderateScale(20),
            ),
            decoration: BoxDecoration(
              color: appColors.white,
              boxShadow: [Utils.customShadow()],
            ),
            padding: EdgeInsets.symmetric(
              vertical: ResponsiveFlutter.of(context).moderateScale(20),
              horizontal: ResponsiveFlutter.of(context).moderateScale(20),
            ),
            child: Stack(
              children: [
                // Bouton Supprimer
                Positioned(
                  bottom: 0,
                  right: 20,
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return StatefulBuilder(
                            builder: (context, setState) {
                              return Dialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Stack(
                                    children: [
                                      Positioned(
                                          right: 0,
                                          top: 0,
                                          child: IconButton(onPressed: (){
                                            Navigator.pop(context);
                                          }, icon: const Icon(Icons.close)
                                          )
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                                        child:
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SizedBox(
                                              height: 60,
                                              width: 60,
                                              child: Center(
                                                child: Icon(
                                                  Icons.question_mark_rounded,
                                                  color: appColors.btnColor,
                                                  size: 50,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 10,),
                                            const Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text("Êtes-vous sûr de vouloir supprimer ce message du livre d'or ?", style: TextStyle(
                                                    fontWeight: FontWeight.bold
                                                ), textAlign: TextAlign.center,),
                                              ],
                                            ),
                                            const SizedBox(height: 20,),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: CommonButton(
                                                    loading: loading,
                                                    btnColor: appColors.appLightColor,
                                                    title: "Annuler",
                                                    padding: const EdgeInsets.symmetric(horizontal: 20),
                                                  ),
                                                ),
                                                const SizedBox(width: 10,),
                                                GestureDetector(
                                                  onTap: () {
                                                    bookViewModel.deleteBook(context, element.id!, event).then((value) {
                                                      Navigator.pop(context);
                                                      setState(() {
                                                        event.books!.remove(element);
                                                        _controller.previousPage(
                                                            duration: const Duration(milliseconds: 500),
                                                            curve: Curves.easeInOutQuint
                                                        );
                                                        loadBooks();
                                                      });
                                                    });
                                                  },
                                                  child: CommonButton(
                                                    loading: loadingDelete,
                                                    title: "Confirmer",
                                                    padding: const EdgeInsets.symmetric(horizontal: 20),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                              );
                            },
                          );
                        },
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: appColors.black.withOpacity(.03),
                      ),
                      padding: const EdgeInsets.only(top: 3, left: 5, right: 7, bottom: 4),
                      child: Row(
                        children: [
                          Icon(Icons.close, size: 12, color: appColors.black.withOpacity(.5)),
                          const SizedBox(width: 2),
                          Text(
                            "Supprimer",
                            style: TextStyle(
                              fontSize: 10,
                              color: appColors.black.withOpacity(.4),
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                        decoration: BoxDecoration(
                          color: element.public == true ? Colors.green : Colors.orange,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(element.public == true ? Icons.lock_open_outlined :Icons.lock_outline_rounded, color: Colors.white, size: 10,),
                            const SizedBox(width: 5,),
                            Text(
                              element.public == true ? 'Public' : 'Privé',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Image.asset("assets/images/quote.png", width: 30),
                    Container(
                      width: 250,
                      margin: const EdgeInsets.only(left: 20, top: 10),
                      constraints: const BoxConstraints(
                        maxHeight: 300,
                      ),
                      child: SingleChildScrollView(
                        child: Text(
                          element.message ?? "",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            color: appColors.black,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    if (element.audioPath != null)
                      AudioPlayerCard(audioPath: element.audioPath!),

                    const SizedBox(height: 10),
                    Text(
                      "${element.invitation!.civility!} ${element.invitation!.name}",
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 10,
                        fontStyle: FontStyle.italic,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        );

      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!loaded) {
      setState(() {
        loaded = true;
      });
      loadBooks();
    }
    _pages = [
      Container(
        margin: EdgeInsets.only(left: ResponsiveFlutter.of(context).moderateScale(20), right: ResponsiveFlutter.of(context).moderateScale(20), bottom: ResponsiveFlutter.of(context).moderateScale(20)),
        decoration: BoxDecoration(
          color: appColors.white,
          boxShadow: [Utils.customShadow()]
        ),
        padding: EdgeInsets.only(
          top: ResponsiveFlutter.of(context).moderateScale(20),
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
              fontSize: 25,
            ),),
            SizedBox(
              width: ResponsiveFlutter.of(context).moderateScale(250),
              child: Text("Vous leur avez invité à votre évenement, ils vous ont laissé un mot en guise de leur reconnaissance et amour", style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
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
              child: Text(widget.event.title!, style: TextStyle(
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
    return Scaffold(
      backgroundColor: appColors.appMediumColor,
      body: SafeArea(
        child: Column(
          children: [
            commonAppBar(
              context: context,
              title: "Livre d'or",
              backArrow: true,
            ),
            const SizedBox(height: 20,),
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
                      Text((step + 1).toString(), style: TextStyle(
                        color: appColors.btnColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                      ),),
                      Text("/${_pages.length}", style: TextStyle(
                          color: Colors.black.withOpacity(.5)
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
                              color: (step > 0 ) ? appColors.btnColor: appColors.darkGreyText.withOpacity(.8),
                              borderRadius: BorderRadius.circular(40)
                          ),
                          child: Icon(CupertinoIcons.chevron_left, color: step > 0 ? Colors.white : Colors.white.withOpacity(.5), size: 15,),
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
                              color: (step + 1 < _pages.length) ? appColors.btnColor: appColors.darkGreyText.withOpacity(.8),
                              borderRadius: BorderRadius.circular(40)
                          ),
                          child: Icon(CupertinoIcons.chevron_right, color: (step + 1 < _pages.length) ? Colors.white : Colors.white.withOpacity(.5), size: 15,),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: ResponsiveFlutter.of(context).moderateScale(20),),
          ],
        ),
      ),
    );
  }
}

class AudioPlayerCard extends StatefulWidget {
  final String audioPath;

  const AudioPlayerCard({super.key, required this.audioPath});

  @override
  State<AudioPlayerCard> createState() => _AudioPlayerCardState();
}

class _AudioPlayerCardState extends State<AudioPlayerCard> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  AppColors appColors = AppColors();

  String get audioUrl => "https://invitation.kuuwaa.com${widget.audioPath}";

  @override
  void initState() {
    super.initState();

    _audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      setState(() => isPlaying = state == PlayerState.playing);
    });

    _audioPlayer.onDurationChanged.listen((d) {
      setState(() => duration = d);
    });

    _audioPlayer.onPositionChanged.listen((p) {
      setState(() => position = p);
    });

    _audioPlayer.onPlayerComplete.listen((event) {
      setState(() => position = Duration.zero);
    });

    _audioPlayer.setSource(UrlSource(audioUrl));
  }

  String formatTime(Duration d) {
    return [d.inMinutes, d.inSeconds % 60]
        .map((seg) => seg.toString().padLeft(2, '0'))
        .join(':');
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: appColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: appColors.btnColor.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
              color: appColors.btnColor,
              size: 28,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () async {
              if (isPlaying) {
                await _audioPlayer.pause();
              } else {
                await _audioPlayer.play(UrlSource(audioUrl));
              }
            },
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 2,
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 5),
                    overlayShape: const RoundSliderOverlayShape(overlayRadius: 10),
                    activeTrackColor: appColors.btnColor,
                    inactiveTrackColor: appColors.btnColor.withOpacity(0.3),
                    thumbColor: appColors.btnColor,
                  ),
                  child: Slider(
                    min: 0,
                    max: duration.inSeconds.toDouble(),
                    value: position.inSeconds.clamp(0, duration.inSeconds).toDouble(),
                    onChanged: (value) async {
                      final newPosition = Duration(seconds: value.toInt());
                      await _audioPlayer.seek(newPosition);
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(formatTime(position), style: const TextStyle(fontSize: 10)),
                    Text(formatTime(duration), style: const TextStyle(fontSize: 10)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}



