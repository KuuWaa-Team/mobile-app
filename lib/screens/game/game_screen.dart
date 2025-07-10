import 'package:kuuwaa/common/app_colors.dart';
import 'package:kuuwaa/common/common_widget.dart';
import 'package:kuuwaa/model/event/event_model.dart';
import 'package:kuuwaa/model/event/game_question_model.dart';
import 'package:flutter/material.dart';
import 'package:kuuwaa/view_model/event/event_view_model.dart';

class GameScreen extends StatefulWidget {
  EventModel event;
  GameScreen({Key? key, required this.event}) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  AppColors appColors = AppColors();
  EventViewModel eventViewModel = EventViewModel();

  bool loading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      top: false,
      child: Scaffold(
        backgroundColor: appColors.appMediumColor,
        body: Column(
          children: [
            commonAppBar(
              context: context,
              title: "Jeu interactif",
              backArrow: true,
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: widget.event.questions?.length ?? 0,
                itemBuilder: (context, index) {
                  final question = widget.event.questions![index];
                  return Card(
                    color: appColors.appLightColor,
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      title: Text(question.title ?? 'Question',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: appColors.lightColor,
                          )),
                      subtitle: Text('Position: ${question.position ?? index + 1}'),
                      onTap: () => showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                        ),
                        builder: (_) => _showAssertionsModal(question),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
  Widget _showAssertionsModal(GameQuestionModel question) {
    return StatefulBuilder(
      builder: (context, setState) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Assertions de: ${question.title}',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              ...List.generate(
                question.assertions?.length ?? 0,
                    (i) => ListTile(
                  title: Text(question.assertions![i].text ?? ''),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          question.assertions![i].isCorrect == true
                              ? Icons.check_circle
                              : Icons.radio_button_unchecked,
                          color: question.assertions![i].isCorrect == true
                              ? Colors.green
                              : Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            for (var a in question.assertions!) {
                              a.isCorrect = false;
                            }
                            question.assertions![i].isCorrect = true;
                          });
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () {
                          setState(() {
                            question.assertions!.removeAt(i);
                          });
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_upward),
                        onPressed: () {
                          if (i > 0) {
                            setState(() {
                              final temp = question.assertions![i - 1];
                              question.assertions![i - 1] = question.assertions![i];
                              question.assertions![i] = temp;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

}