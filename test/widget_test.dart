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

  testWidgets('busca cantos por titulo y muestra estado vacio', (tester) async {
    final dependencies = AppDependencies(
      songRepository: InMemorySongRepository(),
      settingsRepository: InMemorySettingsRepository(),
    );

    await tester.pumpWidget(LumenVesperApp(dependencies: dependencies));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Canciones').last);
    await tester.pumpAndSettle();

    expect(find.text('2 cantos'), findsOneWidget);
    expect(find.text('Great Is Thy Faithfulness'), findsOneWidget);

    await tester.enterText(
      find.byType(TextField).first,
      'faithfulness',
    );
    await tester.pumpAndSettle();

    expect(find.text('1 canto'), findsOneWidget);
    expect(find.text('Great Is Thy Faithfulness'), findsOneWidget);
    expect(find.text('Celebracion de la Luz'), findsNothing);

    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pumpAndSettle();

    expect(find.text('2 cantos'), findsOneWidget);
    expect(find.text('Celebracion de la Luz'), findsOneWidget);

    await tester.enterText(
      find.byType(TextField).first,
      'zzzz-no-existe',
    );
    await tester.pumpAndSettle();

    expect(find.text('0 cantos'), findsOneWidget);
    expect(find.text('No encontramos cantos'), findsOneWidget);
    expect(
      find.text('Intenta cambiar la busqueda o limpiar algunos filtros.'),
      findsOneWidget,
    );
  });

  testWidgets('aplica filtros de categoria junto con la busqueda',
      (tester) async {
    final dependencies = AppDependencies(
      songRepository: InMemorySongRepository(),
      settingsRepository: InMemorySettingsRepository(),
    );

    await tester.pumpWidget(LumenVesperApp(dependencies: dependencies));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Canciones').last);
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.tune_rounded));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('Adoracion').last,
      120,
      scrollable: find.byType(Scrollable).last,
    );
    await tester.tap(find.text('Adoracion').last);
    await tester.tap(find.text('Aplicar'));
    await tester.pumpAndSettle();

    expect(find.text('1 canto'), findsOneWidget);
    expect(find.text('Great Is Thy Faithfulness'), findsOneWidget);
    expect(find.text('Celebracion de la Luz'), findsNothing);
    expect(find.text('Adoracion'), findsWidgets);

    await tester.enterText(find.byType(TextField).first, 'luz');
    await tester.pumpAndSettle();

    expect(find.text('0 cantos'), findsOneWidget);
    expect(find.text('No encontramos cantos'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.tune_rounded));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Limpiar filtros'));
    await tester.tap(find.text('Aplicar'));
    await tester.pumpAndSettle();

    expect(find.text('1 canto'), findsOneWidget);
    expect(find.text('Celebracion de la Luz'), findsOneWidget);
  });

  testWidgets('marca favoritos y registra cantos recientes desde detalle',
      (tester) async {
    final dependencies = AppDependencies(
      songRepository: InMemorySongRepository(),
      settingsRepository: InMemorySettingsRepository(),
    );

    await tester.pumpWidget(LumenVesperApp(dependencies: dependencies));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Canciones').last);
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('song-card-tap-2')),
      120,
      scrollable: find.byType(Scrollable).last,
    );
    final detailTapTarget =
        tester.getTopLeft(find.byKey(const ValueKey('song-card-tap-2'))) +
            const Offset(40, 20);
    await tester.tapAt(detailTapTarget);
    await tester.pumpAndSettle();

    expect(find.text('Detalle de canto'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.star_border_rounded));
    await tester.pumpAndSettle();
    await tester.pageBack();
    await tester.pumpAndSettle();

    await tester.tap(find.text('Favoritos'));
    await tester.pumpAndSettle();

    expect(find.text('2 cantos'), findsOneWidget);

    await tester.tap(find.text('Recientes'));
    await tester.pumpAndSettle();

    expect(find.text('1 canto'), findsOneWidget);
  });

  testWidgets('muestra acciones rapidas por swipe en la lista', (tester) async {
    final dependencies = AppDependencies(
      songRepository: InMemorySongRepository(),
      settingsRepository: InMemorySettingsRepository(),
    );

    await tester.pumpWidget(LumenVesperApp(dependencies: dependencies));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Canciones').last);
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('song-card-tap-2')),
      120,
      scrollable: find.byType(Scrollable).last,
    );
    expect(
      find.text('Desliza a la izquierda o derecha para administrar cantos.'),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey('song-slidable-1')), findsOneWidget);
    expect(find.byKey(const ValueKey('song-slidable-2')), findsOneWidget);
  });
}
