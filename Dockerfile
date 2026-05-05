FROM php:8.5-cli

# 1. Installation des outils de base
RUN apt-get update && apt-get install -y git unzip curl wget && rm -rf /var/lib/apt/lists/*

# 2. On installe Box (la machine-outil pour compiler le binaire)
RUN curl -o /usr/local/bin/box -LSs https://github.com/box-project/box/releases/latest/download/box.phar && \
    chmod +x /usr/local/bin/box

# 3. On autorise PHP à fabriquer des archives (requis par Box)
RUN echo "phar.readonly = 0" > /usr/local/etc/php/conf.d/box.ini

# 4. On importe Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# 5. Configuration de l'usine
WORKDIR /app

# 6. Le script de production explicite
CMD echo "📦 Installation de Castor..." && \
    composer require jolicode/castor && \
    echo "🚀 Création du binaire natif autonome (Injection du moteur statique)..." && \
    ./vendor/bin/castor repack --os linux --arch amd64 && \
    echo "🏷️ Nettoyage du nom et de l'extension..." && \
    mv *linux*.phar update-system 2>/dev/null || mv *linux* update-system && \
    echo "🧹 Nettoyage des déchets de l'usine..." && \
    rm -rf vendor composer.json composer.lock box.json && \
    echo "✅ Terminé ! Ton vrai binaire 'update-system' est prêt."