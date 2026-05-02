# Fase 3 - Ingreso de contenido desde archivos e imágenes

## Objetivo general

Facilitar la creación de cantos a partir de material existente, como archivos PDF, imágenes o fotografías, reduciendo la necesidad de transcribir manualmente todo el contenido.

La Fase 3 busca permitir que el usuario pueda importar material visual o documental, extraer texto cuando sea posible, corregirlo manualmente y crear un canto nuevo a partir de ese contenido.

---

## Objetivo de la fase

Permitir que el usuario pueda:

- subir un archivo PDF
- subir una imagen desde el dispositivo
- tomar una foto desde la cámara
- guardar el archivo original como referencia del canto
- extraer texto desde PDF cuando sea posible
- extraer texto desde imagen o foto cuando sea posible
- revisar y corregir el texto antes de guardar
- crear un canto a partir del contenido importado
- conservar el archivo original como referencia opcional

---

## Relación con fases anteriores

La Fase 1 dejó la base funcional de cantos:

- almacenamiento local
- CRUD de cantos
- búsqueda
- favoritos
- detalle
- modo lectura
- soporte offline

La Fase 2 mejoró la captura de cantos:

- nuevo canto rápido
- nuevo canto completo
- pegar texto
- importar `.txt`
- revisar importación
- copiar contenido
- exportar texto simple

La Fase 3 extiende esa lógica de importación para aceptar fuentes más complejas:

- PDF
- imágenes
- fotografías

---

## Alcance de la fase

Esta fase incluirá:

1. documentación de fase
2. subir archivo PDF
3. subir imagen desde galería
4. tomar foto desde cámara
5. guardar archivo como referencia del canto
6. extraer texto desde PDF cuando sea posible
7. extraer texto desde imagen o foto cuando sea posible
8. permitir corrección manual antes de guardar
9. crear canto a partir del contenido importado
10. mantener archivo original como referencia opcional
11. test
12. entregable

---

## Fuera de alcance en esta fase

Queda fuera de esta fase:

- OCR avanzado con alta precisión garantizada
- reconocimiento perfecto de acordes
- reconocimiento automático de secciones complejas
- separación automática entre versos, coro, puente, etc.
- detección inteligente de tono desde la letra
- importación masiva de muchos archivos al mismo tiempo
- sincronización en la nube
- respaldo automático en Google Drive
- colaboración entre usuarios
- edición avanzada de PDF
- recorte avanzado de imagen
- limpieza automática compleja de texto
- inteligencia artificial avanzada para reescritura de letras
- detección automática de idioma
- escaneo tipo documento con perspectiva corregida

---

## Enfoque principal de la fase

El enfoque principal es ayudar al usuario a partir de material existente.

La app no debe prometer que siempre extraerá el texto perfectamente.  
Debe comportarse como una ayuda inicial:

1. el usuario carga un archivo o foto
2. la app intenta extraer texto
3. el usuario revisa y corrige
4. el usuario guarda el canto

---

## Pantallas contempladas en esta fase

## 1. Entrada de importación desde archivo o imagen

Pantalla o bottom sheet para elegir el origen del contenido.

### Opciones sugeridas

- Importar PDF
- Importar imagen
- Tomar foto
- Ver importaciones recientes, opcional

### Objetivo

Dar acceso claro a los nuevos métodos de ingreso de contenido.

---

## 2. Importar PDF

Pantalla para seleccionar un archivo PDF desde el dispositivo.

### Debe incluir

- explicación breve del flujo
- botón para seleccionar PDF
- nombre del archivo seleccionado
- tamaño del archivo, si está disponible
- opción para continuar
- opción para cancelar

### Comportamiento esperado

Al seleccionar un PDF, la app debe intentar leer o extraer texto cuando sea posible.

---

## 3. Importar imagen

Pantalla para seleccionar una imagen desde la galería.

### Debe incluir

- explicación breve
- botón para seleccionar imagen
- vista previa de la imagen
- opción para extraer texto
- opción para continuar sin extraer texto
- opción para cancelar

---

## 4. Tomar foto

Pantalla o flujo para tomar una fotografía usando la cámara del dispositivo.

### Debe incluir

- acceso a cámara
- captura de foto
- vista previa de la foto
- opción para volver a tomar
- opción para usar foto
- opción para cancelar

---

## 5. Procesando contenido

Pantalla o estado intermedio mientras se intenta extraer texto.

### Debe mostrar

