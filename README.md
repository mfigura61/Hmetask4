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
8. Прописывает точку монтирования в fstab c опциями noauto,x-systemd.automount для повышения стабильности работы сервиса.

## Проверим работу сервисов ##
1. Зайдем на клиентскую машину, и создадим тестовый файл в расшаренной папке.
> [vagrant@nfsc ~]$ cd /media/nfs_share/

> [vagrant@nfsc nfs_share]$ ls

> [vagrant@nfsc nfs_share]$ touch test_write.txt

> [vagrant@nfsc nfs_share]$ ls -ln

total 0
-rw-rw-r--. 1 1000 1000 0 Aug 16 14:42 test_write.txt
2. Со стороны сервера видим подключенного клиента
> [vagrant@nfss ~]$ sudo exportfs 

/nfs-share    	192.168.50.11/32

3. > [vagrant@nfss nfs-share]$ ls    #и на сервере видим недавно созданный клиентом файл.
> test_write.txt
4. попытаемся примаунтить еще раз расшаренную папку. Обратим внимание на udp и nfs версию.Все работает как надо, согласно опциям.
> [vagrant@nfsc nfs_share]$ sudo mount -t nfs 192.168.50.10:/nfs-share/ /media/nfs_share/  -o rw,noatime,noauto,x-systemd.automount,noexec,nosuid,proto=udp,vers=3  -v
> mount.nfs: timeout set for Sun Aug 16 15:38:07 2020
> mount.nfs: trying text-based options 'proto=udp,vers=3,addr=192.168.50.10'
> mount.nfs: prog 100003, trying vers=3, prot=17
> mount.nfs: trying 192.168.50.10 prog 100003 vers 3 prot UDP port 2049
> mount.nfs: prog 100005, trying vers=3, prot=17
> mount.nfs: trying 192.168.50.10 prog 100005 vers 3 prot UDP port 20048
> mount.nfs: mount(2): Device or resource busy
> mount.nfs: /media/nfs_share is busy or already mounted 


