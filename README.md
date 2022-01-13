# FileDragAndDrop

A flutter deskstop package that allows you to drag the native file into app support. 

![](https://github.com/JerryFans/file_drag_and_drop/raw/master/preview.gif)


# Platform Support

Now only support on macOS, if any one can implements other platform method. Please pull request to contributors

| Linux | macOS | Windows |
| :---: | :---: | :-----: |
|   ➖   |   ✔️   |    ➖    |

# Example

See Example Code

Firt Step: ensureInitialized

```
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dragAndDropChannel.initializedMainView();
  runApp(MyApp());
}
```

Second Step: addListener DragContainerListener

```
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
      this.fileResults = fileResults;
    });
  }
```

## Getting Started

This project is a starting point for a Flutter
[plug-in package](https://flutter.dev/developing-packages/),
a specialized package that includes platform-specific implementation code for
Android and/or iOS.

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
