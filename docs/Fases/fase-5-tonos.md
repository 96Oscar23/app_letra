# Fase 5 - Tonos y personalización musical

## Objetivo

Permitir que cada canto pueda manejar tonos musicales de forma práctica, flexible y útil para ensayo, preparación y presentación.

Esta fase agrega la capacidad de guardar un tono principal para cada canto, modificarlo fácilmente subiendo o bajando el tono, y registrar tonos personalizados por cantante cuando sea necesario.

La finalidad es que la app no solo muestre la letra del canto, sino que también ayude a organizar la información musical básica que se usa en ensayos, reuniones o presentaciones.

---

## Alcance de la fase

En esta fase se trabajará únicamente la funcionalidad relacionada con tonos musicales.

Se contempla:

- Agregar tono principal a un canto.
- Editar el tono principal.
- Subir o bajar el tono de forma manual.
- Mostrar el tono actual en la vista del canto.
- Guardar tonos personalizados por cantante.
- Consultar tonos guardados por cantante.
- Probar el flujo completo de tonos.

No se contempla todavía:

- Transposición automática de acordes dentro de toda la letra.
- Detección automática de acordes.
- Repertorios con tonos por evento.
- Sincronización en la nube.
- Modo presentación avanzado.
- Control MIDI.
- Secuencias, pads o pistas.

Estos puntos pueden formar parte de fases posteriores.

---

## Funcionalidades principales

### 1. Documentación de fase

Crear la documentación base de la Fase 5, explicando el objetivo, alcance, funcionalidades, decisiones iniciales y entregable esperado.

La documentación debe servir como guía para el desarrollo y como referencia para futuras fases relacionadas con música, repertorios y presentación.

---

### 2. Agregar tonos

Permitir que un canto tenga asignado un tono principal.

El tono principal representa el tono base en el que normalmente se toca el canto.

Ejemplos:

- C
- D
- E
- F
- G
- A
- B
- Cm
- Dm
- Em
- F#m
- Bb
- Eb

El usuario podrá seleccionar o escribir el tono al crear o editar un canto.

#### Consideraciones

- El tono debe ser opcional.
- No todos los cantos necesitan tener tono.
- Si un canto no tiene tono, la app debe mostrar un estado discreto como “Sin tono asignado”.
- El tono principal debe guardarse localmente junto con la información del canto.

---

### 3. Editar tonos

Permitir modificar el tono principal de un canto existente.

El usuario podrá entrar a la edición del canto y cambiar el tono guardado.

#### Consideraciones

- El cambio debe actualizarse en la base de datos local.
- El tono editado debe reflejarse en la vista de detalle del canto.
- La edición debe ser simple y rápida.
- No debe afectar la letra ni otros datos del canto.

---

### 4. Subir o bajar tono

Permitir al usuario subir o bajar el tono actual de un canto.

Esta función debe ayudar cuando un canto necesita adaptarse a la voz del cantante o al contexto del ensayo.

Ejemplo:

- Si el tono actual es `C` y se sube medio tono, pasa a `C#` o `Db`.
- Si el tono actual es `G` y se baja un tono, pasa a `F`.
- Si el tono actual es `A` y se baja medio tono, pasa a `Ab` o `G#`.

#### Consideraciones iniciales

Para esta fase, la prioridad es manejar el cambio del tono visible, no necesariamente transponer todos los acordes dentro de la letra.

La app debe permitir:

- Subir medio tono.
- Bajar medio tono.
- Mostrar el tono resultante.
- Guardar el tono ajustado si el usuario lo desea.

#### Decisión inicial

El cambio de tono en esta fase se enfocará en el tono principal del canto.

La transposición completa de acordes dentro de la letra puede quedar para una fase posterior.

---

### 5. Guardar tono principal

Permitir guardar un tono principal fijo para cada canto.

Este tono será el tono base del canto y servirá como referencia inicial al abrirlo.

#### Ejemplo

Un canto puede tener:

