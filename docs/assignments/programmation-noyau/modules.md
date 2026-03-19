---
title: "Modules noyaux"
tpno: 2
---
{% set show_sol_a = cal.tp2_sol_a %}
{% set show_sol_b = cal.tp2_sol_b %}

{% set exno = namespace(no=1) %}
{% macro ex() -%}
**Exercice #{{ exno.no }}**: {% set exno.no = exno.no + 1 %}
{%- endmacro %}

{{ ex() }} Générez un module noyau _out of tree_ pour la cible NanoPi :

1. Créez le squelette d'un module noyau et générez-le en dehors des sources du noyau à l'aide
    d'un Makefile. Le module devra afficher un message lors de son enregistrement et lors de sa
    désinstallation.
2. Testez sur la machine hôte la commande `modinfo`[^1] sur votre squelette de module et
    comparez les informations retournées avec celles du code source.
3. Installez le module (`insmod`) et contrôlez le log du noyau (`dmesg`)
4. Comparez les résultats obtenus par la commande `lsmod` avec ceux obtenus avec la
    commande `cat /proc/modules`
5. Désinstallez le module (`rmmod`).
6. Adaptez le `Makefile` du module pour autoriser l'installation du module avec les autres
    modules du noyau permettant l'utilisation de la commande `modprobe`. Le module devra
    être installé dans le root filesystem utilisé en _cifs_ par la cible.

[^1]: Pour installer  `modinfo`, ajoutez le _package_ "kmod utilities" : _Target Packages_ --> _System Tools_ --> _kmod_ et _kmod utilities_. Vous pouvez ensuite mettre à jour le _root file system_ avec la commande `extract-rootfs.sh`, mais attention, vous allez remplacer des fichiers tels que `/etc/fstab`. Sauvegardez vos fichiers importants!

{{ ex() }}  Adaptez le module de l'exercice précédent afin qu'il puisse recevoir deux ou trois paramètres de
votre choix. Ces paramètres seront affichés dans la console. Adaptez également le _rootfs_ afin de
pouvoir utiliser la commande `modprobe`.

{% if show_sol_a %}
??? success "Solution"
    ```text title="/workspace/src/kernel_settings"
    {! include "./modules/src/kernel_settings" !}
    ```
    ```makefile title="/workspace/src/02_modules/exercice01/Makefile"
    {! include "./modules/src/exercice01/Makefile" !}
    ```
    ```c title="/workspace/src/02_modules/exercice01/skeleton.c"
    {! include "./modules/src/exercice01/skeleton.c" !}
    ```
{% endif %}

{{ ex() }}  Trouvez la signification des 4 valeurs affichées lorsque l'on tape la commande
`cat /proc/sys/kernel/printk`

## Gestion de la mémoire, bibliothèque et fonction utile

{{ ex() }} Créez dynamiquement des éléments dans le noyau. Adaptez un module noyau, afin que l'on
puisse lors de son installation spécifier un nombre d'éléments à créer ainsi qu'un texte initial à
stocker dans les éléments précédemment alloués. Chaque élément contiendra également un
numéro unique. Les éléments seront créés lors de l'installation du module et chaînés dans l'une
liste. Ces éléments seront détruits lors de la désinstallation du module. Des messages
d'information seront émis afin de permettre le debugging du module.

{% if show_sol_a %}
??? success "Solution"
    ```makefile title="/workspace/src/02_modules/exercice04/Makefile"
    {! include "./modules/src/exercice04/Makefile" !}
    ```
    ```c title="/workspace/src/02_modules/exercice04/skeleton.c"
    {! include "./modules/src/exercice04/skeleton.c" !}
    ```
{% endif %}

## Accès aux entrées/sorties

{{ ex() }} À l'aide d'un module noyau, afficher le Chip-ID du processeur, la température du CPU et la MAC
adresse du contrôleur Ethernet.

- Les 4 registres de 32 bits du Chip-ID sont aux adresses `0x01c1'4200` à `0x01c1'420c`
- Le registre de 32 bits du senseur de température du CPU est à l'adresse `0x01c2'5080`
- Les 2 registres de 32 bits de la MAC adresse sont aux adresses `0x01c3'0050` et
    `0x01c3'0054`

Pour obtenir la température du CPU, il faut, après lecture du registre, appliquer la formule
suivante : 

$$ \mathsf{temperature} = -1'191 \cdot \frac{\mathsf{register\, value}}{10} + 223'000$$

Avant d'accéder aux registres du _Chip-ID_, veuillez réserver la zone mémoire correspondante aux
registres du microprocesseur. Validez cette réservation à l'aide de la commande `cat /proc/iomem`.
La commande `cat /sys/class/thermal/thermal_zone0/temp` permet de valider la bonne lecture
de la température. La commande `ifconfig` permet de valider la bonne lecture de la _MAC
adresse_.

{% if show_sol_b %}
??? success "Solution"
    ```c title="/workspace/src/02_modules/exercice04/skeleton.c"
    {! include "./modules/src/exercice05/skeleton.c" !}
    ```
{% endif %}

## Threads du noyau

{{ ex() }} Développez un petit module permettant d'instancier un _thread_ dans le noyau. Ce _thread_ affichera
un message toutes les 5 secondes. Il pourra être mis en sommeil durant ces 5 secondes à l'aide de
la fonction `ssleep(5)` provenant de l'interface `<linux/delay.h>`.

{% if show_sol_b %}
??? success "Solution"
    ```c title="/workspace/src/exercice04/skeleton.c"
    {! include "./modules/src/exercice06/skeleton.c" !}
    ```
{% endif %}

## Mise en sommeil

{{ ex() }} Développez un petit module permettant d'instancier deux threads dans le noyau. Le premier
thread attendra une notification de réveil du deuxième thread et se remettra en sommeil. Le 2^ème^
thread enverra cette notification toutes les 5 secondes et se rendormira. On utilisera les
_waitqueues_ pour les mises en sommeil. Afin de permettre le debugging du module, chaque thread
affichera un petit message à chaque réveil.

{% if show_sol_b %}
??? success "Solution"
    ```c title="/workspace/src/exercice04/skeleton.c"
    {! include "./modules/src/exercice07/skeleton.c" !}
    ```
{% endif %}

## Interruptions

{{ ex() }} Développez un petit module permettant de capturer les pressions exercées sur les switches de la
carte d'extension par interruption. Afin de permettre le debugging du module, chaque capture
affichera un petit message.

Quelques informations pour la réalisation du module :

1. Acquérir la porte GPIO avec le service
   `gpio_request (<io_nr>, <label>);`
2. Obtenir le vecteur d'interruption avec le service
   `gpio_to_irq (<io_nr>);`
3. Informations sur les switches de la carte d'extension
    - k1 - `gpio`: A, `pin_nr`=0, `io_nr`=0
    - k2 - `gpio`: A, `pin_nr`=2, `io_nr`=2
    - k3 - `gpio`: A, `pin_nr`=3, `io_nr`=3

{% if show_sol_b %}
??? success "Solution"
    ```c title="/workspace/src/exercice08/skeleton.c"
    {! include "./modules/src/exercice08/skeleton.c" !}
    ```
{% endif %}

