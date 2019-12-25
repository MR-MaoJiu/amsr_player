
import 'dart:convert';

import 'package:amsr_player/config/api.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
class ADDASMRPage extends StatefulWidget {
  @override
  _ADDASMRPageState createState() => _ADDASMRPageState();
}

class _ADDASMRPageState extends State<ADDASMRPage> {
  var  jsonstr="";
  var listitem=[];
  TextEditingController imgUrlController=TextEditingController();
  TextEditingController titleController=TextEditingController();
  TextEditingController subTitleController=TextEditingController();
  TextEditingController amsrurlController=TextEditingController();
  TextEditingController labelController=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("发布ASMR"),centerTitle: true,),
      body:ListView(children: <Widget>[
        Column(children: <Widget>[
          Padding(padding: EdgeInsets.fromLTRB(32, 80, 32, 16),child: TextField(
            controller: imgUrlController,
            decoration: InputDecoration(
                fillColor: Colors.blue.shade100,
                filled: true,
                prefixIcon: Icon(Icons.image),
                suffixText: '请输入asmr图片链接'),
          ),),
          Padding(padding: EdgeInsets.fromLTRB(32, 8, 32, 16),child: TextField(
            controller: titleController,
            decoration: InputDecoration(
                fillColor: Colors.blue.shade100,
                filled: true,
                prefixIcon: Icon(Icons.music_note),
                suffixText: '请输入asmr标题'),
          ),),
          Padding(padding: EdgeInsets.fromLTRB(32, 8, 32, 16),child: TextField(
            controller: subTitleController,
            decoration: InputDecoration(
                fillColor: Colors.blue.shade100,
                filled: true,
                prefixIcon: Icon(Icons.person),
                suffixText: '请输入asmr作者'),
          ),),
          Padding(padding: EdgeInsets.fromLTRB(32, 8, 32, 16),child: TextField(
            controller: amsrurlController,
            decoration: InputDecoration(
                fillColor: Colors.blue.shade100,
                filled: true,
                prefixIcon: Icon(Icons.language),
                suffixText: '请输入asmr音频链接'),
          ),),
          Padding(padding: EdgeInsets.fromLTRB(32, 8, 32, 16),child: TextField(
            controller: labelController,
            decoration: InputDecoration(
                fillColor: Colors.blue.shade100,
                filled: true,
                prefixIcon: Icon(Icons.label_outline),
                suffixText: '请输入asmr标签'),
          ),),
          Container(width: 500,padding: EdgeInsets.fromLTRB(32, 8, 32, 16),
              child: RaisedButton(
                color: Colors.pinkAccent,
                child:Text("发布ASMR",
                  style: TextStyle(color: Colors.white),) ,
                onPressed: (){
                  var img=imgUrlController.text.toString();
                  var title=titleController.text.toString();
                  var sub=subTitleController.text.toString();
                  var asmr=amsrurlController.text.toString();
                  var lab=labelController.text.toString();
                  if(img==""||title==""||sub==""||asmr==""||lab=="")
                    {
                      Toast.show("发布的数据不能为空", context);
                      print(img);
                    }
                  else{
                    getdata(img,title,sub,asmr,lab);

                  }

                },)),
        ],)
      ],) ,);
  }
  getdata(imageurl,title,subtitle,asmrurl,label) async {
    print(label);
    FormData formData = new FormData.fromMap({
      "imageurl":imageurl,
      "title":title,
      "subtitle":subtitle,
      "asmrurl":asmrurl,
      "label": label,
    });
    //获取数据
    if(mounted) {
      Dio dio = new Dio();
      dio.options.contentType = "application/x-www-data-urlencoded";
      Response response = await dio.post(userPush,data: formData,);
      setState(() {
        jsonstr = response.data.toString();
        print(">>>>>>>>>>>"+jsonstr);
        if(jsonstr=="1")
          {
            Toast.show("发布成功", context);
            imgUrlController.text="";
            titleController.text="";
            subTitleController.text="";
            amsrurlController.text="";
            labelController.text="";
          }
       else{
          Toast.show("发布失败", context);
        }

      });
    }
  }
}
