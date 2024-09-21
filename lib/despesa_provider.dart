import 'package:flutter/material.dart';
import 'despesa.dart';

class DespesaProvider with ChangeNotifier {
  List<Despesa> _despesas = [];

  List<Despesa> get despesas => _despesas;

  void adicionarDespesa(String descricao, DateTime data, double valor) {
    _despesas.add(Despesa(descricao: descricao, data: data, valor: valor));
    notifyListeners();
  }

  void removerDespesa(int index) {
    _despesas.removeAt(index);
    notifyListeners();
  }

  // Total de despesas por dia
  double totalPorDia(DateTime dia) {
    return _despesas
        .where((despesa) => isSameDay(despesa.data, dia))
        .fold(0, (sum, item) => sum + item.valor);
  }

  // Total de despesas por semana
  double totalPorSemana(DateTime dia) {
    DateTime primeiraSemana = dia.subtract(Duration(days: dia.weekday - 1));
    DateTime ultimaSemana = primeiraSemana.add(Duration(days: 6));

    return _despesas
        .where((despesa) => despesa.data.isAfter(primeiraSemana.subtract(Duration(days: 1))) &&
            despesa.data.isBefore(ultimaSemana.add(Duration(days: 1))))
        .fold(0, (sum, item) => sum + item.valor);
  }

  // Total de despesas por mês
  double totalPorMes(DateTime mes) {
    return _despesas
        .where((despesa) => despesa.data.month == mes.month && despesa.data.year == mes.year)
        .fold(0, (sum, item) => sum + item.valor);
  }

  // Verifica se duas datas são o mesmo dia
  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
