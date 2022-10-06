import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_shortner/data/app_dio.dart';
import 'package:url_shortner/data/models/shorten_url_model.dart';
import 'package:url_shortner/data/models/url_model.dart';

final appServicesProvider = Provider((ref) => AppServices());

class AppServices {
  static AppServices? _instance;

  factory AppServices() => _instance ??= AppServices._();

  AppServices._();

  Future<ShortenUrlModel> createUrlAlias({required UrlModel urlModel}) async {
    var response =
        await AppDio.getInstance().post('/api/alias', data: urlModel);
    return ShortenUrlModel.fromJson(response.data);
  }

  Future<UrlModel> retrievingLink({required String idAlias}) async {
    var response = await AppDio.getInstance().post('/api/alias/$idAlias');
    return UrlModel.fromJson(response.data);
  }
}
