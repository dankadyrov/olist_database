#!/bin/bash

set -e

DB_USER="postgres"
DB_NAME="olist"
OUTPUT_DIR="results"
SQL_DIR="scripts"
mkdir -p "$OUTPUT_DIR"

echo "🔧 0. Проверка и подготовка роли '$DB_USER'..."
if ! psql postgres -tAc "SELECT 1 FROM pg_roles WHERE rolname='$DB_USER'" | grep -q 1; then
    echo "⚠️ Роль '$DB_USER' не существует. Создаем её..."
    if ! psql postgres -c "CREATE ROLE $DB_USER WITH SUPERUSER LOGIN PASSWORD 'postgres';"; then
        echo "❌ Ошибка: Не удалось создать роль '$DB_USER'."
        exit 1
    fi
    echo "✅ Роль '$DB_USER' успешно создана."
else
    echo "✅ Роль '$DB_USER' уже существует."
fi

export PGPASSWORD='postgres'

echo "🔧 1. Проверка и подготовка базы данных '$DB_NAME'..."
if psql -U "$DB_USER" -lqt | cut -d \| -f 1 | grep -qw "$DB_NAME"; then
    echo "⚠️ База данных '$DB_NAME' уже существует. Удаляем её..."
    dropdb -U "$DB_USER" "$DB_NAME"
fi

echo "🆕 Создание базы данных '$DB_NAME'..."
createdb -U "$DB_USER" "$DB_NAME"

echo "🔧 2. Инициализация БД..."
psql -U "$DB_USER" -d "$DB_NAME" -f "$SQL_DIR/01_create_tables.sql"

echo "📥 3. Импорт данных..."
psql -U "$DB_USER" -d "$DB_NAME" -f "$SQL_DIR/02_import_data.sql"

echo "🔍 4. Выполнение пунктов задания..."
while IFS= read -r -d '' script; do
    echo "🔄 Выполнение $(basename "$script")..."
    base_name=$(basename "$script" .sql)
    psql -U "$DB_USER" -d "$DB_NAME" -f "$script" > "$OUTPUT_DIR/${base_name}_results.txt"
    echo "✅ Результаты сохранены в $OUTPUT_DIR/${base_name}_results.txt"
done < <(find "$SQL_DIR" -name '0[3-9]_*.sql' -print0 | sort -z -V)

echo "✅ Все этапы выполнены успешно!"
echo "📄 Результаты сохранены в директории $OUTPUT_DIR/"