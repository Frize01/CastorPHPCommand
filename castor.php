<?php

use Castor\Attribute\AsTask;
use function Castor\run;
use function Castor\io;
use function Castor\context;

#[AsTask(description: 'Met à jour et nettoie Debian, Flatpak et Snap', default:true)]
function updateSystem(): void
{
    // On définit le contexte avec PTY pour gérer sudo correctement
    $c = context()->withPty();

    io()->title('🔄 Lancement de la maintenance globale du système');
    
    io()->section('1/5 - Recherche des mises à jour Debian (APT)...');
    run('sudo apt update', context: $c);
    
    io()->section('2/5 - Installation des mises à jour Debian...');
    run('sudo apt upgrade -y', context: $c);

    io()->section('3/5 - Nettoyage des paquets système inutiles...');
    run('sudo apt autoremove -y && sudo apt clean', context: $c);
    
    io()->section('4/5 - Mise à jour des paquets Snap...');
    run('sudo snap refresh', context: $c);

    io()->section('5/5 - Mise à jour et nettoyage des applications Flatpak...');
    run('flatpak update -y', context: $c);
    run('flatpak uninstall --unused -y', context: $c);
    
    io()->success('✅ Terminé ! Debian, Snap et Flatpak sont à jour.');
}

#[AsTask(description: 'Start the project')]
function start(): void
{
    io()->writeln("Bienvenue dans <fg=yellow>Castor</> !");
}