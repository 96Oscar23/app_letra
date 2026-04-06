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
- pantallas principales
- flujos principales
- lineamientos generales de experiencia de usuario
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

Se definen los componentes principales para construir una base consistente.

### Navegación principal

#### Móvil
- barra inferior de navegación
- contenido principal
- botón de acción principal opcional

#### Tablet
**Pendiente por validar**
- barra lateral
- barra superior
- combinación de navegación principal y panel contextual

### Botón de acción principal

Botón con icono de “más”.

Funciones posibles:
- agregar canto
- agregar repertorio
- mostrar acciones rápidas

Debe ser visible, útil y no estorbar la lectura del contenido.

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

## Pantallas principales iniciales

Pantallas que deben contemplarse desde esta fase:

- Home
- Lista de cantos
- Detalle de canto
- Crear / editar canto
- Buscar cantos
- Repertorios
- Detalle de repertorio
- Configuración
- Vista de modo en vivo

---

## Flujos a documentar

**Pendiente por desarrollar**

### Flujo para usuario común
- entrar
- buscar
- abrir un canto
- ajustar tamaño de letra
- consultar repertorio

### Flujo para agregar canto rápido
- crear
- pegar texto
- guardar

### Flujo para repertorios
- crear repertorio
- agregar cantos
- ordenar
- ver lista compacta
- abrir detalle

### Flujo para uso en vivo
- abrir repertorio
- navegar entre cantos
- ocultar elementos secundarios
- mostrar solo lo necesario

---

## Validación de experiencia

Antes de pasar a desarrollo, se debe validar que la experiencia cumpla con lo siguiente:

- sea simple de entender
- se sienta moderna
- no sobrecargue la pantalla
- funcione bien en móvil y tablet
- mantenga legibilidad en distintos escenarios de luz
- permita acceso rápido a funciones frecuentes

---

## Pendientes por validar

Estos puntos todavía no están cerrados y deberán validarse con mockups o pruebas tempranas:

- navegación principal en tablet
- comportamiento exacto del botón de acción principal
- definición final de pantallas prioritarias en tablet
- mockups de pantallas principales
- flujos principales detallados

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
- pantallas principales listadas
- flujos principales identificados
- pendientes claramente separados de decisiones ya tomadas