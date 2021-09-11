import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'models/movie.dart';
import 'widgets/search_widget.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _App createState() => _App();
}

class _App extends State<MyApp> {
  List<Movie> _movies = <Movie>[];
  List<Movie> _moviesfordisplay = <Movie>[];
  String query = '';
  @override
  void initState() {
    super.initState();
    _populateAllMovies();
  }

  void _populateAllMovies() async {
    final movies = await _fetchAllMovies();
    setState(() {
      _movies = movies;
      _moviesfordisplay = _movies;
    });
  }

  Future<List<Movie>> _fetchAllMovies() async {
    final response =
        await http.get("https://imdb-api.com/en/API/Top250Movies/k_w8y80y5a");
    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      Iterable list = result["items"];
      return list.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception("Failed to load Movies");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Movies App",
      home: Scaffold(
        body: Column(
          children: <Widget>[
            Container(
              child: Padding(
                padding: const EdgeInsets.only(left: 13, top: 30),
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Home",
                      style:
                          TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                    )),
              ),
            ),
            _moviesfordisplay.length == 0
                ? Container(
                    child: Center(
                      child: Text(
                        "No Movies Found",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                : SizedBox(
                    height: 1,
                    width: 1,
                  ),
            Expanded(
              child: ListView.builder(
                itemCount: _moviesfordisplay.length + 1,
                itemBuilder: (context, index) {
                  return index == 0 ? _searchBar() : _listItem(index - 1);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  _searchBar() {
    return SearchWidget(
      text: query,
      hintText: 'Search For Movies',
      onChanged: (text) {
        text = text.toLowerCase();
        setState(() {
          _moviesfordisplay = _movies.where((movie) {
            var movietitle = movie.title.toLowerCase();
            return movietitle.contains(text);
          }).toList();
        });
      },
    );
  }

  _listItem(index) {
    final movie = _moviesfordisplay[index];
    return Card(
      elevation: 4,
      shadowColor: Colors.grey.shade400,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            SizedBox(
              width: 100,
              child: ClipRRect(
                child: Image.network(movie.poster),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title,
                      style: TextStyle(
                          fontSize: 22,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      movie.year,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    SizedBox(
                      width: 70,
                      height: 23,
                      child: DecoratedBox(
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Text(
                            movie.imdbrating + " IMDB",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.lightBlue,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 3,
                              blurRadius: 10,
                              offset: Offset(0, 1),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
