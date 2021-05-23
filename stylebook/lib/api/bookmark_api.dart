import 'dart:convert';

import 'package:style_book/model/bookmark_model.dart';

import 'api_service.dart';

class BookmarkApi extends AbstractApi {
  BookmarkApi() : super("https://phobobunbo-cmomufjvuq-as.a.run.app/bookmarks");

  Future<bool> postBookmark(BookmarkRequest body) async {
    //user_id=1&item_id=1&on_off=1

    final request = jsonEncode(body.toJson());
    print("BookmarkApi request code ${request.toString()}");
    final response = await httpPost(Uri.parse(baseUrl), request);
    print("BookmarkApi response code ${response.statusCode}");
    print("BookmarkApi response ${response.toString()}");
    if (response.statusCode == 200) {
      return true;
    } else {
      print("BookmarkApi error ${response.statusCode} / ${response.body}");
      return false;
    }
  }

  Future<List<Bookmark>> getBookmark(String userId) async {
    //https://phobobunbo-cmomufjvuq-as.a.run.app/bookmarks?user_id

    String url = '$baseUrl?user_id=$userId';

    final response = await httpGet(Uri.parse(url));

    if (response.statusCode == 200) {
      Iterable body = jsonDecode(response.body);
      return List.from(body.map((e) => Bookmark.fromJson(e)));
    }
    return List.empty();
  }
}