- indicador de carga
- mensaje claro
- nombre del archivo o tipo de contenido
- opción para cancelar si aplica

### Ejemplos de mensaje

```txt
Extrayendo texto del archivo...
Analizando imagen...
Esto puede tardar unos segundos. ```

---


## 6. Revisión de texto extraído

Pantalla para revisar el contenido detectado antes de crear el canto.

### Debe incluir
texto extraído editable
campos editables para título, tono, autor y notas
vista previa del archivo original
opción para guardar archivo como referencia
botón principal para crear canto
opción para cancelar
Objetivo

Dar control total al usuario antes de guardar el canto.

## 7. Error o extracción no disponible

Estado visual cuando no se puede extraer texto.

Casos posibles
PDF protegido
PDF escaneado como imagen
imagen borrosa
foto con poca luz
archivo no compatible
error de permisos
error de lectura
Debe permitir
intentar de nuevo
cambiar archivo
escribir o pegar texto manualmente
guardar solo el archivo como referencia, si aplica

## 8. Archivo de referencia en detalle de canto

Extensión del detalle de canto para mostrar si el canto tiene un archivo asociado.

Debe incluir
indicador de archivo adjunto
nombre del archivo
tipo de archivo
opción para abrir o visualizar referencia
opción para quitar referencia, si aplica


## Funcionalidades principales
### 1. Subir archivo PDF

El usuario podrá seleccionar un archivo PDF desde el dispositivo.

#### Objetivo

Permitir crear un canto desde archivos de letras, partituras simples o documentos guardados previamente.

Consideraciones
validar que el archivo sea PDF
manejar errores de lectura
permitir continuar aunque no se pueda extraer texto
conservar el archivo como referencia opcional

### 2. Subir imagen desde galería

El usuario podrá seleccionar una imagen existente desde su dispositivo.

#### Objetivo

Permitir importar letras guardadas como capturas, imágenes o fotografías previas.

Consideraciones
mostrar vista previa
validar formato de imagen
permitir extracción de texto si está disponible
permitir corrección manual antes de guardar


### 3. Tomar foto

El usuario podrá tomar una foto desde la cámara.

#### Objetivo

Permitir capturar letras desde una hoja física, libreta, pantalla o material impreso.

Consideraciones
pedir permisos de cámara
permitir repetir la foto
mostrar vista previa antes de procesar
permitir continuar con extracción o solo referencia


### 4. Guardar archivo como referencia del canto

El usuario podrá conservar el archivo original asociado al canto.

#### Objetivo

Permitir consultar la fuente original si el texto extraído no quedó perfecto o si el usuario quiere mantener respaldo visual.

Ejemplos
PDF original
imagen original
foto tomada
Consideraciones
debe ser opcional
debe poder consultarse desde el detalle del canto
debe poder eliminarse la referencia posteriormente, si se implementa


### 5. Extraer texto desde PDF

La app intentará extraer texto desde PDFs cuando sea posible.

#### Importante
 
No todos los PDFs contienen texto real.
Algunos PDFs son solo imágenes escaneadas, por lo que podrían requerir OCR.

#### Comportamiento esperado
si el PDF tiene texto seleccionable, intentar extraerlo
si no tiene texto detectable, mostrar mensaje claro
permitir captura manual o guardar archivo como referencia


### 6. Extraer texto desde imagen o foto

La app intentará extraer texto desde imágenes o fotos usando OCR.

#### Consideraciones

La precisión dependerá de:

calidad de la imagen
iluminación
enfoque
tamaño del texto
contraste
inclinación de la foto
limpieza del documento
Objetivo

Ofrecer un punto de partida editable, no una transcripción perfecta.

### 7. Corrección manual antes de guardar

Todo texto extraído deberá pasar por una pantalla de revisión.

El usuario debe poder editar
título
autor
tono base
notas
letra extraída
Regla importante

La app no debe guardar automáticamente texto extraído sin revisión del usuario.

### 8. Crear canto a partir del contenido importado

Después de revisar y corregir, el usuario podrá crear un canto nuevo usando la información detectada.

Datos mínimos para guardar
título
letra
Datos opcionales
autor
tono base
notas
archivo de referencia


### 9. Mantener archivo original como referencia opcional

Al guardar el canto, el usuario podrá elegir si desea conservar el archivo original asociado.

