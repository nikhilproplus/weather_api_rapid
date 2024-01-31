import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rapid_api/controller/controller.dart';
import 'package:rapid_api/model/model.dart';

final GetDataController getDataController = Get.put(GetDataController());

class DataService {
  String apiUrl = getDataController.searchAreaController.text.isEmpty
      ? 'https://weatherapi-com.p.rapidapi.com/current.json?q=${getDataController.q1}%2C${getDataController.q2}'
      : 'https://weatherapi-com.p.rapidapi.com/current.json?q=${getDataController.searchAreaController.text}';

  Future<WelcomeSuccess> getData() async {
    try {
      final response = await http.get(Uri.parse(apiUrl), headers: {
        'X-RapidAPI-Key': '6b33c0d435msh83caf79e8b731bbp15959djsn26626e4302fa',
        'X-RapidAPI-Host': 'weatherapi-com.p.rapidapi.com',
      });

      print(response.body);

      if (response.statusCode == 200) {
        print('200 success');
        return welcomeSuccessFromJson(response.body);
      } else {
        throw Exception('Failed to post exception');
      }
    } catch (e) {
      throw Exception('Failed to get data in service $e');
    }
  }
}
