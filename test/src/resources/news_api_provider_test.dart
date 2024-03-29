import 'package:news/src/resources/news_api_provider.dart';
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';

void main() {
  test('fetchTopIds returns a list of ids', () async {
    // Set up
    final newsApi = NewsApiProvider();

    newsApi.client = MockClient((request) async {
      return Response(json.encode([1, 2, 3, 4]), 200);
    });

    final ids = await newsApi.fetchTopIds();

    // Expectation
    expect(ids, [1, 2, 3, 4]);
  });

  test('fetchItem returns an item model', () async {
    // Set up
    final newsApi = NewsApiProvider();

    newsApi.client = MockClient((request) async {
      final jsonMap = {'id': 123};

      return Response(json.encode(jsonMap), 200);
    });

    final item = await newsApi.fetchItem(999);

    // Expectation
    expect(item.id, 123);
  });
}
