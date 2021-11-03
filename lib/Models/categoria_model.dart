class Categoria {
  int? codigo;
  String? nome;

  Categoria({this.codigo, this.nome});

  factory Categoria.fromJson(Map<String, dynamic> json) {
    return Categoria(
      codigo: json['codigo'],
      nome: json['nome'],
    );
  }
}
