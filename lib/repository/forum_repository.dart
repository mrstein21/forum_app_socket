import 'package:chat_socket_getx/helper/server.dart';
import 'package:chat_socket_getx/helper/user_preference.dart';
import 'package:chat_socket_getx/model/answer.dart';
import 'package:chat_socket_getx/model/question.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ForumRepository {
  Future<List<Question>> getQuestion() async {
    var userSession = await UserPreference.getCredentialUser();
    var response = await http.get(
        Uri.parse(Server().url_api + "/forum/question"), headers: {
      "Authorization": "Bearer " + userSession["token"]
    });
    print("response question " + response.body);
    if (response.statusCode == 200) {
      return compute(listQuestionFromJson, response.body);
    } else {
      throw Exception();
    }
  }


  Future<List<Question>> getYourQuestion() async {
    var userSession = await UserPreference.getCredentialUser();
    var response = await http.post(
        Uri.parse(Server().url_api + "/forum/question"), body: {
      "user_id": userSession["id"]
    }, headers: {
      "Authorization": "Bearer " + userSession["token"]
    });
    print("response your question " + response.body);
    if (response.statusCode == 200) {
      return compute(listQuestionFromJson, response.body);
    } else {
      throw Exception();
    }
  }

  Future<Question> getAnswer(int id) async {
    var userSession = await UserPreference.getCredentialUser();
    var response = await http.get(
        Uri.parse(Server().url_api + "/forum/question/answer/" + id.toString()),
        headers: {
          "Authorization": "Bearer " + userSession["token"]
        });
    print("response answer " + response.body);
    if (response.statusCode == 200) {
      return compute(getDetailQuestion, response.body);
    } else {
      throw Exception();
    }
  }

  Future<String> uploadFile(String base64) async {
    var userSession = await UserPreference.getCredentialUser();
    var response = await http.post(
        Uri.parse(Server().url_api + "/upload"),
        headers: {
          "Authorization": "Bearer " + userSession["token"]
        },
      body: {
          "image":base64
      }
    );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception();
    }
  }

}

