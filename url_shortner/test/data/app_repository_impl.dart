import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:url_shortner/data/app_repository_impl.dart';
import 'package:url_shortner/data/app_services.dart';
import 'package:url_shortner/data/models/shorten_url_model.dart';
import 'package:url_shortner/data/models/url_model.dart';
import 'package:url_shortner/domain/entities/app_error.dart';
import 'package:url_shortner/domain/entities/shorten_url.dart';

class MockAppServices extends Mock implements AppServices {}

void main() {
  test('Verify the entity convertion if service return success', () async {
    final mockService = MockAppServices();
    AppRepositoryImpl repository = AppRepositoryImpl(mockService);
    when(() => mockService.createUrlAlias(
            urlModel: const UrlModel(url: 'https://github.com/dulcoral')))
        .thenAnswer((_) => Future.value(const ShortenUrlModel(
            alias: "4323",
            self: "https://github.com/dulcoral",
            short: "https://shortUrl/4323")));
    final response =
        await repository.createUrlAlias(url: 'https://github.com/dulcoral');

    expect(
        response,
        equals(const Right(ShortenUrl(
            alias: "4323",
            self: "https://github.com/dulcoral",
            short: "https://shortUrl/4323"))));
  });

  test('Verify the entity convertion if service return error', () async {
    final mockService = MockAppServices();
    AppRepositoryImpl repository = AppRepositoryImpl(mockService);
    when(() => mockService.createUrlAlias(
            urlModel: const UrlModel(url: 'https://github.com/dulcoral')))
        .thenAnswer((_) => throw Exception("error"));

    final response =
        await repository.createUrlAlias(url: 'https://github.com/dulcoral');

    response.fold(
        (r) => null,
        (resultL) => Left(AppError(Exception("error")))
            .fold((l) => expect(resultL, l), (r) => null));
  });
}
