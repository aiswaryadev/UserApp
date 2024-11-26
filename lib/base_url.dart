class BaseUrlclass {
  static const String baseUrl = 'https://dummyjson.com/users';
  static String getUsersUrl(int skip) => '$baseUrl?limit=13&skip=$skip';
  static String getUserDetailUrl(int userId) => '$baseUrl/$userId';
}