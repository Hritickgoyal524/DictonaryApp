import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:http/http.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
       
        primarySwatch: Colors.blue,
       
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {


  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String url="https://owlbot.info/api/v4/dictionary/";
  String token="401a34a0f5a71f3b219f2443125e4d9b7562f2e1";
  TextEditingController _textEditingController= TextEditingController();
  StreamController _streamController;
  Stream _stream;
  _search()async{
if(_textEditingController.text==null||_textEditingController.text.length==0){
  _streamController.add(null);
  return ;
}
_streamController.add("waiting");
   Response response=await http.get(url+_textEditingController.text.trim(),headers: {"Authorization":"Token "+token});
  if(response.statusCode==200){
   _streamController.add(json.decode(response.body));
  }
  else{
    _streamController.add("wronginput");
  }}
  void initState(){
    _streamController=StreamController();
    _stream=_streamController.stream;
    super.initState();
  }
@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black38,
        title:Container(
          alignment: Alignment.center,
          child: Text("My Dictionary App",style: TextStyle(fontSize:19,fontWeight:FontWeight.w600,color: Colors.black),)),
        bottom: PreferredSize(preferredSize:Size.fromHeight(50.0) , child:
        Row(children: <Widget>[
          Expanded(child:
          Container(
            //color:Colors.amber,
            margin: EdgeInsets.only(left:12.0,bottom: 8.0),
            padding: EdgeInsets.only(left:30,),
            decoration: BoxDecoration(
              color:Colors.white,
              borderRadius: BorderRadius.circular(24.0)),
            child:
          TextFormField(
            controller: _textEditingController,
          style: TextStyle(color:Colors.black,fontWeight: FontWeight.bold,fontSize:17),  
        decoration:InputDecoration(
          hintText:"Search For Text",
          border: InputBorder.none
      
        ) ),

           ) ),
     
           SizedBox(width:12),
           GestureDetector(
             onTap:(){
              _search();
           
             }
            ,
             child:
       Container(
         height: 40,
         width: 40,
         decoration: BoxDecoration(
           borderRadius:BorderRadius.circular(30),
           color:Colors.black54
         ),
         child:
       Icon(Icons.search,color:Colors.white))
       ) ],),),
      ),
      body:Container(
        margin: const EdgeInsets.all(10.0),
              child: StreamBuilder(
          stream: _stream,
          builder: (BuildContext context,AsyncSnapshot snapshot){
            if(snapshot.data==null){
              return Center(child:Text("Enter a Search Word",style: TextStyle(fontSize:18,fontWeight: FontWeight.w500)));
            }
            if(snapshot.data=="waiting"){
                return Center(child:CircularProgressIndicator());
            }
            if(snapshot.data=="wronginput"){
                return Center(child:Text("No result Found Please try something else",style: TextStyle(fontSize:18,fontWeight: FontWeight.w500)));
            }
      //print(snapshot.data["definitions"].length);

            return ListView.builder(itemCount:(snapshot.data["definitions"].length),
            itemBuilder:(context,int index){
              return ListBody(
                children:[
                  Container(
                    decoration: BoxDecoration(
                      color:Colors.amber[300],
                      borderRadius: BorderRadius.circular(20)
                    ),
                    
                    child:ListTile(
                      leading:snapshot.data["definitions"][index]['image_url']==null?null:CircleAvatar(
                        backgroundImage:NetworkImage(snapshot.data["definitions"][index]['image_url']),
                        )
                      ,title: Text(_textEditingController.text.trim()+"("+snapshot.data["definitions"][index]["type"] +")" ,style: TextStyle(fontSize:18,fontWeight:FontWeight.w600),),),)
               
               ,
               SizedBox(height:6),
               Container(
                 decoration: BoxDecoration(
                  color: Colors.pink[300],
                   borderRadius: BorderRadius.circular(10),),
                 padding:EdgeInsets.all(13.0),
                 child:Text(snapshot.data["definitions"][index]["definition"],style: TextStyle(fontSize:18),)
               )
               ,SizedBox(height:18)
                ]

              );
            }
            )
            ;
          },
     ),
      )
      );
  }
}