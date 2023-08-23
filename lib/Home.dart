import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  var listaItens = [];  

  Future<File> _getFile() async {
    final path = await getApplicationDocumentsDirectory();
    return File('${path}/dados.json');
  }

  _salvar() async {
    var file = await _getFile();

    Map<String, dynamic> tarefa = Map();
    tarefa['titulo'] = 'Ir ao Mercado';
    tarefa['realizada'] = false;
    listaItens.add(tarefa);
    
    var dados = jsonEncode(listaItens);
    file.writeAsString(dados);

  }

  _lerArquivo() async {
    try{
      final file = await _getFile();
      return file.readAsString();

    }catch(e){
      return e;
    }

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _lerArquivo()
      .then((dados){
        setState(() {
          listaItens = jsonDecode(dados);
        });
      });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Listagem itens'),
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: listaItens.length,
                itemBuilder: (context, index){
                  return ListTile(
                    title: Text(listaItens[index]['titulo']),
                  );
                }
              )
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        onPressed: (){}
      ),
    );
  }
}