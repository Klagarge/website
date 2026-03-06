---
title: Bibliothèques et fonctions utiles
---

## Bibliothèques

À l'intérieur du noyau Linux on ne dispose pas des bibliothèques standard C. Par contre, le noyau fournit toute une série de bibliothèques et de fonctions fort utiles.

**`String` dans `<linux/string.h>`**

- Relié à la mémoire: `memset`, `memcpy`, `memmove`, `memscan`, `memcmp`, `memchr`
- Relié aux chaînes de caractères: `strcpy`, `strcat`, `strcmp`, `strchr`, `strrchr`, `strlen`
  et d'autres variantes
- Allocation et copie de blocs mémoire: `kmemdump`
- Allocation et copie de chaînes de caractères: `kstrdup`, `strrndup`

**Conversion de string dans `<linux/kernel.h>`**

- Conversion de strings en entiers: `kstrtoul`, `kstrtol`, `kstrto*` 
- Fonctions sur les chaînes de caractères: `sprintf`, `sscanf`

**Listes chaînées `<linux/list.h>` (_simple doubly linked list_)**

- Très pratique et utilisées à des milliers d'endroits dans le noyau
- Ajouter un membre `struct list_head` dans la structure des éléments
  participant à la liste chaînée. On le nommera généralement `list`
  ou parfois `node`.
- Créer une liste : Si la liste est globale on utilisera la macro
  [`LIST_HEAD`](https://docs.kernel.org/core-api/list.html#c.LIST_HEAD),
  si la liste fait partie d'une structure on définira un
  élément  `struct list_head` et on l'initialisera avec la macro
  [`INIT_LIST_HEAD`](https://docs.kernel.org/core-api/list.html#c.INIT_LIST_HEAD)
- Pour manipuler les éléments de la liste chaînée, on pourra utiliser
    - Ajouter des éléments:
      [`list_add()`](https://docs.kernel.org/core-api/list.html#c.list_add),
      [`list_add_tail()`](https://docs.kernel.org/core-api/list.html#c.list_add_tail)
    - Supprimer, déplacer ou remplacer des éléments:
      [`list_del()`](https://docs.kernel.org/core-api/list.html#c.list_del),
      [`list_move()`](https://docs.kernel.org/core-api/list.html#c.list_move),
      [`list_move_tail()`](https://docs.kernel.org/core-api/list.html#c.list_move_tail),
      [`list_replace()`](https://docs.kernel.org/core-api/list.html#c.list_replace)
    - Tester la liste:
      [`list_empty()`](https://docs.kernel.org/core-api/list.html#c.list_empty)
    - Itérer sur la liste: [`list_for_each_*()`](https://docs.kernel.org/core-api/list.html#c.list_for_each) de la famille des macros
- Il existe également des variantes sûres (_safe_) de ce méthodes

## Exemple de liste chaînée

``` c
// definition of a list element with struct list_head as member
struct element {
    // some members
    struct list_head list;
};

// definition of the global list
static LIST_HEAD (my_list);

// allocate on element and add it at the tail of the list
void alloc_ele () {
    struct element* ele;
    // create a new element
    ele = kzalloc(sizeof(*ele), GFP_KERNEL); 
    if (ele != NULL)
        // add element at the end of the list 
        list_add_tail(&ele->list, &my_list); 
}

// process all elements of the list
void process_all() {
    struct element* ele;
    // iterate over the whole list
    list_for_each_entry(ele, &my_list, list) { 
      // do something with ele
    }
}
```
