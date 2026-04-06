# Fase 1 - Base de cantos y almacenamiento local

## Documentación de fase 1

## Objetivo general

Construir una primera versión funcional de la app que permita guardar, consultar y administrar cantos de forma local, sin depender de internet.

Esta fase se enfoca en establecer la base principal del producto para que ya pueda usarse como biblioteca personal de cantos, manteniendo una experiencia visual consistente con los diseños definidos en la fase 0.

---

## Alcance de la fase

En esta fase se desarrollarán únicamente los elementos esenciales para contar con una primera versión usable centrada en cantos.

### Alcance principal
- base local de cantos
- gestión básica de cantos
- consulta de cantos
- favoritos
- ajustes básicos de lectura
- funcionamiento offline desde el inicio

### Fuera de alcance en esta fase
- sincronización en la nube
- colaboración entre usuarios
- compartir repertorios por enlace o invitación
- secuencias, tracks o audio multicanal
- control por pedal midi
- modo en vivo avanzado
- sistema completo de usuarios
- login obligatorio
- funciones avanzadas de exploración
- recomendaciones inteligentes
- búsqueda avanzada con lógica compleja

---

## Primer objetivo

### Levantar la app con hola mundo
**Estado:** terminado

Este punto corresponde al arranque técnico inicial del proyecto para validar la base de desarrollo y la capacidad de ejecución de la aplicación.

---

## Objetivo funcional de la fase 1

Lograr que el usuario pueda:

- abrir la app
- navegar entre las pantallas principales base
- consultar su biblioteca local de cantos
- buscar cantos por nombre o texto
- abrir el detalle de un canto
- marcar cantos como favoritos
- agregar nuevos cantos
- editar cantos existentes
- borrar cantos
- ajustar tamaño de letra
- usar la app sin conexión a internet

---

## Prioridades de desarrollo

### Prioridad alta
- conexión a base de datos local
- modelo base de canto
- alta de cantos
- edición de cantos
- borrado de cantos
- vista de lista de cantos
- detalle de canto
- favoritos
- búsqueda básica
- ajuste de tamaño de letra
- soporte offline

### Prioridad media
- refinamientos visuales
- mejoras de navegación
- filtros simples
- ajustes adicionales de lectura

### Prioridad baja dentro de esta fase
- mejoras cosméticas no críticas
- microinteracciones avanzadas
- exploración visual adicional

---

## Pantallas contempladas en esta fase

Las siguientes pantallas forman parte del alcance visual y funcional base de la fase 1:

### 1. Home
Pantalla principal de entrada a la app.

Debe permitir acceso rápido a:
- cantos
- repertorios
- favoritos
- ajustes
- buscador
- próximo repertorio como bloque contextual

### 2. Lista de cantos
Pantalla principal de biblioteca local.

Debe incluir:
- listado de cantos
- buscador
- filtros rápidos
- favorito por elemento
- acceso al detalle
- botón para agregar canto

### 3. Detalle de canto
Pantalla para consultar el contenido completo de un canto.

Debe incluir:
- título
- información secundaria
- tono base
- letra
- favorito
- visualización clara
- acceso a acciones básicas

### 4. Modo lectura o pantalla completa
Vista enfocada en lectura cómoda del canto.

Debe priorizar:
- legibilidad
- poco ruido visual
- lectura continua
- soporte para acordes si aplica

### 5. Buscar
Pantalla enfocada en búsqueda rápida.

Debe incluir:
- barra de búsqueda principal
- búsquedas recientes
- resultados rápidos
- acceso al detalle del canto

### 6. Ajustes
Pantalla de configuración básica.

Debe incluir:
- modo visual
- tamaño de letra
- mostrar acordes
- mantener pantalla encendida
- información de soporte o versión

### 7. Repertorios
Visualmente ya está definida, pero funcionalmente en esta fase puede quedar parcial o mínima según avance real del desarrollo.

---

## Funcionalidades principales

## 1. Conexión a base de datos local
Se implementará una base de datos local para almacenar los cantos dentro del dispositivo.

### Objetivo
Permitir que toda la información principal de la app esté disponible sin conexión.

### Consideraciones
- almacenamiento persistente
- lectura rápida
- estructura simple y escalable
- preparada para futuras fases

---

## 2. Agregar canto
El usuario podrá crear nuevos cantos desde la app.

### Información mínima sugerida
- título
- letra
- tono base

