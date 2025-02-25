// 📌 Integrating Hive for Offline Storage – movie_service.dart

import 'package:hive/hive.dart';
import 'package:get/get.dart';
import 'package:uip_tv/controllers/movie_controller.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:uip_tv/utils/app_constants.dart';

class MovieService {
  static const String boxName = 'moviesBox';

  static Future<void> saveMoviesToHive(String key, List movies) async {
    var box = await Hive.openBox(boxName);
    await box.put(key, movies);
  }

  static Future<List> getMoviesFromHive(String key) async {
    var box = await Hive.openBox(boxName);
    return box.get(key, defaultValue: []);
  }
}

class MovieController extends GetxController {
  var isLoading = true.obs;
  var trendingMovies = [].obs;
  var continueWatching = [].obs;
  var recommendedMovies = [].obs;

  @override
  void onInit() {
    loadMovies();
    super.onInit();
  }

  void loadMovies() async {
    trendingMovies.value = await MovieService.getMoviesFromHive('trending');
    continueWatching.value = await MovieService.getMoviesFromHive('continueWatching');
    recommendedMovies.value = await MovieService.getMoviesFromHive('recommended');
    fetchTrendingMovies();
    fetchContinueWatching();
    fetchRecommendedMovies();
  }

  void fetchTrendingMovies() async {
    try {
      isLoading(true);
      var response = await http.get(Uri.parse(AppConstants.trendingMoviesUrl));
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        if (jsonData.containsKey('results')) {
          var movies = jsonData['results'];
          trendingMovies.value = movies;
          await MovieService.saveMoviesToHive('trending', movies);
        } else {
          print("Error: 'results' key missing in API response");
        }
      } else {
        print("API Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching Trending Movies: $e");
    } finally {
      isLoading(false);
    }
  }

  void fetchContinueWatching() async {
    try {
      var response = await http.get(Uri.parse(AppConstants.continueWatchingUrl));
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        if (jsonData.containsKey('results')) {
          var movies = jsonData['results'];
          continueWatching.value = movies;
          await MovieService.saveMoviesToHive('continueWatching', movies);
        } else {
          print("Error: 'results' key missing in API response");
        }
      } else {
        print("API Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching Continue Watching: $e");
    }
  }

  void fetchRecommendedMovies() async {
    try {
      var response = await http.get(Uri.parse(AppConstants.recommendedMoviesUrl));
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        if (jsonData.containsKey('results')) {
          var movies = jsonData['results'];
          recommendedMovies.value = movies;
          await MovieService.saveMoviesToHive('recommended', movies);
        } else {
          print("Error: 'results' key missing in API response");
        }
      } else {
        print("API Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching Recommended Movies: $e");
    }
  }
}

