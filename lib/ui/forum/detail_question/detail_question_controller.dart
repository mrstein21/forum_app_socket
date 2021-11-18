import 'package:chat_socket_getx/helper/server.dart';
import 'package:chat_socket_getx/helper/user_preference.dart';
import 'package:chat_socket_getx/model/answer.dart';
import 'package:chat_socket_getx/model/question.dart';
import 'package:chat_socket_getx/repository/forum_repository.dart';
import 'package:chat_socket_getx/widgets/write_post.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class DetailQuestionController extends GetxController{
  IO.Socket socket = IO.io(Server().url_api,<String, dynamic>{
    'transports': ['websocket']});

  bool isLoading=true;
  Question question=new Question();

  Map<String,dynamic>userCredential = new Map<String,dynamic>();

  void getcrendential()async{
    userCredential=await UserPreference.getCredentialUser();
  }



  void getAnswer(int question_id){
    isLoading=true;
    update();
    ForumRepository().getAnswer(question_id).then((value){
      question=value;
      isLoading=false;
      update();
    }).catchError((err,track){
         print("kesalahan "+err.toString());
        print("kesalahan "+track.toString());
       Get.snackbar("Pesan","Terjadi kesalahan pada server",snackPosition: SnackPosition.BOTTOM);
    });
  }


  ///connect ke socket server pada API
  void connectSocket(){
    socket.onConnect((_) {

    });

    socket.on("answer", (var data){
      Get.snackbar("Message", "News Answer !",backgroundColor: Colors.blue,colorText: Colors.white,snackPosition: SnackPosition.BOTTOM);
      question.list.insert(0,Answer.fromJson(data["data"]));
      update();
    });

    socket.onDisconnect((data){
      print("disconnect ");
    });
    socket.connect();
  }

  /// mengirim postingan lewat event answer pada  Socket...
  /// bisa juga mengirim postingan lewat API asalkan si server mengirim event question
  /// yang diperlukan untuk realtime socket  pada frontend itu adalah event socket dari servernya
  /// supaya bisa di listen/dideteksi di frontend jadi tidak masalah mau dikirim lewat socket
  /// atau API seperti biasa.
  void sendToSocket(String html,int question_id){
    final f = new DateFormat('yyyy-MM-dd');
    Map<String,dynamic>socketPayload=new Map<String,dynamic>();
    socketPayload={
      "notification": userCredential["name"]+" answer your question",
      "data":{
        "question_id":question_id.toString(),
        "user_id":userCredential["id"],
        "answer":html,
        "date":f.format(DateTime.now()),
      }
    };
    socket.emit("answer",socketPayload);
  }


  void showWritePost(BuildContext context,int question_id){
    showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: MaterialLocalizations.of(context)
            .modalBarrierDismissLabel,
        barrierColor: Colors.black45,
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder:  (BuildContext buildContext,
            Animation animation,
            Animation secondaryAnimation){
          return WritePost(
            title: "Tulis Jawaban",
            onCancel: (){
              Navigator.of(context).pop();
            },
            onFinish: (String html){
              print("hasil zefyr "+html);
              sendToSocket(html,question_id);
              Navigator.of(context).pop();
            },
          );
        }
    );
  }





}