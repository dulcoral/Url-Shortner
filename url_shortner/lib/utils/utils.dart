class Utils {
  bool isValidUrl(String url) {
    try {
      return Uri.parse(url).isAbsolute;
    } catch (e) {
      return false;
    }
  }
}
