// @dart=2.9
import 'package:flutter/material.dart';
// Faz chamadas na API
import 'package:http/http.dart' as http;

//Para fazer o parser do json
import 'dart:convert';

import 'models/pessoa.dart';

// Método principal da aplicação
void main() {
  runApp(MaterialApp(
    home: Home(),
    debugShowCheckedModeBanner: false,
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // Criação do ambiente do formulário
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Controllers da aplicação
  TextEditingController usuarioController = TextEditingController();
  TextEditingController senhaController = TextEditingController();
  TextEditingController nomeController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  //  Variáveis do ambiente que receberão os dados da API
  String _id = '';
  String _nome = '';
  String _email = '';
  String _erro = '';
  String _resposta = '';

  //  Documentação da API
  // https://github.com/EdsonMSouza/simple-php-api

  // Endereço da API
  Uri url = Uri.parse('http://emsapi.esy.es/rest/api/search/');
  Uri urlNew = Uri.parse('http://emsapi.esy.es/rest/api/new/');
  Uri urlUpdate = Uri.parse('http://emsapi.esy.es/rest/api/update/');

  //Método atualizar
  atualizar() async {
    http.Response response = await http.put(
      this.urlUpdate,
      headers: <String, String>{
        "content-type": "application/json",
        "Authorization": "123",
      },
      body: jsonEncode(
        <String, String>{
          "name": nomeController.text,
          "email": emailController.text,
          "username": usuarioController.text,
          "password": senhaController.text
        },
      ),
    );

    final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
    List pessoa = parsed.map<Pessoa>((json) => Pessoa.fromJson(json)).toList();

    for (var p in pessoa) {
      if (p.status != '301') {
        usuarioController.text = '';
        senhaController.text = '';
        nomeController.text = '';
        emailController.text = '';
        setState(
          () {
            _id = '';
            _nome = '';
            _email = '';
            _erro = 'Erro ao atualizar usuário';
          },
        );
      } else {
        setState(
          () {
            _resposta = 'Usuário atualizado com sucesso!';
            usuarioController.text = '';
            senhaController.text = '';
            nomeController.text = '';
            emailController.text = '';
            _erro = '';
          },
        );
      }
    }
  }

  //Método cadastrar
  cadastrar() async {
    http.Response response = await http.post(
      this.urlNew,
      headers: <String, String>{
        "content-type": "application/json",
        "Authorization": "123",
      },
      body: jsonEncode(
        <String, String>{
          "name": nomeController.text,
          "email": emailController.text,
          "username": usuarioController.text,
          "password": senhaController.text
        },
      ),
    );

    final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
    List pessoa = parsed.map<Pessoa>((json) => Pessoa.fromJson(json)).toList();

    for (var p in pessoa) {
      if (p.status != '101') {
        usuarioController.text = '';
        senhaController.text = '';
        nomeController.text = '';
        emailController.text = '';
        setState(
          () {
            _id = '';
            _nome = '';
            _email = '';
            _erro = 'Erro ao cadastrar o usuário';
          },
        );
      } else {
        setState(
          () {
            _resposta = 'Usuário cadastrado com sucesso!';
            usuarioController.text = '';
            senhaController.text = '';
            nomeController.text = '';
            emailController.text = '';
          },
        );
      }
    }
  }

  // Método para requisição da API Pesquisar
  jsonRestApiHttp() async {
    http.Response response = await http.post(
      this.url,
      headers: <String, String>{
        "content-type": "application/json",
        "Authorization": "123",
      },
      body: jsonEncode(
        <String, String>{
          "username": usuarioController.text,
          "password": senhaController.text,
        },
      ),
    );

    final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
    List pessoa = parsed.map<Pessoa>((json) => Pessoa.fromJson(json)).toList();

    for (var p in pessoa) {
      if (p.status != '201') {
        usuarioController.text = '';
        senhaController.text = '';
        setState(
          () {
            _id = '';
            _nome = '';
            _email = '';
            _erro = 'Usuário não localizado';
          },
        );
      } else {
        setState(
          () {
            _id = p.id;
            _nome = p.nome;
            _email = p.email;
            _erro = '';
          },
        );
      }
    }
  }

  // Corpo da aplicação
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Configuração da barra do aplicativo
      appBar: AppBar(
        title: Text(
          'Webservices (API)',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.lightBlue[900],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(100.0, 0, 100.0, 0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: Icon(
                  Icons.person,
                  size: 50.0,
                  color: Colors.lightBlue[900],
                ),
              ),
              // Campo nome
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: TextFormField(
                  controller: nomeController,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.text,
                  validator: (value) =>
                      value.isEmpty ? 'Informe o seu nome' : null,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                        Icons.person_add), // coloca um ícone dentro do campo
                    hintText: 'informe o seu nome',
                  ),
                  style:
                      TextStyle(color: Colors.lightBlue[900], fontSize: 16.0),
                ),
              ),
              //Campo e-mail
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: TextFormField(
                  controller: emailController,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.text,
                  validator: (value) =>
                      value.isEmpty ? 'Informe o seu e-mail' : null,
                  decoration: InputDecoration(
                    prefixIcon:
                        Icon(Icons.mail), // coloca um ícone dentro do campo
                    hintText: 'informe o seu e-mail',
                  ),
                  style:
                      TextStyle(color: Colors.lightBlue[900], fontSize: 16.0),
                ),
              ),

              // Campo usuário
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: TextFormField(
                  controller: usuarioController,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.text,
                  validator: (value) =>
                      value.isEmpty ? 'Informe o usuário' : null,
                  decoration: InputDecoration(
                    prefixIcon:
                        Icon(Icons.person), // coloca um ícone dentro do campo
                    hintText: 'informe seu usuário',
                  ),
                  style:
                      TextStyle(color: Colors.lightBlue[900], fontSize: 16.0),
                ),
              ),

              // Campo senha
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: TextFormField(
                  obscureText: true, // configura para ser invisível
                  controller: senhaController,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.visiblePassword,
                  validator: (value) =>
                      value.isEmpty ? 'Informe a senha' : null,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    hintText: 'informe sua senha',
                  ),
                  style:
                      TextStyle(color: Colors.lightBlue[900], fontSize: 16.0),
                ),
              ),

              // Botão
              Padding(
                padding: EdgeInsets.only(top: 50.0),
                child: Container(
                  height: 50.0,
                  child: RawMaterialButton(
                    shape: RoundedRectangleBorder(
                        // arredondar o botão
                        borderRadius: BorderRadius.circular(
                            30.0)), // Deixa o botão arredondado
                    onPressed: () {
                      // requisição da API (método) Pesquisar
                      if (_formKey.currentState.validate()) jsonRestApiHttp();
                    },
                    child: Text(
                      'Pesquisar',
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                    fillColor: Colors.lightBlue[900],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: Container(
                  height: 50.0,
                  child: RawMaterialButton(
                    shape: RoundedRectangleBorder(
                        // arredondar o botão
                        borderRadius: BorderRadius.circular(
                            30.0)), // Deixa o botão arredondado
                    onPressed: () {
                      // requisição da API (método) NEW
                      if (_formKey.currentState.validate()) cadastrar();
                    },
                    child: Text(
                      'Cadastrar',
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                    fillColor: Colors.lightBlue[900],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: Container(
                  height: 50.0,
                  child: RawMaterialButton(
                    shape: RoundedRectangleBorder(
                        // arredondar o botão
                        borderRadius: BorderRadius.circular(
                            30.0)), // Deixa o botão arredondado
                    onPressed: () {
                      // requisição da API (método) Update
                      if (_formKey.currentState.validate()) atualizar();
                    },
                    child: Text(
                      'Atualizar',
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                    fillColor: Colors.lightBlue[900],
                  ),
                ),
              ),

              // Mensagem de erro
              Padding(
                padding: EdgeInsets.only(top: 50.0),
                child: Container(
                  child: Text(
                    _erro,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.red, fontSize: 20.0),
                  ),
                ),
              ),

              // ############# Mostra os valores retornados ###################
              // id
              Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: Container(
                  child: Text(
                    _id,
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(color: Colors.lightBlue[900], fontSize: 20.0),
                  ),
                ),
              ),

              //  Nome
              Padding(
                padding: EdgeInsets.only(top: 5.0),
                child: Container(
                  child: Text(
                    _nome,
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(color: Colors.lightBlue[900], fontSize: 20.0),
                  ),
                ),
              ),

              // Email
              Padding(
                padding: EdgeInsets.only(top: 5.0),
                child: Container(
                  child: Text(
                    _email,
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(color: Colors.lightBlue[900], fontSize: 20.0),
                  ),
                ),
              ),
              //status
              Padding(
                padding: EdgeInsets.only(top: 5.0),
                child: Container(
                  child: Text(
                    _resposta,
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(color: Colors.lightBlue[900], fontSize: 20.0),
                  ),
                ),
              ),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
