import 'dart:convert';
import 'dart:io';

import 'package:file_drag_and_drop/drag_container_listener.dart';
import 'package:file_drag_and_drop/file_result.dart';
import 'package:flutter/material.dart';
import 'package:file_drag_and_drop/file_drag_and_drop_channel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dragAndDropChannel.initializedMainView();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> implements DragContainerListener {
  List<DragFileResult> fileResults = [];
  var visibilityTips = false;

  @override
  void initState() {
    super.initState();
    dragAndDropChannel.addListener(this);
  }

  @override
  void dispose() {
    dragAndDropChannel.removeListener(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('FileDragAndDropContainer Example'),
          ),
          body: Stack(
            children: [
              ListView(
                children: buildWidgetList(fileResults),
              ),
              Visibility(
                visible: visibilityTips,
                child: Positioned(
                    left: 0,
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: Container(
                      color: Colors.black54,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.blueGrey,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                            ),
                            padding: EdgeInsets.all(15),
                            child: Text("Drag your file Here"),
                          ),
                        ],
                      ),
                    )),
              )
            ],
          )),
    );
  }

  List<Widget> buildWidgetList(List<DragFileResult> fileResults) {
    var list = <Widget>[
      Center(
        child: Text('Drag your finder file here'),
      )
    ];
    fileResults.forEach((element) {
      if (element.fileExtension == "png" || element.fileExtension == "jpg") {
        list.add(Center(
          child: Text('Receive Image file'),
        ));
        list.add(Image.file(
          File(element.path),
          height: 100,
          fit: BoxFit.fitHeight,
        ));
      } else {
        list.add(Center(
          child: Text(
              "receive path ${element.path} isDirectory ${element.isDirectory}"),
        ));
      }
    });
    return list;
  }

  @override
  void draggingFileEntered() {
    print("flutter: draggingFileEntered");
    setState(() {
      visibilityTips = true;
    });
  }

  @override
  void draggingFileExit() {
    print("flutter: draggingFileExit");
    setState(() {
      visibilityTips = false;
    });
  }

  @override
  void prepareForDragFileOperation() {
    print("flutter: prepareForDragFileOperation");
    setState(() {
      visibilityTips = false;
    });
  }

  @override
  void performDragFileOperation(List<DragFileResult> fileResults) {
    print("flutter: performDragFileOperation");
    setState(() {
      var cur = this.fileResults;
      cur.addAll(fileResults);
      this.fileResults = cur;
    });
  }
}
