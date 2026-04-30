# Ayudas

## Estructura

Cómo imaginar la estructura de una app Flutter simple

Piensa así:

main.dart arranca la app
una pantalla principal vive en `screens/`
componentes reutilizables viven en `widgets/`
modelos de datos viven en `models/`
base de datos, APIs o helpers en `services/`

Ejemplo de estructura:

lib/
  main.dart
  screens/
    home_page.dart
    add_song_page.dart
    song_detail_page.dart
  widgets/
    song_tile.dart
    custom_button.dart
  models/
    song.dart
  services/
    db_service.dart