import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';

void main() {
  runApp(new MaterialApp(
    title: "Camera App",
    home: LandingScreen(),
  ));
  runApp(MaterialApp(home: LandingScreen(), debugShowCheckedModeBanner: false,));
}

class LandingScreen extends StatefulWidget {
  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  File? imageFile;
  String im64 = 'Selectable Text';
  final _scrollController = ScrollController();

  Future _openGallery(BuildContext context) async{
    final picture = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 30);
    if (picture == null)return;
    final imageTemporary = File(picture.path);
    this.setState(() {
      imageFile = imageTemporary;
    });
    Navigator.of(context).pop();
  }

  Future _openCamera(BuildContext context) async{
    final picture = await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 30);
    if (picture == null)return;
    final imageTemporary = File(picture.path);
    this.setState(() {
     imageFile = imageTemporary;
    });
    Navigator.of(context).pop();
  }

  convert() {
    if (imageFile != null) {
      final bytes = imageFile!.readAsBytesSync();
      String _img64 = base64Encode(bytes);
      im64 = _img64;
      setState(() {
        im64 = _img64;
      });
      Clipboard.setData(new ClipboardData(text: "$_img64"));
    }
  }

  Future<void> _showChoiceDialog(BuildContext context){
    return showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        title: Text("Pick an option"),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              GestureDetector(
                child: Text("Gallery"),
                onTap: (){
                  _openGallery(context);
                },
              ),
             Padding(padding: EdgeInsets.all(8.0)),
             GestureDetector(
               child: Text("Camera"),
               onTap: (){
                _openCamera(context);
             },

             )],
          ),
        ),
      );
    });
  }

  Widget _decideImageView(){
    if(imageFile == null){
      return Container(width: MediaQuery.of(context).size.width/1.5, height: MediaQuery.of(context).size.height/2, child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("No image selected", style: TextStyle(fontSize: MediaQuery.of(context).size.width/15 ),),
            ],
          ),
        ],
      ),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.blueAccent)
        ),
      );
    } else {
      return Image.file(imageFile!,width: MediaQuery.of(context).size.width/1.5, height: MediaQuery.of(context).size.height/2);
    }


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Center(child: Text("Image to Base64")),
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _decideImageView(),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(width: MediaQuery.of(context).size.width/3 , height:  MediaQuery.of(context).size.height/8,
                      child: RaisedButton(onPressed: (){
                        _showChoiceDialog(context);

                      },
                      child: Text("Select Image"),
                      ),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width/3 , height:  MediaQuery.of(context).size.height/8,
                      child: RaisedButton(onPressed: (){
                        convert();

                      },
                        child: Text("Convert/Copy "),

                      ),
                    ),

                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8,4,8,4),

                      child: Scrollbar(
                        isAlwaysShown: true,
                        controller: _scrollController,
                        child: SingleChildScrollView(
                          controller: _scrollController ,

                          child: SizedBox(


                            width: MediaQuery.of(context).size.width , height:  MediaQuery.of(context).size.height/12,

                            child:

                            SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Center(
                                  child: Container(
                                      decoration:  BoxDecoration(
                                          border: Border.all(color: Colors.blueAccent),
                                          color: Colors.lightBlueAccent
                                      ),

                                      height: MediaQuery.of(context).size.height/12,
                                      child: Center(
                                        child: Column(

                                          children: [
                                            Center(child: SelectableText("$im64", style: TextStyle(fontSize: MediaQuery.of(context).size.height/20),)),
                                          ],

                                        ),
                                      )),
                                )),


                          ),
                        ),
                      ),
                    ),


                  ),
                ],
              ),



            ],


          ),
        ),
      ),

    );
  }
}
