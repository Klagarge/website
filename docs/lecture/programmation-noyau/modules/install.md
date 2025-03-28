---
title: Installation / Désinstallation
---

## Installation et désinstallation d'un module

L'installation et la désinstallation de module ne peuvent être réalisées qu'en
ayant les droits <font markdown color="red"><tt markdown>**root**</tt></font>.

Linux propose plusieurs outils pour la gestion des modules noyaux

- La commande `modinfo <module_name>.ko` nous renseigne sur le module:
  paramètres, licence, description, dépendances, ...
- Pour installer un module dans le noyau, on peut utiliser la commande `insmod`. Par exemple
  ``` bash
  insmod mymodule.ko
  ```
- Si l'on rencontre des problèmes ou des erreurs lors de l'installation d'un module,
  la commande `dmesg` permet souvent d'obtenir plus de renseignements sur la cause de l'erreur.
- Pour obtenir la liste des modules déjà installés dans le noyau, il suffit
  simplement de lire le contenu du fichier `/proc/modules` (`cat /proc/modules`)
  ou d'utiliser la commande `lsmod`
- Pour _désinstaller_ un module du noyau, il suffit d'utiliser la commande `rmmod`.
  Il est important de noter que cette opération n'est autorisée que si le module
  n'est plus utilisé, par exemple :
  ``` bash
  rmmod mymodule
  ```

Si un module dépend d'autres modules, il est impératif de les avoir
préalablement chargés dans le noyau Linux. Cette tâche étant
relativement fastidieuse, la commande `modprobe` offre une alternative
très intéressante aux commandes précédentes.

- Pour installer un module: `modprobe <module_name>` (sans l'extension `.ko`)
- Pour désinstaller un module: `modprobe -r <module_name>` (sans l'extension `.ko`)
- Pour charger le module souhaité, `modprobe` interprète le fichier
  `modules.dep` situé dans le répertoire `/lib/modules/<kernel_version>/`
- Ce fichier est généré par les `Makefile` du noyau. Pour inclure son
  propre module dans ce fichier, il suffit de compléter le `Makefile` du
  module avec l'instruction suivante, par exemple
  ``` Makefile
  MODPATH := /buildroot/output/target # production mode
  install:
      $(MAKE) -C $(KDIR) M=$(PWD) INSTALL_MOD_PATH=$(MODPATH) modules_install
  ```
- La variable `INSTALL_MOD_PATH` indique le chemin du répertoire où est placé le root file system
- En mode de développement sous CIFS:
  ``` bash
  MODPATH := /rootfs
  ...
  ```
- Pour installer le module dans le root file system, il suffit de taper
  ``` bash
  sudo make install
  ```
