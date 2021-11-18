import 'dart:convert';

import 'package:chat_socket_getx/model/answer.dart';
import 'package:chat_socket_getx/model/user.dart';

List<Question> listQuestionFromJson(String response) {
  final jsonData = json.decode(response);
  final data = jsonData["data"];
  return new List<Question>.from(data.map((x) => Question.fromJson(x)));
}

Question getDetailQuestion(String response){
  final jsonData = json.decode(response);
  final data = jsonData["data"];
  return Question.fromJson(data);
}

class Question{
  int id;
  String date;
  String question;
  int comment;
  User user;
  List<Answer>list;

  Question({
   this.id,
   this.date,
   this.question,
   this.comment,
   this.user,
    this.list
  });

  factory Question.fromJson(Map<String,dynamic>json)=>Question(
    id: json["id"],
    user: User.fromJson(json["user"]),
    date: json["date"],
    question: json["title"],
    comment: json["answer"].length,
    list: json["answer"]!=null?listAnswerFromJson(json["answer"]):[]
  );

}