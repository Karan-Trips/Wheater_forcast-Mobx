import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:whether_forcast_mobx/models/wheater_mobx.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const MyHomePage(title: 'Wheater Forecast'),
      },
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
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(child: Observer(builder: (_) {
          return Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover, image: NetworkImage(wheater.url))),
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(children: [
                const SizedBox(
                  height: 40,
                ),
                Observer(builder: (_) {
                  return Visibility(
                      child: Text(
                    wheater.wheater,
                    style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ));
                }),
                const SizedBox(
                  height: 50,
                ),
                Observer(builder: (_) {
                  return wheater.wheaterEnum == WheaterEnum.isLoaded
                      ? Text(
                          '${wheater.degree.toStringAsFixed(0)} °C',
                          style: const TextStyle(
                              fontSize: 50,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        )
                      : const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 5,
                          ),
                        );
                }),
                const SizedBox(
                  height: 60,
                ),
                TextFormField(
                  onFieldSubmitted: (value) {
                    if (value.isNotEmpty) {
                      wheater.setWheater(value);
                      wheater.getWheater();
                      wheater.setWheaterEnumdelay();
                      searchController.clear();
                      wheater.changeWhaterImage();
                    } else {
                      var snackBar = const SnackBar(
                        content: Text('Please Enter city'),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
                  keyboardType: TextInputType.streetAddress,
                  validator: (value) => value!.isEmpty ? 'Enter city' : null,
                  controller: searchController,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: 'Enter city',
                    filled: true,
                    fillColor: Colors.grey[200],
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(color: Colors.red, width: 2),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Observer(builder: (_) {
                  return IconButton.filled(
                      style: ButtonStyle(
                          shape: MaterialStatePropertyAll(
                              BeveledRectangleBorder(
                                  side: const BorderSide(
                                      width: 1, color: Colors.red),
                                  borderRadius: BorderRadius.circular(20)))),
                      iconSize: 35,
                      padding: const EdgeInsets.all(15),
                      color: Colors.amber,
                      onPressed: onPressed(),
                      icon: const Icon(Icons.search));
                })
              ]),
            ),
          );
        })));
  }

  void Function()? onPressed() {
    return () {
      if (searchController.text.isNotEmpty) {
        wheater.setWheater(searchController.text);
        wheater.getWheater();
        wheater.setWheaterEnumdelay();
        searchController.clear();
        wheater.changeWhaterImage();
      } else {
        var snackBar = const SnackBar(
          content: Text('Please Enter city'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    };
  }
}
