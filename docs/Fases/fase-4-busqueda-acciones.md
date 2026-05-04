# Fase 4 - Búsqueda, filtros y organización básica

## Objetivo

Facilitar la búsqueda, filtrado y organización de cantos dentro de la aplicación, especialmente cuando la biblioteca local empiece a crecer.

Esta fase busca que el usuario pueda encontrar rápidamente un canto por título, contenido, categoría, artista, género musical, etiquetas, favoritos o cantos recientes.

También se agregarán acciones rápidas para administrar cantos desde la lista principal.

---

## Alcance general

En esta fase se implementarán herramientas básicas de organización para mejorar la experiencia de uso de la biblioteca de cantos.

La fase incluye:

- Búsqueda de cantos por título.
- Búsqueda dentro del contenido de la letra.
- Filtros por categoría.
- Filtros por artista.
- Filtros por género musical.
- Etiquetas personalizadas.
- Etiquetas por temporada o evento.
- Marcado de cantos como favoritos.
- Vista o sección de cantos recientes.
- Acciones rápidas al deslizar un canto.
- Pruebas generales.
- Entregable APK para Android.

---

## Consideraciones de la fase

Esta fase puede dividirse en partes para evitar implementar demasiadas funciones al mismo tiempo.

La búsqueda y los filtros deben sentirse rápidos, claros y fáciles de usar.

La organización debe ayudar al usuario sin volver compleja la experiencia. La app debe seguir siendo simple, limpia y práctica para músicos, cantantes y equipos de alabanza.

---

# División sugerida de la fase

## Parte 1 - Base de búsqueda

### Objetivo

Permitir que el usuario pueda encontrar cantos rápidamente mediante un buscador principal.

### Funciones incluidas

1. Agregar buscador en la pantalla de listado de cantos.
2. Buscar cantos por título.
3. Buscar cantos por contenido de letra.
4. Mostrar resultados en tiempo real o al escribir.
5. Mostrar estado vacío cuando no haya resultados.
6. Mantener buena legibilidad en modo claro y modo oscuro.

### Resultado esperado

El usuario podrá escribir una palabra o frase y la app mostrará los cantos que coincidan por título o por contenido de letra.

---

## Parte 2 - Filtros básicos

### Objetivo

Agregar filtros para organizar mejor la biblioteca de cantos.

### Funciones incluidas

1. Filtro por categoría.
2. Filtro por artista.
3. Filtro por género musical.
4. Combinación de búsqueda con filtros.
5. Opción para limpiar filtros.
6. Indicador visual de filtros activos.

### Resultado esperado

El usuario podrá reducir la lista de cantos usando filtros como categoría, artista o género musical.

Ejemplos:

- Adoración
- Júbilo
- Alabanza
- Entrada
- Santa Cena
- Artista específico
- Género musical específico

---

## Parte 3 - Etiquetas personalizadas

### Objetivo

Permitir que el usuario pueda clasificar cantos con etiquetas propias.

### Funciones incluidas

1. Crear etiquetas personalizadas.
2. Asignar una o varias etiquetas a un canto.
3. Editar etiquetas asignadas.
4. Quitar etiquetas de un canto.
5. Filtrar cantos por etiqueta.

### Ejemplos de etiquetas

- Navidad
- Semana Santa
- Jóvenes
- Domingo
- Vigilia
- Congreso
- Ensayo
- Especial
- Fácil
- Nueva
- Pendiente de practicar

### Resultado esperado

El usuario podrá organizar sus cantos con etiquetas flexibles según sus propias necesidades.

---

## Parte 4 - Etiquetas por temporada o evento

### Objetivo

Agregar soporte para clasificar cantos por temporadas, fechas especiales o eventos.

### Funciones incluidas

1. Crear etiquetas orientadas a temporadas.
2. Crear etiquetas orientadas a eventos.
3. Filtrar cantos por temporada o evento.
4. Mostrar estas etiquetas de forma clara en el detalle del canto.

### Ejemplos de temporadas o eventos

- Navidad
- Semana Santa
- Año Nuevo
- Día de las Madres
- Día del Padre
- Congreso
- Campamento
- Culto especial
- Santa Cena

### Resultado esperado

El usuario podrá encontrar rápidamente cantos relacionados con una fecha, temporada o evento específico.

---

## Parte 5 - Favoritos

### Objetivo

Permitir que el usuario pueda marcar cantos importantes o frecuentes como favoritos.

### Funciones incluidas

1. Marcar un canto como favorito.
2. Quitar un canto de favoritos.
3. Mostrar indicador visual de favorito.
4. Crear sección o filtro de favoritos.
5. Permitir buscar dentro de favoritos.

### Resultado esperado

El usuario podrá acceder más rápido a los cantos que usa con más frecuencia.

---

