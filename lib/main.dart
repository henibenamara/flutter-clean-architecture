import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/app.dart';
import 'package:flutter_clean_architecture/injection.dart';

void main() {
  configureDependencies();
  runApp(const TodoApp());
}
