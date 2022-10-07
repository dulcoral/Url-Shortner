import 'package:equatable/equatable.dart';

class ShortenUrl extends Equatable {
  const ShortenUrl(
      {required this.alias, required this.self, required this.short});

  final String alias;
  final String self;
  final String short;

  @override
  List<Object?> get props => [alias, self, short];
}
