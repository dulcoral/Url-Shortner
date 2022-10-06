import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_shortner/domain/entities.dart/app_error.dart';
import 'package:url_shortner/data/app_repository.dart';
import 'package:url_shortner/data/app_services.dart';
import 'package:url_shortner/data/models/url_model.dart';
import 'package:url_shortner/domain/entities.dart/shorten_url.dart';

final appRepositoryProvider = Provider<AppRepository>(
    (ref) => AppRepositoryImpl(ref.read(appServicesProvider)));

class AppRepositoryImpl implements AppRepository {
  AppRepositoryImpl(this._service);

  final AppServices _service;

  @override
  Future<Either<AppError, ShortenUrl>> createUrlAlias(
      {required String url}) async {
    try {
      final response =
          await _service.createUrlAlias(urlModel: UrlModel(url: url));
      return Right(response.toEntity());
    } on Exception catch (e) {
      return Left(AppError(e));
    }
  }

  @override
  Future<Either<AppError, String>> retrievingLink(
      {required String idAlias}) async {
    try {
      final response = await _service.retrievingLink(idAlias: idAlias);
      return Right(response.url);
    } on Exception catch (e) {
      return Left(AppError(e));
    }
  }
}
