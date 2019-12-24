
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
class ADDASMRPage extends StatefulWidget {
  @override
  _ADDASMRPageState createState() => _ADDASMRPageState();
}

class _ADDASMRPageState extends State<ADDASMRPage> {
  TextEditingController imgUrlController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("发布ASMR"),centerTitle: true,),
      body:ListView(children: <Widget>[
        Column(children: <Widget>[
          Padding(padding: EdgeInsets.fromLTRB(32, 80, 32, 16),child: TextField(
            decoration: InputDecoration(
                fillColor: Colors.blue.shade100,
                filled: true,
                prefixIcon: Icon(Icons.image),
                suffixText: '请输入asmr图片链接'),
          ),),
          Padding(padding: EdgeInsets.fromLTRB(32, 8, 32, 16),child: TextField(
            decoration: InputDecoration(
                fillColor: Colors.blue.shade100,
                filled: true,
                prefixIcon: Icon(Icons.music_note),
                suffixText: '请输入asmr标题'),
          ),),
          Padding(padding: EdgeInsets.fromLTRB(32, 8, 32, 16),child: TextField(
            decoration: InputDecoration(
                fillColor: Colors.blue.shade100,
                filled: true,
                prefixIcon: Icon(Icons.person),
                suffixText: '请输入asmr作者'),
          ),),
          Padding(padding: EdgeInsets.fromLTRB(32, 8, 32, 16),child: TextField(
            decoration: InputDecoration(
                fillColor: Colors.blue.shade100,
                filled: true,
                prefixIcon: Icon(Icons.language),
                suffixText: '请输入asmr音频链接'),
          ),),
          Padding(padding: EdgeInsets.fromLTRB(32, 8, 32, 16),child: TextField(
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
                  Toast.show("等待更新",context);
                },)),
        ],)
      ],) ,);
  }
}
