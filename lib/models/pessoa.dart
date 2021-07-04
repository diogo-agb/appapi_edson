class Pessoa {
  String id;
  String nome;
  String email;
  String status;

  Pessoa({this.email, this.id, this.nome, this.status});

  factory Pessoa.fromJson(Map<String, dynamic> json) {
    //Retorna os dados parseados do json (body.context)
    return Pessoa(
      id: json['id'] as String,
      status: json['status'] as String,
      nome: json['name'] as String,
      email: json['email'] as String,
    );
  }
}
