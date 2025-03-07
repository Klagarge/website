---
title: Génération d'un module
---

 Linux propose deux solutions:
 
**«out of tree»**

- Cette solution consiste à placer le code source du module à l'extérieur de l'arborescence des sources du noyau Linux
- Avantage: gestion des modifications très simple et indépendantes de la génération du noyau
- Désavantage: n'est pas intégré dans la configuration et génération du noyau et ne pourra pas être linké statiquement avec le noyau

**«inside tree»**

- Cette solution consiste à intégrer le code source du module avec les sources
  du noyau Linux
- Le module pourra ainsi être linké statiquement avec le noyau
- Il est naturellement également possible de le charger dynamiquement

## Génération «out of tree»

Les modules Linux doivent être générés par l'intermédiaire d'un Makefile.
Par exemple :

``` Makefile
{! include "./src/gen.mk" !}
```

- La commande `make` génère le module pour la machine cible.
- Le module généré est `mymodule.ko`.
- `.ko` indique qu'il s'agit d'un _kernel object_ pouvant être chargé dans le noyau.
- La compilation du module s'effectue en trois phases
    <div class="md-decimal-list">
    1. Le `Makefile` du module est appelé avec la commande `make` ou `make all`
    1. Lors de ce premier appel, la variable `KERNELRELEASE` n'est pas définie.
       Le `make` appelle par conséquent le `Makefile` du noyau spécifié par
       la variable `KDIR`. On doit impérativement spécifier :
           - L'architecture du processeur avec la variable `ARCH=$(CPU)`
           - Le compilateur à utiliser avec la variable `CROSS_COMPILE=$(TOOLS)`
    2. Le `Makefile` du noyau a la logique pour la génération de modules et,
       grâce à la variable `M`, il peut obtenir la liste des sources à compiler
       en réinterprétant le `Makefile` du module pour obtenir le nom du module
       à générer avec la définition `obj-m` ainsi que la liste des objets
       nécessaire pour construire le module avec la variable `mymodule-objs`
    </div>

!!! warning "Attention"
    Un module compilé pour une version `X` du noyau ne pourra pas être chargé
    sur une version `Y` : _invalid module format_

## Génération «inside tree»

Pour être généré avec le noyau, le code source du module doit
impérativement être déposé dans l'arborescence des sources du noyau
Linux.

- Ajouter les sources dans le répertoire approprié du noyau par exempl dans `./drivers/misc`
  _Remarque:
  si le module est suffisamment petit, quelques milliers de lignes de code,
  on ne créera qu'un seul fichier. Si celui-ci est réellement très grand, on pourra
  alors le partager en plusieurs fichiers et le déposer dans son propre répertoire_

- Modifier le fichier de configuration _Kconfig_ pour y ajouter le
  nouveau module 
  ``` text
  config MISC_MY_MODULE
  tristate "Miscellaneous Module Skeleton"
  help
      Module skeleton for education purpose
  ```
- Modifier le Makefile selon l'entrée de Kconfig
  ```Makefile
  obj-$(CONFIG_MISC_MY_MODULE) += skeleton.o
  ```
- Reconfigurer le noyau pour générer le module (`make linux-menuconfig`)
- Régénérer le noyau (`make`)
- Voir [`./Documenation/kbuild`](https://docs.kernel.org/kbuild/kbuild.html) pour plus de détails et des exemples plus complets