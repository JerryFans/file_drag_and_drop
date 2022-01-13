import Cocoa
import FlutterMacOS

let kFileDragAndDropEventEntered = "enter"
let kFileDragAndDropEventExit = "exit"
let kFileDragAndDropEventPrepareDragTask = "prepare-drag-task"
let kFileDragAndDropEventPerformDragTask = "perform-dragtask"

public class FileDragAndDropPlugin: NSObject, FlutterPlugin {
    
    private var mainWindow: NSWindow {
        get {
            return (self.registrar.view?.window)!;
        }
    }

    private var mainView: NSView {
        get {
            return self.registrar.view!
        }
    }
    
    private var registrar: FlutterPluginRegistrar!;
    private var channel: FlutterMethodChannel!
    private var _initialized = false
    private lazy var mainDropView: FlutterDragContainer = {
        let v = FlutterDragContainer(frame: .zero)
        v.delegate = self
        return v
    }()
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "file_drag_and_drop", binaryMessenger: registrar.messenger)
        let instance = FileDragAndDropPlugin(registrar, channel)
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public init(_ registrar: FlutterPluginRegistrar, _ channel: FlutterMethodChannel) {
        super.init()
        self.registrar = registrar
        self.channel = channel
    }
    
    private func _initializedMainView() {
        if (!_initialized) {
            _initialized = true
            mainView.addSubview(mainDropView)
            mainDropView.frame = mainView.bounds
            mainDropView.translatesAutoresizingMaskIntoConstraints = false
            mainView.addConstraints(
                [
                    NSLayoutConstraint(item: mainDropView, attribute: .leading, relatedBy: .equal, toItem: mainView, attribute: .leading, multiplier: 1, constant: 0),
                    NSLayoutConstraint(item: mainDropView, attribute: .trailing, relatedBy: .equal, toItem: mainView, attribute: .trailing, multiplier: 1, constant: 0),
                    NSLayoutConstraint(item: mainDropView, attribute: .top, relatedBy: .equal, toItem: mainView, attribute: .top, multiplier: 1, constant: 0),
                    NSLayoutConstraint(item: mainDropView, attribute: .bottom, relatedBy: .equal, toItem: mainView, attribute: .bottom, multiplier: 1, constant: 0)
              ]
            )
        }
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "initializedMainView":
            _initializedMainView()
            result(true)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    public func _invokeMethod(_ eventName: String, arguments: [String:Any]? = nil) {
        var args: [String:Any] = [:]
        if let arguments = arguments {
            args = arguments
        }
        args["eventName"] = eventName
        channel.invokeMethod("onEvent", arguments: args, result: nil)
    }
}

extension FileDragAndDropPlugin: FlutterDragContainerDelegate {
    
    func draggingFileEntered() {
        _invokeMethod(kFileDragAndDropEventEntered)
    }
    
    func draggingFileExit() {
        _invokeMethod(kFileDragAndDropEventExit)
    }
    
    func prepareForDragFileOperation() {
        _invokeMethod(kFileDragAndDropEventPrepareDragTask)
    }
    
    func performDragFileOperation(_ results: [FileResult]) {
        var array: [[String:Any]] = []
        for result in results {
            var dict: [String:Any] = [:]
            dict["isDirectory"] = result.isDirectory
            dict["path"] = result.path
            dict["fileExtension"] = result.fileExtension
            array.append(dict)
        }
        _invokeMethod(kFileDragAndDropEventPerformDragTask, arguments: ["fileResult":array])
    }
    
}
