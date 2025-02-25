class AppConstants {
  // ✅ API Key (Ensure it's Secure)
  static const String apiKey = "41126ff73c03fcf96f288209833839c6";

  // ✅ Base URL for TMDB API
  static const String baseUrl = "https://api.themoviedb.org/3";

  // ✅ Image Base URL
  static const String imageBaseUrl = "https://image.tmdb.org/t/p/w500";

  // ✅ API Endpoints (Predefined)
  static const String trendingMoviesUrl = "/trending/movie/week";
  static const String continueWatchingUrl = "/movie/popular";
  static const String recommendedMoviesUrl = "/movie/top_rated";

  // ✅ Function to Build API URLs
  static String buildUrl(String endpoint, {Map<String, String>? queryParams}) {
    String url = "$baseUrl$endpoint?api_key=$apiKey";

    if (queryParams != null) {
      queryParams.forEach((key, value) {
        url += "&$key=$value";
      });
    }

    return url;
  }
}

