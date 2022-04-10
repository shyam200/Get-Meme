import 'package:http/http.dart' as client;

import '../../injection/injection_container.dart';
import '../../resources/network_constants/network_constants.dart';

class RandomMemeDataAPI {
  Future<String> getRawMemeData() async {
    NetworkConstants networkConstants = di<NetworkConstants>();
    Uri url =
        Uri.parse(networkConstants.baseUrl + networkConstants.getRandomMemeUrl);
    final client.Response rawData = await client.get(url);
    return rawData.body;
  }
}
