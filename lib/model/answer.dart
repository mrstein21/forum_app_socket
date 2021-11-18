import 'dart:convert';

import 'package:chat_socket_getx/model/user.dart';
List<Answer> listAnswerFromJson(var data) {
  return new List<Answer>.from(data.map((x) => Answer.fromJson(x)));
}

class Answer{
  int question_id;
  int id;
  String answer;
  String date;
  User user;

  Answer({
    this.question_id,
    this.id,
    this.answer,
    this.date,
    this.user
  });

  factory Answer.fromJson(Map<String,dynamic>json)=>Answer(
      question_id: json["question_id"],
      id:  json["id"],
      date: json["date"],
      answer: json["answer"],
      user: json["user"]!=null? User.fromJson(json["user"]):null
  );

}