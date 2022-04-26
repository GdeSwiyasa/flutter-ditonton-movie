import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv/tv.dart';
import 'package:ditonton/presentation/pages/tv/popular_tv_page.dart';
import 'package:ditonton/presentation/provider/tv/tv_popular_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'popular_tv_shows_page_test.mocks.dart';

@GenerateMocks([PopularTVNotifier])
void main() {
  late MockPopularTVShowsNotifier mockNotifier;

  setUp(() {
    mockNotifier = MockPopularTVShowsNotifier();
  });

  Widget _makeTestableWidget(Widget body) {
    return ChangeNotifierProvider<PopularTVNotifier>.value(
      value: mockNotifier,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  group('Widget Popular TV Shows', () {
    testWidgets('Page should display center progress bar when loading',
        (WidgetTester tester) async {
      when(mockNotifier.requestState).thenReturn(RequestState.Loading);

      final progressBarFinder = find.byType(CircularProgressIndicator);
      final centerFinder = find.byType(Center);

      await tester.pumpWidget(_makeTestableWidget(PopularTvPage()));

      expect(centerFinder, findsOneWidget);
      expect(progressBarFinder, findsOneWidget);
    });
    testWidgets('Page should display AppBar when data is loaded',
        (WidgetTester tester) async {
      when(mockNotifier.requestState).thenReturn(RequestState.Loaded);
      when(mockNotifier.popularTVShows).thenReturn(testTVShowList);

      await tester.pumpWidget(_makeTestableWidget(PopularTvPage()));

      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('Popular TV'), findsOneWidget);
    });

    testWidgets('Page should display ListView when data is loaded',
        (WidgetTester tester) async {
      when(mockNotifier.requestState).thenReturn(RequestState.Loaded);
      when(mockNotifier.popularTVShows).thenReturn(<Tv>[]);

      final listViewFinder = find.byType(ListView);

      await tester.pumpWidget(_makeTestableWidget(PopularTvPage()));

      expect(listViewFinder, findsOneWidget);
    });

    testWidgets('Page should display text with message when Error',
        (WidgetTester tester) async {
      when(mockNotifier.requestState).thenReturn(RequestState.Error);
      when(mockNotifier.message).thenReturn('Error message');

      final textFinder = find.byKey(Key('error_message'));

      await tester.pumpWidget(_makeTestableWidget(PopularTvPage()));

      expect(textFinder, findsOneWidget);
    });
  });
}