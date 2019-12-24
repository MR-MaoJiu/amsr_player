import 'package:amsr_player/utils/UpGrade_util.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:toast/toast.dart';
class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  String _cacheSizeStr;
  double jdt = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('个人中心'),),
      body: SingleChildScrollView(
          child: Column(
            children: <Widget>[

              ListTile(
                leading: Icon(Icons.cloud_download),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('检查更新'),
                    //     Stack(  alignment: const Alignment(0.2, 0.2),
                    //     children: <Widget>[CircularProgressIndicator(
                    //   strokeWidth: 4.0,backgroundColor: jdt>0?Colors.blue:null,
                    //   value: jdt,valueColor:  AlwaysStoppedAnimation<Color>(Colors.red),),
                    // jdt>0?Text((jdt*100).toInt().toString()+"%",style: TextStyle(fontSize: 11,color: Colors.lightBlueAccent),):Text("")],)

                    IsUpgrade.circularTextProgressIndicator(
                        jdt, 4.0, Colors.blueAccent, Colors.pinkAccent,
                        Colors.blueAccent)
                  ],),
                trailing: Icon(Icons.keyboard_arrow_right),
                onTap: () {
                  IsUpgrade.isUpgrade(context,false);
                  Timer.periodic(Duration(seconds: 1), (timer) {
                    setState(() {
                      jdt = IsUpgrade.jd;
                    });

                    if (jdt == 0.9999) {
                      timer.cancel(); // 取消重复计时
                      return;
                    }
                  });
                },
              ),
              Divider(indent: 0.0, color: Colors.black54,),
              ListTile(
                  leading: Icon(Icons.delete),
                  title: Text('清空缓存'),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  onTap: () async {
                    try {
                      Directory tempDir = await getExternalStorageDirectory();
                      //删除缓存目录
                      //await delDir(tempDir);
                      await loadCache();
                      showDialog(context: context,
                          child: AlertDialog(title: Text("系统提示："),
                            content: Text("当前缓存为：" + _cacheSizeStr + "是否清空?"),
                            actions: <Widget>[ FlatButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text("取消"),
                            ), FlatButton(
                              onPressed: () {
                                delDir(tempDir);
                                Toast.show("清除缓存成功！", context,
                                    duration: Toast.LENGTH_SHORT,
                                    gravity: Toast.BOTTOM);
                                Navigator.of(context).pop();
                              },
                              child: Text("清除"),
                            ),
                            ],));
                    } catch (e) {
                      print(e);
                    } finally {
                      //此处隐藏加载loading
                    }
                  }),

              Divider(indent: 0.0, color: Colors.black54,),
            ],
          )
      ),
    );
  }

  ///递归方式删除目录
  Future<Null> delDir(FileSystemEntity file) async {
    try {
      if (file is Directory) {
        final List<FileSystemEntity> children = file.listSync();
        for (final FileSystemEntity child in children) {
          await delDir(child);
        }
      }
      await file.delete();
    } catch (e) {
      print(e);
    }
  }

  ///加载缓存
  Future<Null> loadCache() async {
    try {
      Directory tempDir = await getExternalStorageDirectory();
      double value = await _getTotalSizeOfFilesInDir(tempDir);
      /*tempDir.list(followLinks: false,recursive: true).listen((file){
          //打印每个缓存文件的路径
        print(file.path);
      });*/
      print('临时目录大小: ' + value.toString());
      setState(() {
        _cacheSizeStr = _renderSize(value);
      });
    } catch (err) {
      print(err);
    }
  }

  /// 递归方式 计算文件的大小
  Future<double> _getTotalSizeOfFilesInDir(final FileSystemEntity file) async {
    try {
      if (file is File) {
        int length = await file.length();
        return double.parse(length.toString());
      }
      if (file is Directory) {
        final List<FileSystemEntity> children = file.listSync();
        double total = 0;
        if (children != null)
          for (final FileSystemEntity child in children)
            total += await _getTotalSizeOfFilesInDir(child);
        return total;
      }
      return 0;
    } catch (e) {
      print(e);
      return 0;
    }
  }

  ///格式化文件大小
  _renderSize(double value) {
    if (null == value) {
      return 0;
    }
    List<String> unitArr = List()
      ..add('B')..add('K')..add('M')..add('G');
    int index = 0;
    while (value > 1024) {
      index++;
      value = value / 1024;
    }
    String size = value.toStringAsFixed(2);
    return size + unitArr[index];
  }
}