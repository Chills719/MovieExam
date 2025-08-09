import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import 'package:intro_slider/intro_slider.dart';

void main() {
  runApp(const MyApp());
}

class MediaContent {
  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final String backdropPath;
  final String mediaType;
  final double popularity;
  final double voteAverage;
  final int voteCount;
  final String releaseDate;
  final String originalLanguage;

  final String? knownForDepartment;
  final List<String>? knownFor;

  final String? firstAirDate;
  final List<String>? originCountry;

  MediaContent({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.mediaType,
    required this.popularity,
    required this.voteAverage,
    required this.voteCount,
    required this.releaseDate,
    required this.originalLanguage,
    this.knownForDepartment,
    this.knownFor,
    this.firstAirDate,
    this.originCountry,
  });

  factory MediaContent.fromJson(Map<String, dynamic> json) {
    String mediaType = json['media_type'] ?? 'unknown';

    String title = '';
    if (mediaType == 'person') {
      title = json['name'] ?? '';
    } else if (mediaType == 'tv') {
      title = json['name'] ?? json['original_name'] ?? '';
    } else {
      title = json['title'] ?? json['original_title'] ?? '';
    }

    List<String>? knownForTitles;
    if (mediaType == 'person' && json['known_for'] != null) {
      knownForTitles = [];
      for (var item in json['known_for']) {
        String itemTitle = item['title'] ?? item['name'] ?? '';
        if (itemTitle.isNotEmpty) {
          knownForTitles.add(itemTitle);
        }
      }
    }

    List<String>? countries;
    if (json['origin_country'] != null) {
      countries = List<String>.from(json['origin_country']);
    }

    return MediaContent(
      id: json['id'] ?? 0,
      title: title,
      overview: json['overview'] ?? '',
      posterPath: json['poster_path'] ?? json['profile_path'] ?? '',
      backdropPath: json['backdrop_path'] ?? '',
      mediaType: mediaType,
      popularity: (json['popularity'] ?? 0).toDouble(),
      voteAverage: (json['vote_average'] ?? 0).toDouble(),
      voteCount: json['vote_count'] ?? 0,
      releaseDate: json['release_date'] ?? '',
      originalLanguage: json['original_language'] ?? '',
      knownForDepartment: json['known_for_department'],
      knownFor: knownForTitles,
      firstAirDate: json['first_air_date'],
      originCountry: countries,
    );
  }

  String get fullPosterUrl =>
      posterPath.isNotEmpty ? 'https://image.tmdb.org/t/p/w500$posterPath' : '';

  String get displayDate {
    if (mediaType == 'tv' && firstAirDate != null && firstAirDate!.isNotEmpty) {
      return firstAirDate!;
    }
    return releaseDate;
  }
}

class MovieDetail {
  final int id;
  final String title;
  final String originalTitle;
  final String overview;
  final String posterPath;
  final String backdropPath;
  final String releaseDate;
  final double voteAverage;
  final int voteCount;
  final double popularity;
  final int runtime;
  final String status;
  final String tagline;
  final List<Genre> genres;
  final List<ProductionCompany> productionCompanies;
  final List<ProductionCountry> productionCountries;
  final List<SpokenLanguage> spokenLanguages;
  final int budget;
  final int revenue;
  final String imdbId;
  final String homepage;

  MovieDetail({
    required this.id,
    required this.title,
    required this.originalTitle,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.releaseDate,
    required this.voteAverage,
    required this.voteCount,
    required this.popularity,
    required this.runtime,
    required this.status,
    required this.tagline,
    required this.genres,
    required this.productionCompanies,
    required this.productionCountries,
    required this.spokenLanguages,
    required this.budget,
    required this.revenue,
    required this.imdbId,
    required this.homepage,
  });

