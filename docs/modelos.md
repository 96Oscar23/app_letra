# Modelos del proyecto

Este documento describe los modelos principales contemplados para la aplicación, su propósito general y la relación conceptual entre ellos.

La intención de este archivo no es definir todavía la implementación exacta de base de datos, sino dejar claro qué entidades existen, qué resuelve cada una y cómo se conectan dentro del producto.

---

## Objetivo de este documento

- identificar las entidades principales del sistema
- entender cómo se relacionan entre sí
- servir como base para futuras decisiones de arquitectura y persistencia
- facilitar el desarrollo de pantallas, flujos y fases del roadmap

---

## Consideraciones generales

- no todos los modelos tendrán que existir desde la primera fase
- algunos modelos aparecerán más adelante conforme avance el roadmap
- varios campos pueden cambiar en nombre o detalle técnico
- este documento representa una base conceptual, no una definición final de tablas

---

# 1. Canto

## Descripción

Representa la entidad principal del sistema: una canción o canto registrado dentro de la aplicación.

Es la base desde la cual se construyen otras funciones como tonos, variantes, repertorios, notas, referencias, pads y secuencias.

## Propósito

- guardar la letra principal
- servir como unidad base de consulta
- permitir organización, búsqueda y reutilización

## Campos sugeridos

- `id`
- `uuid`
- `titulo`
- `letra`
- `artista`
- `genero`
- `categoria`
- `tono_principal`
- `estado`
- `notas_generales`
- `fecha_creacion`
- `fecha_actualizacion`
- `fecha_ultimo_uso`
- `favorito`
- `archivado`
- `usuario_creador_id`

## Comentarios

Un canto puede existir como contenido simple desde las primeras fases.  
No necesita estar estructurado por partes desde el inicio.

## Relaciones

- un canto puede tener muchas variantes
- un canto puede tener muchas notas
- un canto puede tener muchos archivos adjuntos o referencias
- un canto puede pertenecer a muchos repertorios
- un canto puede tener un pad asociado
- un canto puede tener una secuencia asociada

---

# 2. Variante de canto

## Descripción

Representa una versión derivada de un canto base.

Sirve para modelar casos donde el mismo canto cambia ligeramente según el artista, el estilo, la letra, el orden o el tono.

## Propósito

- evitar modificar directamente el canto base
- permitir múltiples versiones de una misma canción
- reutilizar una variante dentro de repertorios

## Campos sugeridos

- `id`
- `uuid`
- `canto_id`
- `nombre`
- `artista_referencia`
- `descripcion`
- `letra`
- `tono`
- `orden_general`
- `notas`
- `fecha_creacion`
- `fecha_actualizacion`
- `usuario_creador_id`

## Comentarios

La variante no sustituye al canto base.  
Es una capa adicional para representar adaptaciones reales del contenido.

## Relaciones

- una variante pertenece a un canto
- una variante puede tener notas
- una variante puede tener referencias
- una variante puede usarse dentro de repertorios

---

# 3. Repertorio

## Descripción

Representa un conjunto ordenado de cantos para ensayo, culto, presentación o evento.

## Propósito

- agrupar cantos
- definir orden de ejecución
- servir como base para uso en vivo

## Campos sugeridos

- `id`
- `uuid`
- `nombre`
- `descripcion`
- `fecha_evento`
- `estado`
- `modo_visualizacion`
- `usuario_creador_id`
- `proyecto_id`
- `fecha_creacion`
- `fecha_actualizacion`

## Comentarios

En fases iniciales, el repertorio puede ser solo una lista ordenada.  
En fases posteriores podrá incluir flujo avanzado, transiciones y personalización por canto.

El campo `modo_visualizacion` puede ayudar a guardar la preferencia principal del usuario para ese repertorio, por ejemplo:
- lista
- detalle
- letra
- en_vivo

## Relaciones

- un repertorio tiene muchos elementos de repertorio
- un repertorio puede pertenecer a un proyecto
- un repertorio puede tener notas
- un repertorio puede tener una playlist
- un repertorio puede tener una grabación asociada
- un repertorio puede compartirse con usuarios

---

# 4. Elemento de repertorio

## Descripción

Representa la relación entre un repertorio y un canto o variante dentro de ese repertorio.

