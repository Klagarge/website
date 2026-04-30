---
title: Traitement des signaux
---

## Signaux - Introduction

Les signaux sont des interruptions logicielles permettant de traiter des
événements asynchrones au bon déroulement du programme

Les événements à l'origine de la levée des signaux sont souvent externes au
système, par exemple pression sur la touche ++ctrl+c++ sur un clavier

Un processus peut envoyer un signal à un autre processus ou groupe de
processus, offrant ainsi une forme primitive de communication
interprocessus

Lorsqu'un signal est levé (généré ou envoyé), le noyau effectue une des
actions suivantes:

- **Ignorer le signal** :
  Le noyau ignore le signal et aucune action n'est entreprise.
- **Capturer et traiter le signal** :
  Le noyau arrête l'exécution du processus et traite le signal en appelant une
  fonction ayant été enregistrée préalablement par le processus en cours.
- **Effectuer une action par défaut** :
  Le noyau arrête l'exécution du processus et exécute une action par défaut
  implémentée par le noyau lui-même et dépendante du signal. Celle-ci consiste
  souvent à terminer le processus et générer un _core dump_.

## Liste

Les signaux supportés par Linux sont disponibles dans le fichier `signal.h`

Chaque signal est identifié par une valeur symbolique avec le préfix `SIG`,
laquelle représente une valeur entière positive non nulle

Signaux disponibles sous Linux (`kill -l`):


