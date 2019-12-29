
import 'dart:convert';
import 'dart:io';
import 'package:amsr_player/config/api.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:package_info/package_info.dart';

import 'package:path_provider/path_provider.dart';
import 'package:toast/toast.dart';
class IsUpgrade  {
  static double jd=0.0;
  static isUpgrade(context,isBack)
  async {
    Directory dir = await getExternalStorageDirectory();                            
    String  path = dir.path;
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version=packageInfo.version;
    print(version);
     Dio dio =Dio();
     Response response= await dio.post(IsUpgradeUrl);
     var data=json.decode(response.toString());
     print(data);
     if(data["version"] !=version)
     {
       showDialog(context:context, child:AlertDialog(
               title: Text("系统提示"),
               content: Column(mainAxisSize: MainAxisSize.min,
                 children: <Widget>[ Text(data["updatecontent"]),],),
               actions: <Widget>[
//                  FlatButton(
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                   child:  Text("取消"),
//                 ),
                 FlatButton(
                   onPressed: () async {
                     File f=File(path+"/app.apk");
                     var flg=await f.exists();
                     if(flg)
                       {
                         Toast.show("检查到本地已有安装包若并非最新安装包请删除！！！", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
                         OpenFile.open(path+"/app.apk");
                       }
                     else
                       {
                         if(jd<=0)
                         {
                           Toast.show("正在下载中，请耐心等待", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
                           Navigator.of(context).pop();
                           dio.download(data["url"], path+"/app.apk",onReceiveProgress: (int count, int total){
                             jd=count/total;
                             if(count==total)
                             {
                               jd=0.0;
                               OpenFile.open(path+"/app.apk");

                             }

                           });
                         }
                         else
                         {
                           Toast.show("正在下载中，请耐心等待", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
                           Navigator.of(context).pop();
                         }
                       }

                   },
                   child:  Text("立即更新"),
                 ),

               ],),);
     }
     else
     {
       if(!isBack)
       Toast.show("已是最新版本："+version, context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
     }

  }
//带标题环形进度条
 static Widget circularTextProgressIndicator(val,strokeWidth,backcolor,color,textcolor)
 {
   return Stack(  alignment: const Alignment(0.2, 0.2),
              children: <Widget>[CircularProgressIndicator(
            strokeWidth: strokeWidth,backgroundColor: val>0?backcolor:null,
            value: val,valueColor:  AlwaysStoppedAnimation<Color>(color),), 
          val>0?Text((val*100).toInt().toString()+"%",style: TextStyle(color: textcolor),):Text("")],);
 }

 }
 