  factory MovieDetail.fromJson(Map<String, dynamic> json) {
    return MovieDetail(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      originalTitle: json['original_title'] ?? '',
      overview: json['overview'] ?? '',
      posterPath: json['poster_path'] ?? '',
      backdropPath: json['backdrop_path'] ?? '',
      releaseDate: json['release_date'] ?? '',
      voteAverage: (json['vote_average'] ?? 0).toDouble(),
      voteCount: json['vote_count'] ?? 0,
      popularity: (json['popularity'] ?? 0).toDouble(),
      runtime: json['runtime'] ?? 0,
      status: json['status'] ?? '',
      tagline: json['tagline'] ?? '',
      genres: (json['genres'] as List<dynamic>?)
              ?.map((g) => Genre.fromJson(g))
              .toList() ??
          [],
      productionCompanies: (json['production_companies'] as List<dynamic>?)
              ?.map((pc) => ProductionCompany.fromJson(pc))
              .toList() ??
          [],
      productionCountries: (json['production_countries'] as List<dynamic>?)
              ?.map((pc) => ProductionCountry.fromJson(pc))
              .toList() ??
          [],
      spokenLanguages: (json['spoken_languages'] as List<dynamic>?)
              ?.map((sl) => SpokenLanguage.fromJson(sl))
              .toList() ??
          [],
      budget: json['budget'] ?? 0,
      revenue: json['revenue'] ?? 0,
      imdbId: json['imdb_id'] ?? '',
      homepage: json['homepage'] ?? '',
    );
  }

  String get fullPosterUrl {
    if (posterPath.isEmpty) return '';
    return 'https://image.tmdb.org/t/p/w500$posterPath';
  }

  String get fullBackdropUrl {
    if (backdropPath.isEmpty) return '';
    return 'https://image.tmdb.org/t/p/w1280$backdropPath';
  }

  String get formattedRuntime {
    if (runtime <= 0) return '';
    final hours = runtime ~/ 60;
    final minutes = runtime % 60;
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }

  String get formattedBudget {
    if (budget <= 0) return '';
    if (budget >= 1000000) {
      return '\$${(budget / 1000000).toStringAsFixed(1)}M';
    }
    return '\$${budget.toString()}';
  }

  String get formattedRevenue {
    if (revenue <= 0) return '';
    if (revenue >= 1000000) {
      return '\$${(revenue / 1000000).toStringAsFixed(1)}M';
    }
    return '\$${revenue.toString()}';
  }
}

class Genre {
  final int id;
  final String name;

  Genre({required this.id, required this.name});

  factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }
}

class ProductionCompany {
  final int id;
  final String name;
  final String logoPath;
  final String originCountry;

  ProductionCompany({
    required this.id,
    required this.name,
    required this.logoPath,
    required this.originCountry,
  });

  factory ProductionCompany.fromJson(Map<String, dynamic> json) {
    return ProductionCompany(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      logoPath: json['logo_path'] ?? '',
      originCountry: json['origin_country'] ?? '',
    );
  }

  String get fullLogoUrl {
    if (logoPath.isEmpty) return '';
    return 'https://image.tmdb.org/t/p/w200$logoPath';
  }
}

class ProductionCountry {
  final String iso31661;
  final String name;

  ProductionCountry({required this.iso31661, required this.name});

  factory ProductionCountry.fromJson(Map<String, dynamic> json) {
    return ProductionCountry(
      iso31661: json['iso_3166_1'] ?? '',
      name: json['name'] ?? '',
    );
  }
}

class SpokenLanguage {
  final String englishName;
  final String iso6391;
  final String name;

  SpokenLanguage({
    required this.englishName,
    required this.iso6391,
    required this.name,
  });

  factory SpokenLanguage.fromJson(Map<String, dynamic> json) {
    return SpokenLanguage(
      englishName: json['english_name'] ?? '',
      iso6391: json['iso_639_1'] ?? '',
      name: json['name'] ?? '',
    );
  }
}

class PersonDetail {
  final int id;
  final String name;
  final String biography;
  final String birthday;
  final String? deathday;
  final int gender;
  final String knownForDepartment;
  final String placeOfBirth;
  final double popularity;
  final String profilePath;
  final bool adult;
  final List<String> alsoKnownAs;
  final String homepage;
  final String imdbId;

  PersonDetail({
    required this.id,
    required this.name,
    required this.biography,
    required this.birthday,
    this.deathday,
    required this.gender,
    required this.knownForDepartment,
    required this.placeOfBirth,
    required this.popularity,
    required this.profilePath,
    required this.adult,
    required this.alsoKnownAs,
    required this.homepage,
    required this.imdbId,
  });

