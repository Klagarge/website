---
title: Gestion des répertoires
---

## Files and Directories Management

La gestion des fichiers et des répertoires est un aspect important pour un
système d'exploitation. Linux propose divers services à cet effet.

Hormis les services pour créer et échanger des données avec des fichiers,
Linux, via les bibliothèques `<unistd.h>` et `<dirent.h>`, nous offre des
fonctions pour:

- Modifier les permissions
  ```c
  int chmod (const char* path, mode_t mode);
  int chown (const char* path, uid_t owner, gid_t group);
  ```
- Gérer les répertoires
  ```c
  char* getcwd (char* buf, size_t size);
  int chdir (const char* path);
  int mkdir (const char* path, mode_t mode);
  int rmdir (const char* path);
  ```
- Lire le contenu de répertoires / traverser une arborescence
  ```c
  DIR* opendir(const char* path);
  struct dirent* readdir (DIR* dir);
  int closedir (DIR* dir);
  ```
- Gérer les liens (_hardlinks_ et _softLinks_)
  ```c
  int link (const char* oldpath, const char* newpath);
  int symlink (const char* oldpath, const char* newpath);
  int unlink (const char* path);
  ```

## Lecture du contenu de répertoires

La lecture du contenu de répertoires ou la traversée de l'arborescence d'un
système de fichiers sont des opérations assez courantes. Elles sont utilisées
pour obtenir l'annuaire des fichiers résidants dans un répertoire donné ou
pour rechercher certaines informations, telles que la structure du système.

La lecture s'effectue en trois opérations distinctes :

- Ouverture du répertoire (méthode: `opendir`)
- Lecture du répertoire (méthode: `readdir`)
- Fermeture du répertoire (méthode: `closedir`)

Si l'on souhaite obtenir l'annuaire des répertoires d'une arborescence
donnée, il suffit d'effectuer récursivement les trois opérations ci-dessus sur
tous les fichiers représentant un répertoire.

## Ouverture de l'annuaire d'un répertoire

L'ouverture d'un répertoire est obtenue à l'aide de la méthode `opendir()`

```c
#include <sys/types.h>
#include <dirent.h>
DIR *opendir (const char* dirname);
```

**Exemple**

```c
DIR* dirp = opendir ("/home/myusername/mydirectory");
if (dirp == 0)
    /* error*/
```

**Comportement**

- La fonction `opendir()` retourne un pointeur sur l'annuaire d'un répertoire
  (_stream_) spécifié par l'argument `dirname`. Si une erreur survient lors de
  l'ouverture, le pointeur sera `NULL` et la variable `errno` indiquera l'erreur,
  les plus probables:
    - `EACCES` --> pas de permission
    - `ENOENT` --> répertoire n'existe pas
    - `ENOTDIR` --> dirname n'est pas un répertoire

## Lecture de l'annuaire d'un répertoire

L'ouverture d'un répertoire est obtenue à l'aide de la méthode `readdir()`

```c
#include <dirent.h>
struct dirent *readdir (DIR* dirp);
```

**Exemple**

```c
errno = 0;
while (true) {
    struct dirent* entry = readdir (dirp);
    if (entry == 0) break;
    if (strcmp(entry->d_name, filename) == 0)
        /* do something... */
    }
    if ((errno != 0) && (entry == 0))
        /* error*/
```

**Comportement**

- La fonction `readdir()` retourne un pointeur sur une entrée de l'annuaire du
  répertoire. Si toutes les entrées ont été découvertes, la fonction retourne un
  pointeur `NULL`. En cas d'erreur, le pointeur sera `NULL` et la variable `errno`
  indique l'erreur avec une valeur différente de `0`.
- Il est important de noter que le contenu des données retournées par `readdir()`
  peut être modifié par d'autres appels à cette fonction pour le même annuaire.
  La méthode `readdir_r()` offre un service réentrant

**Données retournées**

- La structure dirent contient les attributs suivants:
  ```c
  struct dirent {
      ino_t d_ino; // inode number
      off_t d_off; // offset to the next dirent
      unsigned short d_reclen; // record length
      unsigned char d_type; // file type; not supported
                            // by all file system types
      char d_name[256]; // filename
  };
  ```
- L'attribut `d_type` peut prendre les valeurs suivantes:
    - `DT_BLK` --> it's a block device
    - `DT_CHR` --> it's a character device
    - `DT_DIR` --> it's a directory
    - `DT_FIFO` -->  it's a named pipe (FIFO)
    - `DT_LNK` --> it's a symbolic link
    - `DT_REG` --> it's a regular file
    - `DT_SOCK` --> it's a UNIX domain socket
    - `DT_UNKNOWN` --> file type unknown
- Il est important de noter que seuls les attributs `d_ino` et `d_name` sont toujours
  disponibles (raisons de compatibilité). Pour obtenir les métadonnées du fichier, il
  suffit d'utiliser la fonction `stat()`.

## Fermeture de l'annuaire d'un répertoire

La fermeture de l'annuaire d'un répertoire est obtenue à l'aide de l'appel
système `closedir()`

```c
#include <sys/types.h>
#include <dirent.h>
int closedir (DIR* dirp);
```

**Exemple**

```c
int err = closedir (dirp);
if (err == -1)
    /* error */
```

**Comportement**

- La fonction `closedir()` permet de fermer l'annuaire du répertoire et de libérer
  les ressources liées à son ouverture.
    - `EBADF` --> pointeur sur l'annuaire de répertoire `dirp` invalide
