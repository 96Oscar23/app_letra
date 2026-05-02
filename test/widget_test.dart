import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:app_letras/app/app.dart';
import 'package:app_letras/app/bootstrap/app_dependencies.dart';
import 'package:app_letras/features/settings/data/in_memory_settings_repository.dart';
import 'package:app_letras/features/songs/data/in_memory_song_repository.dart';

void main() {
  testWidgets('muestra navegacion principal y biblioteca local',
      (tester) async {
    final dependencies = AppDependencies(
      songRepository: InMemorySongRepository(),
      settingsRepository: InMemorySettingsRepository(),
    );

    await tester.pumpWidget(LumenVesperApp(dependencies: dependencies));
    await tester.pumpAndSettle();

    expect(find.text('Inicio'), findsWidgets);
    expect(find.text('Canciones'), findsWidgets);
    expect(find.text('Tu biblioteca local'), findsOneWidget);
    expect(find.text('Great Is Thy Faithfulness'), findsNothing);

    await tester.tap(find.text('Canciones').last);
    await tester.pumpAndSettle();

    expect(find.text('Great Is Thy Faithfulness'), findsOneWidget);
  });

  testWidgets('muestra opciones de captura desde el boton agregar',
      (tester) async {
    final dependencies = AppDependencies(
      songRepository: InMemorySongRepository(),
      settingsRepository: InMemorySettingsRepository(),
    );

    await tester.pumpWidget(LumenVesperApp(dependencies: dependencies));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    expect(find.text('Agregar contenido'), findsOneWidget);
    expect(find.text('Nuevo canto rapido'), findsOneWidget);
    expect(find.text('Nuevo canto completo'), findsOneWidget);
    expect(find.text('Pegar texto'), findsOneWidget);
    expect(find.text('Importar archivo .txt'), findsOneWidget);
    expect(find.text('Importar PDF'), findsOneWidget);
    expect(find.text('Importar imagen'), findsOneWidget);
    expect(find.text('Tomar foto'), findsOneWidget);
  });
}
