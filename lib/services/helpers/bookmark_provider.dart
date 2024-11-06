import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobility/constants/app_constants.dart';
import 'package:jobility/models/response/bookmarks/all_bookmarks.dart';
import 'package:jobility/services/helpers/book_helper.dart';

class BookNotifier extends ChangeNotifier {
  late Future<List<AllBookMarks>> bookmarks;
  bool _bookmark = false;

  bool get bookmark => _bookmark;

  set isBookMark(bool newState) {
    if (_bookmark != newState) {
      _bookmark = newState;
      notifyListeners();
    }
  }

  String _bookmarkId = '';

  String get bookmarkId => _bookmarkId;

  set isBookMarkId(String newState) {
    if (_bookmarkId != newState) {
      _bookmarkId = newState;
      notifyListeners();
    }
  }

  addBookMark(String model) {
    BookMarkHelper.addBookmark(model).then((bookmark) {
      isBookMark = true;
      isBookMarkId = bookmark.bookmarkId;
    });
  }

  getBookMark(String jobId) {
    var bookmark = BookMarkHelper.getBookMark(jobId);

    bookmark.then((value) => {
          if (value == null)
            {
              isBookMark = false,
              isBookMarkId = ''
             } else
            {
              isBookMark = true,
              isBookMarkId = value.bookmarkId,
            }
        });
  }

  deleteBookMark(String jobId) {
    BookMarkHelper.deleteBookMarks(jobId).then((value) {
      if (value) {
        Get.snackbar("Bookmark successfully deleted",
            "Visit the bookmarks page to see the changes",
            colorText: Color(kLight.value),
            backgroundColor: Color(kOrange.value),
            icon: const Icon(Icons.bookmark_remove_outlined));
      }
      isBookMark = false;
    });
  }

  Future<List<AllBookMarks>> getBookMaks() {
    bookmarks = BookMarkHelper.getAllBookmark();

    return bookmarks;
  }
}
