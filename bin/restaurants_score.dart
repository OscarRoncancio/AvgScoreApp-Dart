//import 'package:restaurants_score/restaurants_score.dart' as restaurants_score;
import 'dart:io';
import 'package:excel_dart/excel_dart.dart';

void main() {
  Set tipo = {};
  List<double> calificacionTotal = [];
  Map rating = {};
  Set restaurantes = {};
  //realizo este for para determinar una lista de tipos de comida sin repeticion iterando sobre el set de restaurantes
  database(restaurantes);
  for (int i = 0; i < restaurantes.length; i++) {
    Map restaurante = restaurantes.elementAt(i);
    tipo.add(restaurante['Food_Type']);
  }
  //realizo un for inicial que se itera dependiendo de la cantidad de tipos
  for (int x = 0; x < tipo.length; x++) {
    List<double> promT = [];
    //Este segundo for determina los promedios iterando sobre cada restaurante guardando las calificaciones en una lista
    for (int i = 0; i < restaurantes.length; i++) {
      Map restaurante = restaurantes.elementAt(i);
      double calificacion = 0;
      calificacion=(double.parse(restaurante['Restaurant_Score']));
      //En este if se valida si el tipo del set declarado arriba es igual al tipo del restaurante actual
      if (tipo.elementAt(x) == restaurante['Food_Type']) {
        //Una vez pasada la validacion procedo a añadir la calificación a la lista promT
        promT.add(calificacion);
      }
    }
    //se calcula el promedio de calificacion por tipo de comida con la funcion promedio y se añade al mapa rating
    promedio(promT);
    calificacionTotal.add(promedio(promT));
    rating.addAll({tipo.elementAt(x): calificacionTotal[x]});
  }
  //Se añade un tipo extra que contiene el promedio de todos los anteriores
  rating.addAll({'Todos': promedio(calificacionTotal)});
  print(rating);
}
//Funcion para realizar promedios, recibe una lista de calificaciones y retorna un double con el resultado del promedio de la lista
double promedio(List<dynamic> calificaciones) {
  double resultado = 0;
  for (var i = 0; i < calificaciones.length; i++) {
    resultado += calificaciones[i];
  }
  resultado = resultado / calificaciones.length;

  return resultado;
}

Set database(Set informacion) {
  List<dynamic> values = [];
  List<dynamic> cellValue = [];
  final File file = File('files/Book.xlsx');
  final bytes = file.readAsBytesSync();
  final excel = Excel.decodeBytes(bytes);
  for (var table in excel.tables.keys) {
    for (var row in excel.tables[table]!.rows) {
      cellValue = row.map((cell) => cell?.value).toList();
      values.add(cellValue);
    }
  }
  for (var i = 1; i < values.length; i++) {
    informacion.add({
      '${values[0][0]}': '${values[i][0]}',
      '${values[0][1]}': '${values[i][1]}',
      '${values[0][2]}': '${values[i][2]}',
      '${values[0][3]}': '${values[i][3]}',
      '${values[0][4]}': '${values[i][4]}',
      '${values[0][5]}': '${values[i][5]}'
    });
  }

  return informacion;
}
