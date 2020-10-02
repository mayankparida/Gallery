import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:video_player/video_player.dart';

class BigScreen extends StatefulWidget {
  BigScreen(
      {this.imgindex, this.imgfile, this.vidindex, this.vidfile, this.control});
  static String id = "big_screen";
  int vidindex;
  int imgindex;
  List imgfile;
  List vidfile;
  int control;

  @override
  _BigScreenState createState() => _BigScreenState();
}

class _BigScreenState extends State<BigScreen> {
  Widget play = Icon(Icons.play_circle_filled, size: 30);
  int currentindex = 1;
  int control;
  int imgindex;
  List imgfile;
  int vidindex;
  List vidfile;
  VideoPlayerController controller;

  @override
  void initState() {
    super.initState();
    initialise();
  }

  void initialise() {
    control = widget.control;
    if (control == 0) {
      imgindex = widget.imgindex;
      imgfile = widget.imgfile;
    } else {
      vidindex = widget.vidindex;
      vidfile = widget.vidfile;
      controller = VideoPlayerController.file(vidfile[vidindex])
        ..initialize().then((_) {
          setState(() {});
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return control == 1
        ? WillPopScope(
            onWillPop: () {
              controller.pause();
              Navigator.pop(context);
            },
            child: Scaffold(
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(5, 30, 5, 10),
                  child: AspectRatio(
                    aspectRatio: controller.value.aspectRatio,
                    child: VideoPlayer(controller),
                  ),
                ),
              ),
              bottomNavigationBar: BottomAppBar(
                color: Colors.grey.shade900,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FloatingActionButton(
                    child: play,
                    backgroundColor: Colors.redAccent,
                    onPressed: () {
                      currentindex++;
                      if (currentindex % 2 == 0) {
                        setState(() {
                          controller.play();
                          play = Icon(Icons.pause, size: 30.0);
                        });
                      } else if (currentindex % 2 != 0) {
                        setState(() {
                          controller.pause();
                          play = Icon(Icons.play_circle_filled, size: 30.0);
                        });
                      }
                    },
                  ),
                ),
              ),
            ),
          )
        : Scaffold(
            body: Swiper(
              index: imgindex,
              itemCount: imgfile.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(5, 30, 5, 10),
                  child: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                      image: FileImage(imgfile[index]),
                    )),
                  ),
                );
              },
            ),
          );
  }
}
