// 📌 movie_controller.dart – GetX Controller for Fetching Movie Data

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MovieController extends GetxController {
  var isLoading = true.obs;
  var trendingMovies = [].obs;
  var continueWatching = [].obs;
  var recommendedMovies = [].obs;

  @override
  void onInit() {
    fetchTrendingMovies();
    fetchContinueWatching();
    fetchRecommendedMovies();
    super.onInit();
  }

  void fetchTrendingMovies() async {
    try {
      isLoading(true);
      var response = await http.get(Uri.parse("https://api.themoviedb.org/3/trending/movie/week?api_key=YOUR_API_KEY"));
      if (response.statusCode == 200) {
        trendingMovies.value = jsonDecode(response.body)['results'];
      }
    } catch (e) {
      print("Error fetching Trending Movies: $e");
    } finally {
      isLoading(false);
    }
  }

  void fetchContinueWatching() async {
    try {
      var response = await http.get(Uri.parse("https://api.themoviedb.org/3/movie/popular?api_key=YOUR_API_KEY"));
      if (response.statusCode == 200) {
        continueWatching.value = jsonDecode(response.body)['results'];
      }
    } catch (e) {
      print("Error fetching Continue Watching: $e");
    }
  }

  void fetchRecommendedMovies() async {
    try {
      var response = await http.get(Uri.parse("https://api.themoviedb.org/3/movie/top_rated?api_key=YOUR_API_KEY"));
      if (response.statusCode == 200) {
        recommendedMovies.value = jsonDecode(response.body)['results'];
      }
    } catch (e) {
      print("Error fetching Recommended Movies: $e");
    }
  }
}
