import 'package:avatar_letter/avatar_letter.dart';
import 'package:chat_socket_getx/helper/utils.dart';
import 'package:chat_socket_getx/model/question.dart';
import 'package:chat_socket_getx/ui/forum/detail_question/detail_question_controller.dart';
import 'package:chat_socket_getx/widgets/detail_question_loading.dart';
import 'package:chat_socket_getx/widgets/row_answer.dart';
import 'package:chat_socket_getx/widgets/list_loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';

class DetailQuestionScreen extends StatefulWidget {
  @override
  _DetailQuestionScreenState createState() => _DetailQuestionScreenState();
}

class _DetailQuestionScreenState extends State<DetailQuestionScreen> {
  DetailQuestionController controller=Get.find<DetailQuestionController>();
  Future<void>refresh()async{
    controller.getAnswer(question_id);
    return null;
  }
  ///mmendapatkan parameter dari GetX Navigation
  int question_id=Get.arguments["question_id"];

  @override
  void initState() {
    controller.getcrendential();
    controller.getAnswer(question_id);
    controller.connectSocket();

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: ()=>Get.back(),
          child: Icon(Icons.arrow_back_ios,color: Colors.white,),
        ),
        titleSpacing: 0.1,
        title: Text("Question"),
      ),
      //get builder untuk listen  Update UI ketika ada perubahan nilai di GetXController
      body: GetBuilder<DetailQuestionController>(
        init: DetailQuestionController(),
        builder: (value){
          ///bisa akses variable DetailQuestionController
          ///dari parameter value atau juga dari controller langsung bisa.
          if(value.isLoading==true){
            return DetailQuestionLoading();
          }else{
            return _buildUIDetailQuestion();
          }
        },

      ),
    );
  }

  Widget _buildUIDetailQuestion(){
    return Column(
      children: [
        _buildList(),
        _buildComment()
      ],
    );
  }

  Widget _buildComment(){
   return InkWell(
     onTap: (){
       controller.showWritePost(context,question_id);
     },
     child: Container(
       decoration: BoxDecoration(
           boxShadow: [
             new BoxShadow(
               color: Colors.black38,
               blurRadius: 2.0,
             ),
           ],
           color: Colors.white
       ),
       child: Padding(
         padding: const EdgeInsets.all(5.0),
         child: Row(
           mainAxisAlignment: MainAxisAlignment.start,
           crossAxisAlignment: CrossAxisAlignment.center,
           children: [
             AvatarLetter(
               size: 31,
               fontSize: 14,
               backgroundColor: Colors.red,
               textColor: Colors.white,
               upperCase: true,
               letterType: LetterType.Circular,
               text: controller.userCredential["name"],
               fontFamily: "Roboto",
             ),
             SizedBox(width: 6,),
             Expanded(
               child: Container(
                 padding: EdgeInsets.only(left: 10),
                 margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                 decoration: BoxDecoration(
                   color: Colors.grey[400],
                   // color: Color.fromARGB(58, 255, 255, 255),
                   borderRadius: BorderRadius.all(Radius.circular(20.0)),
                 ),
                 child: TextField(
                   onTap: (){
                   },
                   enabled: false,
                   textInputAction: TextInputAction.done,
                   onSubmitted: (String terms) {
                   },
                   decoration: InputDecoration(
                       isDense: true,
                       border: InputBorder.none,
                       hintText: "Tulis Jawaban",
                       hintStyle: TextStyle(color: Colors.white),
                       icon: Icon(
                         Icons.edit_outlined,
                         color: Colors.white,
                       )),
                 ),
               ),
             )
           ],
         ),
       ),
     ),
   );
  }

  Widget _buildQuestionSection(){
    return Material(
      elevation: 1,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AvatarLetter(
                    size: 31,
                    fontSize: 14,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    upperCase: true,
                    letterType: LetterType.Circular,
                    text: controller.question.user.name,
                    fontFamily: "Roboto",
                  ),
                  SizedBox(width: 6,),
                  Expanded(child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(controller.question.user.name,style: TextStyle(fontWeight: FontWeight.bold,fontFamily: "Roboto"),),
                        SizedBox(height: 4,),
                        Text(Utils().getDiff(controller.question.date),style: TextStyle(color: Colors.black45,fontFamily: "Roboto",fontSize: 12),)
                      ],
                    ),
                  ))
                ],
              ),
            ),
            SizedBox(height: 6,),
            Divider(),
            SizedBox(height: 6,),
            HtmlWidget(controller.question.question),
            SizedBox(height: 6,),
          ],
        ),
      ),
    );
  }

  Widget _buildList(){
    return Expanded(
      child: RefreshIndicator(
        onRefresh: refresh,
        child: ListView(
          children: [
            _buildQuestionSection(),
            SizedBox(height: 20,),
            controller.question.list.isNotEmpty?Material(
              elevation: 1,
              child: Container(
                padding: EdgeInsets.all(10),
                color: Colors.white,
                child:Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(controller.question.list.length.toString()+" Answer",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,fontFamily: "Roboto"),),
                    SizedBox(height: 4,),
                    Divider(),
                    SizedBox(height: 6,),
                    ListView.separated(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                        itemBuilder: (c,i)=>RowAnswer(answer: controller.question.list[i],),
                        separatorBuilder: (x,y)=>Divider(),
                        itemCount: controller.question.list.length)
                  ],
                ),
              ),
            ):Container()
          ],
        ),
      ),
    );
  }


}
