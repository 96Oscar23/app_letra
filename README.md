# app_letras

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Comandos 

El siguiente comando es para instalar dependencias

    flutter pub get

### Comando para correr proyecto

flutter clean
    limpia el proyecto

flutter run
    inicia el proyecto

comando para buscar dispostivos
flutter devices

comando para correr proyecto en un equipo

flutter run -d <id_dispositivo>


### Comandos nuevos 
Comandos básicos

flutter clean
Limpia el proyecto.

flutter pub get
Descarga/actualiza dependencias.

flutter devices
Busca dispositivos disponibles.

flutter run
Inicia la app en modo debug.

flutter run -d <id_dispositivo>
Inicia la app en un dispositivo específico.

flutter analyze
Revisa errores y warnings.

flutter test
Corre tests.

Generar una nueva APK

flutter build apk
Genera una APK nueva en modo release.

Archivo generado:

build/app/outputs/flutter-apk/app-release.apk
Si quieres una APK de debug:

flutter build apk --debug
Si quieres una APK por arquitectura más ligera:

flutter build apk --split-per-abi
Archivos generados normalmente:

build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk
build/app/outputs/flutter-apk/app-arm64-v8a-release.apk
build/app/outputs/flutter-apk/app-x86_64-release.apk
Cuando tengas Mac
En Mac podrás hacer lo mismo para Flutter general:

flutter clean
flutter pub get
flutter devices
flutter run
flutter run -d <id_dispositivo>
flutter analyze
flutter test
flutter build apk
Y además para iPhone/iPad:

flutter build ios
Genera la app de iOS para abrirla en Xcode.

flutter run -d <id_ios>
Corre la app en un iPhone/iPad conectado o simulador.

open ios/Runner.xcworkspace
Abre el proyecto iOS en Xcode.

Resumen rápido
Para probar:

flutter run -d <id_dispositivo>
Para sacar una nueva APK:

flutter build apk
Para sacar versión iPhone/iPad en Mac:

flutter build ios

## OCR Android

Fase 3B agrega OCR para imagen y foto usando `google_mlkit_text_recognition`.

Notas para Android:

- `minSdkVersion 21`
- `targetSdkVersion 35`
- `compileSdkVersion 35`
- el permiso de cÃ¡mara sigue siendo necesario para `Tomar foto`

Con el toolchain actual del proyecto no hizo falta agregar una dependencia
manual extra en Gradle para latin script.

## PDF import

Fase 3C agrega extraccion basica de texto desde PDF usando `read_pdf_text`.

Notas:

- el paquete se usa solo para leer texto ya embebido en el PDF
- no hace OCR sobre PDF escaneado
- si el archivo esta protegido, dañado o no contiene texto real, la app
  mantiene el flujo manual de revision
