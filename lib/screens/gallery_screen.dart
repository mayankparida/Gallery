import 'dart:convert';
import 'dart:io';
import 'package:app/screens/big_screen.dart';
import 'package:app/screens/pin_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:storage_path/storage_path.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:share/share.dart';

class GalleryScreen extends StatefulWidget {
  static String id = "gallery_screen";
  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  String imagePath;
  String videoPath;
  var response;
  File img;
  File vid;
  var videothumb;
  List imgfile = new List();
  List vidfile = new List();
  List vidthumbfile = new List();
  int imglength;
  int vidlength;
  bool isloading = true;
  int currentindex = 0;
  ScrollController controller = ScrollController();
  List<Asset> selectedimages = List<Asset>();
  @override
  void initState() {
    super.initState();
    getimagepath();
  }

  void choiceAction(String choice) async {
    if (choice == Constants.ChangePIN) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt("time", 0);
      Navigator.pushNamed(context, PinScreen.id);
    } else if (choice == Constants.Select) {
      loadAssets();
    }
  }

  loadAssets() async {
    List<Asset> resultList = List<Asset>();
    List<String> fileImageArray = new List<String>();

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
        selectedAssets: resultList,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          statusBarColor: "#F44336",
          actionBarTitleColor: "#F44336",
          actionBarColor: "#212121",
          actionBarTitle: "Select Images",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#F44336",
          selectionLimitReachedText: "You can't select any more.",
        ),
      );
    } catch (e) {
      print("Fail");
    }
    for (Asset asset in resultList) {
      final filePath =
          await FlutterAbsolutePath.getAbsolutePath(asset.identifier);
      String temp = (File(filePath)).toString();
      fileImageArray.add(temp.substring(7, temp.length - 1));
    }
    Share.shareFiles(fileImageArray);
  }

  getimagepath() async {
    try {
      isloading = true;
      imagePath = await StoragePath.imagesPath;
      response = jsonDecode(imagePath);
      int i = 0;
      while (response[0]["files"][i] != null) {
        img = File(response[0]["files"][i]);
        imgfile.add(img);
        i++;
      } //contains images path and folder name in json format
    } catch (e) {
      print("Fail");
    }
    imglength = imgfile.length;
    try {
      isloading = true;
      videoPath = await StoragePath.videoPath;
      response = jsonDecode(videoPath);
      int i = 0;
      while (response[0]["files"][i]["path"] != null) {
        vid = File(response[0]["files"][i]["path"]);
        vidfile.add(vid);
        vid = File(response[0]["files"][i]["displayName"]);
        vidthumbfile.add(vid.toString());
        i++;
      }
      //contains images path and folder name in json format
    } catch (e) {
      print("Fail");
    }
    vidlength = vidfile.length;
    setState(() {
      isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        SystemNavigator.pop();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset("images/gallery_logo.png"),
          ),
          actions: <Widget>[
            PopupMenuButton<String>(
              onSelected: choiceAction,
              itemBuilder: (BuildContext context) {
                return Constants.choices.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(
                      choice,
                      style: TextStyle(
                          color: Colors.redAccent, fontWeight: FontWeight.bold),
                    ),
                  );
                }).toList();
              },
            )
          ],
          title: Text(
            "Gallery",
            style:
                TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent),
          ),
          backgroundColor: Colors.grey.shade900,
        ),
        body: isloading
            ? Container(
                child: LinearProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.redAccent),
                  backgroundColor: Colors.grey.shade700,
                ),
              )
            : currentindex == 0
                ? Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: DraggableScrollbar.rrect(
                      backgroundColor: Colors.redAccent,
                      controller: controller,
                      alwaysVisibleScrollThumb: false,
                      child: GridView.count(
                        controller: controller,
                        crossAxisCount: 3,
                        children: List.generate(imglength, (index) {
                          return GestureDetector(
                            onTap: () {
                              print(index);
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return BigScreen(
                                    imgindex: index,
                                    imgfile: imgfile,
                                    control: currentindex);
                              }));
                            },
                            child: Card(
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0)),
                                    image: DecorationImage(
                                        image: FileImage(imgfile[index]),
                                        fit: BoxFit.cover)),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  )
                : DraggableScrollbar.rrect(
                    backgroundColor: Colors.redAccent,
                    controller: controller,
                    alwaysVisibleScrollThumb: false,
                    child: GridView.count(
                      controller: controller,
                      crossAxisCount: 3,
                      children: List.generate(vidlength, (index) {
                        return FlatButton(
                          onPressed: () {
                            print(index);
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return BigScreen(
                                  vidindex: index,
                                  vidfile: vidfile,
                                  control: currentindex);
                            }));
                          },
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Container(
                                child: Text(vidthumbfile[index]),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          unselectedItemColor: Colors.grey,
          selectedItemColor: Colors.redAccent,
          currentIndex: currentindex,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.photo),
                title: Text(
                  "Photos",
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
            BottomNavigationBarItem(
                icon: Icon(Icons.video_library),
                title: Text(
                  "Videos",
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
          ],
          onTap: (index) {
            setState(() {
              currentindex = index;
            });
          },
        ),
      ),
    );
  }
}

class Constants {
  static const String ChangePIN = "Change PIN";
  static const String Select = "Select";

  static const List<String> choices = <String>[ChangePIN, Select];
}
