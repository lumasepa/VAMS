import 'dart:html';
import 'dart:core';
import 'binary.dart';
import 'simulator.dart';

void bnt_start_clicked(MouseEvent event)
{
  TextAreaElement code = querySelector("#code_container");
  Loader load = new Loader(code.value);
  load.parse();
}

void main() {
  InputElement bnt_start = querySelector("#bnt_start");
  bnt_start.onClick.listen(bnt_start_clicked);
}

