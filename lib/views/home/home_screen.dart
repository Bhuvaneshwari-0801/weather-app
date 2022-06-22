import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:weather_icons/weather_icons.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:http/http.dart' as http;

import '../../model/weather_data_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // to get the value from textfieled
  TextEditingController searchController = TextEditingController();
//scaffold key is use for show snackbar
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
// creating instance of model;
  Future<WeatherModel>? weathFuture;

  String cityName = "Mumbai";
//method of calling api
  Future<WeatherModel> GetData(String cityName) async {
    final response = await http.get(Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=b*******************************"));
    //https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=b7f66da2e4034cba548a39490cba747a
    var data = json.decode(response.body);
    //checking if city not found
    if (data['cod'] == "404") {
      final snackBar = SnackBar(
        content: const Text('City not found! '),
        action: SnackBarAction(label: "Try again", onPressed: () {}),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      setState(() {
        weathFuture = GetData("Mumbai");
      });
    }
    //everything is ok then set the value in model
    return WeatherModel.fromJson(data);
  }

  @override
  void initState() {
    //assign reponse to model
    weathFuture = GetData(cityName);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    // ignore: avoid_print
    print("widget ditroyed");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: NewGradientAppBar(
          gradient: const LinearGradient(
            stops: [0.1, 0.6, 0.8],
            colors: [
              Color.fromARGB(255, 113, 72, 106),
              Color.fromARGB(255, 93, 101, 34),
              Color.fromARGB(255, 4, 46, 66),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
      //future builder is used to show data
      body: FutureBuilder<WeatherModel?>(
        future: weathFuture,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print(e);
          }
          if (snapshot.hasData) {
            return SizedBox(
              height: MediaQuery.of(context).size.height,
              child: ListView.builder(
                  itemCount: snapshot.data!.weather!.length,
                  // reverse: true,
                  itemBuilder: (context, index) {
                    //here we get the data from response and set to variable
                    var icon = snapshot.data!.weather![index].icon!;
                    double getTempData = snapshot.data!.main!.temp!;
                    var temp = getTempData - 273.15;
                    double wind = snapshot.data!.wind!.speed!;
                    double windSpeed = wind / 0.277777777777778;
                    String humidity = snapshot.data!.main!.humidity.toString();
                    return Container(
                      height: MediaQuery.of(context).size.height,
                      decoration: const BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              stops: [
                                0.1,
                                0.6,
                                0.8
                              ],
                              colors: [
                                Color.fromARGB(255, 113, 72, 106),
                                const Color.fromARGB(255, 93, 101, 34),
                                Color.fromARGB(255, 4, 46, 66),
                              ])),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            //Container Search one
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 194, 204, 213),
                                borderRadius: BorderRadius.circular(24)),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      weathFuture = GetData(
                                          searchController.text.toString());
                                      searchController.clear();
                                    });
                                  },
                                  child: Container(
                                    child: const Icon(Icons.search,
                                        color:
                                        Color.fromARGB(255, 47, 97, 183)),
                                    margin:
                                    const EdgeInsets.fromLTRB(3, 0, 7, 0),
                                  ),
                                ),
                                Expanded(
                                  child: TextFormField(
                                    textInputAction: TextInputAction.search,
                                    controller: searchController,
                                    decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        hintText:
                                        "About which city you want to know?"),
                                    onFieldSubmitted: (val) {
                                      val.isEmpty ? val = "Mumbai" : val;
                                      weathFuture = GetData(val);
                                      setState(() {
                                        searchController.clear();
                                      });
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(18),
                                        color: Colors.white.withOpacity(0.5)),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 18, vertical: 10),
                                    padding: const EdgeInsets.all(10),
                                    child: Row(
                                      children: [
                                        Image.network(
                                            "http://openweathermap.org/img/wn/$icon@2x.png"),
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        Column(
                                          children: [
                                            Text(
                                              "${snapshot.data!.weather![index].description}",
                                              style: const TextStyle(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              "${snapshot.data!.name}",
                                              style: const TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          ],
                                        )
                                      ],
                                    )),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 240,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(18),
                                      color: Colors.white.withOpacity(0.5)),
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 18, vertical: 5),
                                  padding: const EdgeInsets.all(33),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      const Icon(WeatherIcons.thermometer),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          const Text(
                                            "       Temperature",
                                            style: TextStyle(
                                              fontSize: 29,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            "     ${temp.toString().substring(0, 4)}°C",
                                            style: const TextStyle(
                                              height: 1.6,
                                              fontSize: 46,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(18),
                                      color: Colors.white.withOpacity(0.5)),
                                  margin:
                                  const EdgeInsets.fromLTRB(20, 10, 10, 0),
                                  height: 190,
                                  padding: const EdgeInsets.all(30),
                                  child: Column(children: [
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      children: const [
                                        Icon(WeatherIcons.day_rain_wind),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    const Text(
                                      "Wind Speed",
                                      style: TextStyle(
                                        fontSize: 19,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "${windSpeed.toString().substring(0, 4)}km/hr",
                                      style: const TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ]),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(18),
                                      color: Colors.white.withOpacity(0.5)),
                                  margin:
                                  const EdgeInsets.fromLTRB(10, 5, 20, 0),
                                  height: 190,
                                  padding: const EdgeInsets.all(30),
                                  child: Column(children: [
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      children: const [
                                        Icon(WeatherIcons.humidity),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    const Text(
                                      "Humidity",
                                      style: TextStyle(
                                        fontSize: 19,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "$humidity %",
                                      style: const TextStyle(
                                        height: 1.5,
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ]),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: const [
                                Text(
                                  "Data Provided By Openweathermap.org",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 184, 178, 178),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  }),
            );
          } else {
            return const Center(
                child: CircularProgressIndicator(
                  color: Colors.red,
                ));
          }
        },
      ),
    );
  }
}
