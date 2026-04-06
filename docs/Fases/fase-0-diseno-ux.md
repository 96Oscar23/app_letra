# Fase 0 - Diseño de producto y experiencia de usuario

## Objetivo de la fase

Antes de comenzar con la programación, se definirá una base visual y funcional inicial para arrancar el desarrollo con claridad.

Esta fase busca establecer una dirección de diseño consistente para la aplicación, contemplando distintos escenarios reales de uso, como:

- uso normal durante el día
- uso en interiores con luz de focos
- uso con poca luz
- uso en modo en vivo
- uso en exteriores con mucha iluminación

La intención es que la app se sienta moderna, agradable, intuitiva y cómoda de usar tanto en teléfono como en tablet.

---

## Alcance de la fase

En esta fase se definirán los siguientes elementos:

- estilo visual inicial
- paleta de colores
- tipografías
- componentes base de interfaz
- layout general por dispositivo
- pantallas principales
- flujos principales
- lineamientos generales de experiencia de usuario
- mockups iniciales de pantallas clave
- puntos pendientes por validar antes de desarrollo

---

## Definir estilo visual inicial

El estilo visual de la aplicación debe ser:

- fresco
- moderno
- limpio
- agradable a la vista
- funcional en escenarios de poca y mucha luz
- adaptable a uso cotidiano y uso en vivo

### Contextos visuales principales

#### Modo claro
Pensado para:
- uso normal durante el día
- espacios bien iluminados
- uso exterior

Características:
- fondo claro
- superficies blancas o grises suaves
- azul sobrio como color principal
- alto contraste sin ser agresivo

#### Modo oscuro
Pensado para:
- interiores con focos
- uso nocturno
- sesiones prolongadas

Características:
- grises azulosos oscuros
- evitar negro puro en toda la interfaz
- mantener contraste y comodidad visual
- azul como acento moderado

#### Modo en vivo
Pensado para:
- escenario
- ensayo
- lectura rápida de letras
- contextos con poca luz

Características:
- fondo casi negro
- texto muy contrastante
- mínimo ruido visual
- pocos colores activos
- enfoque en legibilidad y navegación rápida

---

## Principios de interfaz

La interfaz debe seguir estos principios:

- priorizar legibilidad sobre decoración
- reducir ruido visual
- mantener consistencia entre móvil y tablet
- dar acceso rápido a acciones frecuentes
- no saturar la interfaz con demasiados elementos visibles al mismo tiempo
- permitir navegación clara y predecible

---

## Definir paleta de colores

La aplicación utilizará una paleta basada en azules, neutros claros y neutros oscuros, acompañada por colores de estado.

## Tokens de color

### Brand
- `primary`: `#00487C`
- `primaryPressed`: `#003A64`
- `primaryLight`: `#027BCE`
- `accentSoft`: `#4BB3FD`
- `accentDeep`: `#3E6680`

### Light Theme
- `background`: `#F8FAFC`
- `surface`: `#FFFFFF`
- `surfaceAlt`: `#F1F5F9`
- `surfaceSoftBlue`: `#EEF6FB`
- `border`: `#CBD5E1`
- `borderStrong`: `#94A3B8`
- `textPrimary`: `#0F172A`
- `textSecondary`: `#475569`
- `textMuted`: `#64748B`
- `iconDefault`: `#334155`
- `disabled`: `#CBD5E1`

### Dark Theme
- `backgroundDark`: `#0B1220`
- `surfaceDark`: `#111827`
- `surfaceAltDark`: `#1E293B`
- `surfaceElevatedDark`: `#243244`
- `borderDark`: `#334155`
- `borderStrongDark`: `#475569`
- `textPrimaryDark`: `#F8FAFC`
- `textSecondaryDark`: `#CBD5E1`
- `textMutedDark`: `#94A3B8`
- `iconDefaultDark`: `#E2E8F0`
- `disabledDark`: `#64748B`
- `activeBlueDarkMode`: `#4BB3FD`

### Colores de estado

#### Success
- `success`: `#16A34A`
- `successSoft`: `#DCFCE7`
- `successDark`: `#14532D`

#### Warning
- `warning`: `#D97706`
- `warningSoft`: `#FEF3C7`
- `warningDark`: `#78350F`

#### Error
- `error`: `#DC2626`
- `errorSoft`: `#FEE2E2`
- `errorDark`: `#7F1D1D`

#### Info
- `info`: `#0284C7`
- `infoSoft`: `#E0F2FE`
- `infoDark`: `#0C4A6E`

### Modo en vivo
- `liveBackground`: `#050816`
- `liveSurface`: `#0B1220`
- `liveTextPrimary`: `#FFFFFF`
- `liveTextSecondary`: `#CBD5E1`
- `liveAccent`: `#4BB3FD`
- `liveBorder`: `#1E293B`
- `liveWarning`: `#F59E0B`
- `liveError`: `#EF4444`
- `liveSuccess`: `#22C55E`

---

## Uso de la paleta según escenario

### Escenario 1 - Uso normal de día
Usar modo claro:
- fondo claro
- tarjetas blancas
- bordes suaves
- azul principal como color activo

