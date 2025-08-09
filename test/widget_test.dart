import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:test_exam/main.dart';

void main() {
  testWidgets('TMDB Explorer App intro test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('欢迎使用 TMDB Explorer'), findsOneWidget);
    expect(find.text('跳过'), findsOneWidget);
  });

  testWidgets('Main page test', (WidgetTester tester) async {
    await tester.pumpWidget(GetMaterialApp(
      home: const MainTabPage(),
    ));

    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('TMDB Explorer'), findsOneWidget);
    expect(find.text('All'), findsOneWidget);
    expect(find.text('Movies'), findsOneWidget);
    expect(find.text('People'), findsOneWidget);
    expect(find.text('TV'), findsOneWidget);
  });

  testWidgets('MediaContent model test', (WidgetTester tester) async {
    final movieJson = {
      'id': 1234821,
      'title': 'Jurassic World Rebirth',
      'overview': 'Five years after the events...',
      'poster_path': '/1RICxzeoNCAO5NpcRMIgg1XT6fm.jpg',
      'backdrop_path': '/fncHijpWjitFBmj7SX5z148XEhP.jpg',
      'media_type': 'movie',
      'popularity': 1140.9504,
      'release_date': '2025-07-01',
      'vote_average': 6.4,
      'vote_count': 1218,
      'original_language': 'en',
    };

    final movie = MediaContent.fromJson(movieJson);

    expect(movie.id, 1234821);
    expect(movie.title, 'Jurassic World Rebirth');
    expect(movie.mediaType, 'movie');
    expect(movie.voteAverage, 6.4);
    expect(movie.fullPosterUrl,
        'https://image.tmdb.org/t/p/w500/1RICxzeoNCAO5NpcRMIgg1XT6fm.jpg');
  });

  testWidgets('MediaContent person model test', (WidgetTester tester) async {
    final personJson = {
      'id': 1245,
      'name': 'Scarlett Johansson',
      'profile_path': '/6NsMbJXRlDZuDzatN2akFdGuTvx.jpg',
      'popularity': 123.456,
      'known_for_department': 'Acting',
      'media_type': 'person',
      'known_for': [
        {'title': 'Black Widow'},
        {'title': 'Avengers: Endgame'},
        {'name': 'Marriage Story'}
      ],
    };

    final person = MediaContent.fromJson(personJson);

    expect(person.id, 1245);
    expect(person.title, 'Scarlett Johansson');
    expect(person.mediaType, 'person');
    expect(person.popularity, 123.456);
    expect(person.knownForDepartment, 'Acting');
    expect(person.knownFor!.length, 3);
    expect(person.fullPosterUrl,
        'https://image.tmdb.org/t/p/w500/6NsMbJXRlDZuDzatN2akFdGuTvx.jpg');
  });
}
