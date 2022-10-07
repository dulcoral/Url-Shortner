import 'package:dartz/dartz.dart';
import 'package:url_shortner/domain/entities/app_error.dart';
import 'package:url_shortner/domain/entities/shorten_url.dart';

abstract class AppRepository {
  Future<Either<AppError, ShortenUrl>> createUrlAlias({required String url});
  Future<Either<AppError, String>> retrievingLink({required String idAlias});
}
