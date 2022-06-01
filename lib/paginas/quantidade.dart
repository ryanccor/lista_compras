import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum OperacaoValor { incremento, decremento }

class Quantidade extends StatefulWidget {
  const Quantidade(
      {this.quantidadeInicial = 0.0, required this.eventoNovaQuantidade});

  final Function(double quantidade) eventoNovaQuantidade;
  final double quantidadeInicial;

  @override
  State<Quantidade> createState() => _QuantidadeState();
}

class _QuantidadeState extends State<Quantidade> {
  final _controladorQuantidade = TextEditingController();

  void _atualizarValor(OperacaoValor operacao) {
    if (_controladorQuantidade.text == '') {
      _controladorQuantidade.text = '0';
    }
    double valor = double.parse(_controladorQuantidade.text);
    if (operacao == OperacaoValor.decremento) {
      valor -= 1;
      if (valor < 0.0) {
        valor = 0.0;
      }
    } else {
      valor += 1;
    }
    _controladorQuantidade.text = valor.toString();
  }

  void _executarEventoValor() {
    if (widget.eventoNovaQuantidade != null) {
      double quantidade = 0.0;
      try {
        quantidade = double.parse(_controladorQuantidade.text);
      } catch (e) {
        quantidade = 0.0;
      } finally {
        widget.eventoNovaQuantidade(quantidade);
      }
    }
  }

  @override
  void initState() {
    _controladorQuantidade.text = widget.quantidadeInicial.toString();
    super.initState();
  }

  @override
  void dispose() {
    _controladorQuantidade.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      child: Row(
        children: <Widget>[
          IconButton(
            color: Colors.blue,
            icon: Icon(
              CupertinoIcons.add,
              color: Colors.blue,
            ),
            onPressed: () {
              _atualizarValor(OperacaoValor.incremento);
              _executarEventoValor();
            },
          ),
          Container(
            width: 80,
            height: 50,
            child: TextField(
              textAlign: TextAlign.center,
              onChanged: (valor) {
                if (valor == '') {
                  _controladorQuantidade.text = '0';
                  _executarEventoValor();
                }
              },
              controller: _controladorQuantidade,
              decoration:
                  InputDecoration(labelText: '', border: OutlineInputBorder()),
            ),
          ),
          IconButton(
            color: Colors.blue,
            icon: Icon(
              CupertinoIcons.minus,
              color: Colors.blue,
            ),
            onPressed: () {
              _atualizarValor(OperacaoValor.decremento);
              _executarEventoValor();
            },
          ),
        ],
      ),
    );
  }
}
