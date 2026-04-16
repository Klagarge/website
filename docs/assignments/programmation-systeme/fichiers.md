---
title: "Système de fichiers"
week: 7
---

{% set exno = namespace(no=0) %}
{% set subno = namespace(no=0) %}
{% macro ex() -%}
{% set exno.no = exno.no + 1 %}**Exercice #{{ exno.no }}**{% set subno.no = 0 %}
{%- endmacro %}
{% macro exx() -%}
**{% set subno.no = subno.no + 1 %}Exercice #{{ exno.no }}.{{ subno.no }}**
{%- endmacro %}

## Contexte

La carte NanoPi NEO Plus2 est équipée de deux LEDs. La LED rouge est en principe prévue pour indiquer
si la cible est sous tension (_power_) et la LED verte est là pour donner des indications d'état (_status_).
Avec la configuration actuelle du noyau Linux, ces deux LEDs sont à libre disposition des développeurs.

## Travail à réaliser

Vous trouverez ci-dessous une application qui contrôle la fréquence de clignotement d'une
LED. Ce code n'a pas été très bien programmé et utilise le 100% d'un cœur du processeur (à mesurer
avec `top`).

??? example "silly_led_control.c"
    ```c
    {! include "./fichiers/silly_led_control.c" !}
    ```

Concevez une application permettant de gérer la fréquence de clignotement de la LED `status` de la
carte NanoPi à l'aide des trois boutons-poussoirs.
Quelques indications pour la réalisation de l'application :

1. Au démarrage la fréquence de clignotement sera réglée à 2&nbsp;Hz
2. Utilisation des boutons-poussoirs
    - `k1` pour augmenter la fréquence
    - `k2` pour remettre la fréquence à sa valeur initiale
    - `k3` pour diminuer la fréquence
    - optionnel : une pression continue exercée sur un bouton indiquera une auto
      incrémentation ou décrémentation de la fréquence.
3. Tous les changements de fréquence seront logger avec `syslog` de Linux.
4. Le multiplexage des entrées/sorties devra être utilisé.

## Infos pratiques

### GPIO

L'accès aux entrées/sorties est proposé sous le système de fichiers virtuels _sysfs_, dans le
répertoire `/sys/class/gpio/*`. Cette interface est décrite dans la documentation du noyau
Linux (https://www.kernel.org/doc/Documentation/gpio/sysfs.txt).

Quelques informations utiles pour l'utilisation du module GPIO sous Linux :

**Pour lire ou écrire une valeur sur une _pin_ d'entrée/sortie, il faut
tout d'abord configurer le _GPIO_, soit :**

1. Exporter la porte dans le _sysfs_ à l'aide de la commande :
    ```
    # echo <pin_nr> > /sys/class/gpio/export
    ```
2. Configurer la porte en entrée ou en sortie :
    ```
    # echo in > /sys/class/gpio/gpio<pin_nr>/direction
    # echo out > /sys/class/gpio/gpio<pin_nr>/direction
    ```
3. Lire l'état de la pin (input) :
    ```
    # cat /sys/class/gpio/gpio<pin_nr>/value
    ```
4. Changer l'état de la pin (output) :
    ```
    # echo 0 > /sys/class/gpio/gpio<pin_nr>/value
    # echo 1 > /sys/class/gpio/gpio<pin_nr>/value
    ```
5. Pour traiter les entrées/sorties en mode événementiel :
    ```
    # echo rising > /sys/class/gpio/gpio<pin_nr>/edge
    # echo falling > /sys/class/gpio/gpio<pin_nr>/edge
    # echo both > /sys/class/gpio/gpio<pin_nr>/edge
    ```

**Pour obtenir le numéro du _GPIO_ correspondant à un _pin_ il faut lire la configuration sur le _debugfs_,
soit :**

```
# mount -t debugfs none /sys/kernel/debug
# cat /sys/kernel/debug/gpio
```

### Timer

La librairie `timerfd` offre des services très intéressants pour la génération d'une horloge à haute
résolution et surtout une interface permettant le multiplexage des entrées/sorties.
