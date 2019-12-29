import 'dart:ui';
import 'package:amsr_player/config/api.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
class PlayerPage extends StatefulWidget {
  final List listitem;
  final int index;
  PlayerPage({Key key, this.listitem,  this.index, }) : super(key: key);
  @override
  _PlayerPageState createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  List listitem;
  int index;
  var value=0.0;
  AudioPlayer audioPlayer = new AudioPlayer();
  bool isPlaying = true;
  Duration duration;
  Duration position;
  double sliderValue;
  AudioPlayerState palyerState;
  dynamic listener1,listener2,listener3;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listitem=widget.listitem;
    index=widget.index;
    playThisMusic();
    listener1 = audioPlayer.onDurationChanged.listen((Duration d) {
      // print('Max duration: $d');
      setState(() => duration = d);
      if (position != null) {
        this.sliderValue = (position.inSeconds / duration.inSeconds);
      }
    });
    listener2 = audioPlayer.onAudioPositionChanged.listen((Duration  p){
       //print("Current position: $p");
      setState(() => position = p);
      if (duration != null) {
        setState(() {
          this.sliderValue = (position.inSeconds / duration.inSeconds);
          //print("$sliderValue");
        });

      }
    });
    listener3 = audioPlayer.onPlayerStateChanged.listen((AudioPlayerState s){
       //print("Current player state: $s");
      //播放
      if (s.toString().split('.')[1] == 'PLAYING') {
        setState(() {
          isPlaying = true;
        });
        return;
      }
      //暂停
      if (s.toString().split('.')[1] == 'PAUSED') {
        setState(() {
          isPlaying = false;
        });
        return;
      }
      //完成
      if(s.toString().split('.')[1] == 'COMPLETED'){
        setState(() {
          isPlaying = false;
          onNext();
        });
        return;
      }
    });
  }
  @override
  void  dispose() {
    listener1.cancel();
    listener2.cancel();
    listener3.cancel();
    audioPlayer.release();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text(listitem[index]["title"]),centerTitle: true,),
      body: Column(children: <Widget>[
        //播放模块
        Expanded(flex: 4,
          child:Stack(
              children: <Widget>[
                 Container(
                  decoration:  BoxDecoration(
                    image:  DecorationImage(
                      image:  NetworkImage(listitem[index]["imageurl"]),
                      fit: BoxFit.cover,
                      colorFilter:  ColorFilter.mode(
                        Colors.black54,
                        BlendMode.overlay,
                      ),
                    ),
                  ),
                ),
                 Container(
                    child:  BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                      child: Opacity(
                        opacity: 0.1,
                        child:  Container(
                          decoration:  BoxDecoration(
                            color: Colors.grey.shade900,
                          ),
                        ),
                      ),
                    )),
                Container(
                  //当前音频详情
                  child: Column(mainAxisAlignment: MainAxisAlignment.center,children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 24,bottom: 24),
                      width: 150,
                      height: 150,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(
                            listitem[index]["imageurl"]
                        ),
                      ),


                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceAround,children: <Widget>[

                      IconButton(icon: Icon(Icons.skip_previous,size: 50,color: Colors.pinkAccent,),onPressed: (){
                        onPrevious();
                      },),
                      IconButton(icon: Icon(isPlaying?Icons.pause:Icons.stop,size: 50,color: Colors.pinkAccent,),onPressed: (){
                        stopThisMusic();
                      },),
                      IconButton(icon: Icon(Icons.skip_next,size: 50,color: Colors.pinkAccent,),onPressed: (){
                        onNext();
                      },),
                    ],),
                    Slider(
                      value: sliderValue ?? 0.0,
                      min: 0.0,
                      max: 1.0,
                      onChanged: (newValue) {
                        if (duration != null) {
                          int seconds = (duration.inSeconds * newValue).round();
                          //print("audioPlayer.seek: $seconds");
                          audioPlayer.seek(new Duration(seconds: seconds));
                        }
                      },
                    ),
                  ],
                  ),
                ),
              ]),
        ),
        //简介模块
        Expanded(flex: 5,child: ListView(children: <Widget>[
          Container(
            color: Colors.white,
            child: ListTile(
              leading: Icon(
                Icons.block,
                color: Colors.red,),
              title: Text("违规AMSR音频举报"),
              subtitle: Text("维护良好环境，绝不姑息！！！"),
              trailing: IconButton(
                icon: Icon(Icons.navigate_next,color: Colors.blueAccent,),),onTap: (){
              inform();
            },),),
          Container(
            color: Colors.white,
            child: ListTile(
              leading: Icon(
                Icons.label_outline,
                color: Colors.teal,),
              title: Text("ASMR标签"),
              subtitle: Text(listitem[index]["label"]),
            ),),
          Container(
            color: Colors.white,
            child: ListTile(
              leading: Icon(
                Icons.person,
                color: Colors.blueAccent,),
              title: Text("ASMR作者"),
              subtitle: Text(listitem[index]["subtitle"]),
            ),),
          //Text("再次声明：所有音频都来自网络，本程序是由一位绿色AMSR爱好者编写而成，本程序已在GitHub上开源，本程序是免费的无需登录的，并不存储任何音频包括用户上传的音频链接也来自网络，若上传违规音频链接被举报∂将会封禁手机，该手机将不能上传任何音频链接！！！若侵权请点击举报我们会第一时间删除该音频！！！给您带来的不便还请谅解！！！")
        ],),),
      ],),
      );
  }
  //ASMR播放控制方法

stopThisMusic() {
  if (isPlaying) {
    audioPlayer.pause();
  } else {
    audioPlayer.resume();
  }
}

playThisMusic() {
  audioPlayer.play(
      listitem[index]["asmrurl"]
  );
}
  void deactivate() {
    audioPlayer.stop();
    super.deactivate();
  }
void onPrevious()
{

  if(index>0)
    {
      index--;
      print(index);
      audioPlayer.play(
          listitem[index]["asmrurl"]
      );
    }else{
    index=listitem.length-1;
    print(index);
    audioPlayer.play(
        listitem[index]["asmrurl"]
    );
  }
}
void onNext()
{

  if(index<listitem.length-1)
    {
      index++;
      print(index);
      audioPlayer.play(
          listitem[index]["asmrurl"]
      );
    }
  else
    {
      index=0;
      print(index);
      audioPlayer.play(
          listitem[index]["asmrurl"]
      );
    }
}
//举报
  inform() async {
    FormData formData = new FormData.fromMap({
      "id":listitem[index]["id"],
      "inform":true
    });
    //获取数据
    if(mounted) {
      Dio dio = new Dio();
      dio.options.contentType = "application/x-www-data-urlencoded";
      Response response = await dio.post(informAPI,data: formData,);
      setState(() {
        if(response.data.toString()=="1")
        {
          Toast.show("举报成功刷新后该音频将被屏蔽！维护环境义不容辞！", context);
        }
        else{
          Toast.show("举报失败请重试！", context);
        }

      });
    }
  }

}
