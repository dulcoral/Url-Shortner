import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_shortner/data/app_repository.dart';
import 'package:url_shortner/data/app_repository_impl.dart';
import 'package:url_shortner/domain/entities/app_error.dart';
import 'package:url_shortner/domain/entities/shorten_url.dart';

final urlViewModelProvider =
    ChangeNotifierProvider((ref) => UrlViewModel(ref.read));

class UrlViewModel with ChangeNotifier {
  UrlViewModel(this._reader);

  final Reader _reader;

  late final AppRepository _repository = _reader(appRepositoryProvider);

  Either<AppError, ShortenUrl>? _result;

  Either<AppError, ShortenUrl>? get result => _result;

  Future<void> createUrlAlias(String url) async {
    await _repository
        .createUrlAlias(url: url)
        .then((value) => _result = value)
        .whenComplete(() => notifyListeners());
  }
}
