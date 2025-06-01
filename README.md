# Blocky-Keenetic

[![Version](https://img.shields.io/badge/version-v0.26.2-blue.svg)](https://github.com/0xERR0R/blocky/releases/tag/v0.26.2)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)

## Описание

Blocky-Keenetic - это пакет для установки [Blocky](https://github.com/0xERR0R/blocky) на маршрутизаторы Keenetic с установленным Entware. Blocky - это быстрый и легкий DNS-прокси, который работает как блокировщик рекламы для локальной сети с множеством функций.

## Особенности

- Блокировка рекламы, трекеров и вредоносных доменов
- Использование черных списков (например, StevenBlack hosts)
- Настраиваемые DNS-серверы для разрешения запросов
- Низкое потребление ресурсов
- Автоматический запуск при загрузке системы
- Интеграция с системой Keenetic

## Требования

- Маршрутизатор Keenetic с установленным Entware
- Архитектура aarch64-3.10

## Установка

### Подготовка Entware

1. Установите необходимые зависимости:

```bash
opkg update
opkg install ca-certificates wget-ssl
opkg remove wget-nossl
```

2. Создайте директорию для репозитория и добавьте репозиторий в список источников Entware:

```bash
mkdir -p /opt/etc/opkg
```

Выберите репозиторий в зависимости от архитектуры вашего маршрутизатора:

**Для aarch64-3.10** (Keenetic Peak (KN-2710), Ultra (KN-1811), Hopper (KN-3811), Hopper SE (KN-3812), Giga (KN-1012)):

```bash
echo "src/gz blocky-keenetic https://lastbyte32.github.io/blocky-keenetic/aarch64" > /opt/etc/opkg/blocky-keenetic.conf
```

### Установка пакета

1. Обновите список пакетов и установите blocky-keenetic:

```bash
opkg update
opkg install blocky-keenetic
```

### Ручная установка

1. Скачайте последнюю версию пакета `blocky-keenetic_v0.26.2_aarch64-3.10.ipk`
2. Установите пакет с помощью команды:

```bash
opkg install blocky-keenetic_v0.26.2_aarch64-3.10.ipk
```

### Настройка DNS-сервера Keenetic

Для корректной работы Blocky необходимо отключить встроенный DNS-сервер Keenetic:

1. Подключитесь к CLI маршрутизатора (не путайте с SSH-сервером из Entware, который на порту 222):

```bash
opkg dns-override
system configuration save
```

> **Примечание**: После этого временно пропадет доступ в Интернет, так как родной dns-proxy Keenetic будет отключен. Доступ восстановится после запуска и настройки Blocky.

2. Запустите Blocky:

```bash
/opt/etc/init.d/S99blocky start
```

## Конфигурация

Файл конфигурации находится в `/opt/etc/blocky/config.yml`. По умолчанию используется следующая конфигурация:

```yaml
upstream:
  default:
    - 1.1.1.1
    - 8.8.8.8

blocking:
  blackLists:
    ads:
      - https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts
  clientGroupsBlock:
    default:
      - ads

port: 53
logLevel: info
```

Вы можете изменить этот файл в соответствии с вашими потребностями. Подробную информацию о параметрах конфигурации можно найти в [документации Blocky](https://github.com/0xERR0R/blocky).

## Управление сервисом

Для управления сервисом используйте следующие команды:

```bash
# Запуск сервиса
/opt/etc/init.d/S99blocky start

# Остановка сервиса
/opt/etc/init.d/S99blocky stop

# Перезапуск сервиса
/opt/etc/init.d/S99blocky restart

# Проверка статуса
/opt/etc/init.d/S99blocky status
```


## Сборка пакета

Если вы хотите собрать пакет самостоятельно, выполните следующие команды:

```bash
# Клонирование репозитория
git clone https://github.com/your-username/blocky-keenetic.git
cd blocky-keenetic

# Сборка пакета для архитектуры aarch64
make all
```

Собранный пакет будет находиться в директории `out/`.

## Лицензия

Проект распространяется под лицензией MIT. Подробности можно найти в файле [LICENSE](LICENSE).

## Благодарности

- [0xERR0R](https://github.com/0xERR0R) за создание [Blocky](https://github.com/0xERR0R/blocky)
- Команде Keenetic за отличную платформу для маршрутизаторов