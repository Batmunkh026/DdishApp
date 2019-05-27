import 'package:flutter/material.dart';
import '../blocs/movie_bloc.dart';
import '../models/movie.dart';
import 'package:date_format/date_format.dart';

class MovieListWidget extends StatelessWidget {
  final bloc = MovieBloc();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    bloc.fetchMovies();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:
          AppBar(title: Text('Кино сан'), backgroundColor: Colors.indigoAccent),
      body: StreamBuilder(
        stream: bloc.allMovies,
        builder: (context, AsyncSnapshot<List<Movie>> snapshot) {
          if (snapshot.hasData) {
            return buildList(snapshot);
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget buildList(AsyncSnapshot<List<Movie>> snapshot) {
    return ListView.builder(
        itemCount: snapshot.data.length,
        itemBuilder: (BuildContext context, int index) {
          Movie item = snapshot.data[index];
          return Container(
            height: 100.0,
            child: ListTile(
                leading: Image.network(
                  item.posterUrl,
                  fit: BoxFit.contain,
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(item.title, style: TextStyle(color: Colors.indigo)),
                    Text(item.genres.toString(),
                        style: TextStyle(color: Colors.indigo)),
                    Text(formatDate(item.startDateTime, [HH, ':', nn]),
                        style: TextStyle(color: Colors.indigo)),
                  ],
                )),
          );
        });
  }
}
