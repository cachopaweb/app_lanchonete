class Produtos {
  int codigo;
  String nome;
  dynamic valor;
  int categoria;

  Produtos({this.codigo, this.nome, this.valor, this.categoria});

  factory Produtos.fromJson(Map<String, dynamic> json) {
    return Produtos(
        codigo: json['codigo'],
        nome: json['nome'],
        valor: json['valor'],
        categoria: json['categoria']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['codigo'] = this.codigo;
    data['nome'] = this.nome;
    data['valor'] = this.valor;
    data['categoria'] = this.categoria;
    return data;
  }
}
