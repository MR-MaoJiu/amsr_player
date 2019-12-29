import 'dart:convert';
import 'package:amsr_player/config/api.dart';
import 'package:amsr_player/pages/add_asmr_page.dart';
import 'package:amsr_player/pages/player%E2%80%94%E2%80%94page.dart';
import 'package:amsr_player/pages/setting_page.dart';
import 'package:amsr_player/utils/UpGrade_util.dart';
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
  ScrollController _scrollController = new ScrollController();
  TextEditingController _textEditingController = TextEditingController();
  String  jsonstr="";
  var listitem=[];
  int  pageSize=10;
  int pageNum=1;
  var label="";
  bool isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getMoreData();
      }
    });
    super.initState();
    getdata(label);
    IsUpgrade.isUpgrade(context,true);

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController.dispose();
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
          return new Future.value(true);
        },
        child:Scaffold(
          floatingActionButton: FloatingActionButton(child: Icon(Icons.add),onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (contex)=>ADDASMRPage()));
          },),
        drawer:  Drawer(child:  ListView(
        children: <Widget>[
           UserAccountsDrawerHeader(   //Material内置控件

            decoration:  BoxDecoration(
              //用一个BoxDecoration装饰器提供背景图片
              image:  DecorationImage(
                fit: BoxFit.fill,
                 image:  NetworkImage('http://yuanwanji.club/image/lbt3.jpg')

              ),
            color: Colors.pinkAccent
            ),
          ),

           ListTile(
            leading: Icon(Icons.settings),//第二个功能项
              title:  Text('设置'),
              trailing:  Icon(Icons.arrow_right),
              onTap: () {
               //设置页面
                Navigator.of(context).push(MaterialPageRoute(builder: (contex)=>SettingPage()));
              }
          ),
          ListTile(
              leading: Icon(Icons.queue_music),//第二个功能项
              title:  Text('发布ASMR'),
              trailing:  Icon(Icons.arrow_right),
              onTap: () {
                //设置页面
                Navigator.of(context).push(MaterialPageRoute(builder: (contex)=>ADDASMRPage()));
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
                        hintText: "输入关键字进行模糊查询",
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
              child:
                RefreshIndicator(child:ListView.builder(
                  //列表数量
                  itemCount:listitem.length>0?listitem.length:0 ,
                  //动态生成
                  itemBuilder: (context, index) {
                    return Column(children: <Widget>[
                      ListTile(leading:Image.network(listitem[index]["imageurl"]),title: Text(listitem[index]["title"]),subtitle: Text(listitem[index]["subtitle"]),onTap: (){

                        Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (BuildContext buildContext)=>PlayerPage(
                                    listitem:listitem,index:index
                                   )));
                      },),
                      Divider(),
                    ],);
                  },
                  controller: _scrollController,
                ),onRefresh: _onRefresh,),
              ),
          ],),));
  }
  void _search() {
    setState(() {
      print("提交数据："+_textEditingController.text.toString());
      label=_textEditingController.text.toString();
      getdata(label);
      _textEditingController.text = '';
      isSearch=false;

    });
  }

  getdata(label) async {
    pageNum=1;
    FormData formData = new FormData.fromMap({
      "label": label,
      "pageNo":pageNum,
      "pageSize":pageSize
    });
    //获取数据
    if(mounted) {
      Dio dio = new Dio();
      dio.options.contentType = "application/x-www-data-urlencoded";
      Response response = await dio.post(getDataAPI,data: formData,);
      setState(() {
        jsonstr = response.data.toString();
        print(jsonstr);
        if(jsonstr!="-1")
          {
            setState(() {
              isLoading = false;
              listitem=json.decode(jsonstr);
            });

          }
        else{
          isLoading = false;
          listitem.clear();
          Toast.show("没有查询到相关数据", context);
        }


      });
    }
  }

  Widget _swiperBuilder(BuildContext context, int index) {
    return (Image.network(
      piclist[index],
      fit: BoxFit.fill,
    ));
  }
  //刷新
  Future<Null> _onRefresh()async
  {
    if (mounted) {
      setState(() {
        listitem.clear();
        getdata(label);
      });
    }
  }
  //加载更多
  void _getMoreData() async {

    pageNum += 1;
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });

      FormData formData = new FormData.fromMap({
        "label": label,
        "pageNo":pageNum,
        "pageSize":pageSize
      });
      //获取数据
      if(mounted) {
        Dio dio = new Dio();
        dio.options.contentType = "application/x-www-data-urlencoded";
        Response response = await dio.post(getDataAPI,data: formData,);
        setState(() {
          jsonstr = response.data.toString();
          print(jsonstr);
          if(jsonstr!="-1")
          {
            setState(() {
              isLoading = false;
              listitem.addAll(json.decode(jsonstr));
            });

          }
          else{
            isLoading = false;
            Toast.show("没有查询到相关数据", context);
          }


        });
      }
    }
  }

}

