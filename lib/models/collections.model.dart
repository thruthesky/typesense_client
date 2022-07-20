class CollectionModel {
  CollectionModel({
    required this.name,
    required this.fields,
    this.tokenSeparators = const [],
    this.symbolsToIndex = const [],
    this.defaultSortingField = '',
    this.createdAt = 0,
    this.numDocuments = 0,
  });

  final String name;
  final List fields;

  final List tokenSeparators;
  final List symbolsToIndex;
  final String defaultSortingField;
  final int createdAt;

  final int numDocuments;

  factory CollectionModel.fromJson(Map<String, dynamic> data) {
    return CollectionModel(
      name: data['name'] ?? '',
      fields: data['fields'] ?? [],
      tokenSeparators: data['token_separators'] ?? [],
      symbolsToIndex: data['symbols_to_index'] ?? [],
      defaultSortingField: data['default_sorting_field'] ?? '',
      createdAt: data['created_at'] ?? 0,
      numDocuments: data['num_documents'] ?? 0,
    );
  }
}
