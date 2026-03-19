---
title: "Introduction"
---
## Bienvenue

- Module : MA-CSEL1
- Titre : MA-CSEL1 - Construction de Systèmes Embarqués sous Linux
- Intervenant
    - Jacques Supcik (HEIA-FR / ISC)<br/><jacques.supcik@hefr.ch>
- {{ info.students_count }} étudiants inscrits
    {%- if info.students_cs  > 0 %}
    - {{ info.students_cs }} étudiant{% if info.students_cs  > 1 %}s{% endif %} CS
    {%- endif %}
    {%- if info.students_ds  > 0 %}
    - {{ info.students_ds }} étudiant{% if info.students_ds  > 1 %}s{% endif %} DS
    {%- endif %}
    {%- if info.students_ics  > 0 %}
    - {{ info.students_ics }} étudiant{% if info.students_ics  > 1 %}s{% endif %} ICS
    {%- endif %}
    {%- if info.students_eie  > 0 %}
    - {{ info.students_eie }} étudiant{% if info.students_eie  > 1 %}s{% endif %} EIE
    {%- endif %}
    {%- if info.students_enen  > 0 %}
    - {{ info.students_enen }} étudiant{% if info.students_enen  > 1 %}s{% endif %} EnEn
    {%- endif %}
    {%- if info.students_ft  > 0 %}
    - {{ info.students_ft }} étudiant{% if info.students_ft  > 1 %}s{% endif %} plein temps
    {%- endif %}
    {%- if info.students_pt  > 0 %}
    - {{ info.students_pt }} étudiant{% if info.students_pt  > 1 %}s{% endif %} temps partiel
    {%- endif %}
    
## Groupe Microsoft Teams

{%- if teams_code %}
<div style="font-size: 1.4em; border: solid; padding: 0.5em">
code pour rejoindre l'équipe : <b>{{ teams_code }}</b>
</div>
{%- elif teams_name and teams_url %}
[{{ teams_name }}]({{ teams_url }})
{%- else %}
**A DÉFINIR**
{%- endif %}

## Programme des cours

{%- if horaire == "1300" %}
- Horaire : 13:00 - 15:25 (avec deux pauses de 5 minutes)
    - 13:00 - 13:45 : Cours
    - 13:45 - 13:50 : Pause
    - 13h50 - 14:35 : Cours / TP
    - 14:35 - 14:40 : Pause
    - 14:40 - 15:25 : Cours / TP
{%- else %}
- Horaire : 14:35 - 17:00 (avec deux pauses de 5 minutes)
    - 14:35 - 15:20 : Cours
    - 15:20 - 15:25 : Pause
    - 15:25 - 16:10 : Cours / TP
    - 16:10 - 16:15 : Pause
    - 16:15 - 17:00 : Cours / TP
{%- endif %}
- Salle de classe : HEIA-FR / C00.16

{% set week_no = 8 %}
{% set i = 0 %}

