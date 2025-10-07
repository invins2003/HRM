class EmployeeBiometricModel {
  final List<List<double>> embedding;

  EmployeeBiometricModel({required this.embedding});

  factory EmployeeBiometricModel.fromJson(Map<String, dynamic> json) {
    final List embeddingJson = json['embedding'] ?? [];
    final embeddings = embeddingJson
        .map<List<double>>((e) => (e as List).map<double>((v) => (v as num).toDouble()).toList())
        .toList();

    return EmployeeBiometricModel(embedding: embeddings);
  }

  Map<String, dynamic> toJson() => {
        "embedding": embedding,
      };
}