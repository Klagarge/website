---
title: Paramètres d'un module
---

Linux permet de passer des paramètres à un module lors de son chargement.

Le code ci-dessous montre les adaptations à apporter au squelette du module pour
supporter deux paramètres

``` C hl_lines="6 8-9 11-12 16"
/* skeleton.c */
#include <linux/module.h>  /* needed by all modules */
#include <linux/init.h>    /* needed for macros */
#include <linux/kernel.h>  /* needed for debugging */

#include <linux/moduleparam.h>  /* needed for module parameters */

static char* text = "dummy help";
module_param(text, charp, 0);

static int elements = 1;
module_param(elements, int, 0);

static int __init skeleton_init(void) {
    pr_info ("Linux module skeleton loaded\n");
    pr_info ("text: %s\nelements: %d\n", text, elements);
    return 0;
}

static void __exit skeleton_exit(void) {
    pr_info ("Linux module skeleton unloaded\n");
}

module_init (skeleton_init);
module_exit (skeleton_exit);

MODULE_AUTHOR ("Jacques Supcik <jacques.supcik@hefr.ch>");
MODULE_DESCRIPTION ("Module skeleton");
MODULE_LICENSE ("GPL");
```

**La macro `module_param` permet de définir des paramètres dans un module.
Cette macro est disponible depuis l'interface `linux/moduleparam.h`**

- 1^er^ argument : indique le nom du paramètre et de la variable dans le module
- 2^ème^ argument : indique le type de paramètre
  (`byte`, `short`, `ushort`, `int`, `uint`, `long`, `ulong`, `charp` ou `bool`).
  Ce paramètre est contrôlé lors de la compilation.
- 3^ème^ argument : spécifie les droits d'accès au fichier contenant les
  paramètres (`/sys/module/<module_name>/parameters/<param>`).
  La valeur `0` indique que ce fichier n'existe pas.

**Le passage de paramètres s'effectue lors du chargement du module**

- Avec `insmod`:
  ``` bash
  insmod mymodule.ko elements=-1 'text="bonjour le monde"'
  ```
- Avec `modprobe`, il suffit d'inclure les paramètres du module dans 
  un fichier avec l'extension `.conf` qui se trouve dans le dossier `/etc/modprobe.d`.
  Par exemple : `/etc/modprobe.d/mymodule.conf` :
  ``` text title="/etc/modprobe.d/mymodule.conf"
  options mymodule elements=5 text="salut les copains..."
  ```
- Si le module est _linké_ statiquement avec le noyau, on peut passer
  les paramètres dans la ligne de commande du noyau lors de son
  lancement, par exemple :
  ```
  mymodule.elements=10
  ```