Este modelo es importante porque ahí puede vivir la personalización real de uso:
qué variante se usa, en qué parte inicia, en qué parte termina, si conecta con otro canto, etc.

## Propósito

- guardar el orden dentro del repertorio
- permitir personalización por uso
- soportar medleys, transiciones y cambios de tono
- mostrar información resumida en vista compacta

## Campos sugeridos

- `id`
- `uuid`
- `repertorio_id`
- `canto_id`
- `variante_id`
- `orden`
- `parte_inicio`
- `parte_fin`
- `tono_en_repertorio`
- `sin_pausa_con_siguiente`
- `tipo_transicion`
- `notas`
- `fecha_creacion`
- `fecha_actualizacion`

## Comentarios

Este modelo cobra más importancia en el flujo avanzado de repertorio.

En vista compacta de repertorio, este modelo puede ser la base para mostrar:
- orden
- título
- variante
- tono
- indicadores simples

## Relaciones

- pertenece a un repertorio
- referencia a un canto
- opcionalmente referencia a una variante

---

# 5. Proyecto

## Descripción

Representa un contenedor superior para organizar repertorios, playlists, usuarios y colaboración dentro de un mismo contexto.

## Propósito

- agrupar trabajo relacionado
- evitar duplicación de playlists o referencias
- organizar repertorios bajo un mismo contexto

## Campos sugeridos

- `id`
- `uuid`
- `nombre`
- `descripcion`
- `estado`
- `usuario_creador_id`
- `fecha_creacion`
- `fecha_actualizacion`

## Comentarios

Proyecto no reemplaza a repertorio.  
Proyecto agrupa varios repertorios y otros recursos relacionados.

## Relaciones

- un proyecto puede tener muchos repertorios
- un proyecto puede tener muchas playlists
- un proyecto puede tener muchos usuarios asociados

---

# 6. Playlist

## Descripción

Representa una lista de referencias musicales asociadas a un repertorio o proyecto.

Puede contener enlaces de YouTube, Spotify u otras referencias.

## Propósito

- alinear al equipo con una referencia musical
- reutilizar playlists sin crear nuevas cada vez
- compartir versiones de referencia

## Campos sugeridos

- `id`
- `uuid`
- `nombre`
- `descripcion`
- `tipo_origen`
- `repertorio_id`
- `proyecto_id`
- `usuario_creador_id`
- `fecha_creacion`
- `fecha_actualizacion`

## Comentarios

Una playlist puede vivir en repertorio o en proyecto.  
No siempre será necesario crear una nueva; puede reutilizarse una existente.

## Relaciones

- una playlist puede pertenecer a un repertorio o proyecto
- una playlist tiene muchos elementos de playlist

---

# 7. Elemento de playlist

## Descripción

Representa cada referencia individual dentro de una playlist.

## Propósito

- guardar enlaces concretos
- mantener orden de reproducción o consulta

## Campos sugeridos

- `id`
- `uuid`
- `playlist_id`
- `titulo`
- `tipo_fuente`
- `url`
- `orden`
- `descripcion`
- `fecha_creacion`

## Comentarios

El `tipo_fuente` puede indicar si la referencia es:
- YouTube
- Spotify
- otro enlace externo

## Relaciones

- pertenece a una playlist

---

# 8. Nota

## Descripción

Representa anotaciones visibles o internas relacionadas con un canto, variante, repertorio o elemento de repertorio.

## Propósito

- registrar observaciones musicales
- dejar instrucciones para ensayo o en vivo
- documentar detalles importantes

## Campos sugeridos

- `id`
- `uuid`
- `tipo_origen`
- `origen_id`
- `contenido`
- `visibilidad`
- `usuario_creador_id`
- `fecha_creacion`
- `fecha_actualizacion`

## Comentarios

Una nota puede aplicarse a diferentes niveles:
- canto
- variante
- repertorio
- elemento de repertorio

## Relaciones

- pertenece lógicamente a una entidad del sistema según `tipo_origen`

---

# 9. Usuario

## Descripción

Representa una cuenta dentro del sistema.

## Propósito

- permitir inicio de sesión
- identificar propiedad del contenido
- soportar colaboración y permisos

## Campos sugeridos

