import 'dart:convert';

import 'package:chat_socket_getx/repository/forum_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:progress_dialog/progress_dialog.dart';

class Test extends StatefulWidget {
  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  ProgressDialog progressDialog;
  HtmlEditorController controller = HtmlEditorController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: (){
          },
          child: Icon(Icons.close,color: Colors.white,),
        ),
        actions: [
          InkWell(
            onTap: ()async{
              final txt = await controller.getText();
            },
            child: Icon(Icons.send,color: Colors.white,),
          ),
          SizedBox(width: 5,)
        ],
        title: Text("Tulist"),),
      body: Container(
        height: double.infinity,
        child: HtmlEditor(
          htmlToolbarOptions: HtmlToolbarOptions(
            toolbarType: ToolbarType.nativeScrollable,
            defaultToolbarButtons: [
              StyleButtons(),
              ColorButtons(),
              ListButtons(),
              ParagraphButtons(),
              InsertButtons(),
            ],
            //by default
          ),
          htmlEditorOptions: HtmlEditorOptions(

          ),

          otherOptions: OtherOptions(
          ),
          controller: controller,
          callbacks: Callbacks(
              onPaste: (){

              },
              onImageUpload: (FileUpload file){
                progressDialog.style(message: "Loading...");
                progressDialog.show();
                ForumRepository().uploadFile(file.base64).then((value){
                  Future.delayed(Duration(seconds: 1)).then((_){
                    progressDialog.hide();
                    var result=json.decode(value);
                    print(result["url"]);
                    String url=result["url"];
                    controller.insertNetworkImage(url);
                  });
                });
              }
          ),
          // options: HtmlEditorOptions(
          // ),
        ),
      ),
    );
  }
}