### Información opcional para esta fase
- autor
- categoría
- notas breves

---

## 3. Editar canto
El usuario podrá modificar la información de un canto ya guardado.

### Alcance
- editar título
- editar letra
- editar tono base
- actualizar favorito si aplica

---

## 4. Borrar canto
El usuario podrá eliminar cantos guardados localmente.

### Consideración
Debe existir confirmación antes de borrar para evitar errores accidentales.

---

## 5. Vista básica de canto
Se implementará la vista principal de lectura de un canto.

### Debe permitir
- leer la letra
- ver tono base
- mostrar información secundaria
- acceder a modo lectura o pantalla completa
- consultar acordes si aplica

---

## 6. Modificar tamaño de letra
El usuario podrá ajustar el tamaño de la letra del canto para una lectura más cómoda.

### Objetivo
Adaptar la lectura a distintos contextos:
- uso personal
- ensayo
- escenario
- lectura prolongada

---

## 7. Soporte offline desde el inicio
Toda la funcionalidad principal de la fase 1 debe operar sin conexión a internet.

### Incluye
- acceso a cantos guardados
- búsqueda local
- favoritos
- lectura
- ajustes básicos

---

## 8. Agregar favoritos
Se permitirá marcar y desmarcar cantos como favoritos.

### Objetivo
Dar acceso rápido a cantos frecuentes o importantes.

### Alcance inicial
- marcar favorito
- quitar favorito
- visualizar favoritos en lista o filtro simple
- mostrar indicador visual por canto

---

## Decisiones visuales base tomadas desde fase 0

La fase 1 utilizará la línea visual ya definida durante la fase 0.

### Dirección visual general
- estilo oscuro como base principal
- estética worship moderna y sobria
- alto enfoque en legibilidad
- cards redondeadas
- navegación inferior consistente
- interfaz limpia, moderna y sin saturación

### Pantallas móviles base ya definidas visualmente
- Home
- Repertorios
- Ajustes
- Lista de cantos
- Detalle de canto
- Modo lectura
- Buscar

Estas pantallas sirven como referencia para el desarrollo visual inicial de la fase 1.

---

## Flujo principal esperado en esta fase

### Flujo 1 - Consultar un canto
1. abrir la app
2. entrar a cantos o buscar
3. localizar un canto
4. abrir detalle
5. leer contenido
6. ajustar letra si es necesario

### Flujo 2 - Agregar canto
1. abrir la app
2. tocar botón de agregar
3. capturar datos mínimos
4. guardar
5. visualizar el nuevo canto en la lista

### Flujo 3 - Marcar favorito
1. abrir lista de cantos o detalle
2. marcar o desmarcar favorito
3. consultar el canto desde favoritos o filtro relacionado

---

## Estructura mínima de datos sugerida para canto

Se propone una estructura simple para la primera fase.

### Campos base
- id
- título
- letra
- tono_base
- autor
- categoria
- favorito
- fecha_creacion
- fecha_actualizacion

Esta estructura puede ajustarse durante la implementación según la tecnología elegida para almacenamiento local.

---

## Criterios de éxito de la fase

La fase 1 se considerará funcionalmente cumplida cuando:

- la app abra correctamente
- exista almacenamiento local funcional
- sea posible agregar cantos
- sea posible editar cantos
- sea posible borrar cantos
- sea posible consultar la lista de cantos
- sea posible abrir el detalle de un canto
- sea posible cambiar tamaño de letra
- sea posible marcar favoritos
- la app funcione sin internet en sus funciones principales

---

## Test

En esta fase se deberán validar al menos los siguientes puntos:

- creación de cantos
- edición de cantos
- borrado de cantos
- lectura correcta de información guardada
- persistencia local de datos
- funcionamiento de favoritos
- búsqueda local
- ajuste de tamaño de letra
- funcionamiento sin conexión
- estabilidad general de navegación entre pantallas

---

## Entregable

Al finalizar esta fase se espera contar con:

- una app funcional con almacenamiento local
- gestión básica de cantos
- lectura de cantos
- buscador funcional
- favoritos
- ajustes básicos de lectura
- soporte offline
- base visual consistente con fase 0
- primera versión usable del producto

---

## Notas

Esta fase se concentra en construir una base sólida y usable.
Las funciones más avanzadas de repertorios, colaboración, sincronización, secuencias y uso en vivo avanzado se evaluarán en fases posteriores.