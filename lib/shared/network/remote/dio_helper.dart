import 'package:dio/dio.dart';

class DioHelper{
  static Dio? dio;

  static init(){
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://student.valuxapps.com/api/',
        receiveDataWhenStatusError: true,
      ),
    );
  }

  static Future<Response> getData(
  {
    required String url,
    Map<String, dynamic>? query,
    String lang = 'en',
    String? authorization,
  })async
  {
    dio!.options.headers = {// create header over the previous one and add the lang
      'Content-Type':'application/json',
      'lang':lang,
      'Authorization':authorization??'',
    };

    return await dio!.get(url, queryParameters: query);
  }



  static Future<Response> postData(
      {
        required String url,
        Map<String, dynamic>? query,
        required Map<String, dynamic> data,
        String lang = 'en',
        String? authorization,
      })async
  {
    dio!.options.headers = {// create header over the previous one and add the lang
      'Content-Type':'application/json',
      'lang':lang,
        'Authorization':authorization??'',
      };
    return await dio!.post(
        url,
        queryParameters: query,
      data: data,
    );
  }

  static Future<Response> putData(
      {
        required String url,
        Map<String, dynamic>? query,
        required Map<String, dynamic> data,
        String lang = 'en',
        String? authorization,
      })async
  {
    dio!.options.headers = {// create header over the previous one and add the lang
      'Content-Type':'application/json',
      'lang':lang,
      'Authorization':authorization??'',
    };
    return await dio!.put(
      url,
      queryParameters: query,
      data: data,
    );
  }
}


