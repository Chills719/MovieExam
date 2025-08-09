import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart' hide Response;
import '../models/media_content.dart';

class ApiService extends GetxService {
  late Dio _dio;

  @override
  void onInit() {
    super.onInit();
    _initializeDio();
  }

  void _initializeDio() {
    _dio = Dio();

    // 配置超时时间
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
    _dio.options.sendTimeout = const Duration(seconds: 30);

    // 添加拦截器来打印请求和响应信息
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      logPrint: (obj) => debugPrint('DIO: $obj'),
    ));
  }

  // 封装完整的浏览器headers
  Map<String, String> _getBrowserHeaders() {
    return {
      'accept': 'application/json',
      'accept-encoding': 'gzip, deflate, br, zstd',
      'accept-language': 'zh-CN,zh;q=0.9,vi;q=0.8,ko;q=0.7,en;q=0.6',
      'authorization':
          'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJkMjczMzRhYWJlNGUyZGZlMTRjNTZiMjY4Y2Q3ZTViYyIsIm5iZiI6MTc1NDU5MzU3MC45Mjk5OTk4LCJzdWIiOiI2ODk0ZjkyMjdlMWUyZGViNzdhMzJlMTAiLCJzY29wZXMiOlsiYXBpX3JlYWQiXSwidmVyc2lvbiI6MX0.PkEZf_GWcgRg3mzBQAZ8dmBeZmme5YrrqLk-ic9yDCk',
      'dnt': '1',
      'origin': 'https://developer.themoviedb.org',
      'referer': 'https://developer.themoviedb.org/',
      'sec-ch-ua':
          '"Not)A;Brand";v="8", "Chromium";v="138", "Google Chrome";v="138"',
      'sec-ch-ua-mobile': '?0',
      'sec-ch-ua-platform': '"Windows"',
      'sec-fetch-dest': 'empty',
      'sec-fetch-mode': 'cors',
      'sec-fetch-site': 'cross-site',
      'user-agent':
          'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36',
      'x-readme-api-explorer': '5.437.1',
    };
  }

  // 封装API请求方法
  Future<Response> _makeApiRequest(String endpoint) async {
    return await _dio.get(
      'https://try.readme.io/https://api.themoviedb.org/3$endpoint',
      options: Options(
        headers: _getBrowserHeaders(),
      ),
    );
  }

  // 获取热门所有内容
  Future<List<MediaContent>> fetchTrendingAll() async {
    try {
      debugPrint('开始请求所有热门内容...');

      final response =
          await _makeApiRequest('/trending/all/day?language=en-US');

      if (response.statusCode == 200) {
        final data = response.data;
        final List<dynamic> results = data['results'];

        debugPrint('获取到 ${results.length} 条所有内容');

        return results.map((json) => MediaContent.fromJson(json)).toList();
      } else {
        throw Exception('获取数据失败: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('请求所有内容出错: $e');
      rethrow;
    }
  }

  // 获取热门电影
  Future<List<MediaContent>> fetchTrendingMovies() async {
    try {
      debugPrint('开始请求热门电影...');

      final response =
          await _makeApiRequest('/trending/movie/day?language=en-US');

      if (response.statusCode == 200) {
        final data = response.data;
        final List<dynamic> results = data['results'];

        debugPrint('获取到 ${results.length} 部热门电影');

        return results.map((json) => MediaContent.fromJson(json)).toList();
      } else {
        throw Exception('获取电影数据失败: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('请求电影内容出错: $e');
      rethrow;
    }
  }

  // 获取热门人物
  Future<List<MediaContent>> fetchTrendingPeople() async {
    try {
      debugPrint('开始请求热门人物...');

      final response =
          await _makeApiRequest('/trending/person/day?language=en-US');

      if (response.statusCode == 200) {
        final data = response.data;
        final List<dynamic> results = data['results'];

        debugPrint('获取到 ${results.length} 位热门人物');

        return results.map((json) => MediaContent.fromJson(json)).toList();
      } else {
        throw Exception('获取人物数据失败: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('请求人物内容出错: $e');
      rethrow;
    }
  }

  // 获取热门TV
  Future<List<MediaContent>> fetchTrendingTv() async {
    try {
      debugPrint('开始请求热门TV...');

      final response = await _makeApiRequest('/trending/tv/day?language=en-US');

      if (response.statusCode == 200) {
        final data = response.data;
        final List<dynamic> results = data['results'];

        debugPrint('获取到 ${results.length} 部热门TV');

        return results.map((json) => MediaContent.fromJson(json)).toList();
      } else {
        throw Exception('获取TV数据失败: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('请求TV内容出错: $e');
      rethrow;
    }
  }
}
