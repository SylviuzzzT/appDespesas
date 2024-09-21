import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'despesa_provider.dart';
import 'relatorios_page.dart';  

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _descricaoController = TextEditingController();

  final TextEditingController _valorController = TextEditingController();

  DateTime _dataSelecionada = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final despesaProvider = Provider.of<DespesaProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Despesas Pessoais'),
        actions: [
          IconButton(
            icon: Icon(Icons.bar_chart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RelatoriosPage()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: despesaProvider.despesas.length,
              itemBuilder: (context, index) {
                final despesa = despesaProvider.despesas[index];
                return ListTile(
                  title: Text(despesa.descricao),
                  subtitle: Text(
                      '${despesa.data.day}/${despesa.data.month}/${despesa.data.year} - R\$ ${despesa.valor.toStringAsFixed(2)}'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      despesaProvider.removerDespesa(index);
                    },
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: _descricaoController,
                  decoration: InputDecoration(labelText: 'Descrição'),
                ),
                TextField(
                  controller: _valorController,
                  decoration: InputDecoration(labelText: 'Valor'),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  child: Text('Adicionar Despesa'),
                  onPressed: () {
                    final descricao = _descricaoController.text;
                    final valor = double.tryParse(_valorController.text) ?? 0;

                    if (descricao.isNotEmpty && valor > 0) {
                      despesaProvider.adicionarDespesa(
                          descricao, _dataSelecionada, valor);
                      _descricaoController.clear();
                      _valorController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