## Parte 6 - Cantos recientes

### Objetivo

Mostrar los cantos consultados o modificados recientemente.

### Funciones incluidas

1. Registrar últimos cantos abiertos.
2. Registrar últimos cantos editados.
3. Mostrar sección de cantos recientes.
4. Ordenar recientes por fecha de uso.
5. Evitar duplicados en la lista de recientes.

### Resultado esperado

El usuario podrá regresar rápidamente a los cantos que usó hace poco.

---

## Parte 7 - Acciones rápidas al deslizar

### Objetivo

Agregar acciones rápidas desde la lista de cantos para mejorar la administración.

### Funciones incluidas

1. Deslizar canto hacia la izquierda o derecha.
2. Mostrar acción para editar.
3. Mostrar acción para borrar.
4. Mostrar acción para marcar o quitar favorito.
5. Confirmar antes de borrar.
6. Mostrar mensaje de confirmación después de una acción.

### Acciones sugeridas

Al deslizar un canto se podrán mostrar acciones como:

- Editar
- Borrar
- Marcar como favorito
- Quitar de favoritos

### Resultado esperado

El usuario podrá administrar cantos de forma rápida sin entrar necesariamente al detalle del canto.

---

## Parte 8 - Ajustes visuales y experiencia de usuario

### Objetivo

Mejorar la presentación visual de búsqueda, filtros, etiquetas, favoritos y recientes.

### Funciones incluidas

1. Diseño limpio para buscador.
2. Chips o botones para filtros.
3. Chips para etiquetas.
4. Indicadores visuales para favoritos.
5. Estado vacío para búsquedas sin resultados.
6. Estado vacío para favoritos sin cantos.
7. Estado vacío para recientes sin registros.
8. Compatibilidad con modo claro y modo oscuro.

### Resultado esperado

La organización de cantos debe sentirse simple, clara y rápida de usar.

---

## Parte 9 - Pruebas

### Objetivo

Validar que la búsqueda, filtros y organización funcionen correctamente.

### Pruebas sugeridas

1. Buscar canto por título.
2. Buscar canto por palabra dentro de la letra.
3. Buscar sin resultados.
4. Aplicar filtro por categoría.
5. Aplicar filtro por artista.
6. Aplicar filtro por género musical.
7. Aplicar varios filtros al mismo tiempo.
8. Limpiar filtros activos.
9. Crear etiqueta personalizada.
10. Asignar etiqueta a un canto.
11. Quitar etiqueta de un canto.
12. Filtrar por etiqueta.
13. Marcar canto como favorito.
14. Quitar canto de favoritos.
15. Ver lista de favoritos.
16. Abrir canto y validar que aparezca en recientes.
17. Editar canto y validar que aparezca en recientes.
18. Deslizar canto y editar.
19. Deslizar canto y marcar como favorito.
20. Deslizar canto y borrar con confirmación.
21. Validar comportamiento en modo claro.
22. Validar comportamiento en modo oscuro.

---

## Parte 10 - Entregable

### Objetivo

Generar una versión funcional de la fase 4 para pruebas en Android.

### Entregable esperado

- APK de Android.
- Búsqueda funcional por título.
- Búsqueda funcional por contenido de letra.
- Filtros básicos funcionando.
- Etiquetas personalizadas funcionando.
- Favoritos funcionando.
- Cantos recientes funcionando.
- Acciones rápidas al deslizar funcionando.
- Pruebas básicas realizadas.

---

# Roadmap resumido de la fase

1. Documentación de fase.
2. Buscador por título.
3. Buscador por contenido de letra.
4. Filtros por categoría.
5. Filtros por artista.
6. Filtros por género musical.
7. Etiquetas personalizadas.
8. Etiquetas por temporada o evento.
9. Favoritos.
10. Cantos recientes.
11. Acciones rápidas al deslizar cantos.
12. Pruebas.
13. Entregable APK Android.

---

# Recomendación de implementación

Para evitar que la fase sea demasiado pesada, se recomienda trabajar en el siguiente orden:

1. Primero implementar búsqueda por título y letra.
2. Después agregar filtros básicos.
3. Luego agregar favoritos.
4. Después agregar etiquetas.
5. Luego agregar cantos recientes.
6. Finalmente agregar acciones rápidas al deslizar.

De esta manera, cada parte se puede probar antes de avanzar a la siguiente.

---

# Resultado final esperado

Al terminar esta fase, App Letras permitirá que el usuario encuentre, filtre y organice sus cantos de forma mucho más rápida.

La aplicación estará mejor preparada para manejar bibliotecas grandes de cantos sin que el usuario tenga que buscar manualmente entre muchas canciones.

Esta fase convierte la biblioteca de cantos en una herramienta más práctica, ordenada y útil para el uso real en ensayos, cultos, eventos y presentaciones.