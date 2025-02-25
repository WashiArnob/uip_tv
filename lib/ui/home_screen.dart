// 📌 home_screen.dart – Updated with API Data Integration

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:uip_tv/controllers/movie_controller.dart';

class HomeScreen extends StatelessWidget {
  final MovieController movieController = Get.put(MovieController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSearchBar(),
              SizedBox(height: 16),
              _buildCategorySection(),
              SizedBox(height: 16),
              _buildFeaturedMovie(),
              SizedBox(height: 16),
              _buildMovieSection("Trending Movies", movieController.trendingMovies),
              _buildMovieSection("Continue Watching", movieController.continueWatching),
              _buildMovieSection("Recommended For You", movieController.recommendedMovies),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.black,
      elevation: 0,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Hello Rafsan", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text("Let's watch today", style: TextStyle(fontSize: 14, color: Colors.grey)),
        ],
      ),
      actions: [
        CircleAvatar(
          backgroundImage: AssetImage('assets/images/profile.png'),
        ),
        SizedBox(width: 10),
        Icon(Icons.more_vert),
        SizedBox(width: 10),
      ],
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: "Search",
        prefixIcon: Icon(Icons.search, color: Colors.grey),
        filled: true,
        fillColor: Colors.grey[800],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildCategorySection() {
    List<String> categories = ["Action", "Anime", "Sci-Fi", "Thriller"];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((category) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Chip(
              label: Text(category, style: TextStyle(color: Colors.white)),
              backgroundColor: Colors.red,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFeaturedMovie() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: CachedNetworkImage(
        imageUrl: 'https://image.tmdb.org/t/p/w500/sample_movie.jpg',
        height: 180,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildMovieSection(String title, RxList movies) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            Text("See More", style: TextStyle(fontSize: 14, color: Colors.red)),
          ],
        ),
        SizedBox(height: 10),
        Container(
          height: 140,
          child: Obx(() {
            if (movies.isEmpty) {
              return Center(child: CircularProgressIndicator(color: Colors.red));
            }
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: movies.length,
              itemBuilder: (context, index) {
                var movie = movies[index];
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      imageUrl: 'https://image.tmdb.org/t/p/w500${movie['poster_path']}',
                      height: 140,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            );
          }),
        ),
      ],
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      backgroundColor: Colors.black,
      selectedItemColor: Colors.red,
      unselectedItemColor: Colors.white,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.download), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
      ],
    );
  }
}