| Semaine                          | Date                    | Thème                                               |
|:---------------------------------|:------------------------|:----------------------------------------------------|
| {{ week_no + i }}/SP-{{ i+1 }}  | {{ cal.start | ld(i) }} | Environnement Linux embarqué 1 (sur site à Fribourg) | {% set i = i + 1 %}
| {{ week_no + i }}/SP-{{ i+1 }}  | {{ cal.start | ld(i) }} | Environnement Linux embarqué 2 (Teams)               | {% set i = i + 1 %}
| {{ week_no + i }}/SP-{{ i+1 }}  | {{ cal.start | ld(i) }} | Programmation noyau Linux 1    (sur site à Fribourg) | {% set i = i + 1 %}
| {{ week_no + i }}/SP-{{ i+1 }}  | {{ cal.start | ld(i) }} | Programmation noyau Linux 2    (Teams)               | {% set i = i + 1 %}
| {{ week_no + i }}/SP-{{ i+1 }}  | {{ cal.start | ld(i) }} | Programmation noyau Linux 3    (sur site à Fribourg) | {% set i = i + 1 %}
| {{ week_no + i }}/SP-{{ i+1 }}  | {{ cal.start | ld(i) }} | Programmation noyau Linux 4    (Teams)               | {% set i = i + 1 %}
| {{ week_no + i }}/SP-{{ i+1 }}  | {{ cal.start | ld(i) }} | **Vendredi Saint**                                   | {% set i = i + 1 %}
| {{ week_no + i }}               |                         | **Pâques**                                           | {% set i = i + 1 %}
| {{ week_no + i }}/SP-{{ i }}    | {{ cal.start | ld(i) }} | Programmation système Linux 1  (sur site à Fribourg) | {% set i = i + 1 %}
| {{ week_no + i }}/SP-{{ i }}    | {{ cal.start | ld(i) }} | Programmation système Linux 2  (Teams)               | {% set i = i + 1 %}
| {{ week_no + i }}/SP-{{ i }}    | {{ cal.start | ld(i) }} | Programmation système Linux 3  (sur site à Fribourg) | {% set i = i + 1 %}
| {{ week_no + i }}/SP-{{ i }}    | {{ cal.start | ld(i) }} | Programmation système Linux 4  (Teams)               | {% set i = i + 1 %}
| {{ week_no + i }}/SP-{{ i }}    | {{ cal.start | ld(i) }} | **Pont de l'Ascension**                              | {% set i = i + 1 %}
| {{ week_no + i }}/SP-{{ i }}    | {{ cal.start | ld(i) }} | Optimisation système Linux     (sur site à Fribourg) | {% set i = i + 1 %}
| {{ week_no + i }}/SP-{{ i }}    | {{ cal.start | ld(i) }} | Mini projet intégré 1          (Teams)               | {% set i = i + 1 %}
| {{ week_no + i  }}              | {{ cal.start | ld(i) }}[^1] | Mini projet intégré 2      (Teams)               | {% set i = i + 1 %}

[^1]: Ce jours est réservé pour finaliser le mini projet intégré. Il n'y a pas de cours en présentiel ce jour-là.

[Calendrier MSE {{ year }}](assets/MSE_CalendrierAcademique_2025-2026_vf.pdf)

## Déroulement des cours

### Déroulement

- Travail personnel de préparation avant le cours
- Cours combiné: théorie et travail pratique
- Travail personnel après le cours
- Rédaction d'un rapport

### Participation et collaboration

- Ne pas hésiter à participer et rendre le cours plus interactif et plus intéressant
- Ne pas hésiter à poser des questions
- Ne pas hésiter à partager vos propres expériences
- Ne pas hésiter à aider vos collègues
- Ne pas hésiter à expliquer ce que vous avez compris à vos collègues
- Ne pas hésiter à notifier des bugs au(x) professeur(s)
- Ne pas hésiter à regarder des solutions sur Internet

## Objectifs du module

Au terme de ce module, les étudiant-e-s seront capable de :

- Choisir l'architecture (HW et SW) pour des systèmes embarqués pour Linux
- Mettre en place un environnement de développement pour Linux
- Choisir et configurer un boot-loader pour une cible donnée
- Choisir et configurer un système de fichiers pour Linux
- Choisir et configurer une distribution Linux pour une cible donnée
- Concevoir et développer des device drivers complexes sous Linux embarqué
- Concevoir et développer des applications sous Linux embarqué

## Contenu du module

### Environnement Linux embarqué

- Architecture générale de systèmes embarqués pour Linux
- Environnements de développement
- Outils de développement
- Création, génération et débogage d'applications
- Survol des boot-loaders
- Survol et configuration des systèmes de fichiers
- Survol des distributions Linux embarqué

### Programmation noyaux Linux

- Programmation de modules noyau
- Développement et débogage d'un module noyaux
- Types de pilotes de périphériques
- Développement et débogage d'un pilote de périphériques
- Traitement des interruptions 
- Paramétrage et configuration d'un pilotes de périphériques

