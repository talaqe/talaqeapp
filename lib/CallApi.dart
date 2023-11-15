import 'dart:convert';
import 'package:http/http.dart' as http;

class CallApi{
  final String _url="https://talaqe.org/api/";
  static String imgurl="https://talaqe.org/storage/app/public/";
  postData(data,apiurl) async {
    var fullUrl=_url+apiurl;
    return await http.post(
      Uri.parse(fullUrl),
      body: jsonEncode(data),
      headers: _setHeaders(),
    );
  }
  Future<bool> addImagepatient(Map<String, String> body, String filepath) async {
    String addimageUrl = '${_url}upload/scans';
    var request = http.MultipartRequest('POST', Uri.parse(addimageUrl))
      ..fields.addAll(body)
      ..headers.addAll(_setHeaders())
      ..files.add(await http.MultipartFile.fromPath('image', filepath));
    var response = await request.send();
    final responseBody = await response.stream.bytesToString();
    print('RESPONSE BODY:   $responseBody');
    print('response${response.statusCode}');
    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }

  }
    Future<bool> addImage(Map<String, String> body, String filepath) async {
      String addimageUrl = '${_url}signup/dentist/image';
     var request = http.MultipartRequest('POST', Uri.parse(addimageUrl))
        ..fields.addAll(body)
        ..headers.addAll(_setHeaders())
        ..files.add(await http.MultipartFile.fromPath('image', filepath));
      var response = await request.send();
      final responseBody = await response.stream.bytesToString();
      print('RESPONSE BODY:   $responseBody');
      print('response${response.statusCode}');
      if (response.statusCode == 201) {
        return true;
      } else {
        return false;
      }

  }
  _setHeaders()=>{
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'X-API-KEY':'KeygH9vj6sMwkTP_MZBdEBGtM8g1ob3Go1uG5v',
    'Authorization':  'Basic KeygH9vj6sMwkTP_MZBdEBGtM8g1ob3Go1uG5v',
    'Authorization': 'Bearer KeygH9vj6sMwkTP_MZBdEBGtM8g1ob3Go1uG5v'

  };

  getallData(String apiurl) async {
    var fullUrl=_url+apiurl;
    return await http.get(
      Uri.parse(fullUrl),
      headers: _setHeaders(),
    );

  }


  Future<String> addImagedentist(Map<String, String> body, String filepath) async {
    String addimageUrl = '${_url}dentist/avatar';
    Map<String, String> headers = {
      'Content-Type': 'multipart/form-data',
    };
    var request = http.MultipartRequest('POST', Uri.parse(addimageUrl))
      ..fields.addAll(body)
      ..headers.addAll(headers)
      ..files.add(await http.MultipartFile.fromPath('image', filepath));
    var response = await request.send();
    final responseBody = await response.stream.bytesToString();
    print('RESPONSE BODY:   $responseBody');
    print('response${response.statusCode}');
return responseBody;

  }
  Future<bool> addImagegallory(Map<String, String> body, String filepath) async {
    String addimageUrl = '${_url}add/imagegallories';
    Map<String, String> headers = {
      'Content-Type': 'multipart/form-data',
    };
    var request = http.MultipartRequest('POST', Uri.parse(addimageUrl))
      ..fields.addAll(body)
      ..headers.addAll(headers)
      ..files.add(await http.MultipartFile.fromPath('image', filepath));
    var response = await request.send();
    final responseBody = await response.stream.bytesToString();
    print('RESPONSE BODY:   $responseBody');
    print('response${response.statusCode}');
    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }

  }

  addImageproduct(Map<String, String> body, String filepath) async {
    String addimageUrl = '${_url}product/addimage';
    var request = http.MultipartRequest('POST', Uri.parse(addimageUrl))
      ..fields.addAll(body)
      ..headers.addAll(_setHeaders())
      ..files.add(await http.MultipartFile.fromPath('image', filepath));
    var response = await request.send();
    final responseBody = await response.stream.bytesToString();
    print('RESPONSE BODY:   $responseBody');
    print('response${response.statusCode}');
    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }

  }

  addImagesproduct(Map<String, String> body, String filepath) async {
    String addimageUrl = '${_url}product/addimages';
    var request = http.MultipartRequest('POST', Uri.parse(addimageUrl))
      ..fields.addAll(body)
      ..headers.addAll(_setHeaders())
      ..files.add(await http.MultipartFile.fromPath('image', filepath));
    var response = await request.send();
    final responseBody = await response.stream.bytesToString();
    print('RESPONSE BODY:   $responseBody');
    print('response${response.statusCode}');
    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }

  }

}