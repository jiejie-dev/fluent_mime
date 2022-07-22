import 'dart:io';

void main(List<String> args) {
  final content = File('generator/mime.types').readAsStringSync();
  generate(content);
}

generate(String content) {
  Map mimeMap = {}, sortedMimeMap = {};
  final lineExp =
      RegExp(r'^([\w-]+/[\w+.-]+)((?:\s+[\w-]+)*)$', multiLine: true);
  final extensionExp = RegExp(r'\s+');
  final matches = lineExp.allMatches(content);
  for (final m in matches) {
    final mimeType = m.group(1)!;
    final extensions = m.group(2)!.trimLeft().split(extensionExp);
    for (final extension in extensions) {
      mimeMap.addAll({extension: mimeType});
    }
  }
  final sortedKeys = mimeMap.keys.toList()..sort();
  for (final key in sortedKeys) {
    sortedMimeMap[key] = mimeMap[key];
  }
  final extensionToMimeSortedKeys = sortedMimeMap.keys;
  final sbExtensionToMime = StringBuffer();

  sbExtensionToMime.writeln("import 'dart:collection';");
  sbExtensionToMime.writeln();
  sbExtensionToMime
      .writeln('const Map<String, String> _mimeMap = <String, String>{');

  for (final key in extensionToMimeSortedKeys) {
    if (key == extensionToMimeSortedKeys.last) {
      sbExtensionToMime.writeln("  '$key': '${sortedMimeMap[key]}'");
    } else {
      sbExtensionToMime.writeln("  '$key': '${sortedMimeMap[key]}',");
    }
  }
  sbExtensionToMime.writeln('};');
  sbExtensionToMime.writeln();
  sbExtensionToMime.writeln(
      'HashMap<String, String> extensionToMimeMaps = HashMap<String, String>.from(_mimeMap);');
  File('lib/extension_to_mimes.dart')
      .writeAsString(sbExtensionToMime.toString());

  final sbMimeToExtension = StringBuffer();

  sbMimeToExtension.writeln("import 'dart:collection';");
  sbMimeToExtension.writeln();
  sbMimeToExtension.writeln(
      'const Map<String, List<String>> _mimeMap = <String, List<String>>{');

  Map<String, List<String>> mimeToExtensionMap = <String, List<String>>{};

  for (final key in extensionToMimeSortedKeys) {
    final mimeType = sortedMimeMap[key];
    if (mimeToExtensionMap.containsKey(mimeType)) {
      mimeToExtensionMap[mimeType]?.add(key);
    } else {
      mimeToExtensionMap[mimeType] = [key];
    }
  }

  final mimeToExtensionSortedKeys = mimeToExtensionMap.keys.toList()..sort();

  for (final key in mimeToExtensionSortedKeys) {
    if (key == mimeToExtensionSortedKeys.last) {
      sbMimeToExtension
          .writeln("  '$key': [${_flat(mimeToExtensionMap[key])}]");
    } else {
      sbMimeToExtension
          .writeln("  '$key': [${_flat(mimeToExtensionMap[key])}],");
    }
  }

  sbMimeToExtension.writeln('};');
  sbMimeToExtension.writeln();
  sbMimeToExtension.writeln(
      'HashMap<String, List<String>> mimeToExtensionMaps = HashMap<String, List<String>>.from(_mimeMap);');
  File('lib/mime_to_extensions.dart')
      .writeAsString(sbMimeToExtension.toString());
}

_flat(List<String>? items) {
  return items?.map((e) => "'$e'").join(', ');
}