### Programmation système Linux

- Interface noyaux (system calls et bibliothèques)
- File I/O
- Gestion des processus et threads
- Communication inter processus (IPC, signaux, ...)
- Mémoire virtuelle et accès aux périphériques par UIO
- Unix domain sockets
- IPC system V
- Caractéristiques de l'ordonnanceur
- Mesure de performance (profiling)
- Aspects temps-réel (processus/thread)

### Mini-projet

- Mise en œuvre des concepts étudiés durant les 6 premières semaines

## Rapport de laboratoire

### Rapport

- Rapports de laboratoire par groupe de 2 étudiants, à rendre
    - {{  cal.start | add_week(6) | dow(3) | euro_day }} : Environnement Linux embarqué et programmation noyau Linux 
    - {{  cal.start | add_week(14) | dow(3) | euro_day }} : Programmation système Linux et optimisation système Linux
    - {{  cal.start | add_week(15) | dow(5) | euro_day }} : Mini projet intégré
- Format : fichier PDF à déposer dans l'_assignment_ de Teams. Le nom du fichier doit être : <br/>
  `CSEL1-<groupe>-<sujet>.pdf`
- Langue : français, allemand ou anglais

### Contenu (indicatif)

- En-tête
    - logos
    - établissement
    - titre
    - auteur
    - **lien vers un dépôt git** (github, gitlab, bitbucket, ...)
    - lieu
    - date
    - version
- Entre 1 et 4 pages par thème (comme on traite un thème sur 2 semaines, ça fait entre 1 et 2 pages par semaine)
    - Résumé du laboratoire
    - Réponse aux questions
    - Synthèse sur ce qui a été appris/exercé
        - Non acquis
        - Acquis, mais à exercer
        - Parfaitement acquis
    - Remarques et choses à retenir
    - Feedback personnel sur le laboratoire
- Annexes (références/littérature, code source/patches dans fichier tar)

## Evaluation

### Examen théorique

- Sous forme d'examen oral
    - Deux thèmes tirés au sort
    - 20' de préparation (un résumé de 5 feuilles A4 recto-verso autorisé)
    - 20' de présentation au rétroprojecteur sur transparents avec questions des professeurs (le résumé n'est plus autorisé)
- Experts: le professeur du module + un professeur du domaine

### Note finale du cours

- Examen théorique oral 65%
- Les rapports de laboratoire 35%

## Littérature

![Embedded Linux Primer, Second Edition](assets/embedded_linux_primer.jpg){align=right width="200" class="shadow"}
### Embedded Linux Primer, Second Edition
_A Practical Real-World Approach_<br/>
By Christopher Hallinan<br/>
November, 2010, 656 pages<br/>
ISBN-10: 0137017839 | ISBN-13: 978-0137017836

<div style="clear: both"/>

![Image title](assets/linux_kernel_development.jpg){align=right width="200" class="shadow"}
### Linux Kernel Development
_A thorough guide to the design and implementation of the Linux kernel_<br/>
By Robert Love<br/>
July, 2010, 440 pages<br/>
ISBN-10: 0672329468 | ISBN-13: 978-0672329463

<div markdown style="clear: both"/>

![Image title](assets/essential_linux_device_drivers.jpg){align=right width="200" class="shadow"}
### Essentials Linux Device Drivers
_Probably the most wide ranging and complete Linux device driver book..._<br/>
By Sreekrishnan Venkateswaran<br/>
April, 2008, 744 pages<br/>
ISBN-10: 0132396556 | ISBN-13: 978-0132396554

<div style="clear: both"/>

![Image title](assets/writing_linux_device_drivers.jpeg){align=right width="200" class="shadow"}
### Writing Linux Device Drivers
A guide with exercices<br/>
By Jerry Cooperstein<br/>
September, 2009, 394 pages<br/>
ISBN-10: 1448672384 | ISBN-13: 978-1448672387

<div style="clear: both"/>

