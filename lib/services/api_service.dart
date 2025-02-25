import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uip_tv/models/movie_model.dart';
import 'package:uip_tv/utils/app_constants.dart';  // Import AppConstants

class ApiService {
  static Future<List<Movie>> fetchMovies(String endpoint, {Map<String, String>? queryParams}) async {
    try {
      //  Use buildUrl() to construct API URL dynamically
      final url = Uri.parse(AppConstants.buildUrl(endpoint, queryParams: queryParams));

      //  Debugging Log
      print("📡 Fetching API: $url");

      final response = await http.get(url);

      //  Debugging - API Status & Response
      print(" API Status Code: ${response.statusCode}");
      print(" API Response Body: ${response.body}");

      if (response.statusCode == 200) {
        var decodedData = jsonDecode(response.body);

        //  Check if 'results' key exists in API response
        if (decodedData.containsKey('results') && decodedData['results'] is List) {
          List<Movie> movies = (decodedData['results'] as List)
              .map((movie) => Movie.fromJson(movie))
              .toList();
          print(" Movies Fetched: ${movies.length}"); // Debugging
          return movies;
        } else {
          print(" Error: 'results' key missing in API response!");
          return [];
        }
      } else {
        print(" API Error: ${response.statusCode} - ${response.body}");
        return [];
      }
    } catch (e) {
      print(" API Fetch Error: $e");
      return [];
    }
  }
}



