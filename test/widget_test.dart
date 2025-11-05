// test/widget_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:personal_portfolio/app/app.dart';

void main() {
  testWidgets('smoke', (tester) async {
    await tester.pumpWidget(const PortfolioApp()); // <-- fix class name
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
