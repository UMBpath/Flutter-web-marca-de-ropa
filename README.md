# 📱 Herencia Streetwear - Flutter Mobile App

Aplicación móvil desarrollada en Flutter para la tienda de ropa streetwear **"Herencia - Gestión de Catálogo de Ropa"** (Proyecto de Arquitectura de Software).

---

## ✨ Características Implementadas

1. **🔥 Home & Lookbook 2026:**
   - Carrusel visual interactivo con looks y fotografías oficiales del lookbook.
   - Manifiesto de marca *"Una historia para contar"*.
   - Acceso rápido a colecciones Hombre y Mujer.
   - Grid de prendas destacadas.

2. **🏷️ Catálogo Completo:**
   - Pestañas dinámicas de filtro por género: **Todos**, **Hombre** y **Mujer**.
   - Filtros por categoría: **Buzos**, **Camisetas**, **Jeans**.
   - Barra de búsqueda en tiempo real (por nombre, categoría o descripción).

3. **👕 Detalle de Producto:**
   - Galería de fotos con swipe e indicadores.
   - Selector interactivo de tallas (XS, S, M, L, XL, 28, 30, etc.).
   - Precios duales en USD y COP.
   - Información de envío y política de 30 días para cambios.
   - Botón directo "Añadir al Carrito" con feedback visual.

4. **🛒 Carrito de Compras Dinámico:**
   - Conteo de artículos en badge del menú inferior.
   - Incremento y decremento de cantidades.
   - Eliminación individual o vaciado completo del carrito.
   - Cálculo automático de subtotal, envío gratis y total en USD y COP.

5. **💳 Pasarela de Pago & Checkout:**
   - Formulario de tarjeta de crédito/débito (Visa, Mastercard, Amex).
   - Validación de titular, número de 16 dígitos, fecha MM/AA y CVV.
   - Campo para dirección de envío y entrega.
   - Simulación de pago seguro SSL con modal de confirmación y generación de número de pedido.

6. **🤖 Chatbot con IA:**
   - Asistente virtual especializado en el catálogo de Herencia.
   - Chips de preguntas frecuentes rápidas.
   - Respuestas sobre productos, tallas, precios, envíos y políticas.
   - Integración con Claude API y fallback inteligente sin conexión.

7. **👤 Cuenta y Políticas:**
   - Simulación de autenticación (Google Sign-In).
   - Acceso directo a Políticas de Privacidad (Ley 1581 de 2012), garantías y envíos.
   - Enlaces a redes sociales oficiales (@her3ncia).

---

## 🚀 Compilación y Despliegue en Codemagic CI/CD

El proyecto ya cuenta con el archivo de configuración `codemagic.yaml` listo para compilar el **APK de Android** en la nube sin necesidad de tener Flutter ni Android Studio instalados localmente.

### Pasos para compilar en Codemagic:

1. **Subir los cambios a GitHub:**
   ```bash
   git add .
   git commit -m "feat: app móvil Flutter y configuración Codemagic"
   git push origin main
   ```

2. **Entrar a Codemagic:**
   - Ingresa a [https://codemagic.io](https://codemagic.io)
   - Inicia sesión con tu cuenta de **GitHub**.

3. **Conectar el Repositorio:**
   - Haz clic en **"Add application"** (o "New app").
   - Selecciona **GitHub** como proveedor y elige el repositorio `Web-Gestion-de-prendas-y-ventas-de-ropa`.
   - Selecciona el tipo de proyecto: **Flutter App**.

4. **Iniciar la Compilación:**
   - Codemagic detectará automáticamente el archivo `codemagic.yaml`.
   - Haz clic en **"Start new build"** seleccionando la rama `main` y el workflow `Herencia Android APK Build`.
   - Codemagic descargará Flutter, resolverá las dependencias y compilará el archivo `.apk`.

5. **Descargar el APK en tu celular:**
   - Al terminar la compilación (unos 3 a 5 minutos), en la pestaña **Artifacts** podrás descargar directamente el archivo `app-release.apk` o escanear el código QR que genera Codemagic para instalarlo directo en tu celular Android.
