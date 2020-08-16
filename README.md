# Домашнее задание 4 #

Vagrant стенд для NFS или SAMBA
NFS или SAMBA на выбор:

vagrant up должен поднимать 2 виртуалки: сервер и клиент
на сервере должна быть расшарена директория
на клиента она должна автоматически монтироваться при старте (fstab или autofs)
в шаре должна быть папка upload с правами на запись
- требования для NFS: NFSv3 по UDP, включенный firewall

## Что было сделано ##
1. Создан вагрант-файл, поднимающий 2 виртуалки, к конфигу каждой из них  добавлен дополнительный скрипт, выполняющий основную часть магии.
2. Вспомогательный скрипт сервера nfss_script.sh устанавливает необходимые для работы nfs пакеты, конфигурирует автостарт необходимых служб, создает собственно 
целевую папку обмена nfs-share c правами на запись.
3. Указывает доступ клиентской машине с правами на запись 192.168.50.11/32(rw,sync,no_root_squash,no_all_squash) в /etc/exports
4. Конфигурирует файерволл для корректной работы nfs
5. Вспомогательный скрипт nfsc_script.sh конфижит при старте клиентсую машину.Аналогично, ставит необходимые пакеты, стартует нужные службы.
6. Создает папку монтирования mkdir /media/nfs_share.
7. Маунтит нужную директорию важными для данного задания опциями 
sudo mount -t nfs 192.168.50.10:/nfs-share/ /media/nfs_share/  -o rw,noatime,noauto,x-systemd.automount,noexec,nosuid,proto=udp,vers=3
8. Прописывает точку монтирования а fstab c опциями noauto,x-systemd.automount для повышения стабильности работы сервиса.

