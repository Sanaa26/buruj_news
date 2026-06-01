import '../../domain/entities/source.dart';

class SourceModel extends Source {
  SourceModel({
    super.id,
    required super.name,
  });

  factory SourceModel.fromJson(Map<String, dynamic> json) {
    return SourceModel(
      id: json['id'],
      name: json['name'] ?? 'Unknown',
    );
  }
}
