import Cocoa
import FlutterMacOS

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
        FlutterDragContainer(frame: .zero)
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
        case "getPlatformVersion":
            result("macOS " + ProcessInfo.processInfo.operatingSystemVersionString)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
