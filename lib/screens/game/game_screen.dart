import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:kuuwaa/common/app_colors.dart';
import 'package:kuuwaa/common/common_widget.dart';
import 'package:kuuwaa/data/response/status.dart';
import 'package:kuuwaa/model/event/event_model.dart';
import 'package:kuuwaa/model/event/game_assertion_model.dart';
import 'package:kuuwaa/model/event/game_question_model.dart';
import 'package:kuuwaa/responsive/responsive_flutter.dart';
import 'package:kuuwaa/screens/events/details_screen.dart';
import 'package:kuuwaa/view_model/event/event_view_model.dart';
import 'package:provider/provider.dart';

class GameScreen extends StatefulWidget {
  final EventModel event;

  const GameScreen({Key? key, required this.event}) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  AppColors appColors = AppColors();
  EventViewModel eventViewModel = EventViewModel();
  bool loading = false;
  List<GameResultModel> gameResults = [];

  @override
  void initState() {
    eventViewModel.getQuestionsList(context, widget.event.id!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
bottom: !Platform.isIOS,
      child: Scaffold(
        backgroundColor: appColors.appMediumColor,
        body: Column(
          children: [
            commonAppBar(
              context: context,
              title: "Jeu interactif",
              backArrow: true,
              backClick: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailsScreen(id: widget.event.id!),
                  ),
                );
              },
            ),
            ChangeNotifierProvider<EventViewModel>(
              create: (BuildContext context) => eventViewModel,
              child: Consumer<EventViewModel>(
                builder: (context, value, _) {
                  switch (value.questionsList.status) {
                    case Status.LOADING:
                      return const Center(child: Padding(
                        padding: EdgeInsets.only(top: 30.0),
                        child: CupertinoActivityIndicator(),
                      ),);
                    case Status.ERROR:
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 30.0),
                          child: Text(value.event.message.toString()),
                        ),
                      );
                    case Status.COMPLETED:
                      List<GameQuestionModel> questions = value.questionsList.data!;
                      gameResults = value.gameResultsList.data ?? [];
                      return Expanded(
                      child: questions?.isNotEmpty == true
                  ? ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: questions!.length,
                      itemBuilder: (context, index) {
                        final question = questions![index];
                        return Card(
                          color: appColors.appLightColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          margin: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            children: [
                              Expanded(
                                child: ListTile(
                                  leading: Icon(Icons.question_mark, color: appColors.btnColor),
                                  title: Text(
                                    question.title ?? 'Question',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      color: appColors.lightColor,
                                    ),
                                  ),
                                  onTap: () => _showAssertionsModal(question),
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.edit, color: appColors.darkGreyText),
                                onPressed: () {
                                  _showEditQuestionDialog(question);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline_outlined, color: Colors.red),
                                onPressed: () async {
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: const Text("Confirmation"),
                                      content: const Text("Supprimer cette question ?"),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(ctx, false),
                                          child: const Text("Annuler"),
                                        ),
                                        TextButton(
                                          onPressed: () => Navigator.pop(ctx, true),
                                          child: const Text("Supprimer", style: TextStyle(color: Colors.red)),
                                        ),
                                      ],
                                    ),
                                  );

                                  if (confirm == true) {
                                    await eventViewModel.removeGameQuestion(context, question.id!).then((value) {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => GameScreen(event: widget.event),
                                        ),
                                      );
                                    });
                                  }
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    )
                      : Center(
                  child: Text(
                  "Aucune question ajoutée",
                  style: TextStyle(color: appColors.lightColor),
                  ),
                  )
                  );
                  }
                },
              ),
            )
          ],
        ),
        floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: "resultsBtn",
            backgroundColor: appColors.appLightColor,
            onPressed: _showResultsModal,
            child: const Icon(Icons.leaderboard, color: Colors.black),
          ),
          const SizedBox(height: 12),
          FloatingActionButton(
            heroTag: "addBtn",
            backgroundColor: appColors.btnColor,
            onPressed: _showAddQuestionDialog,
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ],
      ),

      ),
    );
  }

  void _showAssertionsModal(GameQuestionModel question) {
    TextEditingController assertionController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(question.title.toString(),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20)),
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
                                    ? appColors.btnColor
                                    : Colors.grey,
                              ),
                              onPressed: () {
                                eventViewModel.setGameAssertionCorrect(context, question.assertions![i].id!);
                                setState(() {
                                  for (var a in question.assertions!) {
                                    a.isCorrect = false;
                                  }
                                  question.assertions![i].isCorrect = true;
                                });
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                assertionController.text = question.assertions![i].text ?? '';
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text("Modifier l'assertion"),
                                      content: TextField(
                                        controller: assertionController,
                                        decoration: const InputDecoration(hintText: "Nouveau texte"),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context),
                                          child: const Text("Annuler"),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            // TODO: appeler l’API pour modifier l’assertion
                                            setState(() {
                                              question.assertions![i].text = assertionController.text;
                                            });
                                            Navigator.pop(context);
                                          },
                                          child: const Text("Modifier"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline),
                              onPressed: () {
                                eventViewModel.removeGameAssertion(context, question.assertions![i].id!);
                                setState(() {
                                  question.assertions!.removeAt(i);
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Divider(height: 30),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Nouvelle assertion",
                        style: TextStyle(
                          color: appColors.btnColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: assertionController,
                      decoration: const InputDecoration(
                        hintText: "Texte de l'assertion",
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: () async {
                        if (assertionController.text.trim().isEmpty) return;
                        await eventViewModel.addAssertionToQuestion(
                          context,
                          {
                            'text': assertionController.text.trim()
                          },
                          question.id!,
                        ).then((value) {
                          if (value != null) {
                            setState(() {
                              question.assertions?.add(value);
                              assertionController.clear();
                            });
                          }
                        });
                      },
                      icon: const Icon(Icons.add, color: Colors.white,),
                      label: const Text("Ajouter une assertion"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: appColors.btnColor,
                        foregroundColor: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showAddQuestionDialog() {
    String questionTitle = '';
    List<String> assertions = ['', ''];
    int? correctIndex;

    showModalBottomSheet(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                top: 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  MyTextView(
                    "Nouvelle question",
                    textAligntNew: TextAlign.start,
                    styleNew: MyTextStyle(
                      colorNew: appColors.btnColor,
                      fontWeightNew: FontWeight.w600,
                      size: ResponsiveFlutter.of(context).fontSize(2),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    onChanged: (value) => questionTitle = value,
                    decoration: const InputDecoration(labelText: "Intitulé de la question"),
                  ),

                  const SizedBox(height: 10),
                  ...List.generate(assertions.length, (i) {
                    return Row(
                      children: [
                        Expanded(
                          child: TextField(
                            onChanged: (value) => assertions[i] = value,
                            decoration: InputDecoration(labelText: "Assertion ${i + 1}"),
                          ),
                        ),
                        Radio<int>(
                          value: i,
                          groupValue: correctIndex,
                          onChanged: (value) {
                            setState(() => correctIndex = value);
                          },
                        ),
                        const Text("Correct"),
                        IconButton(
                          icon: const Icon(Icons.delete, size: 20),
                          onPressed: () {
                            setState(() {
                              assertions.removeAt(i);
                              if (correctIndex == i) correctIndex = null;
                            });
                          },
                        )
                      ],
                    );
                  }),
                  TextButton.icon(
                    onPressed: () {
                      setState(() => assertions.add(''));
                    },
                    icon: Icon(Icons.add, color: appColors.btnColor),
                    label: MyTextView(
                      "Ajouter une assertion",
                      textAligntNew: TextAlign.start,
                      styleNew: MyTextStyle(
                        colorNew: appColors.btnColor,
                        fontWeightNew: FontWeight.w500,
                        size: ResponsiveFlutter.of(context).fontSize(1.7),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(appColors.btnColor),
                    ),
                    onPressed: loading ? null : () async {
                      if (questionTitle.trim().isEmpty ||
                          correctIndex == null ||
                          assertions.any((a) => a.trim().isEmpty)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Complétez tous les champs")),
                        );
                        return;
                      }

                      setState(() {
                        loading = false;
                      });

                      final data = {
                        "title": questionTitle.trim(),
                        "position": 0,
                        "assertions": List.generate(assertions.length, (i) {
                          return {
                            "text": assertions[i],
                            "isCorrect": i == correctIndex
                          };
                        })
                      };

                      final url = Uri.parse("https://yourdomain.com/api/events/${widget.event.id}/questions"); // 🔁 adapte ce lien
                      await eventViewModel.addGameQuestion(context, data, widget.event.id!).then((value) {
                        if (value) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GameScreen(event: widget.event),
                            ),
                          );
                        }
                        setState(() {
                          loading = false;
                        });
                      });
                    },
                    child: MyTextView(
                      "Enrégistrer",
                      textAligntNew: TextAlign.start,
                      styleNew: MyTextStyle(
                        colorNew: appColors.white,
                        fontWeightNew: FontWeight.w500,
                        size: ResponsiveFlutter.of(context).fontSize(1.7),
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }
  void _showEditQuestionDialog(GameQuestionModel question) {
    String questionTitle = question.title ?? '';

    showModalBottomSheet(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                top: 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Modifier la question",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  TextField(
                    controller: TextEditingController(text: questionTitle),
                    onChanged: (value) => questionTitle = value,
                    decoration: const InputDecoration(labelText: "Intitulé de la question"),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(appColors.btnColor),
                    ),
                    onPressed: () async {
                      if (questionTitle.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Le titre ne peut pas être vide")),
                        );
                        return;
                      }

                      final data = {
                        "title": questionTitle.trim(),
                        "position": question.position,
                      };

                      final success = await eventViewModel.editGameQuestion(
                        context,
                        data,
                        question.id!,
                      );

                      if (success == true) {
                        setState(() {
                          question.title = questionTitle.trim();
                        });
                        Navigator.pop(context);
                      }
                    },
                    child: const Text("Modifier", style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showResultsModal() async {
    gameResults.sort((a, b) => b.percentage!.compareTo(a.percentage!));

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Résultats du Quiz",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Divider(),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                child: ListView.builder(
                  itemCount: gameResults.length,
                  itemBuilder: (context, index) {
                    final r = gameResults[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: appColors.btnColor,
                          child: Text(
                            "${index + 1}",
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text(r.name!),
                        subtitle: Text("Le ${r.dateTimeFormatted}"),
                        trailing: Text(
                          "${r.percentage}%",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: index == 0 ? Colors.green : appColors.darkGreyText,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }


}