  factory PersonDetail.fromJson(Map<String, dynamic> json) {
    return PersonDetail(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      biography: json['biography'] ?? '',
      birthday: json['birthday'] ?? '',
      deathday: json['deathday'],
      gender: json['gender'] ?? 0,
      knownForDepartment: json['known_for_department'] ?? '',
      placeOfBirth: json['place_of_birth'] ?? '',
      popularity: (json['popularity'] ?? 0).toDouble(),
      profilePath: json['profile_path'] ?? '',
      adult: json['adult'] ?? false,
      alsoKnownAs: (json['also_known_as'] as List<dynamic>?)
              ?.map((name) => name.toString())
              .toList() ??
          [],
      homepage: json['homepage'] ?? '',
      imdbId: json['imdb_id'] ?? '',
    );
  }

  String get fullProfileUrl {
    if (profilePath.isEmpty) return '';
    return 'https://image.tmdb.org/t/p/w500$profilePath';
  }

  String get genderText {
    switch (gender) {
      case 1:
        return '女性';
      case 2:
        return '男性';
      case 3:
        return '非二元性别';
      default:
        return '未指定';
    }
  }

  String get formattedBirthday {
    if (birthday.isEmpty) return '';
    try {
      final date = DateTime.parse(birthday);
      return '${date.year}年${date.month}月${date.day}日';
    } catch (e) {
      return birthday;
    }
  }

  String get formattedDeathday {
    if (deathday == null || deathday!.isEmpty) return '';
    try {
      final date = DateTime.parse(deathday!);
      return '${date.year}年${date.month}月${date.day}日';
    } catch (e) {
      return deathday!;
    }
  }

  int? get age {
    if (birthday.isEmpty) return null;
    try {
      final birthDate = DateTime.parse(birthday);
      final endDate = deathday != null && deathday!.isNotEmpty
          ? DateTime.parse(deathday!)
          : DateTime.now();
      return endDate.year - birthDate.year;
    } catch (e) {
      return null;
    }
  }

  String get ageText {
    final ageValue = age;
    if (ageValue == null) return '';
    if (deathday != null && deathday!.isNotEmpty) {
      return '$ageValue岁（已故）';
    }
    return '$ageValue岁';
  }
}

class ApiService extends GetxService {
  late Dio _dio;

  @override
  void onInit() {
    super.onInit();
    _initDio();
  }

