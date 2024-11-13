#!/bin/bash

# Archivos de entrada y salida
filtrado_file="filtrado_salida.txt"
mios_file="mios.txt"
nuevos_output="nuevos_enlaces.txt"

# Limpiar el archivo de salida de nuevos enlaces
> "$nuevos_output"

# Verificar si el archivo filtrado_salida.txt existe
if [ ! -f "$filtrado_file" ]; then
    echo "Error: El archivo $filtrado_file no existe."
    exit 1
fi

# Verificar si el archivo mios.txt existe
if [ ! -f "$mios_file" ]; then
    echo "Error: El archivo $mios_file no existe."
    exit 1
fi

# Leer el archivo filtrado_salida.txt de dos en dos (canal y enlace)
echo "Canales nuevos encontrados:"

while IFS= read -r canal && IFS= read -r acestream_link; do
    # Comprobar si el enlace acestream no está presente en mios.txt
    if ! grep -Fxq "$acestream_link" "$mios_file"; then
        # Si el enlace no se encuentra en mios.txt, imprimir y guardar el canal y enlace
        echo "$canal $acestream_link"
        printf "%s %s\n" "$canal" "$acestream_link" >> "$nuevos_output"
    fi
done < "$filtrado_file"

echo "La comparación ha terminado. Los nuevos canales se han guardado en $nuevos_output."

