#!/bin/bash

# URL de la página web
URL="https://acestream-ids-actualizados.webnode.es/"

# Archivo local con los canales
LOCAL_FILE="canales.txt"

# Archivo temporal para almacenar los canales extraídos de la web
TEMP_FILE=$(mktemp)

# Descargar el contenido de la página web en formato HTML
curl -s "$URL" > "$TEMP_FILE.page"

# Procesar el HTML para extraer pares de nombre de canal e ID de acestream
# Primero extrae las líneas con nombres e IDs, luego limpia el HTML
grep -A 1 "acestream://" "$TEMP_FILE.page" | sed -E 's/<[^>]*>//g' | sed '/^--$/d' | \
awk '/acestream:\/\// {sub(/.*acestream:\/\//, "", $0); print prev_line "\n" $0} {prev_line=$0}' > "$TEMP_FILE"

# Comprobar si hay canales nuevos (pares de nombre y ID) que no estén en el archivo local
echo "Canales nuevos encontrados:"
grep -Fxv -f "$LOCAL_FILE" "$TEMP_FILE" | while read -r line; do
    echo "$line"
done

# Limpiar archivos temporales
rm "$TEMP_FILE" "$TEMP_FILE.page"

