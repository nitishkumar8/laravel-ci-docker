# Base PHP image
FROM php:8.2-cli

# Install required system packages
RUN apt-get update \
    && apt-get install -y \
       git \
       unzip \
       libzip-dev \
    && docker-php-ext-install zip pdo \
    && rm -rf /var/lib/apt/lists/*

# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www

# Copy application source
COPY . .

# Install PHP dependencies (production)
RUN composer install --no-dev --no-interaction --prefer-dist

# Expose Laravel port
EXPOSE 8000

# Start Laravel application
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]
