-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 27 Jul 2025 pada 03.11
-- Versi server: 10.4.32-MariaDB
-- Versi PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `open-course_db`
--

-- --------------------------------------------------------

--
-- Struktur dari tabel `komentar`
--

CREATE TABLE `komentar` (
  `id` int(11) NOT NULL,
  `materi_id` int(11) DEFAULT NULL,
  `content` text DEFAULT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `komentar`
--

INSERT INTO `komentar` (`id`, `materi_id`, `content`, `parent_id`, `created_at`) VALUES
(1, 1, 'nice', NULL, '2025-07-25 07:25:44'),
(9, 0, 'bagus', 2, '2025-07-26 13:34:20'),
(10, 2, 'bagus\r\n', NULL, '2025-07-26 13:37:44'),
(11, 0, 'iya', 10, '2025-07-26 13:37:49'),
(12, 0, 'iya', 10, '2025-07-26 13:38:16'),
(13, 2, 'iya', 10, '2025-07-26 13:43:58'),
(14, 2, 'bagus', NULL, '2025-07-26 13:53:48'),
(15, 2, 'bagus', NULL, '2025-07-26 13:53:53'),
(16, 2, 'bagus', NULL, '2025-07-26 13:55:07'),
(17, 1, 'iya', 1, '2025-07-26 14:01:07');

-- --------------------------------------------------------

--
-- Struktur dari tabel `materi`
--

CREATE TABLE `materi` (
  `id` int(11) NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `type` varchar(50) DEFAULT NULL,
  `file_path` varchar(255) DEFAULT NULL,
  `thumbnail` varchar(255) DEFAULT NULL,
  `status` enum('pending','approved') DEFAULT 'pending',
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `materi`
--

INSERT INTO `materi` (`id`, `title`, `description`, `type`, `file_path`, `thumbnail`, `status`, `created_at`) VALUES
(1, 'Python FUll Course For Beginner', 'Master Python from scratch 🚀 No fluff—just clear, practical coding skills to kickstart your journey! ', 'video', 'https://www.youtube.com/embed/K5KVEU3aaeQ?si=Nb6Sh2aig2qbyO2r', 'https://storage.googleapis.com/workspace-0f70711f-8b4e-4d94-86f1-2a93ccde5887/image/95b1026d-d7d4-499e-89d4-46e888c418f3.png', 'approved', '2025-07-25 00:33:50'),
(2, 'Data Science Full Course 2025 (FREE) | Intellipaat', NULL, 'video', 'https://www.youtube.com/embed/ppYbY-LbqiI?si=EVWlmnZUknDauqr2', 'https://storage.googleapis.com/workspace-0f70711f-8b4e-4d94-86f1-2a93ccde5887/image/0f63a199-6512-48f8-94a2-a5a639990e60.png', 'approved', '2025-07-25 01:07:00'),
(3, 'Javascript Full Course', 'Belajar Javasvript ', NULL, 'https://www.youtube.com/embed/lfmg-EJ8gm4?si=gYAhaJGw4uvrJu9k', NULL, 'approved', '2025-07-26 15:15:32'),
(4, 'CSS Full Course', 'Belajar CSS', NULL, 'https://www.youtube.com/embed/HGTJBPNC-Gw?si=I7Tn_M6mwV1CD1dQ', NULL, 'approved', '2025-07-26 16:56:22');

-- --------------------------------------------------------

--
-- Struktur dari tabel `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `password` text DEFAULT NULL,
  `role` enum('user','admin') DEFAULT 'user'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `password`, `role`) VALUES
(8, 'Agus Satrio', 'satrio@gmail.com', '$2b$10$0sSoV0Rh0rbTIMWVMSHZ2u5FMyYiCciloDWIIB/221NM9HpOz4qUO', 'user'),
(9, 'ahmad', 'ahmad@gmail.com', '$2b$10$nq6ZrEhI0vsA4sMntnplyeS2QWsHsbTwjhiSPFZ2s1qX0AXNzmCJq', 'user'),
(10, 'Asep', 'asep@gmail.com', '$2b$10$C8.ObpUIhQL8./JV56W9FOhrRinZo4oCiXRRunWoeT2gdjSLZSo7u', 'user'),
(11, 'naruto', 'naruto@gmail.com', '$2b$10$UIiJJmizo3brVOZP3oAh7OJQ/4gHVUt6Bsk32kzXfUkhlv2v2AwlC', 'user'),
(12, 'uzumaki', 'uzumaki@gmail.com', '$2b$10$Y75xz.N32ifjFfaB5IyyO.UDFJJ8vvc9.5sFEs5fr9ag5zkn/NcgO', 'admin'),
(13, 'aryo', 'aryo@gmail.com', '$2b$10$ogaooCBPGPb3xB6CF/ZdW.N1cniTK7h0OvKc/SiMW3WFpOFCCX5ZG', 'user');

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `komentar`
--
ALTER TABLE `komentar`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `materi`
--
ALTER TABLE `materi`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `komentar`
--
ALTER TABLE `komentar`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT untuk tabel `materi`
--
ALTER TABLE `materi`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT untuk tabel `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
