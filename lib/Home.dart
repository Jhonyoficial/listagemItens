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

  TextEditingController _editingController = TextEditingController();
  var listaItens = [];  

  Future<File> _getFile() async {
    final path = await getApplicationDocumentsDirectory();
    return File('${path}/dados.json');
  }

  _salvar() async {
    var file = await _getFile();
    
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

  _salvarTarefa(){
    String textoDigitado =  _editingController.text;

    Map<String, dynamic> tarefa = Map();
    tarefa['titulo'] = textoDigitado;
    tarefa['realizada'] = false;
    
    setState(() {
      listaItens.add(tarefa);
    });
    
    _salvar();
    _editingController.text = "";

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

                  return CheckboxListTile(
                    title: Text(listaItens[index]['titulo']),
                    value: listaItens[index]['realizada'], 
                    onChanged: (valor){
                      setState(() {
                        listaItens[index]['realizada'] =  valor;
                      });

                      _salvar();
                    }
                  );
                  // return ListTile(
                  //   title: Text(listaItens[index]['titulo']),
                  // );
                }
              )
            )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.purple,
        onPressed: (){
          showDialog(
            context: context, 
            builder: (context){
              return AlertDialog(
                title: Text('Adicionar Tarefa'),
                content: TextField(
                  controller: _editingController,
                  decoration: InputDecoration(
                    labelText: 'Digite sua tarefa'
                  ),
                  onChanged: (text){
                    _salvarTarefa();
                  },
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context), 
                    child: Text('Cancelar')
                  ),
                  TextButton(
                    onPressed: () => {

                    }  , 
                    child: Text('Salvar')
                  ),
                ],
              );
            }
          );
        }
      ),
    );
  }
}