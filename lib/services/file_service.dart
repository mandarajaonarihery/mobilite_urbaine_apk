class FileService {
  static String getPreviewUrl(String filename) {
    final encoded = Uri.encodeComponent(filename);
    return 'https://gateway.tsirylab.com/serviceupload/file/preview/$encoded';
  }
}
