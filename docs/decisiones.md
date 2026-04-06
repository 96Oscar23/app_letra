# Decisiones del proyecto

Este documento registra decisiones importantes del proyecto, tanto funcionales como técnicas, para mantener claridad sobre el rumbo de la app y facilitar continuidad en el desarrollo.

---

## 1. Framework principal

Se decidió utilizar **Flutter** como framework principal para el desarrollo de la aplicación.

### Motivo
- permite desarrollar una sola base para varias plataformas
- cubre bien tablets Android, iPad, iPhone y Android
- se adapta al enfoque multiplataforma del proyecto

---

## 2. Enfoque principal de plataforma

Aunque la aplicación podrá correr en varios dispositivos, el enfoque principal del proyecto estará en:

- tablets Android
- iPad

### Motivo
El uso principal previsto está relacionado con ensayo, culto y ejecución en vivo, donde una pantalla más grande ofrece mejor experiencia para letras, tonos, repertorios y navegación.

---

## 3. Prioridad de experiencia de usuario

Se decidió que la aplicación debe sentirse:

- intuitiva
- moderna
- amigable
- rápida de usar para personas no técnicas

### Motivo
El usuario principal no es programador.  
La app está pensada para músicos, cantantes y líderes, por lo que la experiencia debe ser natural y práctica.

---

## 4. Desarrollo guiado por fases pequeñas

Se decidió dividir el proyecto en **fases pequeñas y entregables concretos**.

### Motivo
- reduce complejidad
- facilita retomar el proyecto
- evita fases demasiado pesadas
- permite liberar valor progresivamente

---

## 5. Enfoque offline-first

Se decidió que la aplicación debe funcionar localmente desde fases tempranas.

### Motivo
- no siempre habrá internet en ensayo o presentación
- la app debe seguir siendo útil sin conexión
- la experiencia central no debe depender de la nube

---

## 6. Base local primero, sincronización después

Se decidió priorizar almacenamiento local en primeras fases y dejar la sincronización para fases posteriores.

### Motivo
- reduce complejidad inicial
- permite construir una app útil antes de resolver colaboración y nube
- encaja mejor con el enfoque offline-first

---

## 7. Agregar cantos debe ser rápido y agradable

Se decidió priorizar mucho el flujo de alta de nuevos cantos.

### Motivo
Si agregar cantos es lento o tedioso, el usuario seguirá usando documentos sueltos o Google Drive.

### Implicaciones
Debe existir:
- alta rápida
- alta completa
- importación simple
- flujo cómodo para pegar texto

---

## 8. Ingreso desde archivos e imágenes en fases tempranas

Se decidió subir a fases tempranas la posibilidad de:

- subir PDF
- subir imagen
- subir foto
- guardar el archivo original como referencia
- extraer texto cuando sea posible

### Motivo
Hay cantos que solo existen en PDF, imagen o foto, y transcribirlos manualmente no siempre es viable.

---

## 9. Estructura de canto no obligatoria desde el inicio

Se decidió que no todos los cantos deberán estar estructurados por partes desde el inicio.

### Motivo
Obligar a estructurar todos los cantos vuelve más pesada la carga inicial del contenido.

### Implicaciones
- primero puede existir el canto simple
- después puede existir variante
- luego puede existir personalización dentro del repertorio

---

## 10. Las variaciones reales deben modelarse como variantes

Se decidió separar el concepto de **variante de canto** del canto base.

### Motivo
Un mismo canto puede cambiar por:
- artista
- estilo
- orden
- letra
- tono

No todo debe resolverse solo con “tono por cantante”.

---

## 11. Repertorio básico y repertorio avanzado

Se decidió dividir el manejo de repertorios en dos niveles:

### Repertorio básico
- crear
- editar
- ordenar
- duplicar
- agregar o quitar cantos
- visualizar el repertorio en modo lista

### Flujo avanzado de repertorio
- elegir variante
- definir inicio y fin
- unir cantos
- marcar transiciones
- cambiar tono entre cantos

### Motivo
En la práctica, los repertorios reales suelen tener medleys, transiciones y entradas parciales.

---

## 12. El repertorio debe poder verse sin mostrar la letra completa

Se decidió que un repertorio debe tener al menos una **vista compacta de lista**.

### Motivo
En uso real muchas veces solo se necesita:
- ver el orden
- ver el tono base
- navegar rápido
- decidir qué sigue

No siempre es deseable mostrar toda la letra desde la vista de repertorio.

### Implicaciones
El repertorio debe contemplar al menos estas formas de visualización:
- vista compacta de lista
- vista detallada
- vista de letra
- vista en vivo

---

## 13. Referencias y playlists sí forman parte del valor del producto

Se decidió incluir referencias musicales y playlists como funcionalidad del proyecto.