```txt
Título: Digno y Santo
Tono principal: G

Cuando el usuario abra el canto, la app mostrará el tono principal guardado.

Consideraciones
El tono principal debe estar disponible desde la vista de canto.
Debe poder editarse posteriormente.
Debe poder usarse como punto de partida para subir o bajar tono.
6. Guardar tono por cantante

Permitir guardar tonos personalizados por cantante.

Esto es útil cuando un mismo canto se toca en distintos tonos dependiendo de quién lo canta.

Ejemplo
Canto: Digno y Santo
Tono principal: G

Tonos por cantante:
- Ana: A
- Carlos: G
- María: F
Funcionalidad esperada

El usuario podrá:

Agregar un cantante.
Asignarle un tono específico para ese canto.
Editar el tono de un cantante.
Eliminar un tono guardado por cantante.
Consultar la lista de tonos personalizados.
Consideraciones
Los tonos por cantante pertenecen al canto.
Un canto puede tener cero, uno o varios tonos por cantante.
El tono por cantante no reemplaza necesariamente al tono principal.
El tono principal sigue siendo la referencia general del canto.
El usuario debe poder elegir rápidamente qué tono usar.
7. Mostrar tono actual en vista de canto

Mostrar de forma clara el tono actual dentro de la vista de canto.

La vista de canto debe permitir identificar rápidamente:

Título del canto.
Categoría, si aplica.
Tono principal.
Tono actual seleccionado.
Tonos por cantante, si existen.
Ejemplo visual esperado
Digno y Santo

Tono actual: G
Tono principal: G

Cantante:
Ana - A
Carlos - G
María - F
Consideraciones de interfaz
El tono actual debe ser visible sin saturar la pantalla.
Debe poder cambiarse de manera rápida.
Debe estar pensado para usarse durante ensayo o presentación.
En tablet debe aprovecharse mejor el espacio disponible.
En móvil debe mantenerse limpio y compacto.
Modelo de datos sugerido
Canto

Agregar campos relacionados con tono principal.

id
titulo
letra
categoria_id
tono_principal
created_at
updated_at
deleted
Campo nuevo sugerido
tono_principal

Descripción:

Guarda el tono base del canto.

Ejemplos:

C
D
E
F
G
A
B
Cm
F#m
Bb
Eb
CantoTonoCantante

Crear una nueva entidad para guardar tonos personalizados por cantante.

id
canto_id
nombre_cantante
tono
created_at
updated_at
deleted
Descripción de campos
Campo	Descripción
id	Identificador único del registro
canto_id	Relación con el canto
nombre_cantante	Nombre del cantante
tono	Tono asignado para ese cantante
created_at	Fecha de creación
updated_at	Fecha de última modificación
deleted	Borrado lógico
Flujo principal
Flujo 1 - Agregar tono principal
El usuario entra a crear o editar un canto.
Selecciona el campo de tono.
Elige o escribe el tono principal.
Guarda el canto.
La app muestra el tono en la vista de canto.
Flujo 2 - Editar tono principal
El usuario abre un canto existente.
Entra a la opción de editar.
Cambia el tono principal.
Guarda los cambios.
La vista del canto muestra el nuevo tono.
Flujo 3 - Subir o bajar tono
El usuario abre un canto.
La app muestra el tono actual.
El usuario presiona “Subir tono” o “Bajar tono”.
La app calcula el nuevo tono.
El usuario puede dejarlo temporalmente o guardarlo como tono principal.
Flujo 4 - Guardar tono por cantante
El usuario abre un canto.
Entra a la sección de tonos por cantante.
Agrega el nombre del cantante.
Selecciona el tono correspondiente.
Guarda el registro.
El cantante aparece en la lista de tonos personalizados.
Flujo 5 - Seleccionar tono por cantante
El usuario abre un canto.
Revisa la lista de tonos por cantante.
Selecciona un cantante.
La app cambia el tono actual al tono guardado para ese cantante.
El usuario puede usar ese tono durante el ensayo o presentación.
Pantallas consideradas para esta fase

Las pantallas se diseñarán después de cerrar este documento.

Pantallas sugeridas:

Vista de canto con tono actual.
Selector de tono.
Modal o pantalla para tonos por cantante.
Estado vacío de tonos por cantante.
Formulario para agregar tono por cantante.
Vista de canto con tono seleccionado por cantante.
Reglas de negocio
Tono principal
Un canto puede tener un tono principal.
El tono principal es opcional.
El tono principal puede editarse.
El tono principal se muestra como referencia base.
Tono actual
El tono actual es el tono que se está usando en ese momento.
Puede ser igual al tono principal.
Puede cambiar temporalmente al subir o bajar tono.
Puede cambiar al seleccionar un tono por cantante.
Tono por cantante
Un canto puede tener varios tonos por cantante.
Un cantante no debería repetirse dentro del mismo canto con el mismo propósito.
Si se repite el nombre de cantante, la app debe advertir o permitir editar el registro existente.
El tono por cantante no elimina ni reemplaza el tono principal.
Validaciones
Tono principal
Puede estar vacío.
Si se captura, debe ser un tono válido o reconocido por la app.
Debe permitir tonos mayores y menores.
Debe permitir sostenidos y bemoles.

Ejemplos válidos:

C
C#
Db
D
D#
Eb
E
F
F#
Gb
G
G#
Ab
A
A#
Bb
B
Cm
C#m
Dbm
Dm
D#m
Ebm
Em
Fm
F#m
Gbm
Gm
G#m
Abm
Am
A#m
Bbm
Bm
Nombre de cantante
No debe estar vacío.
Debe limpiarse de espacios extra.
Debe permitir nombres cortos o completos.
Debe poder editarse.
Tono por cantante
Debe tener un tono válido.
Debe pertenecer a un canto existente.
Debe poder eliminarse mediante borrado lógico si aplica.
Consideraciones de UX

La función de tonos debe sentirse rápida y práctica.

La app debe evitar que el usuario tenga que entrar a demasiadas pantallas para cambiar un tono durante un ensayo.

Se recomienda:

Mostrar el tono actual de forma visible.
Usar botones claros para subir y bajar tono.
Permitir seleccionar tono desde una lista.
Permitir guardar cambios solo cuando el usuario lo decida.
Diferenciar entre tono principal y tono temporal.
Mostrar los tonos por cantante de forma compacta.
Evitar saturar la vista de canto.
Consideraciones técnicas
Transposición básica

Para subir o bajar tonos, se puede usar una lista ordenada de semitonos.

Ejemplo usando sostenidos:

C, C#, D, D#, E, F, F#, G, G#, A, A#, B

Ejemplo usando bemoles:

C, Db, D, Eb, E, F, Gb, G, Ab, A, Bb, B

Para esta fase se puede iniciar con una sola notación principal.

Recomendación inicial:

C, C#, D, D#, E, F, F#, G, G#, A, A#, B

Después se puede agregar preferencia para mostrar bemoles o sostenidos.

Decisiones iniciales
El tono principal será opcional.
El cambio de tono será sobre el tono actual visible.
La transposición completa de acordes dentro de la letra queda fuera de esta fase.
Se permitirá guardar tonos personalizados por cantante.
El tono por cantante será específico por canto.
La vista de canto debe mostrar el tono actual de forma clara.
El usuario podrá subir o bajar medio tono.
Se debe mantener una experiencia simple para ensayo.
Casos de prueba
Caso 1 - Crear canto con tono principal
Crear un canto nuevo.
Asignar tono principal G.
Guardar el canto.
Abrir la vista del canto.
Validar que se muestre el tono G.

Resultado esperado:

El canto se guarda correctamente y muestra el tono principal.
Caso 2 - Editar tono principal
Abrir un canto con tono G.
Editar el canto.
Cambiar tono a A.
Guardar.
Volver a abrir el canto.

Resultado esperado:

El canto muestra el nuevo tono principal A.
Caso 3 - Subir tono
Abrir un canto con tono actual C.
Presionar subir tono.
Validar que el tono cambie a C#.

Resultado esperado:

El tono actual cambia correctamente al siguiente semitono.
Caso 4 - Bajar tono
Abrir un canto con tono actual G.
Presionar bajar tono.
Validar que el tono cambie a F#.

Resultado esperado:

El tono actual cambia correctamente al semitono anterior.
Caso 5 - Guardar tono por cantante
Abrir un canto.
Entrar a tonos por cantante.
Agregar cantante Ana.
Asignar tono A.
Guardar.

Resultado esperado:

El tono personalizado de Ana se guarda correctamente.
Caso 6 - Seleccionar tono por cantante
Abrir un canto.
Seleccionar el tono guardado para Ana.
Validar que el tono actual cambie a A.

Resultado esperado:

El tono actual se actualiza con el tono asignado al cantante.
Caso 7 - Canto sin tono
Crear un canto sin tono principal.
Abrir la vista del canto.

Resultado esperado:

La app muestra un estado discreto como “Sin tono asignado”.
Caso 8 - Eliminar tono por cantante
Abrir un canto con tonos por cantante.
Eliminar el registro de un cantante.
Guardar o confirmar eliminación.

Resultado esperado:

El tono por cantante deja de mostrarse en la lista.
Entregable de la fase

Al finalizar esta fase, la app debe permitir:

Guardar tono principal en un canto.
Editar tono principal.
Mostrar tono actual en la vista de canto.
Subir y bajar tono.
Guardar tonos personalizados por cantante.
Seleccionar rápidamente un tono por cantante.
Probar el flujo completo sin afectar las funcionalidades anteriores.
Resultado esperado

Al terminar la Fase 5, App Letras tendrá una primera capa de personalización musical.

El usuario podrá abrir un canto y saber rápidamente en qué tono se toca, modificarlo si es necesario y guardar tonos específicos para diferentes cantantes.

Esto prepara la app para futuras fases como repertorios, modo presentación, transposición completa de acordes, control con pedal MIDI y funciones más avanzadas para ensayos.