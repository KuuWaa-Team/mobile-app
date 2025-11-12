import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kuuwaa/common/utils.dart';
import 'package:kuuwaa/model/event/event_model.dart';
import 'package:kuuwaa/repository/book/book_repository.dart';

class BookViewModel with ChangeNotifier{
  final _repository = BookRepository();

  Future<bool> deleteBook(BuildContext context, int id, EventModel event) async {
    await _repository.deleteBookApi(context: context, id: id).then((value) {
      return true;
    });
    // .onError((error, stackTrace) {
    //   Utils.flushBarErrorMessage("Une erreur est survenue. Veuillez réessayer plus tard.", context);
    //   return false;
    // });
    return false;
  }

}