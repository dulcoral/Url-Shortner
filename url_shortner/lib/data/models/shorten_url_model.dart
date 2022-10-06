import 'package:equatable/equatable.dart';
import 'package:url_shortner/domain/entities.dart/shorten_url.dart';

class ShortenUrlModel extends Equatable {
  const ShortenUrlModel(
      {required this.alias, required this.self, required this.short});

  final String alias;
  final String self;
  final String short;

  factory ShortenUrlModel.fromJson(Map<String, dynamic> json) =>
      ShortenUrlModel(
          alias: json['alias'],
          self: json['_links']['self'],
          short: json['_links']['short']);

  Map<String, dynamic> toJson() => {
        '_links': {
          'self': self,
          'short': short,
        },
        'alias': alias
      };

  ShortenUrl toEntity() => ShortenUrl(alias: alias, self: self, short: short);

  @override
  List<Object?> get props => [alias, self, short];
}