### Escenario 2 - Ensayo o iglesia con focos y poca luz
Usar modo oscuro:
- fondo oscuro
- superficies gris oscuro
- texto claro
- azul como acento moderado

### Escenario 3 - Modo en vivo
Usar configuración de alto contraste:
- fondo casi negro
- letras blancas
- notas secundarias en gris claro
- azul solo en elementos clave
- warning y success bien medidos

### Escenario 4 - Exterior o luz fuerte
Usar modo claro con contraste fuerte:
- tipografía más marcada
- botones y tabs bien visibles
- azul principal suficientemente oscuro

---

## Definir tipografías

Se utilizará la tipografía por defecto del sistema para mantener compatibilidad, buena legibilidad y una apariencia natural en cada plataforma.

### Reglas iniciales
- respetar el escalado de texto configurado por el usuario
- permitir aumentar el tamaño de letra dentro de la app
- definir límites mínimos y máximos para evitar tamaños extremos
- mantener una jerarquía clara entre títulos, subtítulos y texto secundario
- priorizar legibilidad sobre estética decorativa

### Consideración importante
La letra del canto debe poder crecer más que el resto de la interfaz, pero con límites razonables para no romper la experiencia visual.

---

## Definir componentes base de interfaz

Se definen los componentes principales de la aplicación para construir una base consistente.

### Navegación principal

#### Móvil
Se considera como navegación principal una barra inferior de menú, por ser un patrón claro y familiar para la mayoría de usuarios.

Uso esperado:
- Home
- Cantos
- Repertorios
- Buscar
- Configuración

#### Tablet
**Pendiente por validar**

Opciones a explorar:
- barra horizontal
- barra lateral con iconos
- combinación de header con panel lateral contextual

Por el momento, la idea más estable es mantener una navegación clara y visible, sin sobrecargar la pantalla.

### Botón de acción principal
Botón circular con icono de “más”.

Funciones posibles:
- agregar canto
- agregar repertorio
- mostrar acciones rápidas

Debe ser un acceso rápido y visible, pero sin estorbar la lectura del contenido.

### Componentes base a considerar
- header principal
- barra inferior de navegación
- botón de acción principal
- cards de canto
- cards de repertorio
- listas compactas
- campo de búsqueda
- chips o etiquetas
- selector de tono
- botones primarios y secundarios
- modal o menú de acciones rápidas
- vista compacta de repertorio
- vista de letra en modo en vivo

---

## Layout por dispositivo

### Móvil
En móvil, la interfaz debe priorizar una sola sección principal.

Estructura base:
- header
- contenido principal
- barra inferior de navegación
- botón de acción principal opcional

### Tablet
En tablet, se contempla una estructura más amplia y flexible.

Distribución conceptual:
- área de navegación
- contenido principal
- panel contextual opcional

**Pendiente por validar:**
- si conviene barra lateral
- si conviene panel contextual fijo
- si conviene una estructura más simple sin múltiples paneles visibles al mismo tiempo

---

## Vista de repertorio

Desde fases tempranas, el repertorio debe poder visualizarse sin necesidad de mostrar la letra completa de cada canto.

### Vista compacta
Debe mostrar:
- orden
- nombre del canto
- variante si aplica
- tono base
- acceso rápido al detalle

### Vista detallada
Debe mostrar más contexto:
- notas
- variante
- información adicional
- relación con repertorio

### Vista de letra
Se accede solo cuando el usuario lo desea o cuando entra a modo de lectura o modo en vivo.

---

## Reglas de barra inferior o área inferior

En lugar de tratarse como footer tradicional, se manejará como barra inferior de navegación o acciones.

### Reglas
- visible por defecto en móvil
- puede ocultarse en modo presentación
- puede ocultarse en modo en vivo
- debe permitir recuperar espacio para letras en pantallas pequeñas

Puede ocultarse mediante:
- botón
- gesto
- cambio automático según modo

---

## Pantallas principales

### 1. Home
**Objetivo:** servir como punto de entrada rápido a las funciones principales.

**Elementos principales:**
- accesos rápidos
- recientes o sugeridos
- botón para agregar canto
- acceso a repertorios
- acceso a búsqueda
- acceso a configuración

---

### 2. Lista de cantos
**Objetivo:** mostrar todos los cantos guardados localmente.

**Elementos principales:**
- listado de cantos
- buscador
- acceso a crear canto
- acceso al detalle de cada canto

**Nota:**
En fases futuras puede incluir filtros, etiquetas o categorías.

---

### 3. Detalle de canto
**Objetivo:** permitir leer el contenido del canto y consultar su información principal.

**Elementos principales:**
- título
- tono base
- letra
- botón editar
- ajuste de tamaño de letra
- acciones rápidas

---

### 4. Crear canto
**Objetivo:** permitir capturar un nuevo canto de forma rápida.

**Elementos principales:**
- título
- tono base
- letra
- botón guardar
- botón cancelar

---

### 5. Editar canto
**Objetivo:** modificar la información de un canto existente.

**Elementos principales:**
- campos precargados
- edición de título
- edición de tono
- edición de letra
- guardar cambios

---

