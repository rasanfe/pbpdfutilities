# pbpdfutilities — Dividir y unir PDFs ✂️📄

![PowerBuilder](https://img.shields.io/badge/PowerBuilder-2025-orange?style=flat-square)
![.NET](https://img.shields.io/badge/.NET-10-512BD4?style=flat-square&logo=dotnet&logoColor=white)
![itext7](https://img.shields.io/badge/itext7-9.6.0-2C8EBB?style=flat-square)
![Blog](https://img.shields.io/badge/blog-rsrsystem-FF5722?style=flat-square&logo=blogger&logoColor=white)

## 📋 ¿Qué es esto?

Para finalizar el mes de Enero, os traje un pequeño ejemplo que sirve para **unir dos (o más) PDF en uno solo** o para **dividir un PDF en un fichero por página**. Es muy posible que en futuras versiones de PowerBuilder integren esto como nativo, pero de momento hay que recurrir a una librería de terceros… y aquí es donde entra la gracia del ejemplo.

Fijaos en la idea: el trabajo "sucio" con el PDF lo hace una **librería .NET** (`SplitMergePdf`), y PowerBuilder la consume directamente como un `dotnetobject`. Gracias al **.NET DLL Importer** de PowerBuilder 2025, importamos el ensamblado y llamamos a la clase `SplitMerge` como si fuera un objeto nativo de PB:

- `MergeFiles(string[] fileNames, string targetPdf)` → une la lista de PDFs en `targetPdf`.
- `SplitFiles(string inputFile, string outputPath)` → trocea el PDF de entrada en una página por fichero.

Sin C# en tiempo de ejecución, sin servicios intermedios: PowerBuilder hablando directamente con la DLL. Tenéis PDFs de prueba en la propia carpeta (`prueba_4_paginas_para_split.pdf`, `prueba_pagina1_para_join.pdf`, `prueba_pagina2_para_join.pdf`).

## 🔗 Motor .NET

El motor es la librería **`SplitMergePdf`**, desplegada en `DotNet\SplitMergePdf\` y consumida desde PowerBuilder como `dotnetobject`.

- **Código fuente .NET:** `C:\proyecto pw2025\Blog\Net10\SplitMergePdf` (antes en `Net8`).
- **Repo .NET (Visual Studio 2022):** <https://github.com/rasanfe/SplitMergePdf>
- **Despliegue:** se publica y se copia a `DotNet\SplitMergePdf\` con el script `desplegar_dotnet.bat` (hace `dotnet publish` y espeja las DLLs al ejemplo).

> 💡 **Dato didáctico:** al migrar a **.NET 10** este motor pasó de la vieja **iTextSharp 5 (abandonada)** a **itext7 9.6.0**, ya moderna y mantenida. Mismo objetivo (cortar y pegar PDFs), pero con una librería viva debajo.

## 🛠️ Requisitos

- **PowerBuilder 2025** (con el .NET DLL Importer).
- **.NET 10 Runtime** instalado en la máquina que ejecuta el ejemplo.
- Las DLLs de `DotNet\SplitMergePdf\` (incluye itext7 y sus dependencias: `itext.kernel`, `itext.layout`, `BouncyCastle`, etc.).

## ▶️ Cómo probarlo

1. Clona el repo "en modo solución" y abre el workspace en PowerBuilder 2025.
2. Compila y ejecuta `pbpdfutilities`.
3. **Dividir:** elige `prueba_4_paginas_para_split.pdf` y lánzalo a un directorio de salida → obtendrás un PDF por página.
4. **Unir:** selecciona `prueba_pagina1_para_join.pdf` y `prueba_pagina2_para_join.pdf` y genera un único PDF combinado.

🎬 **Vídeo demo:** <https://youtu.be/5yb0aYMcQoQ>

## 🔗 Repo PowerBuilder

- **Ejemplo PB (modo solución):** <https://github.com/rasanfe/pbpdfutilities>
- **Motor .NET:** <https://github.com/rasanfe/SplitMergePdf>

---

> ¡Nos vemos en el próximo artículo! Y recuerda: en PowerBuilder, los límites solo están en nuestra imaginación. 🚀

📨 **Blog:** <https://rsrsystem.blogspot.com/>