| Signal    | No | Description                                 |
|-----------|----|---------------------------------------------|
| SIGHUP    | 1  | Hangup                                      |
| SIGINT    | 2  | Terminal interrupt (Ctrl-C)                 |
| SIGQUIT   | 3  | Terminal quit (Ctrl-\\)                     |
| SIGILL    | 4  | Illegal instruction                         |
| SIGTRAP   | 5  | Trace trap                                  |
| SIGABRT   | 6  | Abort                                       |
| SIGBUS    | 7  | BUS error                                   |
| SIGFPE    | 8  | Floating point exception                    |
| SIGKILL   | 9  | Kill (can't be caught or ignored)           |
| SIGUSR1   | 10 | User defined signal 1                       |
| SIGSEGV   | 11 | Invalid memory segment access               |
| SIGUSR2   | 12 | User defined signal 2                       |
| SIGPIPE   | 13 | Write on a pipe with no reader, Broken pipe |
| SIGALRM   | 14 | Alarm clock                                 |
| SIGTERM   | 15 | Termination                                 |
| SIGSTKFLT | 16 | Stack fault                                 |
| SIGCHLD   | 17 | Child process has stopped or exited         |
| SIGCONT   | 18 | Continue executing, if stopped              |
| SIGSTOP   | 19 | Stop executing (can't be caught or ignored) |
| SIGTSTP   | 20 | Terminal stop signal (Ctrl-Z)               |
| SIGTTIN   | 21 | Background process trying to read, from TTY |
| SIGTTOU   | 22 | Background process trying to write, to TTY  |
| SIGURG    | 23 | Urgent condition on socket                  |
| SIGXCPU   | 24 | CPU limit exceeded                          |
| SIGXFSZ   | 25 | File size limit exceeded                    |
| SIGVTALRM | 26 | Virtual alarm clock                         |
| SIGPROF   | 27 | Profiling alarm clock                       |
| SIGWINCH  | 28 | Window size change                          |
| SIGIO     | 29 | I/O now possible                            |
| SIGPWR    | 30 | Power failure restart                       |

Les signaux `SIGSTOP` (19) et `SIGKILL` (9) ne peuvent être ni capturés et ni ignorés.

## Opérations

Pour le traitement des signaux, Linux propose des services permettant
d'attacher une méthode spécifique à chaque signal respectivement de lever
un signal pour un processus ou un groupe de processus.

| Opérations             | syscall     |
|------------------------|-------------|
| Capturer un signal     | `sigaction` |
| Lever un signal        | `kill`      |
| Attendre sur un signal | `pause`     |

## Capturer un signal

Pour capturer et traiter un signal, l'application doit préalablement attacher une
méthode de traitement pour le signal souhaité. Pour ce faire, Linux propose
l'appel système `sigaction()`.

```c
#include <signal.h>
int sigaction (int signo,
               const struct sigaction* act,
               struct sigaction *oldact);
```

**Exemple**

```c
struct sigaction act = {.sa_handler = catch_signal,};
int err = sigaction (SIGHUP, &act, NULL);
if (err == -1)
    /* error */
```

**Comportement**

- La fonction `sigaction()` associe une méthode de traitement au signal passé
  en 1^er^ argument, ici `SIGHUP`. Il est possible de donner un pointeur sur une
  `struct sigaction` afin de récupérer l'action précédente. 

La `struct sigaction` permet d'attacher une méthode de traitement pour le
signal que l'on souhaite capturer

```c
struct sigaction {
    void (*sa_handler)(int);
    void (*sa_sigaction)(int, siginfo_t*, void*);
    sigset_t sa_mask;
    int sa_flags;
    void (*sa_restorer)(void); /* obsolete: do not use */
};
```

- Cette structure permet de choisir entre deux signatures pour la méthode de
  traitement, soit `sa_handler`, soit `sa_sigaction`. Si l'on souhaite traiter le
  signal avec la méthode `sa_sigaction`, il est nécessaire d'ajouter le fanion
  `SA_SIGINFO` dans `sa_flags`.
- Si l'on souhaite ignorer le signal, on pourra associer `SIG_IGN` à `sa_handler`. Si
  l'on souhaite le comportement par défaut on assignera `SIG_DFL` à `sa_handler`.
- `sa_mask` permet de bloquer certains signaux lors du traitement par le _handler_.
- `sa_flags` permet de modifier le comportement du signal. Pour plus de détails
  voir la [man page](https://man7.org/linux/man-pages/man2/sigaction.2.html).

La méthode de traitement `catch_signal` prend la forme suivante :

```c
void catch_signal (int signo) {
    /* do something... */
    /* to terminate process execution with
    * 1) success: exit(EXIT_SUCCESS);
    * 2) failure: exit(EXIT_FAILURE);
    */
}
```

Une fois le signal traité à l'aide de la méthode `catch_signal()`, le processus
poursuivra son exécution. Par contre, si l'on souhaite terminer l'exécution du
processus ayant capturé le signal, il suffit d'utiliser l'appel système `exit()`.

## Lever un signal

Pour lever un signal, Linux propose l'appel système `kill()` pour envoyer un
signal à un processus ou à un groupe de processus.

```c
#include <sys/types.h>
#include <signal.h>
int kill (pid_t pid, int sig);
```

**Exemple**

```c
int err = kill (0, SIGHUP);
if (err == -1)
    /* error */
```

**Comportement**

- Si `pid` est une valeur positive plus grande que `0` (zéro), la fonction `kill()` permet
  de lever le signal `sig` sur le processus `pid`, pour autant qu'il est les droits.
- Si `pid` vaut `0` (zéro), alors `kill()` émet le signal `sig` à tous les processus du
  groupe du processus levant le signal.
- Si `pid` est égal à `-1`, `kill()` lèvera le signal `sig` pour tous les processus dont il a
  la permission d'envoyer un signal.
- Si pid est plus petit que `-1`, la fonction `kill()` envoie le signal sig à tous les
  processus du groupe identifié par `-pid`.

## Attendre sur un signal

Pour t'attendre qu'un signal soit levé ou que le processus se termine, Linux
propose l'appel système `pause()`.

```c
#include <unistd.h>
int pause();
```
**Exemple**

```c
while (1)
    pause();
```

**Comportement**

- La fonction `pause()` met en sommeil le processus jusqu'à qu'un signal soit levé
  et capturé ou que le processus se termine.

## Précaution et rappel

Sous Linux, il est très courant que des méthodes faisant des appels système
soient interrompues par la levée de signaux.

Pour éviter un mauvais comportement de l'application, il est important de bien
contrôler la valeur de la variable `errno` et de la tester contre l'erreur `EINTR`.

Si l'erreur `EINTR` est signalée, il faut simplement répéter l'appel.

Il est judicieux de toujours bien vérifier (par exemple par la [man-page](https://man7.org/linux/man-pages/man2/nanosleep.2.html)) si un appel
système dépend d'un signal.

**Exemple**

```c
/**
 * reliable implementation of a sleep against raising of the EINTR signal.
 * this method will sleep at least the specified value.
 * @param ns sleep time in nanoseconds
 */

void safe_sleep(int ns) {
    struct timespec sleep_time = {.tv_nsec = ns,};
    struct timespec remaining  = {.tv_nsec=0,};
    
    while(true) {
        int status = nanosleep (&sleep_time, &remaining);
        if(status == 0) break;
        if (errno == EINTR) {
            sleep_time = remaining;
        } else {
            perror ("nanosleep");
            exit(status);
        }
    }
}
```