### Motivo
Ayudan a:
- alinear al equipo
- compartir la versión esperada
- reutilizar referencias
- evitar crear playlists nuevas innecesariamente

---

## 14. Proyecto como contenedor superior

Se decidió incluir el concepto de **proyecto** como nivel superior a repertorio.

### Motivo
Permite agrupar:
- repertorios
- playlists
- usuarios
- colaboración

### Alcance
Proyecto no sustituye a repertorio, sino que lo organiza dentro de un contexto más grande.

---

## 15. Pads y sonidos ambientales antes que secuencias

Se decidió incluir una fase de pads y sonidos ambientales antes de secuencias.

### Motivo
- aporta valor musical temprano
- sirve para ambientar o sostener tono
- no requiere la complejidad de secuencias completas

### Alcance
Esta fase no busca sustituir instrumentos completos, sino ofrecer apoyo simple y práctico.

---

## 16. Instrumentos faltantes y coros se dejan para secuencias

Se decidió que los casos de:
- instrumentos faltantes
- coros
- acompañamiento más complejo

se resolverán hasta fases de secuencias, no antes.

### Motivo
Evita mezclar una fase de audio simple con una fase de producción musical más avanzada.

---

## 17. Grabación básica tiene alto valor real

Se decidió subir la grabación básica en prioridad.

### Motivo
El uso real del producto contempla grabar ensayos o cultos para revisar errores después, por lo que no es una función secundaria.

---

## 18. Métricas sí aportan valor práctico

Se decidió incluir métricas como una fase media del producto.

### Motivo
Permiten saber:
- qué cantos se usan más
- cuáles están olvidados
- qué tanto se repite un canto
- patrones reales del equipo

---

## 19. Historial y papelera antes que funciones complejas

Se decidió que papelera, recuperación e historial básico deben ir antes que funciones como MIDI o proyección avanzada.

### Motivo
Aportan más valor práctico y ayudan a proteger el contenido desde antes.

---

## 20. Funciones complejas se dejan para fases tardías

Se decidió dejar para fases más avanzadas:

- secuencias
- consola de pistas
- MIDI
- proyección
- vistas de escenario diferenciadas

### Motivo
Son valiosas, pero no tan prioritarias como la base de contenido, repertorios, colaboración y uso real temprano.

---

## 21. Distribución inicial restringida

Se decidió que en etapas iniciales la app no se liberará públicamente.

### Motivo
Se busca evitar que usuarios externos descarguen versiones verdes o con errores en fases tempranas.

### Idea de distribución
- iOS / iPadOS: TestFlight por invitación
- Android: distribución restringida o pruebas cerradas

---

## 22. Liberación pública posterior con modo demo

Se decidió contemplar una futura liberación pública más adelante, acompañada de un modo demo.

### Motivo
Permite probar la app sin exponer todas las funciones ni el producto completo.

---

## 23. Monetización y licenciamiento quedan fuera del roadmap principal

Se decidió no mezclar todavía monetización, licencias y paquetes con el roadmap principal de construcción funcional.

### Motivo
Es otro bloque del producto y conviene documentarlo aparte para no contaminar las prioridades iniciales.

### Temas reservados para documento aparte
- modo demo
- activación por key
- key master
- restricción de funciones
- paquetes o niveles de acceso
- monetización
- distribución y actualizaciones

---

## 24. Documentación separada por propósito

Se decidió no dejar toda la documentación en un solo README.

### Motivo
Separar documentación ayuda a:
- encontrar información rápido
- mantener claridad
- escalar el proyecto mejor

### Estructura sugerida
- `roadmap.md`
- `decisiones.md`
- `modelos.md`
- `vision.md`
- `fases/`

---

## 25. El roadmap puede ajustarse con el tiempo

Se decidió asumir que el roadmap no está congelado y podrá evolucionar.

### Motivo
El proyecto todavía está en exploración funcional y seguirán apareciendo casos reales de uso.

### Regla
Las fases pueden refinarse, dividirse o reordenarse siempre que se mantenga el enfoque de entregables pequeños y útiles.

## Decisión de Home móvil v1

Se adopta como base el Home móvil oscuro con:
- buscador superior
- navegación principal en grid 2x2
- bloque de próximo repertorio
- géneros populares
- recientes
- botón flotante
- barra inferior de navegación

El bloque de próximo repertorio tendrá:
- versión compacta por defecto
- posibilidad de expandirse para mostrar más detalle

## Buscador móvil v1

Se adopta una versión más enfocada y simplificada del buscador, priorizando búsqueda rápida y acceso inmediato a resultados.

Elementos principales:
- barra de búsqueda protagonista
- chips de apoyo
- búsquedas recientes
- resultados rápidos en tarjetas compactas
- favorito visible por resultado
- barra inferior consistente con el resto de la app

La intención es que la pantalla funcione primero como herramienta de búsqueda, dejando la exploración avanzada para fases posteriores.