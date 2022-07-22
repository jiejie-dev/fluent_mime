library fluent_mime;

import 'dart:io';

import 'package:fluent_mime/extension_to_mimes.dart';
import 'package:fluent_mime/mime_to_extensions.dart';

String? filenameToMime(String filename) {
  final extension = filename.split('.').last;
  return extensionToMimeMaps[extension];
}

String? filenameToExtension(String filename) {
  return filename.split('.').last;
}

List<String> mimeToExtensions(String mime) {
  return mimeToExtensionMaps[mime] ?? [];
}

extension StringToMime on String {
  String? get mime {
    return filenameToMime(this);
  }

  String? get extension {
    return filenameToExtension(this);
  }

  bool get isVideo {
    return mime?.startsWith('video') ?? false;
  }

  bool get isImage {
    return mime?.startsWith('image') ?? false;
  }

  bool get isAudio {
    return mime?.startsWith('audio') ?? false;
  }

  bool get isText {
    return mime?.startsWith('text') ?? false;
  }

  bool get isHtml {
    return mime?.startsWith('text/html') ?? false;
  }

  bool get isPdf {
    return mime?.startsWith('application/pdf') ?? false;
  }

  bool get isJson {
    return mime?.startsWith('application/json') ?? false;
  }

  bool get isXml {
    return mime?.startsWith('application/xml') ?? false;
  }

  bool get isCsv {
    return mime?.startsWith('text/csv') ?? false;
  }
}

extension FileToMime on File {
  String? get mime {
    return filenameToMime(path);
  }

  String? get extension {
    return filenameToExtension(path);
  }

  bool get isVideo {
    return mime?.startsWith('video') ?? false;
  }

  bool get isImage {
    return mime?.startsWith('image') ?? false;
  }

  bool get isAudio {
    return mime?.startsWith('audio') ?? false;
  }

  bool get isText {
    return mime?.startsWith('text') ?? false;
  }

  bool get isHtml {
    return mime?.startsWith('text/html') ?? false;
  }

  bool get isPdf {
    return mime?.startsWith('application/pdf') ?? false;
  }

  bool get isJson {
    return mime?.startsWith('application/json') ?? false;
  }

  bool get isXml {
    return mime?.startsWith('application/xml') ?? false;
  }

  bool get isCsv {
    return mime?.startsWith('text/csv') ?? false;
  }
}
