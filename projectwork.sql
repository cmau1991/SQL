-- SQL and Data Project - Code First Girls

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

-- Database: `library`
--
CREATE DATABASE IF NOT EXISTS `library` 
DEFAULT CHARACTER 
SET latin1 
COLLATE latin1_swedish_ci;
USE `library`;

CREATE TABLE IF NOT EXISTS `book` (
  `book_id` int(11) NOT NULL,
  `title` varchar(1000) NOT NULL,
  `author` varchar(1000) NOT NULL,
  `description` text NOT NULL,
  `category_id` int(5) NOT NULL,
  `added_by` int(11) NOT NULL,
  `added_at_timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `book_category` (
  `id` int(5) NOT NULL,
  `category` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `book_issue` (
  `issue_id` int(11) NOT NULL,
  `book_id` int(11) NOT NULL,
  `available_status` tinyint(1) NOT NULL DEFAULT '1',
  `added_by` int(11) NOT NULL,
  `added_at_timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `book_issue_log` (
  `id` int(16) NOT NULL,
  `book_issue_id` int(11) NOT NULL,
  `student_id` int(11) NOT NULL,
  `issue_by` int(11) NOT NULL,
  `issued_at` varchar(50) NOT NULL,
  `return_time` varchar(50) NOT NULL,
  `time_stamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `branches` (
  `id` int(5) NOT NULL,
  `branch` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `students` (
  `student_id` int(11) NOT NULL,
  `first_name` varchar(512) NOT NULL,
  `last_name` varchar(512) NOT NULL,
  `approved` int(1) NOT NULL DEFAULT '0',
  `rejected` int(1) NOT NULL DEFAULT '0',
  `category` int(1) NOT NULL,
  `roll_num` varchar(15) NOT NULL,
  `branch` int(1) NOT NULL DEFAULT '0',
  `year` int(5) NOT NULL,
  `books_issued` int(1) NOT NULL DEFAULT '0',
  `email_id` varchar(512) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `student_category` (
  `cat_id` int(2) NOT NULL,
  `category` varchar(512) NOT NULL,
  `max_allowed` int(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `users` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `username` varchar(512) NOT NULL,
  `password` varchar(255) NOT NULL,
  `verification_status` tinyint(1) NOT NULL DEFAULT '0',
  `remember_token` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Primary Key addition
ALTER TABLE `books`
  ADD PRIMARY KEY (`book_id`);

ALTER TABLE `book_categories`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `book_issue`
  ADD PRIMARY KEY (`issue_id`);

ALTER TABLE `book_issue_log`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `branches`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `students`
  ADD PRIMARY KEY (`student_id`);

ALTER TABLE `student_categories`
  ADD PRIMARY KEY (`cat_id`);

ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

-- AUTO_INCREMENT
ALTER TABLE `books`
  MODIFY `book_id` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE `book_categories`
  MODIFY `id` int(5) NOT NULL AUTO_INCREMENT;

ALTER TABLE `book_issue`
  MODIFY `issue_id` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE `book_issue_log`
  MODIFY `id` int(16) NOT NULL AUTO_INCREMENT;

ALTER TABLE `branches`
  MODIFY `id` int(5) NOT NULL AUTO_INCREMENT;

ALTER TABLE `students`
  MODIFY `student_id` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE `student_categories`
  MODIFY `cat_id` int(2) NOT NULL AUTO_INCREMENT;

ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
