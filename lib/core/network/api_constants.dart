class ApiConstants {
  static const String apiBaseUrl =
      'https://hiring-tasks.github.io/mobile-app-apis';

  static const String compoundsEndPoint = '/compounds.json';
  static const String AreasEndPoint = '/areas.json';
  static const String propertiesGetFiltrationOptionsEndPoint =
      '/properties-get-filter-options.json';
  static const String propertiesSearchEndPoint = '/properties-search.json';
}

class ApiErrors {
  static const String badRequestError = "badRequestError";
  static const String noContent = "noContent";
  static const String forbiddenError = "forbiddenError";
  static const String unauthorizedError = "unauthorizedError";
  static const String notFoundError = "notFoundError";
  static const String conflictError = "conflictError";
  static const String internalServerError = "internalServerError";
  static const String unknownError = "unknownError";
  static const String timeoutError = "timeoutError";
  static const String defaultError = "defaultError";
  static const String cacheError = "cacheError";
  static const String noInternetError = "no InternetError";
  static const String loadingMessage = "loading_message";
  static const String retryAgainMessage = "retry_again_message";
  static const String ok = "Ok";
}