- `id`
- `uuid`
- `nombre`
- `correo`
- `password_hash`
- `foto`
- `estado`
- `fecha_creacion`
- `fecha_actualizacion`
- `ultimo_login`

## Comentarios

Este modelo puede arrancar simple y crecer conforme aparezcan colaboración, proyectos y roles.

## Relaciones

- un usuario puede crear cantos
- un usuario puede crear variantes
- un usuario puede crear repertorios
- un usuario puede pertenecer a proyectos
- un usuario puede participar en sesiones

---

# 10. Rol de colaboración

## Descripción

Representa el tipo de acceso que tiene un usuario sobre un repertorio o proyecto.

## Propósito

- definir permisos
- distinguir entre líder, editor o solo lectura

## Campos sugeridos

- `id`
- `uuid`
- `nombre`
- `descripcion`

## Relaciones

- puede ser usado en relaciones de usuarios con repertorios o proyectos

---

# 11. UsuarioProyecto

## Descripción

Representa la relación entre un usuario y un proyecto.

## Propósito

- registrar qué usuarios participan en un proyecto
- definir su rol dentro del proyecto

## Campos sugeridos

- `id`
- `uuid`
- `usuario_id`
- `proyecto_id`
- `rol_id`
- `fecha_creacion`

## Relaciones

- pertenece a usuario
- pertenece a proyecto
- pertenece a rol

---

# 12. UsuarioRepertorio

## Descripción

Representa la relación entre un usuario y un repertorio compartido.

## Propósito

- controlar acceso por repertorio
- definir permisos más específicos

## Campos sugeridos

- `id`
- `uuid`
- `usuario_id`
- `repertorio_id`
- `rol_id`
- `fecha_creacion`

---

# 13. Pad o sonido ambiental

## Descripción

Representa un sonido de apoyo simple asociado a un canto o repertorio.

## Propósito

- ambientar
- sostener un tono
- apoyar musicalmente sin entrar todavía a secuencias

## Campos sugeridos

- `id`
- `uuid`
- `nombre`
- `archivo`
- `tono_base`
- `volumen`
- `loop`
- `tipo_origen`
- `origen_id`
- `usuario_creador_id`
- `fecha_creacion`
- `fecha_actualizacion`

## Comentarios

Puede ser:
- un pad incluido por la app
- un pad personalizado subido por el usuario

## Relaciones

- puede pertenecer a un canto o repertorio

---

# 14. Grabación

## Descripción

Representa una grabación de audio de ensayo, culto o sesión.

## Propósito

- revisar errores o detalles después
- guardar referencia histórica
- asociar audio a un repertorio o fecha

## Campos sugeridos

- `id`
- `uuid`
- `nombre`
- `archivo`
- `fecha_grabacion`
- `duracion`
- `repertorio_id`
- `sesion_id`
- `usuario_creador_id`
- `fecha_creacion`

## Relaciones

- puede pertenecer a un repertorio
- puede pertenecer a una sesión
- pertenece a un usuario creador

---

# 15. Sesión en vivo

## Descripción

Representa una sesión sincronizada entre varios dispositivos durante ensayo o presentación.

## Propósito

- sincronizar repertorio actual
- sincronizar canto actual
- definir líder y participantes

## Campos sugeridos

- `id`
- `uuid`
- `nombre`
- `codigo_acceso`
- `estado`
- `repertorio_id`
- `usuario_lider_id`
- `fecha_inicio`
- `fecha_fin`
- `fecha_creacion`

## Comentarios

Este modelo cobra importancia en fases de sincronización y modo en vivo multiusuario.

## Relaciones

- una sesión puede tener muchos participantes
- una sesión usa un repertorio
- una sesión tiene un líder

---

# 16. Participante de sesión

## Descripción

Representa a cada usuario o dispositivo dentro de una sesión en vivo.

## Propósito

- saber quién está conectado
- manejar estado de participación

## Campos sugeridos

- `id`
- `uuid`
- `sesion_id`
- `usuario_id`
- `nombre_dispositivo`
- `estado_conexion`
- `fecha_union`
- `fecha_ultimo_ping`

---

# 17. Secuencia

## Descripción

Representa un recurso de audio más avanzado ligado a un canto.

## Propósito

