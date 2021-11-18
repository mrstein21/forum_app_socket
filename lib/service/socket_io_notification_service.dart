import 'package:chat_socket_getx/helper/server.dart';
import 'package:chat_socket_getx/helper/utils.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

/// class untuk notifikasi Socket IO yang nantinya dijalankan Getx Service
class SocketIONotificationService extends GetxService{

  ///inisiasi alamat socket
  IO.Socket socket = IO.io(Server().url_api,<String, dynamic>{
    'transports': ['websocket']});


  Future onSelectNotification(String payload) async {
    print("selected notification ? "+payload);
  }

  Future<void> init(){
    print("starting service....");


    socket.on("question", (var data){
      print("terdeteksi question");
    ///data socket
    ///disni tipe data yang dikirimnya dari server yaitu Map<String,dynamic>

    });

    socket.on("notification", (var data){
      print("terdeteksi answer");
      ///data socket
      ///disni tipe data yang dikirimnya dari server yaitu Map<String,dynamic>
    });

    socket.connect();
  }
}