import 'package:file_drag_and_drop/file_result.dart';

abstract class DragContainerListener {
    void draggingFileEntered() {}
    void draggingFileExit() {}
    void prepareForDragFileOperation() {}
    void performDragFileOperation(List<DragFileResult> fileResults) {}
}
