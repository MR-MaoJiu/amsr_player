import 'package:flutter/material.dart';
Widget musicCard(image,title,subtitle,url,val,audioPlayer,isplay,istime)
{

  return Container(color: Colors.white70,height: 50,
    child:ListTile(
    leading: CircleAvatar(backgroundImage: NetworkImage(image),),
    title: Text(title,overflow: TextOverflow.ellipsis,),
    trailing: Stack(alignment: Alignment.center,children: <Widget>[
      CircularProgressIndicator(
        strokeWidth: 4.0,
        backgroundColor: Colors.black26,
        value: val,
        valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),
      ),
      IconButton(icon:Icon(isplay?Icons.stop:Icons.keyboard_arrow_right,color: Colors.red,),onPressed: ()  async {
        try{
          if(isplay)
          {
            await audioPlayer.stop();

          }
          else
          {

           int res= await audioPlayer.seek(istime);
           await audioPlayer.play(url);
           print("$res<<<<<<<<<<<<<<<<<");
          }
        }catch(e)
        {
          print(e);
        }

      },)
    ],),
    subtitle: Text(subtitle,overflow: TextOverflow.ellipsis,),
  ),
  );
}
