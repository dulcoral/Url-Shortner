import 'package:equatable/equatable.dart';

class UrlModel extends Equatable {
  const UrlModel({required this.url});

  final String url;

  factory UrlModel.fromJson(Map<String, dynamic> json) =>
      UrlModel(url: json['url']);

  Map<String, dynamic> toJson() => {'url': url};

  @override
  List<Object?> get props => [url];
}
