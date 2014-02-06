import 'dart:html';
import 'dart:core';
import '../lib/simulator.dart';
import '../lib/compiler.dart';

void bnt_start_clicked(MouseEvent event)
{
  TextAreaElement code = querySelector("#code_container");
  TextAreaElement log = querySelector("#log");
  Compiler compiler = new Compiler(code.value);
  log.children.clear();
  var bin;
  try 
  {
      bin = compiler.compile();
      for (int i = 0; i < bin.length;i++)
      {
           log.appendHtml(bin[i].toStringfill() + "\n");
      }
  }
  on List<String> catch(e)
  {
       for (int i = 0; i < e.length;i++)
       {
          log.appendHtml(e[i] + "\n");
       }
  }
}

void main() {
  InputElement bnt_start = querySelector("#bnt_compile");
  bnt_start.onClick.listen(bnt_start_clicked);
}