- reproducir click, guía e instrumentos
- soportar acompañamiento por pistas
- base para consola de secuencias

## Campos sugeridos

- `id`
- `uuid`
- `nombre`
- `canto_id`
- `descripcion`
- `tempo`
- `tono`
- `duracion`
- `usuario_creador_id`
- `fecha_creacion`
- `fecha_actualizacion`

## Relaciones

- pertenece a un canto
- tiene muchas pistas

---

# 18. Pista de secuencia

## Descripción

Representa cada pista individual dentro de una secuencia.

## Propósito

- separar click, guía, instrumentos y otros elementos
- permitir control individual en consola

## Campos sugeridos

- `id`
- `uuid`
- `secuencia_id`
- `nombre`
- `tipo`
- `archivo`
- `volumen`
- `mute`
- `solo`
- `orden`
- `fecha_creacion`

## Comentarios

El tipo puede ser por ejemplo:
- click
- guía
- instrumento
- coro
- ambiente

---

# 19. Archivo adjunto

## Descripción

Representa un archivo relacionado con un canto u otra entidad.

## Propósito

- conservar material original
- guardar referencia visual o documental
- evitar pérdida de información

## Campos sugeridos

- `id`
- `uuid`
- `tipo_origen`
- `origen_id`
- `nombre`
- `tipo_archivo`
- `ruta_archivo`
- `tamano`
- `usuario_creador_id`
- `fecha_creacion`

## Comentarios

Puede utilizarse para:
- PDF
- imagen
- foto
- archivo de referencia

## Relaciones

- puede pertenecer a un canto, variante u otra entidad soportada

---

# 20. Métrica de uso

## Descripción

Representa el registro de uso de un canto dentro del sistema.

## Propósito

- construir estadísticas útiles
- detectar repeticiones
- identificar cantos olvidados o frecuentes

## Campos sugeridos

- `id`
- `uuid`
- `canto_id`
- `repertorio_id`
- `proyecto_id`
- `usuario_id`
- `tipo_evento`
- `fecha_evento`

## Comentarios

Este modelo puede crecer con el tiempo.  
Al inicio puede ser suficiente guardar eventos simples de uso.

---

# 21. Historial de cambios

## Descripción

Representa un registro simple de cambios sobre una entidad.

## Propósito

- saber qué cambió
- facilitar recuperación
- apoyar auditoría básica

## Campos sugeridos

- `id`
- `uuid`
- `tipo_origen`
- `origen_id`
- `tipo_cambio`
- `resumen`
- `usuario_id`
- `fecha_creacion`

---

# 22. Papelera

## Descripción

Representa elementos eliminados de forma recuperable.

## Propósito

- evitar pérdida accidental
- permitir restauración simple

## Campos sugeridos

- `id`
- `uuid`
- `tipo_origen`
- `origen_id`
- `contenido_respaldo`
- `usuario_id`
- `fecha_eliminacion`
- `fecha_expiracion`

---

# Relaciones principales resumidas

## Canto
- tiene muchas variantes
- puede estar en muchos repertorios
- puede tener notas
- puede tener archivos adjuntos
- puede tener un pad
- puede tener una secuencia

## Variante
- pertenece a un canto
- puede tener referencias
- puede usarse en repertorios
- puede tener notas

## Repertorio
- tiene muchos elementos de repertorio
- puede pertenecer a un proyecto
- puede tener playlist
- puede tener grabaciones
- puede compartirse con usuarios
- puede tener preferencias de visualización

## Elemento de repertorio
- pertenece a un repertorio
- referencia a un canto
- opcionalmente referencia a una variante
- sirve como base para vista compacta y flujo avanzado

## Proyecto
- tiene muchos repertorios
- tiene muchas playlists
- tiene muchos usuarios

## Secuencia
- pertenece a un canto
- tiene muchas pistas

## Sesión
- usa un repertorio
- tiene participantes
- tiene un usuario líder

---

# Observaciones finales

- no todos estos modelos deben construirse desde el inicio
- varios pueden comenzar simples y crecer después
- conviene mantener separación entre contenido base, colaboración, uso en vivo y audio avanzado
- el repertorio debe contemplar tanto vista compacta como vistas más detalladas
- este documento puede refinarse conforme avance la arquitectura real del proyecto