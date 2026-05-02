# Fase 1 - Estructura tecnica propuesta

## Objetivo

Dejar una base facil de entender para construir la fase 1 sin meter complejidad innecesaria.

## Estructura de carpetas

```text
lib/
  app/
    bootstrap/     -> arranque e inyeccion de dependencias
    theme/         -> paleta, tema y estilos globales
  features/
    home/          -> pantalla de inicio
    repertories/   -> modulo parcial de repertorios
    search/        -> busqueda local
    settings/      -> ajustes de lectura y visual
    shell/         -> navegacion principal adaptativa
    songs/         -> CRUD de cantos, detalle y almacenamiento
  shared/
    data/          -> base de datos local
    widgets/       -> widgets reutilizables
```

## Por que esta estructura

- `app/` guarda solo lo global de la app.
- `features/` separa cada modulo funcional para que no mezcles pantallas, modelos y logica.
- `shared/` evita duplicar piezas comunes.
- `songs/` concentra el modulo mas importante de la fase 1.

## Decisiones tecnicas

- `sqflite` para la base local de cantos.
- `shared_preferences` para ajustes simples como tamano de letra.
- `ChangeNotifier` para estado basico, porque es mas facil de aprender que una solucion con codegen.
- navegacion adaptable con `NavigationBar` en movil y `NavigationRail` en tablet.

## Orden recomendado para seguir

1. Validar que `flutter pub get` descargue dependencias.
2. Confirmar que la UI base coincide con los prototipos.
3. Refinar cards, tipografia e iconografia.
4. Agregar modo lectura dedicado en pantalla completa.
5. Cubrir CRUD y persistencia con mas pruebas.
