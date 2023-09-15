import 'package:flutter/material.dart';
import 'package:mac_feasts/api/eats.dart';
import 'package:mac_feasts/api/restaurant.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mac Feasts',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Mac Feasts - Home'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<List<Restaurant>> futureRestaurants;
  final eats = Eats();

  @override
  void initState() {
    super.initState();
    futureRestaurants = eats.getAllRestaurants();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          ElevatedButton(
              onPressed: eats.getAllRestaurants, child: const Text('fetch')),
          FutureBuilder<List<Restaurant>>(
            future: futureRestaurants,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // return Text(snapshot.data!);
                return const Text("received!");
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }

              // By default, show a loading spinner.
              return const CircularProgressIndicator();
            },
          ),
        ],
      ),
    );
  }
}
