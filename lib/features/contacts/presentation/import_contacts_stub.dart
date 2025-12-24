// Stub implementation for non-web platforms (iOS/Android)
// These functions will not be called on mobile, but need to exist for compilation

/// Result of file pick operation
class FilePickResult {
  final String fileName;
  final String content;

  FilePickResult({required this.fileName, required this.content});
}

/// Stub for picking CSV file (not available on mobile)
Future<FilePickResult?> pickCsvFile() async {
  // This should never be called on mobile - UI prevents it
  throw UnsupportedError('CSV import is only available on web');
}

/// Stub for downloading sample CSV (not available on mobile)
void downloadSampleCsv() {
  // This should never be called on mobile - UI hides it
  throw UnsupportedError('Sample download is only available on web');
}

