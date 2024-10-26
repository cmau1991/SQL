# SQL
SQL and Data

**Library Management System**
An automated system to manage a public library. Admin panel for librarians to control and manage the system easily through an interactive interface.

NOTE: PHP 5.6, the PHP mcrypt extension, and MySQL are required for this project:

apt-get update
apt-get install php5.6 php5.6-mcrypt
git clone https://github.com/prabhakar267/library-management-system
cd library-management-system

[sudo] chmod -R 755 app/storage
composer install
Edit mysql.config.php.sample according to your MySQL configurations and save it in the same directory as mysql.config.php
php artisan migrate
php artisan serve

PHP Setup

Obtaining the mcrypt extension for PHP 7+ is not trivial and involves compiling your own PHP build. If your PHP version does not support mcrypt (i.e. if you have PHP 7+), then the easiest way to run Laravel 4.2 applications is to download a compatible version of XAMPP and make sure the app is run with it.

With the above notes in mind, Windows setup is not too tricky:

Open git shell;
cd C:/path/to/xampp/htdocs;
git clone https://github.com/prabhakar267/library-management-system;
cd library-management-system;
composer update;

NOTE: If your PHP version is not compatible with mcrypt you will receive an error here. Do not worry, simply perform these additional two steps:

C:/path/to/xampp5.6.33/php/php.exe artisan clear-compiled
C:/path/to/xampp5.6.33/php/php.exe artisan cache:clear
Create a table for the app via phpmyadmin (or however you prefer);
Edit app/config/mysql.config.php.sample according to your MySQL configurations and save it in the same directory as mysql.config.php;
php artisan migrate

**Features**
Librarians can be given their authorized login ID and password without which the system can not be accessed.
Students can only access limited features, i.e., public access level features which include searching a book and student registration form.
After logging in librarians can search for a specific book, book issue or student from the home panel.
Librarians need to make an entry for new books. To automate the process they simply need to enter the number of issues, then the Issue ID for each book issue is generated automatically.
Another responsibility of a librarian is to approve students in situations where approval is needed, i.e. where documents are to be verified or some manual work. Librarians have a panel to simply approve / reject students and to view all approved students. The librarian ID is stored alongside each approved/rejected student to keep track.
The most important function of any library is to issue and return books. This system includes a panel to view all outstanding logs and a super simple panel to issue and return books for all librarians.