![Image title](assets/the_linux_programming_interface.jpeg){align=right width="200" class="shadow"}
### The Linux Programming Interface
A Linux and UNIX System Programming Handbook<br/>
By Michael Kerrisk<br/>
October, 2010, 1552 pages<br/>
ISBN-10: 1593272200 | ISBN-13: 978-1593272203

<div style="clear: both"/>

![Image title](assets/building_embedded_linux_systems.jpg){align=right width="200" class="shadow"}
### Building Embedded Linux Systems, Second Edition
Concepts, techniques, tricks, and traps<br/>
By Philippe Gerum, Karim Yaghmour, Jon Masters, Gilad Ben-Yossef<br/>
August 2008, 462 pages<br/>
ISBN 10: 0-596-52968-6 | ISBN 13: 9780596529680

<div style="clear: both"/>

![Image title](assets/linux_device_drivers.jpeg){align=right width="200" class="shadow"}
### Linux Device Drivers, Third Edition 
By Jonathan Corbet, Alessandro Rubini, Greg Kroah-Hartman<br/>
February 2005, 636 pages<br/>
ISBN 10: 0-596-00590-3 | ISBN 13: 9780596005900<br/>
http://lwn.net/Kernel/LDD3/ (as PDF)

<div style="clear: both"/>

![Image title](assets/understanding_the_linux_kernel.jpeg){align=right width="200" class="shadow"}
### Understanding the Linux Kernel, Third Edition
By Daniel P. Bovet & Marco Cesati<br/>
November 2005, 944 pages<br/>
ISBN 10: 0-596-00565-2 0-596-00590-3 | ISBN 13: 978-0596005658<br/>

<div style="clear: both"/>

![Image title](assets/linux_system_programming.jpeg){align=right width="200" class="shadow"}
### Linux System Programming
Talking Directly to the Kernel and C Library<br/>
By Robert Love<br/>
September 2007, 388 pages<br/>
ISBN 10: 0-596-00958-5 | ISBN 13: 9780596009588

<div style="clear: both"/>

![Image title](assets/advanced_programming_in_the_unix_environment.jpeg){align=right width="200" class="shadow"}
### Advanced Programming in the UNIX Environment 
By W. R. Stevens, Stephen A. Rago<br/>
January 1992, 768 pages<br/>
ISBN-10: 0201563177  | ISBN-13: 978-0201563177

<div style="clear: both"/>

![Image title](assets/linux_for_embedded_and_real-time_applications.jpeg){align=right width="200" class="shadow"}
### Linux for Embedded and Real-time Applications
By Doug Abboot<br/>
March, 2003, 254 pages<br/>
ISBN-10: 0750675462  | ISBN-13: 978-0750675468

<div style="clear: both"/>

![Image title](assets/practical_linux_programming.jpg){align=right width="200" class="shadow"}
### Practical Linux Programming
Device Drivers, Embedded Systems, and the Internet<br/>
By Ashfaq A. Khan<br/>
February, 2002, 420 pages<br/>
ISBN-10: 1584500964 | ISBN-13: 978-1584500964

<div style="clear: both"/>

![Image title](assets/embedded_linux.jpg){align=right width="200" class="shadow"}
### Embedded Linux
Hardware, Software, and Interfacing<br/>
By Craig Hollabaugh<br/>
March 2002, 432 pages<br/>
ISBN-10: 0672322269 | ISBN-13: 978-0672322266

<div style="clear: both"/>

## Liens utiles

### Noyau Linux

- [Linux documentation](http://www.tldp.org)
- [Linux weekly news](http://lwn.net)
- [Linux kernel mailing list (FAQ)](http://www.tux.org/lkml/)
- [Kernel Newbies (glossaire, articles, présentations, ...)](http://kernelnewbies.org)

### Projet ARM

- [ARM Linux project](http://www.arm.linux.org.uk)

### Consultants et fabricants 
- [Denx software Engineering (U-Boot / ELDK)](http://www.denx.de)
- [bootlin (Experts Linux embarqué)](http://bootlin.com)