  void _initDio() {
    _dio = Dio();

    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
    _dio.options.sendTimeout = const Duration(seconds: 30);

    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      logPrint: (obj) => debugPrint('DIO: $obj'),
    ));
  }

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

  String _getEndpoint(String contentType) {
    switch (contentType) {
      case 'all':
        return '/trending/all/day?language=en-US';
      case 'movie':
        return '/trending/movie/day?language=en-US';
      case 'person':
        return '/trending/person/day?language=en-US';
      case 'tv':
        return '/trending/tv/day?language=en-US';
      default:
        return '/trending/all/day?language=en-US';
    }
  }

  Future<List<MediaContent>> fetchContent(String contentType) async {
    try {
      debugPrint('开始请求$contentType数据...');

      final response = await _dio.get(
        'https://try.readme.io/https://api.themoviedb.org/3${_getEndpoint(contentType)}',
        options: Options(headers: _getBrowserHeaders()),
      );

      debugPrint('请求完成，状态码: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = response.data;
        final List<dynamic> results = data['results'];

        debugPrint('获取到 ${results.length} 条内容');

        return results.map((json) => MediaContent.fromJson(json)).toList();
      } else {
        throw Exception('获取数据失败: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('请求出错: $e');
      throw Exception('网络错误: $e');
    }
  }

  Future<List<MediaContent>> searchMovies(String query, {int page = 1}) async {
    try {
      debugPrint('开始搜索电影: $query');

      final response = await _dio.get(
        'https://try.readme.io/https://api.themoviedb.org/3/search/movie',
        queryParameters: {
          'query': query,
          'language': 'en-US',
          'page': page,
          'include_adult': false,
        },
        options: Options(headers: _getBrowserHeaders()),
      );

      debugPrint('搜索完成，状态码: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = response.data;
        final List<dynamic> results = data['results'];

        debugPrint('搜索到 ${results.length} 部电影');

        return results.map((json) => MediaContent.fromJson(json)).toList();
      } else {
        throw Exception('搜索失败: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('搜索出错: $e');
      throw Exception('搜索错误: $e');
    }
  }

  Future<MovieDetail> getMovieDetail(int movieId) async {
    try {
      debugPrint('开始获取电影详情: $movieId');

      final response = await _dio.get(
        'https://try.readme.io/https://api.themoviedb.org/3/movie/$movieId',
        queryParameters: {
          'language': 'en-US',
        },
        options: Options(headers: _getBrowserHeaders()),
      );

      debugPrint('电影详情请求完成，状态码: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = response.data;
        debugPrint('获取到电影详情: ${data['title']}');

        return MovieDetail.fromJson(data);
      } else {
        throw Exception('获取电影详情失败: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('获取电影详情出错: $e');
      throw Exception('获取电影详情错误: $e');
    }
  }

  Future<PersonDetail> getPersonDetail(int personId) async {
    try {
      debugPrint('开始获取人物详情: $personId');

      final response = await _dio.get(
        'https://try.readme.io/https://api.themoviedb.org/3/person/$personId',
        queryParameters: {
          'language': 'en-US',
        },
        options: Options(headers: _getBrowserHeaders()),
      );

      debugPrint('人物详情请求完成，状态码: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = response.data;
        debugPrint('获取到人物详情: ${data['name']}');

        return PersonDetail.fromJson(data);
      } else {
        throw Exception('获取人物详情失败: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('获取人物详情出错: $e');
      throw Exception('获取人物详情错误: $e');
    }
  }
}

class ContentController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();

  final RxList<MediaContent> contents = <MediaContent>[].obs;
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;
  final String contentType;

  ContentController(this.contentType);

  @override
  void onInit() {
    super.onInit();
    fetchContent();
  }

  Future<void> fetchContent() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await _apiService.fetchContent(contentType);
      contents.value = result;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void retry() {
    fetchContent();
  }
}

class SearchController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();

  final RxList<MediaContent> searchResults = <MediaContent>[].obs;
  final RxBool isSearching = false.obs;
  final RxString searchQuery = ''.obs;
  final RxBool showSearchResults = false.obs;

  Future<void> searchMovies(String query) async {
    if (query.trim().isEmpty) {
      clearSearch();
      return;
    }

    try {
      isSearching.value = true;
      searchQuery.value = query;

      final results = await _apiService.searchMovies(query);
      searchResults.value = results;
      showSearchResults.value = true;
    } catch (e) {
      searchResults.clear();
      Get.snackbar(
        '搜索错误',
        e.toString(),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
    } finally {
      isSearching.value = false;
    }
  }

  void clearSearch() {
    searchResults.clear();
    searchQuery.value = '';
    showSearchResults.value = false;
    isSearching.value = false;
  }
}

class MovieDetailController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();

  final Rx<MovieDetail?> movieDetail = Rx<MovieDetail?>(null);
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;

  Future<void> loadMovieDetail(int movieId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final detail = await _apiService.getMovieDetail(movieId);
      movieDetail.value = detail;
    } catch (e) {
      errorMessage.value = e.toString();
      movieDetail.value = null;
    } finally {
      isLoading.value = false;
    }
  }

  void retry(int movieId) {
    loadMovieDetail(movieId);
  }
}

class PersonDetailController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();

  final Rx<PersonDetail?> personDetail = Rx<PersonDetail?>(null);
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;

  Future<void> loadPersonDetail(int personId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final detail = await _apiService.getPersonDetail(personId);
      personDetail.value = detail;
    } catch (e) {
      errorMessage.value = e.toString();
      personDetail.value = null;
    } finally {
      isLoading.value = false;
    }
  }

  void retry(int personId) {
    loadPersonDetail(personId);
  }
}

class IntroController extends GetxController {
  final RxBool isFirstTime = true.obs;

  @override
  void onInit() {
    super.onInit();
    checkFirstTime();
  }

  void checkFirstTime() {
    isFirstTime.value = true;
  }

  void completeIntro() {
    isFirstTime.value = false;
    Get.offAll(() => const MainTabPage());
  }
}

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(IntroController());

    return IntroSlider(
      key: UniqueKey(),
      listContentConfig: [
        ContentConfig(
          title: "欢迎使用 TMDB Explorer",
          description: "探索最新最热门的电影、电视剧和明星信息",
          pathImage: null,
          backgroundColor: const Color(0xff203152),
          styleTitle: const TextStyle(
            color: Colors.white,
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
          ),
          styleDescription: const TextStyle(
            color: Colors.white,
            fontSize: 18.0,
            fontStyle: FontStyle.italic,
          ),
        ),
        ContentConfig(
          title: "发现热门内容",
          description: "浏览当日最热门的电影、电视剧和明星",
          pathImage: null,
          backgroundColor: const Color(0xff40175A),
          styleTitle: const TextStyle(
            color: Colors.white,
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
          ),
          styleDescription: const TextStyle(
            color: Colors.white,
            fontSize: 18.0,
            fontStyle: FontStyle.italic,
          ),
        ),
        ContentConfig(
          title: "搜索功能",
          description: "快速搜索您喜欢的电影和明星",
          pathImage: null,
          backgroundColor: const Color(0xff6A1B9A),
          styleTitle: const TextStyle(
            color: Colors.white,
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
          ),
          styleDescription: const TextStyle(
            color: Colors.white,
            fontSize: 18.0,
            fontStyle: FontStyle.italic,
          ),
        ),
        ContentConfig(
          title: "详细信息",
          description: "查看电影详情、演员信息和更多精彩内容",
          pathImage: null,
          backgroundColor: const Color(0xff01579B),
          styleTitle: const TextStyle(
            color: Colors.white,
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
          ),
          styleDescription: const TextStyle(
            color: Colors.white,
            fontSize: 18.0,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
      onDonePress: () => controller.completeIntro(),
      onSkipPress: () => controller.completeIntro(),
      renderSkipBtn: const Text(
        "跳过",
        style: TextStyle(
          color: Colors.white,
          fontSize: 16.0,
        ),
      ),
      renderNextBtn: const Icon(
        Icons.navigate_next,
        color: Colors.white,
        size: 35.0,
      ),
      renderDoneBtn: const Text(
        "开始使用",
        style: TextStyle(
          color: Colors.white,
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      indicatorConfig: IndicatorConfig(
        colorIndicator: Colors.white.withValues(alpha: 0.3),
        colorActiveIndicator: Colors.white,
        sizeIndicator: 13.0,
        typeIndicatorAnimation: TypeIndicatorAnimation.sizeTransition,
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ApiService());
    Get.put(SearchController());

    return GetMaterialApp(
      title: 'TMDB Explorer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AppInitializer(),
    );
  }
}

class AppInitializer extends StatelessWidget {
  const AppInitializer({super.key});

  @override
  Widget build(BuildContext context) {
    final introController = Get.put(IntroController());

    return Obx(() {
      if (introController.isFirstTime.value) {
        return const IntroPage();
      } else {
        return const MainTabPage();
      }
    });
  }
}

class MainTabPage extends StatefulWidget {
  const MainTabPage({super.key});

  @override
  State<MainTabPage> createState() => _MainTabPageState();
}

class _MainTabPageState extends State<MainTabPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('TMDB Explorer'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: MovieSearchDelegate(),
              );
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Movies'),
            Tab(text: 'People'),
            Tab(text: 'TV'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ContentView(contentType: 'all'),
          ContentView(contentType: 'movie'),
          ContentView(contentType: 'person'),
          ContentView(contentType: 'tv'),
        ],
      ),
    );
  }
}

class MovieSearchDelegate extends SearchDelegate<String> {
  final SearchController searchController = Get.find<SearchController>();

  @override
  String get searchFieldLabel => '搜索电影...';

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
            searchController.clearSearch();
          },
        ),
      TextButton(
        onPressed: query.trim().isNotEmpty
            ? () {
                _performSearch(context);
                showResults(context);
              }
            : null,
        child: Text(
          '搜索',
          style: TextStyle(
            color: query.trim().isNotEmpty ? Colors.blue : Colors.grey,
            fontSize: 16,
          ),
        ),
      ),
    ];
  }

  void _performSearch(BuildContext context) {
    if (query.trim().isNotEmpty) {
      FocusScope.of(context).unfocus();
      searchController.searchMovies(query.trim());
    }
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        searchController.clearSearch();
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Obx(() {
        if (searchController.isSearching.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (searchController.searchResults.isEmpty &&
            !searchController.showSearchResults.value) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search,
                  size: 64,
                  color: Colors.grey,
                ),
                SizedBox(height: 16),
                Text(
                  '输入电影名称，然后点击搜索按钮或按回车键',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        if (searchController.searchResults.isEmpty &&
            searchController.showSearchResults.value) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.movie_filter,
                  size: 64,
                  color: Colors.grey,
                ),
                SizedBox(height: 16),
                Text(
                  '没有找到相关电影',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: searchController.searchResults.length,
          itemBuilder: (context, index) {
            final movie = searchController.searchResults[index];
            return _buildSearchResultCard(movie, context);
          },
        );
      }),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.movie,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              '输入电影名称进行搜索',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '点击右上角的"搜索"按钮或按回车键开始搜索',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResultCard(MediaContent movie, BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: movie.fullPosterUrl.isNotEmpty
              ? Image.network(
                  movie.fullPosterUrl,
                  width: 40,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 40,
                      height: 60,
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.movie,
                        color: Colors.grey,
                      ),
                    );
                  },
                )
              : Container(
                  width: 40,
                  height: 60,
                  color: Colors.grey[300],
                  child: const Icon(
                    Icons.movie,
                    color: Colors.grey,
                  ),
                ),
        ),
        title: Text(
          movie.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (movie.displayDate.isNotEmpty)
              Text(
                '上映日期: ${movie.displayDate}',
                style: const TextStyle(fontSize: 12),
              ),
            Row(
              children: [
                const Icon(
                  Icons.star,
                  size: 14,
                  color: Colors.amber,
                ),
                const SizedBox(width: 4),
                Text(
                  movie.voteAverage.toStringAsFixed(1),
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ],
        ),
        onTap: () {
          close(context, movie.title);
          Get.to(() => MovieDetailPage(movieId: movie.id));
        },
      ),
    );
  }
}