### 6. Buscar cantos
**Objetivo:** encontrar un canto de forma rápida por nombre o contenido.

**Elementos principales:**
- campo de búsqueda
- resultados
- acceso al detalle
- estado vacío sin resultados

---

### 7. Repertorios
**Objetivo:** mostrar los repertorios disponibles.

**Elementos principales:**
- lista de repertorios
- botón agregar repertorio
- acceso al detalle
- vista compacta

---

### 8. Detalle de repertorio
**Objetivo:** consultar los cantos de un repertorio y su orden.

**Elementos principales:**
- nombre del repertorio
- lista ordenada de cantos
- tono base
- acceso al detalle de canto
- vista compacta
- acceso a modo en vivo

---

### 9. Configuración
**Objetivo:** permitir ajustes básicos de lectura y experiencia.

**Elementos principales:**
- tamaño de letra
- tema claro / oscuro
- opciones visuales
- configuraciones básicas

---

### 10. Modo en vivo
**Objetivo:** mostrar la letra o contenido de forma limpia y legible durante uso en escenario o ensayo.

**Elementos principales:**
- letra en gran tamaño
- navegación simple
- mínimo ruido visual
- opción de ocultar barras o controles

---

## Flujos principales

### Flujo 1 - Usuario común
**Objetivo:** consultar cantos y repertorios de forma simple.

**Pantallas involucradas:**
- Home
- Lista de cantos
- Detalle de canto
- Repertorios
- Detalle de repertorio

**Pasos del usuario:**
1. abrir la app
2. entrar a cantos o repertorios
3. buscar o seleccionar un elemento
4. abrir el detalle
5. leer el contenido
6. ajustar tamaño de letra si es necesario

**Resultado esperado:**
El usuario puede consultar contenido de forma rápida y clara.

---

### Flujo 2 - Agregar canto rápido
**Objetivo:** guardar un nuevo canto con pocos pasos.

**Pantallas involucradas:**
- Home
- Crear canto
- Detalle de canto

**Pasos del usuario:**
1. abrir la app
2. tocar el botón de agregar
3. seleccionar crear canto
4. capturar título
5. capturar tono base
6. pegar o escribir la letra
7. guardar
8. ver el canto creado

**Resultado esperado:**
El canto queda guardado localmente y disponible en la lista.

---

### Flujo 3 - Repertorios
**Objetivo:** organizar cantos dentro de un repertorio.

**Pantallas involucradas:**
- Repertorios
- Detalle de repertorio
- Lista de cantos
- Detalle de canto

**Pasos del usuario:**
1. entrar a repertorios
2. crear o abrir un repertorio
3. agregar cantos
4. ordenar los cantos
5. consultar la vista compacta
6. abrir un canto si necesita más detalle

**Resultado esperado:**
El repertorio queda organizado y listo para consulta o uso en vivo.

---

### Flujo 4 - Uso en vivo
**Objetivo:** consultar contenido de forma clara durante ensayo o presentación.

**Pantallas involucradas:**
- Repertorios
- Detalle de repertorio
- Modo en vivo

**Pasos del usuario:**
1. abrir un repertorio
2. seleccionar entrar a modo en vivo
3. visualizar solo lo necesario
4. navegar entre cantos
5. mantener lectura clara y rápida

**Resultado esperado:**
La app muestra el contenido con legibilidad alta y mínima distracción.

---

## Mockups de pantallas principales

Se deberán crear mockups para:
- Home
- Repertorios
- Configuración
- Lista de cantos
- Detalle de canto
- Crear o editar canto
- Repertorio en vista compacta
- Repertorio en vista detallada
- Modo en vivo
- Búsqueda

---

## Validación de experiencia

Antes de pasar a desarrollo funcional, se debe validar que la experiencia cumpla con lo siguiente:

- sea simple de entender
- se sienta moderna
- no sobrecargue la pantalla
- funcione bien en móvil y tablet
- mantenga legibilidad en distintos escenarios de luz
- permita acceso rápido a funciones frecuentes
- se adapte bien a repertorio, detalle de canto y modo en vivo

---

## Pendientes por validar

Estos puntos todavía no están cerrados y deberán validarse con mockups o pruebas tempranas:

- navegación principal en tablet: horizontal o lateral
- uso real del panel contextual en tablet
- comportamiento exacto del botón de acción principal
- reglas finales para ocultar barra inferior en modo presentación
- definición final de pantallas prioritarias en tablet
- detalle visual de Home, Repertorio y Configuración en móvil y tablet

---

## Test

En esta fase se deben revisar al menos los siguientes puntos:

- legibilidad en modo claro
- legibilidad en modo oscuro
- legibilidad en modo en vivo
- uso con iluminación de focos
- uso en exterior o alta iluminación
- contraste de colores
- escalado de tipografía
- comportamiento general en móvil
- comportamiento general en tablet

---

## Entregable

Al finalizar esta fase se espera contar con:

- lineamientos visuales iniciales
- paleta de colores definida
- reglas tipográficas base
- componentes base identificados
- layout general por dispositivo
- pantallas principales listadas
- flujos principales identificados
- mockups iniciales de pantallas clave
- pendientes claramente separados de decisiones ya tomadas