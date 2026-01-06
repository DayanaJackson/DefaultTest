#!/bin/bash

# Перевірка, чи передано аргумент (шлях до файлу)
if [ -z "$1" ]; then
    echo "Помилка: Будь ласка, вкажіть шлях до лог-файлу."
    echo "Використання: $0 /шлях/до/лог-файлу"
    exit 1
fi

LOG_FILE="$1"

# Перевірка, чи існує файл
if [ ! -f "$LOG_FILE" ]; then
    echo "Помилка: Файл '$LOG_FILE' не знайдено."
    exit 1
fi

# Перевірка, чи файл доступний для читання
if [ ! -r "$LOG_FILE" ]; then
    echo "Помилка: У вас немає прав на читання файлу '$LOG_FILE'."
    exit 1
fi

echo "Аналіз файлу: $LOG_FILE"
echo "----------------------------------------"

# 1. Підрахунок рядків зі словами "Failed" або "Error" (case-insensitive)
ERROR_COUNT=$(grep -iE "Failed|Error" "$LOG_FILE")

echo "Кількість помилок (Failed/Error): $ERROR_COUNT"
echo "----------------------------------------"

# 2. Вивід списку останніх 10 унікальних IP-адрес
echo "Останні 10 унікальних IP-адрес:"

grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" "$LOG_FILE" | sort | uniq | tail -n 10

echo "----------------------------------------"

if [ "$ERROR_COUNT" -gt 20 ]; then
    echo -e "\033[0;31mWarning: High error rate detected\033[0m"
fi