class MovieDetailPage extends StatelessWidget {
  final int movieId;

  const MovieDetailPage({super.key, required this.movieId});

  @override
  Widget build(BuildContext context) {
    final controller =
        Get.put(MovieDetailController(), tag: movieId.toString());

    controller.loadMovieDetail(movieId);

    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red[300],
                ),
                const SizedBox(height: 16),
                Text(
                  controller.errorMessage.value,
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => controller.retry(movieId),
                  child: const Text('重试'),
                ),
              ],
            ),
          );
        }

        final movie = controller.movieDetail.value;
        if (movie == null) {
          return const Center(
            child: Text('电影详情不存在'),
          );
        }

        return CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 300,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  movie.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        offset: Offset(1, 1),
                        blurRadius: 3,
                        color: Colors.black54,
                      ),
                    ],
                  ),
                ),
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    movie.fullBackdropUrl.isNotEmpty
                        ? Image.network(
                            movie.fullBackdropUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[300],
                                child: const Icon(
                                  Icons.movie,
                                  size: 64,
                                  color: Colors.grey,
                                ),
                              );
                            },
                          )
                        : Container(
                            color: Colors.grey[300],
                            child: const Icon(
                              Icons.movie,
                              size: 64,
                              color: Colors.grey,
                            ),
                          ),
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black54,
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: movie.fullPosterUrl.isNotEmpty
                              ? Image.network(
                                  movie.fullPosterUrl,
                                  width: 120,
                                  height: 180,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: 120,
                                      height: 180,
                                      color: Colors.grey[300],
                                      child: const Icon(
                                        Icons.movie,
                                        size: 40,
                                        color: Colors.grey,
                                      ),
                                    );
                                  },
                                )
                              : Container(
                                  width: 120,
                                  height: 180,
                                  color: Colors.grey[300],
                                  child: const Icon(
                                    Icons.movie,
                                    size: 40,
                                    color: Colors.grey,
                                  ),
                                ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                movie.title,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (movie.originalTitle != movie.title)
                                Text(
                                  movie.originalTitle,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              const SizedBox(height: 8),
                              if (movie.tagline.isNotEmpty)
                                Text(
                                  movie.tagline,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[700],
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.star,
                                    size: 20,
                                    color: Colors.amber,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${movie.voteAverage.toStringAsFixed(1)} (${movie.voteCount})',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              if (movie.releaseDate.isNotEmpty)
                                Text(
                                  '上映日期: ${movie.releaseDate}',
                                  style: const TextStyle(fontSize: 14),
                                ),
                              if (movie.formattedRuntime.isNotEmpty)
                                Text(
                                  '时长: ${movie.formattedRuntime}',
                                  style: const TextStyle(fontSize: 14),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    if (movie.genres.isNotEmpty)
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: movie.genres.map((genre) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.blue),
                            ),
                            child: Text(
                              genre.name,
                              style: const TextStyle(
                                color: Colors.blue,
                                fontSize: 12,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    const SizedBox(height: 24),
                    if (movie.overview.isNotEmpty) ...[
                      const Text(
                        '剧情简介',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        movie.overview,
                        style: const TextStyle(fontSize: 16, height: 1.5),
                      ),
                      const SizedBox(height: 24),
                    ],
                    _buildInfoSection('制作信息', [
                      if (movie.status.isNotEmpty) '状态: ${movie.status}',
                      if (movie.formattedBudget.isNotEmpty)
                        '预算: ${movie.formattedBudget}',
                      if (movie.formattedRevenue.isNotEmpty)
                        '票房: ${movie.formattedRevenue}',
                    ]),
                    const SizedBox(height: 16),
                    if (movie.productionCompanies.isNotEmpty)
                      _buildInfoSection(
                          '制作公司',
                          movie.productionCompanies
                              .map((company) => company.name)
                              .toList()),
                    const SizedBox(height: 16),
                    if (movie.productionCountries.isNotEmpty)
                      _buildInfoSection(
                          '制作国家',
                          movie.productionCountries
                              .map((country) => country.name)
                              .toList()),
                    const SizedBox(height: 16),
                    if (movie.spokenLanguages.isNotEmpty)
                      _buildInfoSection(
                          '语言',
                          movie.spokenLanguages
                              .map((lang) => lang.englishName)
                              .toList()),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildInfoSection(String title, List<String> items) {
    if (items.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ...items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                '• $item',
                style: const TextStyle(fontSize: 14),
              ),
            )),
      ],
    );
  }
}

