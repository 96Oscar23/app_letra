# Fase 2 - Alta rápida, importación y exportación simple

## Objetivo general

Mejorar la experiencia de captura de cantos para que agregar contenido nuevo sea más rápido, cómodo y con menos fricción.

La Fase 1 ya dejó una base funcional con almacenamiento local, CRUD de cantos, búsqueda, favoritos, detalle y lectura.  
La Fase 2 no busca rehacer esa base, sino agregar nuevos flujos para capturar cantos de forma más ágil y flexible.

---

## Objetivo de la fase

Permitir que el usuario pueda:

- agregar un canto rápidamente con pocos campos
- agregar un canto de forma más completa si desea capturarlo mejor desde el inicio
- pegar una letra directamente sin perder formato básico
- importar texto simple y convertirlo en un canto editable
- importar archivo `.txt`
- copiar el contenido de un canto fácilmente
- exportar un canto como texto simple
- guardar con validaciones básicas y mensajes claros

---

## Alcance de la fase

En esta fase se desarrollarán los siguientes elementos:

1. documentación de fase
2. acceso a nuevas opciones desde el botón de agregar
3. flujo de nuevo canto rápido
4. flujo de nuevo canto completo
5. pegar letra directamente
6. importar texto simple
7. importar archivo `.txt`
8. revisión previa antes de guardar contenido importado
9. copiar contenido fácilmente
10. exportar canto como texto simple
11. validaciones básicas al guardar
12. test
13. entregable

---

## Fuera de alcance en esta fase

Quedan fuera de esta fase:

- sincronización en la nube
- login o cuentas de usuario
- colaboración entre usuarios
- compartir por enlace
- repertorios avanzados
- filtros avanzados complejos
- recomendaciones inteligentes
- importación desde PDF o Word
- OCR o escaneo de imagen
- control en vivo avanzado
- secuencias, audio o multitracks

---

## Enfoque principal de la fase

La prioridad de esta fase es reducir fricción al momento de alimentar la base local de cantos.

Esto significa que la experiencia de alta debe ser:

- más rápida
- más clara
- menos pesada
- útil tanto para captura casual como para captura más ordenada

---

## Relación con la fase 1

La Fase 2 parte sobre la base ya implementada en Fase 1:

- base local de cantos
- CRUD funcional
- búsqueda básica
- favoritos
- detalle de canto
- ajustes básicos
- soporte offline

La idea es reutilizar la estructura actual del módulo de cantos y extenderla con nuevos flujos de entrada.

---

## Flujo de entrada desde botón +

El botón de agregar deberá evolucionar para abrir un menú o bottom sheet con nuevas opciones.

### Opciones sugeridas

- Nuevo canto rápido
- Nuevo canto completo
- Pegar texto
- Importar archivo `.txt`

### Objetivo

Dar acceso claro a distintos modos de captura sin saturar una sola pantalla.

---

## Pantallas contempladas en esta fase

### 1. Bottom sheet o menú de alta desde botón +
Pantalla ligera o modal de entrada a los nuevos flujos.

Debe mostrar de forma clara las acciones disponibles:
- nuevo canto rápido
- nuevo canto completo
- pegar texto
- importar `.txt`

---

### 2. Pantalla nuevo canto rápido
Pantalla enfocada en capturar un canto con la menor cantidad de pasos posible.

### Campos sugeridos
- título
- letra
- tono base, opcional
- notas, opcional

### Objetivo
Permitir guardar un canto rápidamente aunque aún no tenga toda la información completa.

---

### 3. Pantalla nuevo canto completo
Pantalla más detallada para capturar mayor información desde el inicio.

### Campos sugeridos
- título
- autor o artista, opcional
- letra
- tono base
- capo, opcional
- tempo o BPM, opcional
- categoría, opcional
- etiquetas, opcional
- notas
- estado del canto, opcional

### Objetivo
Guardar cantos mejor estructurados para uso futuro en repertorios, filtros y organización.

---

### 4. Pantalla pegar texto / importar texto simple
Pantalla donde el usuario puede pegar texto completo para que la app lo interprete o lo use como base de un nuevo canto.

### Debe permitir
- pegar texto largo
- respetar saltos de línea
- mantener estrofas
- interpretar campos simples si existen
- editar antes de guardar

---

### 5. Pantalla de revisión de importación
Pantalla intermedia para revisar y corregir la información detectada antes de guardar.

### Debe mostrar
- título detectado
- tono detectado
- otros campos detectados si existen
- letra detectada
- opción de editar
- opción de guardar
- opción de cancelar

---

## Funcionalidades principales

## 1. Nuevo canto rápido

Se implementará un flujo simple para agregar un canto con pocos campos y pocos pasos.

### Campos mínimos
- título
- letra

### Campos opcionales
- tono base
- notas

### Objetivo
Guardar rápidamente una letra nueva sin pasar por un formulario largo.

### Ejemplo de uso
El usuario encuentra una letra, la copia, entra a la app, pega el contenido, agrega el título y guarda.

---

## 2. Nuevo canto completo

Se implementará o refinará un flujo más detallado para capturar un canto con información más completa.

### Objetivo
Permitir mejor orden desde el inicio para usuarios que sí quieren registrar más datos del canto.

### Consideraciones
- puede reutilizar parte del formulario actual de alta/edición
- debe mantener buena legibilidad
- no debe sentirse saturado

---

## 3. Pegar letra directamente

La app deberá permitir pegar una letra completa directamente en el formulario.

### Consideraciones
- respetar saltos de línea
- evitar eliminar espacios importantes
- mantener estrofas separadas
- permitir editar el contenido después de pegarlo
- no requerir formato especial obligatorio

### Objetivo
Facilitar la captura de cantos copiados desde notas, páginas web, documentos o mensajes.

---

## 4. Importar texto simple

Se permitirá pegar texto con una estructura sencilla y que la app interprete algunos campos automáticamente.

### Ejemplo de texto simple

```txt
Título: Sublime Gracia
Autor: Tradicional
Tono: G
Capo: 2
BPM: 72

Sublime gracia del Señor
Que a un infeliz salvó
Fui ciego mas hoy miro yo
Perdido y Él me halló