Casos de uso
conservar imagen de una hoja original
consultar PDF original después
comparar texto extraído contra la fuente
mantener evidencia o respaldo
Validaciones básicas
Validaciones de archivo
validar tipo PDF
validar tipo imagen
manejar archivo vacío
manejar archivo dañado
manejar permisos no concedidos
manejar selección cancelada
Validaciones para guardar canto
título obligatorio
letra obligatoria o confirmación si solo se guarda referencia
no guardar canto vacío sin advertencia
mostrar mensaje claro si no se extrajo texto
Criterios de éxito de la fase

La Fase 3 se considerará terminada cuando:

el usuario pueda seleccionar un PDF
el usuario pueda seleccionar una imagen
el usuario pueda tomar una foto
la app pueda intentar extraer texto desde PDF
la app pueda intentar extraer texto desde imagen o foto
exista pantalla de revisión editable
el usuario pueda crear un canto desde el texto importado
el usuario pueda conservar el archivo original como referencia opcional
existan mensajes claros cuando no se pueda extraer texto
el flujo no rompa el CRUD de cantos existente
todo funcione en Android físico
Prioridades de desarrollo
Prioridad alta
entrada de importación desde PDF/imagen/foto
selección de archivo PDF
selección de imagen
toma de foto
pantalla de revisión editable
creación de canto desde contenido revisado
manejo de errores básicos
Prioridad media
extracción de texto desde PDF
extracción de texto desde imagen/foto
guardar archivo como referencia
mostrar referencia en detalle de canto
Prioridad baja dentro de esta fase
vista previa avanzada
mejoras visuales de procesamiento
limpieza automática de texto
recorte manual de imagen
historial de importaciones

Consideraciones técnicas sugeridas
Paquetes posibles

Para seleccionar archivos:

file_picker

Para seleccionar imágenes o tomar foto:

image_picker

Para extraer texto desde imagen/foto:

google_mlkit_text_recognition

Para extraer texto desde PDF:

syncfusion_flutter_pdf

o alguna alternativa compatible.

Flujos principales
Flujo 1 - Crear canto desde PDF
abrir la app
tocar botón +
elegir importar PDF
seleccionar archivo PDF
intentar extraer texto
revisar texto detectado
corregir información
decidir si conservar PDF como referencia
guardar canto
Flujo 2 - Crear canto desde imagen
abrir la app
tocar botón +
elegir importar imagen
seleccionar imagen desde galería
mostrar vista previa
intentar extraer texto
revisar texto detectado
corregir información
decidir si conservar imagen como referencia
guardar canto
Flujo 3 - Crear canto desde foto
abrir la app
tocar botón +
elegir tomar foto
abrir cámara
tomar foto
mostrar vista previa
permitir repetir o usar foto
intentar extraer texto
revisar texto detectado
corregir información
decidir si conservar foto como referencia
guardar canto
Flujo 4 - Fallo de extracción
usuario selecciona archivo, imagen o foto
la app intenta extraer texto
no se detecta texto útil
la app muestra mensaje claro
el usuario puede:
intentar con otro archivo
escribir manualmente
pegar texto
conservar archivo como referencia
Test

Validar al menos:

seleccionar PDF válido
seleccionar PDF inválido
seleccionar PDF sin texto extraíble
seleccionar imagen válida
seleccionar imagen borrosa
tomar foto
cancelar selección de archivo
cancelar cámara
negar permisos de cámara
extraer texto y editarlo
guardar canto desde texto extraído
guardar archivo como referencia
abrir canto creado desde importación
validar título requerido
validar letra requerida
verificar que no se rompa Fase 1 y Fase 2
Entregable

Al finalizar la Fase 3 se espera contar con:

flujo para importar PDF
flujo para importar imagen
flujo para tomar foto
extracción básica de texto cuando sea posible
pantalla de revisión editable
creación de canto desde contenido importado
opción para conservar archivo original como referencia
manejo básico de errores
integración visual con la app actual
pruebas en Android físico
Notas finales

La Fase 3 debe mantener el enfoque práctico.

El objetivo no es que la extracción sea perfecta, sino que el usuario tenga una ayuda para empezar desde material existente y pueda corregir antes de guardar.

Esta fase debe cuidar mucho los mensajes al usuario para evitar falsas expectativas.

## Notas finales
Para esta fase sí quedó bien marcarla por partes: **3A selección**, **3B OCR**, **3C PDF**, **3D referencia**. Así Codex puede avanzar sin meter cámara, archivos, OCR y PDF todo revuelto en un solo cambio.