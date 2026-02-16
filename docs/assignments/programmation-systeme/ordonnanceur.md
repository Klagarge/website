---
title: "Multiprocessing et Ordonnanceur"
week: 9
---

{% set exno = namespace(no=0) %}
{% set subno = namespace(no=0) %}
{% macro ex() -%}
{% set exno.no = exno.no + 1 %}**Exercice #{{ exno.no }}**{% set subno.no = 0 %}
{%- endmacro %}
{% macro exx() -%}
**{% set subno.no = subno.no + 1 %}Exercice #{{ exno.no }}.{{ subno.no }}**
{%- endmacro %}

## Processus, signaux et communication

{{ ex() }}: Concevez et développez une petite application mettant en
œuvre un des services de communication proposés par Linux (par exemple
`socketpair`) entre un processus parent et un processus enfant. Le
processus enfant devra émettre quelques messages sous forme de texte
vers le processus parent, lequel les affichera sur la console. Le
message `exit` permettra de terminer l'application. Cette application
devra impérativement capturer les signaux
`SIGHUP`,
`SIGINT`,
`SIGQUIT`,
`SIGABRT` et
`SIGTERM`
et les ignorer. Seul un message d'information sera affiché sur la
console. Chacun des processus devra utiliser son propre cœur, par
exemple _core 0_ pour le parent, et _core 1_ pour l'enfant.

## CGroups

{{ ex() }}: Concevez une petite application permettant de valider la
capacité des groupes de contrôle à limiter l'utilisation de la mémoire.

### Quelques indications pour la création du programme :

- Allouer un nombre défini de blocs de mémoire d'un mébibyte[^1], par exemple 50
- Tester si le pointeur est non nul
- Remplir le bloc avec des 0

[^1]: $1$ mébibyte = $2^{20}$ byte

### Quelques indications pour monter les _CGroups_ :

- `$ mount -t tmpfs none /sys/fs/cgroup`
- `$ mkdir /sys/fs/cgroup/memory`
- `$ mount -t cgroup -o memory memory /sys/fs/cgroup/memory`
- `$ mkdir /sys/fs/cgroup/memory/mem`
- `$ echo $$ > /sys/fs/cgroup/memory/mem/tasks`
- `$ echo 20M > /sys/fs/cgroup/memory/mem/memory.limit_in_bytes`

### Quelques questions :

1. Quel effet a la commande `echo $$ > ...` sur les _cgroups_ ?
2. Quel est le comportement du sous-système _memory_ lorsque le quota de
   mémoire est épuisé&nbsp;? Pourrait-on le modifier ? Si oui, comment ?
3. Est-il possible de surveiller/vérifier l'état actuel de la mémoire ?
   Si oui, comment ?

{{ ex() }}: Afin de valider la capacité des groupes de contrôle de
limiter l'utilisation des CPU, concevez une petite application composée
au minimum de 2 processus utilisant le 100% des ressources du
processeur.

### Quelques indications pour monter les CGroups :

- Si ce n'est pas déjà effectué, monter le _cgroup_ de l'exercice précédent.
- `$ mkdir /sys/fs/cgroup/cpuset`
- `$ mount -t cgroup -o cpu,cpuset cpuset /sys/fs/cgroup/cpuset`
- `$ mkdir /sys/fs/cgroup/cpuset/high`
- `$ mkdir /sys/fs/cgroup/cpuset/low`
- `$ echo 3 > /sys/fs/cgroup/cpuset/high/cpuset.cpus`
- `$ echo 0 > /sys/fs/cgroup/cpuset/high/cpuset.mems`
- `$ echo 2 > /sys/fs/cgroup/cpuset/low/cpuset.cpus`
- `$ echo 0 > /sys/fs/cgroup/cpuset/low/cpuset.mems`


### Quelques questions :

1. Les 4 dernières lignes sont obligatoires pour que les prochaines
   commandes fonctionnent correctement. Pouvez-vous en donner la raison ?
2. Ouvrez deux shells distincts et placez une dans le _cgroup high_ et
   l'autre dans le _cgroup low_, par exemple :
   ```
   # ssh root@192.168.53.14
   $ echo $$ > /sys/fs/cgroup/cpuset/low/tasks
   ```
   Lancez ensuite votre application dans chacun des shells. Quel
   devrait être le bon comportement ? Pouvez-vous le vérifier ?
3. Sachant que l'attribut ``cpu.shares`` permet de répartir le temps CPU
   entre différents _cgroups_, comment devrait-on procéder pour lancer
   deux tâches distinctes sur le cœur 4 de notre processeur et attribuer
   75% du temps CPU à la première tâche et 25% à la deuxième ?

---

!!! note "Archives 2021/2022"
    - [Exercices](ordonnanceur/sp.06.2_mas_csel_mulitprocessing_exercices.pdf)
