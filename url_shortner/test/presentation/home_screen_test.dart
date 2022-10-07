import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:url_shortner/constants/app_strings.dart';
import 'package:url_shortner/domain/entities/app_error.dart';
import 'package:url_shortner/domain/entities/shorten_url.dart';
import 'package:url_shortner/presentation/home_screen.dart';
import 'package:url_shortner/presentation/url_viewmodel.dart';

class MockViewModel extends Mock implements UrlViewModel {}

void main() {
  testWidgets("when enter a valid url then can shorten url",
      (WidgetTester tester) async {
    final mockViewModel = MockViewModel();
    when(() => mockViewModel.createUrlAlias("https://github.com/dulcoral"))
        .thenAnswer((_) => Future.value());
    when(() => mockViewModel.result).thenAnswer((_) => const Right(ShortenUrl(
        alias: "4323",
        self: "https://github.com/dulcoral",
        short: "https://shortUrl/4323")));

    await tester.pumpWidget(ProviderScope(overrides: [
      urlViewModelProvider.overrideWithValue(mockViewModel),
    ], child: const MaterialApp(home: HomeScreen())));

    await tester.enterText(
        find.byType(TextFormField), "https://github.com/dulcoral");
    final goShortUrl = find.byIcon(Icons.arrow_forward);
    await tester.tap(goShortUrl);

    expect(find.byType(SelectableText), findsNWidgets(2));
    expect(find.byType(Card), findsOneWidget);
    expect(find.text("https://shortUrl/4323"), findsOneWidget);
  });

  testWidgets("when enter a invalid url then show error",
      (WidgetTester tester) async {
    final mockViewModel = MockViewModel();

    await tester.pumpWidget(ProviderScope(overrides: [
      urlViewModelProvider.overrideWithValue(mockViewModel),
    ], child: const MaterialApp(home: HomeScreen())));

    await tester.enterText(find.byType(TextFormField), "hola");
    await tester.pumpAndSettle();

    expect(find.byType(SelectableText), findsNothing);
    expect(find.byType(Card), findsNothing);
    expect(find.text(AppStrings.errorTextInputUrl), findsOneWidget);
  });

  testWidgets(
      "when enter a invalid url and click arrow_forward then show snackbar error",
      (WidgetTester tester) async {
    final mockViewModel = MockViewModel();
    await tester.pumpWidget(ProviderScope(overrides: [
      urlViewModelProvider.overrideWithValue(mockViewModel),
    ], child: const MaterialApp(home: HomeScreen())));

    await tester.enterText(find.byType(TextFormField), "hola");
    final goShortUrl = find.byIcon(Icons.arrow_forward);
    await tester.tap(goShortUrl);
    await tester.pump();

    expect(find.byType(SelectableText), findsNothing);
    expect(find.byType(Card), findsNothing);
    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text(AppStrings.errorSnackErrorUrl), findsOneWidget);
  });

  testWidgets("when the service return error then show snackbar with error",
      (WidgetTester tester) async {
    final mockViewModel = MockViewModel();

    when(() => mockViewModel.createUrlAlias("https://github.com/dulcoral"))
        .thenAnswer((_) => Future.value());

    when(() => mockViewModel.result)
        .thenAnswer((_) => Left(AppError(Exception("error"))));

    await tester.pumpWidget(ProviderScope(overrides: [
      urlViewModelProvider.overrideWithValue(mockViewModel),
    ], child: const MaterialApp(home: HomeScreen())));

    await tester.enterText(
        find.byType(TextFormField), "https://github.com/dulcoral");

    final goShortUrl = find.byIcon(Icons.arrow_forward);
    await tester.tap(goShortUrl);
    await tester.pump();

    expect(find.byType(SelectableText), findsNothing);
    expect(find.byType(Card), findsNothing);
    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('AppError: Exception: error'), findsOneWidget);
  });
}
