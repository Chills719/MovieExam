import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../models/media_content.dart';
import '../services/api_service.dart';

class ContentController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();

  final RxList<MediaContent> allContents = <MediaContent>[].obs;
  final RxList<MediaContent> movieContents = <MediaContent>[].obs;
  final RxList<MediaContent> personContents = <MediaContent>[].obs;
  final RxList<MediaContent> tvContents = <MediaContent>[].obs;
  
  final RxBool isAllLoading = true.obs;
  final RxBool isMovieLoading = true.obs;
  final RxBool isPersonLoading = true.obs;
  final RxBool isTvLoading = true.obs;
  
  final RxString allError = ''.obs;
  final RxString movieError = ''.obs;
  final RxString personError = ''.obs;
  final RxString tvError = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllContent();
  }

  // 获取所有内容
  Future<void> fetchAllContent() async {
    try {
      isAllLoading.value = true;
      allError.value = '';
      
      final contents = await _apiService.fetchTrendingAll();
      allContents.assignAll(contents);
    } catch (e) {
      allError.value = '获取数据失败: $e';
    } finally {
      isAllLoading.value = false;
    }
  }

  // 获取电影内容
  Future<void> fetchMovieContent() async {
    if (movieContents.isNotEmpty) return;
    
    try {
      isMovieLoading.value = true;
      movieError.value = '';
      
      final contents = await _apiService.fetchTrendingMovies();
      movieContents.assignAll(contents);
    } catch (e) {
      movieError.value = '获取电影数据失败: $e';
    } finally {
      isMovieLoading.value = false;
    }
  }

  // 获取人物内容
  Future<void> fetchPersonContent() async {
    if (personContents.isNotEmpty) return;
    
    try {
      isPersonLoading.value = true;
      personError.value = '';
      
      final contents = await _apiService.fetchTrendingPeople();
      personContents.assignAll(contents);
    } catch (e) {
      personError.value = '获取人物数据失败: $e';
    } finally {
      isPersonLoading.value = false;
    }
  }

  // 获取TV内容
  Future<void> fetchTvContent() async {
    if (tvContents.isNotEmpty) return;
    
    try {
      isTvLoading.value = true;
      tvError.value = '';
      
      final contents = await _apiService.fetchTrendingTv();
      tvContents.assignAll(contents);
    } catch (e) {
      tvError.value = '获取TV数据失败: $e';
    } finally {
      isTvLoading.value = false;
    }
  }

  // 刷新指定类型的内容
  Future<void> refreshContent(String contentType) async {
    switch (contentType) {
      case 'all':
        allContents.clear();
        await fetchAllContent();
        break;
      case 'movie':
        movieContents.clear();
        await fetchMovieContent();
        break;
      case 'person':
        personContents.clear();
        await fetchPersonContent();
        break;
      case 'tv':
        tvContents.clear();
        await fetchTvContent();
        break;
    }
  }

  // 根据类型获取对应的内容列表
  List<MediaContent> getContentsByType(String contentType) {
    switch (contentType) {
      case 'all':
        return allContents;
      case 'movie':
        return movieContents;
      case 'person':
        return personContents;
      case 'tv':
        return tvContents;
      default:
        return [];
    }
  }

  // 根据类型获取加载状态
  bool getLoadingStateByType(String contentType) {
    switch (contentType) {
      case 'all':
        return isAllLoading.value;
      case 'movie':
        return isMovieLoading.value;
      case 'person':
        return isPersonLoading.value;
      case 'tv':
        return isTvLoading.value;
      default:
        return false;
    }
  }

  // 根据类型获取错误信息
  String getErrorByType(String contentType) {
    switch (contentType) {
      case 'all':
        return allError.value;
      case 'movie':
        return movieError.value;
      case 'person':
        return personError.value;
      case 'tv':
        return tvError.value;
      default:
        return '';
    }
  }
}
