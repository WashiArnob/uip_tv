import 'package:get/get.dart';
import 'package:uip_tv/services/api_service.dart';
import 'package:uip_tv/services/movie_service.dart';
import 'package:uip_tv/models/movie_model.dart';
import 'package:uip_tv/utils/app_constants.dart';

class MovieController extends GetxController {
  var isLoading = true.obs;
  var trendingMovies = <Movie>[].obs;
  var continueWatching = <Movie>[].obs;
  var recommendedMovies = <Movie>[].obs;

  @override
  void onInit() {
    loadMovies();
    super.onInit();
  }

  void loadMovies() async {
    var trending = await MovieService.getMoviesFromHive('trending');
    var continueWatch = await MovieService.getMoviesFromHive('continueWatching');
    var recommended = await MovieService.getMoviesFromHive('recommended');

    trendingMovies.value = trending?.map<Movie>((e) => Movie.fromJson(e)).toList() ?? <Movie>[];
    continueWatching.value = continueWatch?.map<Movie>((e) => Movie.fromJson(e)).toList() ?? <Movie>[];
    recommendedMovies.value = recommended?.map<Movie>((e) => Movie.fromJson(e)).toList() ?? <Movie>[];

    fetchTrendingMovies();
    fetchContinueWatching();
    fetchRecommendedMovies();
  }

  void fetchTrendingMovies() async {
    try {
      isLoading(true);
      var movies = await ApiService.fetchMovies(AppConstants.trendingMoviesUrl);
      print("Trending Movies: $movies"); // Debugging

      if (movies.isNotEmpty) {
        trendingMovies.value = movies; // List<Movie> Assign
        await MovieService.saveMoviesToHive('trending', movies);
      } else {
        print("Error: Trending Movies API Returned Empty List");
      }
    } catch (e) {
      print("Error fetching Trending Movies: $e");
    } finally {
      isLoading(false);
    }
  }

  void fetchContinueWatching() async {
    try {
      var movies = await ApiService.fetchMovies(AppConstants.continueWatchingUrl);
      print("Continue Watching Movies: $movies"); // Debugging

      if (movies.isNotEmpty) {
        continueWatching.value = movies;
        await MovieService.saveMoviesToHive('continueWatching', movies);
      } else {
        print("Error: Continue Watching API Returned Empty List");
      }
    } catch (e) {
      print("Error fetching Continue Watching: $e");
    }
  }

  void fetchRecommendedMovies() async {
    try {
      var movies = await ApiService.fetchMovies(AppConstants.recommendedMoviesUrl);
      print("Recommended Movies: $movies"); // Debugging

      if (movies.isNotEmpty) {
        recommendedMovies.value = movies;
        await MovieService.saveMoviesToHive('recommended', movies);
      } else {
        print("Error: Recommended API Returned Empty List");
      }
    } catch (e) {
      print("Error fetching Recommended Movies: $e");
    }
  }
}


