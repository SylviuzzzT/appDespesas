import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'despesa_provider.dart';
import 'package:intl/intl.dart';

class RelatoriosPage extends StatefulWidget {
  @override
  _RelatoriosPageState createState() => _RelatoriosPageState();
}

class _RelatoriosPageState extends State<RelatoriosPage> {
  DateTime _dataSelecionada = DateTime.now();
  String _tipoRelatorio = 'Diário';

  @override
  Widget build(BuildContext context) {
    final despesaProvider = Provider.of<DespesaProvider>(context);

    double total = 0;
    switch (_tipoRelatorio) {
      case 'Diário':
        total = despesaProvider.totalPorDia(_dataSelecionada);
        break;
      case 'Semanal':
        total = despesaProvider.totalPorSemana(_dataSelecionada);
        break;
      case 'Mensal':
        total = despesaProvider.totalPorMes(_dataSelecionada);
        break;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Relatórios de Despesas'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                DropdownButton<String>(
                  value: _tipoRelatorio,
                  items: ['Diário', 'Semanal', 'Mensal']
                      .map((tipo) => DropdownMenuItem<String>(
                            value: tipo,
                            child: Text(tipo),
                          ))
                      .toList(),
                  onChanged: (String? novoTipo) {
                    setState(() {
                      _tipoRelatorio = novoTipo!;
                    });
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    _selecionarData(context);
                  },
                  child: Text(DateFormat('dd/MM/yyyy').format(_dataSelecionada)),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Total $_tipoRelatorio: R\$ ${total.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  // Abre o DatePicker para selecionar uma data
  Future<void> _selecionarData(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dataSelecionada,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _dataSelecionada) {
      setState(() {
        _dataSelecionada = picked;
      });
    }
  }
}