class PersonDetailPage extends StatelessWidget {
  final int personId;

  const PersonDetailPage({super.key, required this.personId});

  @override
  Widget build(BuildContext context) {
    final controller =
        Get.put(PersonDetailController(), tag: personId.toString());

    controller.loadPersonDetail(personId);

    return Scaffold(
      appBar: AppBar(
        title: const Text('人物详情'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red[300],
                ),
                const SizedBox(height: 16),
                Text(
                  controller.errorMessage.value,
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => controller.retry(personId),
                  child: const Text('重试'),
                ),
              ],
            ),
          );
        }

        final person = controller.personDetail.value;
        if (person == null) {
          return const Center(
            child: Text('人物详情不存在'),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: person.fullProfileUrl.isNotEmpty
                        ? Image.network(
                            person.fullProfileUrl,
                            width: 150,
                            height: 200,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 150,
                                height: 200,
                                color: Colors.grey[300],
                                child: const Icon(
                                  Icons.person,
                                  size: 60,
                                  color: Colors.grey,
                                ),
                              );
                            },
                          )
                        : Container(
                            width: 150,
                            height: 200,
                            color: Colors.grey[300],
                            child: const Icon(
                              Icons.person,
                              size: 60,
                              color: Colors.grey,
                            ),
                          ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          person.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (person.knownForDepartment.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.blue),
                            ),
                            child: Text(
                              person.knownForDepartment,
                              style: const TextStyle(
                                color: Colors.blue,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        const SizedBox(height: 12),
                        _buildInfoRow('性别', person.genderText),
                        if (person.formattedBirthday.isNotEmpty)
                          _buildInfoRow('出生日期', person.formattedBirthday),
                        if (person.formattedDeathday.isNotEmpty)
                          _buildInfoRow('逝世日期', person.formattedDeathday),
                        if (person.ageText.isNotEmpty)
                          _buildInfoRow('年龄', person.ageText),
                        if (person.placeOfBirth.isNotEmpty)
                          _buildInfoRow('出生地', person.placeOfBirth),
                        _buildInfoRow(
                            '人气指数', person.popularity.toStringAsFixed(1)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              if (person.alsoKnownAs.isNotEmpty) ...[
                const Text(
                  '别名',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: person.alsoKnownAs.map((alias) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Text(
                        alias,
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
              ],
              if (person.biography.isNotEmpty) ...[
                const Text(
                  '个人简介',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  person.biography,
                  style: const TextStyle(fontSize: 16, height: 1.5),
                ),
                const SizedBox(height: 24),
              ],
              if (person.homepage.isNotEmpty || person.imdbId.isNotEmpty) ...[
                const Text(
                  '外部链接',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                if (person.homepage.isNotEmpty)
                  _buildLinkButton('官方网站', person.homepage, Icons.web),
                if (person.imdbId.isNotEmpty)
                  _buildLinkButton(
                      'IMDb',
                      'https://www.imdb.com/name/${person.imdbId}/',
                      Icons.movie),
              ],
            ],
          ),
        );
      }),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    if (value.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLinkButton(String label, String url, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () {
          Get.snackbar(
            '链接',
            url,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.blue.withValues(alpha: 0.8),
            colorText: Colors.white,
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.blue.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.blue),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 20, color: Colors.blue),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ContentView extends StatelessWidget {
  final String contentType;

  const ContentView({super.key, required this.contentType});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      ContentController(contentType),
      tag: contentType,
    );

    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      if (controller.errorMessage.value.isNotEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red[300],
              ),
              const SizedBox(height: 16),
              Text(
                controller.errorMessage.value,
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: controller.retry,
                child: const Text('重试'),
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: controller.fetchContent,
        child: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: controller.contents.length,
          itemBuilder: (context, index) {
            final content = controller.contents[index];
            return _buildContentCard(content);
          },
        ),
      );
    });
  }

  Widget _buildContentCard(MediaContent content) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      elevation: 4,
      child: InkWell(
        onTap: () {
          if (content.mediaType == 'movie') {
            Get.to(() => MovieDetailPage(movieId: content.id));
          } else if (content.mediaType == 'person') {
            Get.to(() => PersonDetailPage(personId: content.id));
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: content.fullPosterUrl.isNotEmpty
                    ? Image.network(
                        content.fullPosterUrl,
                        width: 80,
                        height: 120,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 80,
                            height: 120,
                            color: Colors.grey[300],
                            child: Icon(
                              _getIconForMediaType(content.mediaType),
                              size: 40,
                              color: Colors.grey,
                            ),
                          );
                        },
                      )
                    : Container(
                        width: 80,
                        height: 120,
                        color: Colors.grey[300],
                        child: Icon(
                          _getIconForMediaType(content.mediaType),
                          size: 40,
                          color: Colors.grey,
                        ),
                      ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: _getColorForMediaType(content.mediaType),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            content.mediaType.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            content.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    if (content.displayDate.isNotEmpty)
                      Text(
                        '${content.mediaType == 'tv' ? '首播' : '上映'}日期: ${content.displayDate}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          size: 16,
                          color: Colors.amber,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${content.voteAverage.toStringAsFixed(1)} (${content.voteCount})',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Icon(
                          Icons.trending_up,
                          size: 16,
                          color: Colors.orange,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          content.popularity.toStringAsFixed(1),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (content.mediaType == 'person' &&
                        content.knownFor != null &&
                        content.knownFor!.isNotEmpty)
                      Text(
                        '代表作品: ${content.knownFor!.take(3).join(', ')}',
                        style: const TextStyle(fontSize: 14),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      )
                    else if (content.overview.isNotEmpty)
                      Text(
                        content.overview,
                        style: const TextStyle(fontSize: 14),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIconForMediaType(String mediaType) {
    switch (mediaType) {
      case 'movie':
        return Icons.movie;
      case 'tv':
        return Icons.tv;
      case 'person':
        return Icons.person;
      default:
        return Icons.help_outline;
    }
  }

  Color _getColorForMediaType(String mediaType) {
    switch (mediaType) {
      case 'movie':
        return Colors.blue;
      case 'tv':
        return Colors.green;
      case 'person':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
