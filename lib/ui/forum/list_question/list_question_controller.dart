import 'dart:convert';

import 'package:chat_socket_getx/helper/server.dart';
import 'package:chat_socket_getx/helper/user_preference.dart';
import 'package:chat_socket_getx/model/question.dart';
import 'package:chat_socket_getx/repository/forum_repository.dart';
import 'package:chat_socket_getx/routes.dart';
import 'package:chat_socket_getx/widgets/write_post.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:get/get.dart';

class ListQuestionController extends GetxController{
  IO.Socket socket = IO.io(Server().url_api,<String, dynamic>{
  'transports': ['websocket']});
  List<Question>list = new List<Question>();
  bool isLoading=true;
  Map<String,dynamic>userCredential = new Map<String,dynamic>();
  List<dynamic>online_user=new List<dynamic>();

  void getcrendential()async{
    userCredential=await UserPreference.getCredentialUser();
    socket.emit("online_users",{
      "id":userCredential["id"],
      "name":userCredential["name"]
    });
    print("user credential "+userCredential.toString());
  }

  void logout(){
    ///emit offline untuk delete sambungan user di server
    socket.emit("offline_users",{
      "id":userCredential["id"],
      "name":userCredential["name"]
    });
    ///hapus session dan hentikan service kemudian pindah ke halaman splash
    UserPreference.deleteCredentiallUser().then((value){
      Get.reset();
      Get.offAllNamed(RouterGenerator.routeSplash);
    });
  }

  ///connect ke socket server pada API
  void connectSocket(){
    socket.onConnect((_) {
      print('connect');
      socket.emit('test', 'test');
    });

    socket.on("question", (var data){
      print("value socket io"+data["data"].toString());
      list.insert(0,Question.fromJson(data["data"]));
      update();
    });

    socket.on("online_users", (data){
       print("online users "+data.toString());
       online_user=data;
       update(["online_users"]);
     }
    );

    ///mendetksi event disconnect
    socket.onDisconnect((data){
      print("disconnect ");
    });
    socket.connect();
  }

  void sendToSocket(String html){
    final f = new DateFormat('yyyy-MM-dd');
    Map<String,dynamic>socketPayload=new Map<String,dynamic>();
    socketPayload={
      "notification": userCredential["name"]+" sending question",
      "data":{
        "title":html,
        "date":f.format(DateTime.now()),
        "user_id":userCredential["id"],
      }
    };
    socket.emit("question",socketPayload);
  }


  void getQuestion(){
    isLoading=true;
    update();
    ForumRepository().getQuestion().then((value){
      list=value;
      isLoading=false;
      update();
    }).catchError((err,track){
      print("kesalahan "+err.toString());
      print("kesalahan "+track.toString());
      Get.snackbar("Pesan","Terjadi kesalahan pada server",snackPosition: SnackPosition.BOTTOM);
    });
  }

  void showWritePost(BuildContext context){
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
            title: "Write Question",
            onCancel: (){
              Navigator.of(context).pop();
            },
            onFinish: (String html){
              sendToSocket(html);
              Navigator.of(context).pop();
            },
          );
        }
    );
  }

}