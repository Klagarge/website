---
title: "Opérations bloquantes"
---

## Opérations d'entrées/sorties bloquantes

Quand une opération de lecture ou d'écriture doit attendre sur des données ou
sur la disponibilité du périphérique, le pilote doit bloquer le _thread_ jusqu'à ce
que les données soient disponibles. Ceci peut être réalisé en le mettant en
sommeil jusqu'à ce que la requête puisse être satisfaite à l'aide de _waitqueues_.

Déclaration de la _waitqueue_ ([`<linux/wait.h>`](https://elixir.bootlin.com/linux/v5.15.148/source/include/linux/wait.h),
[`<linux/sched.h>`](https://elixir.bootlin.com/linux/v5.15.148/source/include/linux/sched.h)) et d'un
fanion de signalisation

```c
wait_queue_head_t my_queue;
int request_can_be_processed = 0;
```

Initialisation de la _waitqueue_ avec la macro [`init_waitqueue_head`](https://elixir.bootlin.com/linux/v5.15.148/source/include/linux/wait.h#L66)

```c
init_waitqueue_head (&my_queue);
```

Attendre jusqu'à ce que l'opération puisse être satisfaite (_read/write_) avec la macro
[`wait_event_interruptible`](https://elixir.bootlin.com/linux/v5.15.148/source/include/linux/wait.h#L496)

```c
wait_event_interruptible(&my_queue, request_can_be_processed != 0);
```

Lorsque les ressources sont disponibles, le pilote peut réveiller le _thread_ et lui
signaler que la requête peut finalement être traitée avec la macro
[`wake_up_interruptible`](https://elixir.bootlin.com/linux/v5.15.148/source/include/linux/wait.h#L228)

```c
request_can_be_processed = 1;
wake_up_interruptible(&my_queue);
```

L'application en espace utilisateur sera notifiée s'il utilise un des appels
système pour la scrutation (
[`select`](https://man7.org/linux/man-pages/man2/select.2.html),
[`poll`](https://man7.org/linux/man-pages/man2/poll.2.html) ou
[`epoll`](https://man7.org/linux/man-pages/man7/epoll.7.html)). Ces opérations
utilisent l'opération `poll` du pilote de périphérique dont les services sont
disponibles dans l'interface
[`<linux/poll.h>`](https://elixir.bootlin.com/linux/v5.15.148/source/include/linux/poll.h).

Cette méthode permet de multiplexer l'attente sur plusieurs ressources : le thread se bloque une seule fois dans `epoll_wait` au lieu de se bloquer individuellement sur chaque appel `read`/`write`.

```c
static unsigned int skeleton_poll (struct file *f,
                                   poll_table *wait) {
    unsigned mask = 0;
    poll_wait (f, &my_queue, wait);
    if (request_can_be_processed != 0) {
        mask |= POLLIN | POLLRDNORM; // read operation
        // mask |= POLLOUT | POLLWRNORM; // write operation
    }
    return mask;
}
```