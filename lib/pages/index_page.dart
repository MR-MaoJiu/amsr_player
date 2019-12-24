import 'dart:convert';
import 'package:amsr_player/config/api.dart';
import 'package:amsr_player/widgets/music_widget.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:toast/toast.dart';


class IndexPage extends StatefulWidget {
  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  DateTime lastPopTime; //上次点击时间
  bool isSearch=false;
  TextEditingController _textEditingController = TextEditingController();
  AudioPlayer audioPlayer = AudioPlayer();
  String  jsonstr="";
  var listitem=[];
  var image="https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1576959164417&di=8aa461cb27074b046fc5622452bb1c5a&imgtype=0&src=http%3A%2F%2Fi0.hdslb.com%2Fbfs%2Farchive%2Ff1d4300c18a8457a9e062ab28ad8636789af28e7.jpg", title="共享AMSR播放器", subtitle="点击列表播放";
  var val=0.0;
  var url="";
  bool isplay=false;
  Duration istime;
  final List<String> piclist = [
    "http://yuanwanji.club/image/lbt1.jpg",
    "http://yuanwanji.club/image/lbt2.jpg",
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    audioPlayer.pause();
    audioPlayer.dispose();
  }
  @override
  Widget build(BuildContext context) {

    return WillPopScope(
        onWillPop: () async {
          if (lastPopTime == null ||
              DateTime.now().difference(lastPopTime) > Duration(seconds: 1)) {
            //两次点击间隔超过1秒则重新计时
            Toast.show("再按一次退出", context);
            lastPopTime = DateTime.now();
            return new Future.value(false);
          }
          audioPlayer.pause();
          audioPlayer.dispose();
          return new Future.value(true);
        },
        child:Scaffold(
      drawer:  Drawer(child:  ListView(
        children: <Widget>[
           UserAccountsDrawerHeader(   //Material内置控件
//            accountName:  Text('CYC'), //用户名
//            accountEmail:  Text('example@126.com'),  //用户邮箱
//            currentAccountPicture:  GestureDetector( //用户头像
//              onTap: () => print('current user'),
//              child:  CircleAvatar(    //圆形图标控件
//                backgroundImage:  NetworkImage('https://upload.jianshu.io/users/upload_avatars/7700793/dbcf94ba-9e63-4fcf-aa77-361644dd5a87?imageMogr2/auto-orient/strip|imageView2/1/w/240/h/240'),//图片调取自网络
//              ),
//            ),

            decoration:  BoxDecoration(
              //用一个BoxDecoration装饰器提供背景图片
              image:  DecorationImage(
                fit: BoxFit.fill,
                 image:  NetworkImage('https://www.semorn.com/wp-content/uploads/2017/03/ppomoasmr-430x230.jpg')

              ),
            ),
          ),

           ListTile(
            leading: Icon(Icons.settings),//第二个功能项
              title:  Text('设置'),
              trailing:  Icon(Icons.arrow_right),
              onTap: () {
               //设置页面
              }
          ),
           Divider(),    //分割线控件
           ListTile(
            leading: Icon(Icons.clear),//退出按钮
            title:  Text('关闭'),
            trailing:  Icon(Icons.cancel),
            onTap: () => Navigator.of(context).pop(),   //点击后收起侧边栏
          ),
        ],
      ),),
      appBar: AppBar(
        title: Text("共享ASMR播放器"),
        centerTitle: true,actions: <Widget>[
        IconButton(
            icon:Icon(Icons.search),
            onPressed: (){
              setState(() {
                isSearch?isSearch=false:isSearch=true;
                //isSearch?FocusScope.of(context).requestFocus(_commentFocus):_commentFocus.unfocus();

              });

            }
        ),
    ],),
          body: Column(children: <Widget>[
            isSearch?
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: TextField(
                    cursorColor: Colors.pinkAccent, // 光标颜色
                    controller: _textEditingController,
                    // 默认设置
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
                        border: InputBorder.none,
                        icon: Icon(Icons.label_outline),
                        hintText: "输入标签",
                        hintStyle: new TextStyle(
                            fontSize: 14, color: Color.fromARGB(50, 0, 0, 0))),
                    style: new TextStyle(fontSize: 14, color: Colors.pink),
                  ),
                ),
                InkWell(
                  child: Container(
                    alignment: Alignment.center,
                    child: Icon(Icons.search,size: 25.5,color: Colors.pink),
                  ),
                  onTap: (){
                    _search();
                  },
                ),
              ],
            ) :Container(child: Container(
            width: MediaQuery.of(context).size.width,
            height: 200.0,
            child: Swiper(
            itemBuilder: _swiperBuilder,
            itemCount: piclist.length,
            pagination: new SwiperPagination(
            builder: DotSwiperPaginationBuilder(
            color: Colors.black54,
            activeColor: Colors.pinkAccent,
            )),
            scrollDirection: Axis.horizontal,
            autoplay: true,
            onTap: (index) => print('点击了第$index个'),
    )),
    ),
            Expanded(
              flex: 6,
              child: ListView.builder(
              //列表数量
              itemCount:listitem.length>0?listitem.length:0 ,
              //动态生成
              itemBuilder: (context, index) {
                return Column(children: <Widget>[
                  ListTile(leading:Image.network(listitem[index]["image"]),title: Text(listitem[index]["title"]),subtitle: Text(listitem[index]["subtitle"]),onTap: (){
                    play(index,listitem.length,context);
                  },),
                  Divider(),
                ],);
              },

            ),),
           Expanded(flex: 1,child: musicCard(image, title, subtitle,url,val,audioPlayer,isplay,istime),)

          ],),));
  }
  void _search() {
    setState(() {
      print("提交数据："+_textEditingController.text.toString());
      _textEditingController.text = '';
      isSearch=false;
    });
  }

  getdata() async {
    //获取数据
    if(mounted) {
      Dio dio = new Dio();
      Response response = await dio.get(getDataAPI);
      setState(() {
        jsonstr = response.data.toString();
        listitem=json.decode(jsonstr);
        print(jsonstr);
      });
    }
  }
  play(index,all,context) async {
    setState(() {
      isplay=true;
    });
    try {
       url=listitem[index]["url"];
      setState(() {
        title=listitem[index]["title"];
        subtitle=listitem[index]["subtitle"];
        image=listitem[index]["image"];
      });

      await audioPlayer.pause();
      int result = await audioPlayer.play(url,isLocal: true);
      if (result == 1) {
        // success
        print('播放成功');
        Duration time;
        //Toast.show("播放音频:$title", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
         audioPlayer.onDurationChanged.listen((Duration d){
           setState(() {
             time=d;
           });
         });

        audioPlayer.onAudioPositionChanged.listen((Duration  p) {
            setState(() {

              istime=p;
              val=double.parse((p.inSeconds/time.inSeconds).toString());
              if(val==1.0)
                {
                  if(index<all)
                  {
                    play(index+1,all,context);
                  }
                  else
                  {
                    index=0;
                    play(index,all,context);
                  }
                }
            });
    });
        audioPlayer.onPlayerStateChanged.listen((AudioPlayerState s) {
        print('当前状态: $s');
        if(s==AudioPlayerState.COMPLETED)
          {

            if(index<all)
            {
              play(index+1,all,context);
            }
            else
            {
              index=0;
              play(index,all,context);
            }
          }
        if(s==AudioPlayerState.PLAYING)
          {
            setState(() {
              isplay=true;
            });
          }
        else if(s==AudioPlayerState.STOPPED)
          {
            setState(() {
              isplay=false;
            });
          }
    });
//        audioPlayer.onPlayerCompletion.listen((event) {
//          if(index<all)
//          {
//            play(index+1,all,context);
//          }
//          else
//          {
//            index=0;
//            play(index,all,context);
//          }
//        });
      } else {
        print('播放失败');
        if(index<all)
        {
          play(index+1,all,context);
        }
        else
        {
          index=0;
          play(index,all,context);
        }
      }
      
    }catch(e)
    {
      print('播放异常$e');
      if(index<all)
      {
        play(index+1,all,context);
      }
      else
      {
        index=0;
        play(index,all,context);
      }
    }
   
  }
   pause() async {
    int result = await audioPlayer.pause();
    if (result == 1) {
      // success
      print('停止播放成功');
    } else {
      print('停止播放失败');
    }
  }
  Widget _swiperBuilder(BuildContext context, int index) {
    return (Image.network(
      piclist[index],
      fit: BoxFit.fill,
    ));
  }
}

