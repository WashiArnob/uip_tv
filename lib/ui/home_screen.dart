import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uip_tv/controllers/movie_controller.dart';
import 'package:uip_tv/utils/app_constants.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MovieController movieController = Get.find<MovieController>();

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80),
          child: _appBar(),
        ),
      
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //  Search Bar
                _buildSearchBar(),
      
                const SizedBox(height: 20),
      
                //  Categories Section
                _buildCategories(),
      
                const SizedBox(height: 20),
      
                //  Featured Movie (From API)
                _buildFeaturedMovie(movieController),
      
                const SizedBox(height: 20),
      
                //  Trending Movies
                _buildMovieSection("Trending Movies", movieController.trendingMovies),
      
                const SizedBox(height: 20),
      
                //  Continue Watching
                _buildMovieSection("Continue Watching", movieController.continueWatching),
      
                const SizedBox(height: 20),
      
                // _ Recommended For You
                _buildMovieSection("Recommended For You", movieController.recommendedMovies),
              ],
            ),
          ),
        ),
        bottomNavigationBar: _buildBottomNavBar(),
      ),
    );
  }

  //AppBar Function
  Widget _appBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.black,
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //  Title Section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Hello Washi",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Let's watch today",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),

            //  Profile Picture with Proper Face Visibility
            Container(
              padding: EdgeInsets.all(3), // Small padding for glow effect
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Colors.purpleAccent, Colors.blueAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(40), // Circular Image Fix
                child: Image.asset(
                  "assets/images/profile.jpg",
                  width: 50, // Slightly Increased Size for Better Visibility
                  height: 50,
                  fit: BoxFit.cover, // Ensures Full Face Visibility
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //  Search Bar Widget
  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: "Search",
          hintStyle: TextStyle(color: Colors.white70),
          prefixIcon: Icon(Icons.search, color: Colors.white70),
          suffixIcon: Icon(Icons.filter_list, color: Colors.white70),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        ),
      ),
    );
  }

  //  Categories Section
  Widget _buildCategories() {
    List<String> categories = ["Action", "Anime", "Sci-Fi", "Thriller", "Romance","Horror","Crime"];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader("Categories"),
        SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: categories.map((category) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 6),
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[850],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  child: Text(
                    category,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  //  Featured Movie (Dynamic API)
  Widget _buildFeaturedMovie(MovieController controller) {
    return Obx(() {
      if (controller.trendingMovies.isEmpty) {
        return _loadingPlaceholder(height: 200);
      }
      var movie = controller.trendingMovies.first;
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          "${AppConstants.imageBaseUrl}${movie.posterPath}",
          height: 200,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Icon(Icons.error, size: 50, color: Colors.red),
        ),
      );
    });
  }

  //  Movie Section (Trending / Continue Watching / Recommended)
  Widget _buildMovieSection(String title, RxList movies) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader(title),
        SizedBox(height: 10),
        SizedBox(
          height: 200, //  Fixed height to prevent overflow
          child: Obx(() {
            if (movies.isEmpty) {
              return _loadingPlaceholder(height: 200);
            }
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: movies.length,
              itemBuilder: (context, index) {
                final movie = movies[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    children: [
                      //  Movie Poster with Fixed Size
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          "${AppConstants.imageBaseUrl}${movie.posterPath}",
                          height: 150,
                          width: 100,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Icon(Icons.error, size: 50, color: Colors.red),
                        ),
                      ),
                      SizedBox(height: 5), // Spacing
                      // Movie Title
                      Text(
                        movie.title,
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  ),
                );
              },
            );
          }),
        ),
      ],
    );
  }

  //  Section Header Widget
  Widget _sectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text("See More", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
      ],
    );
  }

  //  Loading Placeholder
  Widget _loadingPlaceholder({double height = 100}) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(child: CircularProgressIndicator(color: Colors.red)),
    );
  }

  //  Bottom Navigation Bar
  Widget _buildBottomNavBar() {
    return Container(
      margin: EdgeInsets.all(16), // Adds spacing around the navbar
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8), // Inner padding
      decoration: BoxDecoration(
        color: Colors.black, // Background color
        borderRadius: BorderRadius.circular(30), // Smooth rounded corners
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3), // ✅ Light Shadow for Elevation
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30), // Ensuring clipping within border
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed, // Keeps all icons aligned
          backgroundColor: Colors.transparent, // Transparent as container has color
          selectedItemColor: Colors.red, // Active icon color
          unselectedItemColor: Colors.grey, // Inactive icon color
          showSelectedLabels: false, // No labels
          showUnselectedLabels: false,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home, size: 28), label: ""),
            BottomNavigationBarItem(icon: Icon(Icons.tv, size: 26), label: ""),
            BottomNavigationBarItem(icon: Icon(Icons.download, size: 26), label: ""),
            BottomNavigationBarItem(icon: Icon(Icons.person, size: 26), label: ""),
          ],
        ),
      ),
    );
  }


}


