# Use an official PHP runtime as a parent image
FROM php:8.1-fpm

# Set the working directory
WORKDIR /var/www/html

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libzip-dev \
    libonig-dev \
    libpng-dev \
    && docker-php-ext-install pdo mbstring zip exif pcntl

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copy the existing application directory contents
COPY . /var/www/html

# Copy the existing application directory permissions
COPY --chown=www-data:www-data . /var/www/html

# Install PHP dependencies
RUN composer install --no-dev --optimize-autoloader

# Expose port 8000 and start the application
EXPOSE 8000
CMD php artisan serve --host=0.0.0.0 --port=8000

