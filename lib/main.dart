import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'Movie_repository.dart';
import 'StringCubit.dart';
import 'Movies.dart';
import 'TicketCubit.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MovieListScreen(),
    );
  }
}

class SummaryScreen extends StatelessWidget {
  final Movie movie;
  final int ticketCount;

  const SummaryScreen({
    Key? key,
    required this.movie,
    required this.ticketCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int ticketPrice = 30;
    final int totalPrice = ticketCount * ticketPrice;

    return Scaffold(
      appBar: AppBar(
        title: Text('Resumen de la compra'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Detalles de la película: ${movie.title}'),
            Text('Cantidad de entradas: $ticketCount'),
            Text('Precio total: $totalPrice Bs.'),
          ],
        ),
      ),
    );
  }
}

class MovieItemWidget extends StatelessWidget {
  final Movie movie;
  final TicketCubit ticketCubit;

  const MovieItemWidget({
    Key? key,
    required this.movie,
    required this.ticketCubit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(movie.title),
        subtitle: Text('Descripción de la película'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                ticketCubit.increment();
              },
            ),
            BlocBuilder<TicketCubit, int>(
              bloc: ticketCubit,
              builder: (context, state) {
                return Text('$state');
              },
            ),
            IconButton(
              icon: Icon(Icons.remove),
              onPressed: () {
                ticketCubit.decrement();
              },
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SummaryScreen(
                      movie: movie,
                      ticketCount: ticketCubit.state,
                    ),
                  ),
                );
              },
              child: Text('Confirmar'),
            ),
          ],
        ),
      ),
    );
  }
}

class MovieListScreen extends StatefulWidget {
  @override
  _MovieListScreenState createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  final MovieRepository movieRepository = MovieRepository();
  late List<Movie> movies = [];
  final StringCubit stringCubit = StringCubit();
  final Map<int, TicketCubit?> ticketCubitMap = {}; // Usar TicketCubit nullable

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    stringCubit.updateString('Loading');
    try {
      final List<Movie> fetchedMovies = await movieRepository.fetchMovies();
      setState(() {
        movies = fetchedMovies;
        stringCubit.updateString('Success');
      });

      for (var movie in movies) {
        if (!ticketCubitMap.containsKey(movie.id)) {
          ticketCubitMap[movie.id] = TicketCubit();
        }
      }
    } catch (error) {
      stringCubit.updateString('Error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de películas'),
      ),
      body: BlocBuilder<StringCubit, StringState>(
        bloc: stringCubit,
        builder: (context, state) {
          if (state.value == 'Loading') {
            return Center(child: CircularProgressIndicator());
          } else if (state.value == 'Success') {
            return ListView.builder(
              itemCount: movies.length,
              itemBuilder: (context, index) {
                final movie = movies[index];
                final ticketCubit = ticketCubitMap[movie.id];

                if (ticketCubit != null) {
                  // Comprueba si ticketCubit no es nulo
                  return MovieItemWidget(
                    movie: movie,
                    ticketCubit: ticketCubit,
                  );
                } else {
                  return SizedBox(); // O cualquier otro manejo de un TicketCubit nulo
                }
              },
            );
          } else {
            return Center(child: Text('Error al cargar las películas'));
          }
        },
      ),
    );
  }
}
