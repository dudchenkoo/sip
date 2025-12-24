// Web-specific implementation for CSV file picking
import 'dart:async';
import 'dart:html' as html;

/// Result of file pick operation
class FilePickResult {
  final String fileName;
  final String content;

  FilePickResult({required this.fileName, required this.content});
}

/// Pick a CSV file on web
Future<FilePickResult?> pickCsvFile() async {
  final completer = Completer<FilePickResult?>();

  final uploadInput = html.FileUploadInputElement()..accept = '.csv';
  uploadInput.click();

  uploadInput.onChange.listen((event) async {
    final files = uploadInput.files;
    if (files != null && files.isNotEmpty) {
      final file = files[0];
      final reader = html.FileReader();
      reader.readAsText(file);

      reader.onLoadEnd.listen((event) {
        final content = reader.result as String?;
        if (content != null) {
          completer.complete(FilePickResult(
            fileName: file.name,
            content: content,
          ));
        } else {
          completer.complete(null);
        }
      });

      reader.onError.listen((event) {
        completer.complete(null);
      });
    } else {
      completer.complete(null);
    }
  });

  return completer.future;
}

/// Download sample CSV file on web
void downloadSampleCsv() {
  const sampleCsv = '''Name,Phone,Email,Company,Label
John Doe,+1 555 123 4567,john@example.com,Acme Inc,Work
Jane Smith,+1 555 987 6543,jane@example.com,Tech Corp,Mobile
Bob Wilson,+1 555 456 7890,,Wilson LLC,Home''';

  final blob = html.Blob([sampleCsv], 'text/csv');
  final url = html.Url.createObjectUrlFromBlob(blob);
  final anchor = html.AnchorElement(href: url)
    ..setAttribute('download', 'contacts_sample.csv')
    ..click();
  html.Url.revokeObjectUrl(url);
}

