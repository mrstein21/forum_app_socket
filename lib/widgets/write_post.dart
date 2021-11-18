import 'dart:convert';

import 'package:chat_socket_getx/repository/forum_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:progress_dialog/progress_dialog.dart';

class WritePost extends StatefulWidget {
  Function(String html)onFinish;
  Function()onCancel;
  String title;

  WritePost({
    this.title,
    this.onCancel,
    this.onFinish
  });

  @override
  _WritePostState createState() => _WritePostState();
}

class _WritePostState extends State<WritePost> {
  HtmlEditorController controller = HtmlEditorController();
  ProgressDialog progressDialog;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    progressDialog=new ProgressDialog(context);
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: (){
            widget.onCancel();
          },
          child: Icon(Icons.close,color: Colors.white,),
        ),
        actions: [
          InkWell(
            onTap: ()async{
              final txt = await controller.getText();
              widget.onFinish(txt);
            },
            child: Icon(Icons.send,color: Colors.white,),
          ),
          SizedBox(width: 5,)
        ],
        title: Text(widget.title),),
      body: HtmlEditor(
        htmlToolbarOptions: HtmlToolbarOptions(
          toolbarType: ToolbarType.nativeScrollable,
          defaultToolbarButtons: [
            StyleButtons(),
            ColorButtons(),
            ListButtons(),
            ParagraphButtons(),
            InsertButtons(),
          ],
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
                String url=result["url"];
                controller.insertNetworkImage(url);
              });
            });
          }
        ),
      ),
    );
  }
}
