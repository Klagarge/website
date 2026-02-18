---
title: Chaîne d'outils GNU (et autres outils)
---

- `make` --> utilitaire pour l'automation de la génération de logiciel
- `gcc` --> compilateur C/C++
- `ar` --> utilitaire pour la création de bibliothèques
- `as` --> assembleur
- `ld` --> éditeur de liens

- `gdb` --> debugger / debugger
- `ddd` --> data display debugger
- `addr2line` --> utilitaire pour convertir une adresse vers un fichier et une ligne

- `nm` --> utilitaire pour lister les symboles d'un fichier de code objet
- `objdump` --> utilitaire pour lister des informations d'un fichier de code objet
- `size` --> utilitaire pour lister la taille du code objet
- `strings` --> utilitaire pour lister les chaines de caractères imprimables
- `strip` --> utilitaire pour éliminer les symboles d'un fichier de code objet

- `gcov` --> code/test coverage
- `gprof` --> profiling tool

## Compilation

Avec la chaîne d'outils GNU sous Linux

_compilation de l'application pour le debugging_

``` text
gcc -g -c -Wall -Wextra -O2 -std=gnu11 -o fibonacci.o fibonacci.c
```

- `-g` --> enclenche les options pour le debugging
- `-c` --> indique au compilateur de ne pas linker l'application
- `-Wall` --> enclenche tous les warning
- `-Wextra` --> enclenche des warning supplémentaires
- `-O2` --> force l'optimisation du code généré
- `-std=gnu11` --> autorise l'utilisation des extensions de 2011
- `-o` --> spécifie le nom du fichier de sortie

Si tous les fichiers d'entête (header files) ne sont pas dans le
même répertoire que le fichier à compiler:

- `-I dir` --> spécifie le répertoire où le compilateur trouvera les
  header files, par exemple:
  ```
  -I. -I.. -I /workspace/include
  ```

## Linkage

après la compilation de l'application, vous devez linker tous les
fichiers afin d'obtenir le fichier exécutable:

``` bash
gcc fibonacci.o -o fibonacci
```

il est également possible de compiler et de _linker_
l'application en une seule commande:

``` bash
gcc -g -Wall -Wextra -O2 -std=gnu11 -o fibonacci fibonacci.c
```

- `-o` --> spécifie le nom de l'exécutable
- `-c` --> attention ce flag **ne doit pas** être utilisé!!!

## Lancement & désassemblage

**démarrage l'application**

``` bash
./fibonacci 15
```

**taille du code objet**

``` bash
size -t fibonacci.o
```

**désassemblage du code objet**

``` bash
objdump -d -S -C fibonacci.o
```

**désassmblage de l'application**

``` bash
objdump -d -S -C fibonacci
```

**élimination des symboles de debugging** (pour rendre le code plus léger)

``` bash
strip -g -o fibonacci_s fibonacci
```

## Utilitaire - `make`

`make` est un utilitaire permettant de décrire les dépendances d'une application et
de compiler les fichiers objets nécessaires pour sa génération.

`make` ou `make -f Makefile` ou `make -f mymakefile`

La description de ces dépendances se fait par l'intermédiaire d'un fichier texte.
Le nom de défaut est _Makefile_, mais il est possible de le nommer différemment. 

Exemples:

<figure markdown>
![](img/gnu/makefile.drawio.svg)
</figure>

``` Makefile
exec: main.o mymathlib.o
	gcc -o exec main.o mymathlib.o

main.o: main.c mymathlib.h
	gcc -c -Wall -Wextra -O2 -std=gnu11 -g -o main.o main.c

mymathlib.o: mymathlib.c mymathlib.h
	gcc -c -Wall -Wextra -O2 -std=gnu11 -g -o mymathlib.o mymathlib.c
```

## `make` - variables

L'utilisation de _variables_ simplifie grandement l'écriture des `Makefile`,
par exemple :

``` Makefile
EXEC=exec
CC=gcc
CFLAGS=-Wall -Wextra -O2 -std=gnu11 -g -c

$(EXEC): main.o mymathlib.o
	$(CC) $(LDFLAGS) -o $(EXEC) main.o mymathlib.o

main.o: main.c mymathlib.h
	$(CC) $(CFLAGS) -o main.o main.c

mymathlib.o: mymathlib.c mymathlib.h
	$(CC) $(CFLAGS) -o mymathlib.o mymathlib.c
```

## `make` - plusieurs cibles (targets)

Il est possible de spécifier dans un même «Makefile» plusieurs cibles
différentes, par exemple :

<figure markdown>
![](img/gnu/make-targets.drawio.svg)
</figure>

## `make` - règles _suffixes_

Les règles suffixes permettent d'éviter de spécifier pour chaque fichier (cible
ou dépendance) les commandes à effectuer. Ce travail fastidieux peut être
simplifié de la manière suivante:

<figure markdown>
![](img/gnu/make-suffix.drawio.svg)
</figure>

## `make` - dépendances

Lors de la génération d'applications développées en _C_ il est essentiel de
garantir que celles-ci soient correctement générées et que toutes les
modifications soient bien prises en compte. Pour ce faire, le compilateur GNU
permet de générer un fichier des dépendances, qui pourra ensuite être utilisé
dans le `Makefile`.

