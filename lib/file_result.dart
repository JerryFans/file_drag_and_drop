class DragFileResult {
  
  bool isDirectory = false;
  String path = "";
  String fileExtension = "";

  DragFileResult({
    required this.isDirectory,
    required this.path,
    required this.fileExtension,
  });

  DragFileResult.fromJson(dynamic json) {
    isDirectory = json['isDirectory'];
    path = json['path']?.toString() ?? "";
    fileExtension = json['fileExtension']?.toString() ?? "";
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['isDirectory'] = isDirectory;
    data['fileExtension'] = fileExtension;
    return data;
  }
}