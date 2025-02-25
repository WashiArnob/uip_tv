// 📌 Integrating Hive for Offline Storage – movie_service.dart

import 'package:hive/hive.dart';
import 'package:get/get.dart';
import 'package:uip_tv/controllers/movie_controller.dart';
import 'package:http/http.dart' as http;

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
      var response = await http.get(Uri.parse("https://api.themoviedb.org/3/trending/movie/week?api_key=YOUR_API_KEY"));
      if (response.statusCode == 200) {
        var movies = jsonDecode(response.body)['results'];
        trendingMovies.value = movies;
        await MovieService.saveMoviesToHive('trending', movies);
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
        var movies = jsonDecode(response.body)['results'];
        continueWatching.value = movies;
        await MovieService.saveMoviesToHive('continueWatching', movies);
      }
    } catch (e) {
      print("Error fetching Continue Watching: $e");
    }
  }

  void fetchRecommendedMovies() async {
    try {
      var response = await http.get(Uri.parse("https://api.themoviedb.org/3/movie/top_rated?api_key=YOUR_API_KEY"));
      if (response.statusCode == 200) {
        var movies = jsonDecode(response.body)['results'];
        recommendedMovies.value = movies;
        await MovieService.saveMoviesToHive('recommended', movies);
      }
    } catch (e) {
      print("Error fetching Recommended Movies: $e");
    }
  }
}
