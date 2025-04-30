#!/bin/bash

# Mostrar comandos en consola
set -e

echo "🚀 Iniciando proceso de despliegue..."

# 1. Instalar dependencias (si aplica)
if [ -f package.json ]; then
  echo "📦 Instalando dependencias..."
  npm install
fi

# 2. Ejecutar pruebas
if [ -f package.json ]; then
  echo "🧪 Ejecutando pruebas..."
  npm test
fi

# 3. Compilar (opcional)
if [ -f package.json ]; then
  echo "🛠 Compilando la aplicación..."
  npm run build
fi

# 4. Desplegar (ajústalo a tu entorno)
echo "📤 Desplegando archivos..."
# Ejemplo: copiar archivos al servidor remoto (ajústalo)
# scp -r dist/* usuario@mi-servidor:/var/www/html/

# O mover a un directorio local (simulación)
mkdir -p deploy
cp -r dist/* deploy/

echo "✅ ¡Despliegue completado exitosamente!"
