#!/bin/bash

# 1. Применяем конфиг пинов (для карты hwC1D0)
echo "0x14 0x411111f0" | sudo tee /sys/class/sound/hwC1D0/user_pin_configs
echo "0x1b 0x90170110" | sudo tee /sys/class/sound/hwC1D0/user_pin_configs
echo "0x12 0x90a60130" | sudo tee /sys/class/sound/hwC1D0/user_pin_configs

# 2. Пересборка (пробуем несколько раз, если занято)
echo 1 | sudo tee /sys/class/sound/hwC1D0/reconfig || true

# 3. включаем питание на 0x1b
sudo hda-verb /dev/snd/hwC1D0 0x1b SET_EAPD_BTL 2

# 4. Даем системе 2 секунды прогрузить аудио
sleep 2

# 5. Заставляем Pipewire переключиться на динамики
# Ищем индекс устройства и ставим порт
SINK=$(pactl short sinks | grep "alsa_output.pci" | awk '{print $1}')
pactl set-sink-port "$SINK" analog-output-speaker 2>/dev/null
pactl set-sink-mute "$SINK" 0
pactl set-sink-volume "$SINK" 60%
