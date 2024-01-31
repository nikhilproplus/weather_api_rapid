import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rapid_api/controller/controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final GetDataController getDataController = Get.put(GetDataController());

  @override
  void initState() {
    initializeData();
    super.initState();
  }

//use future delayed for functions that need to be used inside initstate
  initializeData() {
    Future.delayed(Duration.zero, () async {
      getDataController.isDataLoading.value = true;
      await getDataController.getCurrentPosition(context);
      await getDataController.getDataApi();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Weather App',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: getDataController.searchAreaController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    isDense: true,
                    border: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    hintText: 'Enter an area',
                    hintStyle: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                    ),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () async {
                          await getDataController.getDataApi();
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.orange,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('Search'),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Obx(
                  () => getDataController.isDataLoading.value
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : getDataController.saveData.isEmpty
                          ? const Text(
                              "No data available, please check your spelling",
                              style: TextStyle(color: Colors.white),
                            )
                          : Card(
                              elevation: 5,
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: [
                                    ListTile(
                                      title: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: 50,
                                            child: Image.network(
                                              'https:${getDataController.saveData.first!.current.condition.icon}',
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          Text(
                                            getDataController.saveData.first!
                                                .current.condition.text,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                            ),
                                          ),
                                        ],
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const SizedBox(height: 16),
                                          Text(
                                            'Location: ${getDataController.saveData.first!.location.name}',
                                            style:
                                                const TextStyle(fontSize: 18),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'Region: ${getDataController.saveData.first!.location.region}',
                                            style:
                                                const TextStyle(fontSize: 18),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'Country: ${getDataController.saveData.first!.location.country}',
                                            style:
                                                const TextStyle(fontSize: 18),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'Temperature: ${getDataController.saveData.first!.current.tempC}°C',
                                            style:
                                                const TextStyle(fontSize: 18),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'Humidity: ${getDataController.saveData.first!.current.humidity.toString()}%',
                                            style:
                                                const TextStyle(fontSize: 18),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'Wind: ${getDataController.saveData.first!.current.windKph}km/h',
                                            style:
                                                const TextStyle(fontSize: 18),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'Last updated: ${getDataController.saveData.first!.current.lastUpdated}',
                                            style:
                                                const TextStyle(fontSize: 18),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () async {
                    getDataController.searchAreaController.clear();
                    await getDataController
                        .getCurrentPosition(context)
                        .then((value) => getDataController.getDataApi());
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 18,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Get current location',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