<figure markdown>
![](img/gnu/make-dep.drawio.svg)
</figure>

## `make` - conditions

`make` offre des directives permettant d'exécuter _conditionnellement_ une
partie du `Makefile`, ceci en fonction d'une variable et de sa valeur, par exemple :

``` Makefile
ifeq ($(VARIABLE), value)
	## if true do that
else
	## if false do this
endif
```

La variable peut être contenue dans le `Makefile`, mais il est également
possible de la spécifier lors de l'appel du `Makefile`, par exemple :

``` bash
make VARIABLE=value <cible>
```

Cette technique permet de générer un logiciel pour différentes plateformes
(machine hôte, cible, ...) ou en différentes versions (release, debug, ...)

## `make` - sous-Makefile

`make` permet de créer plusieurs `Makefile` où chacun correspond à une
partie distincte d'un grand projet. Pour simplifier sa génération, on préfère
généralement appeler un `Makefile` unique gérant l'ensemble de la
génération de l'application.

La variable `$(MAKE)` fournit l'outil nécessaire pour l'appel de sous-`Makefile`.

``` bash
$(MAKE) -C <directory> <target>
```

Le mot clef `export` permet de passer les variables du `Makefile` maître aux
sous-`Makefile`

## make - commandes silencieuses

Pour éviter d'afficher une longue liste de commandes et d'arguments lors de la
génération d'une application, `make` propose une instruction permettant de
supprimer l'écho des lignes de commandes. Pour ceci, il suffit de rajouter le
caractère «`@`» devant la ligne de commande, par exemple :

``` Makefile
.c.o:
	@echo "(CC) $<"
	@$(CC) $(CFLAGS) -MD -o $*.o $<

$(EXEC): $(OBJS)
	@echo "(LD) $@"
	@$(CC) $(LDFLAGS) -o $@ $^
```

## CMake

Les `Makefile` sont très pratiques pour la génération d'applications,
mais ils peuvent devenir très rapidement difficiles à maintenir, surtout
pour les projets de grande envergure. C'est pour cette raison que des
outils de génération de `Makefile` ont été développés, parmi lesquels on
trouve _CMake_.

Pour générer un `Makefile` à l'aide de _CMake_, il suffit de créer un
fichier `CMakeLists.txt` à la racine du projet, et d'y spécifier les différentes cibles et dépendances.
Le fichier permettant de compiler _fibonacci_ peut être le suivant:

``` CMake title="CMakeLists.txt"
cmake_minimum_required(VERSION 3.28)
project(fibonacci)

add_executable(fibonacci fibonacci.c)
```

Ce `CMakeLists.txt` peut être suffisant pour de la compilation native, mais pour de la compilation croisée, il est nécessaire de spécifier le compilateur à utiliser. On peut pour cela créer un fichier `nanopi.cmake` contenant les informations nécessaires :

``` CMake title="nanopi.cmake"
set(CMAKE_SYSTEM_NAME Linux)

find_program(CMAKE_C_COMPILER aarch64-linux-gcc)
find_program(CMAKE_CXX_COMPILER aarch64-linux-g++)
set(CMAKE_FIND_ROOT_PATH /buildroot/output/host)
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)

set(CMAKE_C_FLAGS "-Wall -Wextra -g -O0 -MD -std=gnu17")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -mcpu=cortex-a53 -funwind-tables")

set(CMAKE_CXX_FLAGS "-Wall -Wextra -g -O0 -MD -std=gnu++17")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -mcpu=cortex-a53 -funwind-tables")
```

Ce fichier peut ensuite être utilisé par le `CMakeLists.txt` de la manière suivante:

``` CMake title="CMakeLists.txt" hl_lines="4"
cmake_minimum_required(VERSION 3.28)
project(fibonacci)

include(../../nanopi.cmake)
add_executable(fibonacci fibonacci.c)
```

Pour générer le `Makefile` à partir du `CMakeLists.txt`, il suffit de lancer la commande suivante:

``` bash
cmake -S . -B build
```

Notez que le résultat se trouve dans le répertoire `build`, ce qui permet de garder la racine du projet propre.
Pour compiler l'application, vous pouvez soit lancer la commande `make` dans le répertoire `build`,
soit utiliser `cmake` de la manière suivante:

``` bash
cmake --build build
```

Votre application est disponible dans le répertoire `build` et peut être déployée sur la cible

!!! note "Note"
	_CMake_ permet aussi de générer des fichiers pour le système _Ninja_, qui est plus rapide que _Make_.
	Vous trouverez plus d'informations dans la [documentation officielle de _CMake_](https://cmake.org/cmake/help/latest/index.html)

## Just

_Just_ est un outil semblable à `make`, mais plus moderne et plus facile
à utiliser. Il utilise des fichiers `justfile` pour décrire les tâches à
exécuter, et offre une syntaxe plus simple et plus lisible que les
`Makefile`. 

_Just_ est particulièrement apprécié pour sa simplicité et sa
flexibilité, et est de plus en plus utilisé dans les projets de
développement logiciel. Contrairement à `make`, _just_ ne repose pas sur
des règles de suffixes et ne permet pas de limiter les tâches en
fonction de la date de modification des fichiers.  Il n'est donc pas un
remplacement direct de `make` et les deux outils peuvent être utilisés
de manière complémentaire en fonction des besoins du projet.