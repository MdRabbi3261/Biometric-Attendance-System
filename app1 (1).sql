-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Feb 06, 2025 at 09:22 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `app1`
--

-- --------------------------------------------------------

--
-- Table structure for table `admin`
--

CREATE TABLE `admin` (
  `id` int(11) NOT NULL,
  `admin_name` varchar(30) NOT NULL,
  `admin_email` varchar(80) NOT NULL,
  `admin_pwd` longtext NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `admin`
--

INSERT INTO `admin` (`id`, `admin_name`, `admin_email`, `admin_pwd`) VALUES
(1, 'Admin', 'admin@gmail.com', '$2y$10$89uX3LBy4mlU/DcBveQ1l.32nSianDP/E1MfUh.Z.6B4Z0ql3y7PK');

-- --------------------------------------------------------

--
-- Table structure for table `chairman`
--

CREATE TABLE `chairman` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(255) NOT NULL,
  `mobile_number` varchar(15) NOT NULL,
  `user_type` varchar(50) NOT NULL,
  `department` varchar(255) NOT NULL,
  `designation` varchar(255) NOT NULL,
  `father_name` varchar(255) NOT NULL,
  `mother_name` varchar(255) NOT NULL,
  `present_address` text NOT NULL,
  `permanent_address` text NOT NULL,
  `dob` date DEFAULT NULL,
  `photo` varchar(255) DEFAULT NULL,
  `password` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `chairman`
--

INSERT INTO `chairman` (`id`, `name`, `email`, `mobile_number`, `user_type`, `department`, `designation`, `father_name`, `mother_name`, `present_address`, `permanent_address`, `dob`, `photo`, `password`) VALUES
(1, 'galib', '11.cse@student.just.edu.bd', '01561234567', 'chairman', 'Computer Science', 'Chairman', '', '', '', '', NULL, NULL, '$5$rounds=535000$PnZrneuko9xWjIOa$NakR3qPDyxdeOdtcTStU2cgF.ju.NHsbGUWUiitcOT7');

-- --------------------------------------------------------

--
-- Table structure for table `classes`
--

CREATE TABLE `classes` (
  `id` int(11) NOT NULL,
  `session` varchar(20) NOT NULL,
  `semester` varchar(10) NOT NULL,
  `course_code` varchar(10) NOT NULL,
  `class_date` date NOT NULL,
  `start_time` time NOT NULL,
  `end_time` time NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `course`
--

CREATE TABLE `course` (
  `id` int(11) NOT NULL,
  `semester` varchar(10) NOT NULL,
  `course_code` varchar(20) NOT NULL,
  `course_name` varchar(100) NOT NULL,
  `department` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `course`
--

INSERT INTO `course` (`id`, `semester`, `course_code`, `course_name`, `department`) VALUES
(1, '1-1', 'CSE 1001', 'COMPUTER', NULL),
(2, '1-1', 'CSE 1002', 'MATH', NULL),
(3, '1-2', 'CSE 1201', 'MATH', NULL),
(4, '2-1', 'CSE 2101', 'MATH', NULL),
(8, '2-2', 'CSE 2201', 'Data communication', NULL),
(9, '2-2', 'CSE 2203', 'Database Management System', NULL),
(10, '1-2', 'CSE 1105', 'Chemistry', NULL),
(11, '1-2', 'cse-1205', 'cse', 'Computer Science'),
(12, '2-2', 'CSE-2201', 'Data communication', 'CSE'),
(13, '2-2', 'CSE 2205', 'MATH', 'CSE'),
(14, '2-2', 'CSE 2206', 'PHYSICS', 'CSE'),
(17, '2-2', 'CSE 2208', 'SDP-1', 'CSE'),
(18, '2-2', 'EEE 2201', 'EEE', 'EEE');

-- --------------------------------------------------------

--
-- Table structure for table `course_feedback`
--

CREATE TABLE `course_feedback` (
  `id` int(11) NOT NULL,
  `roll_number` varchar(20) NOT NULL,
  `course_code` varchar(30) NOT NULL,
  `rating` int(11) NOT NULL CHECK (`rating` between 1 and 5),
  `comment` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `course_feedback`
--

INSERT INTO `course_feedback` (`id`, `roll_number`, `course_code`, `rating`, `comment`, `created_at`) VALUES
(1, '2', 'CSE 2201', 5, NULL, '2025-01-19 22:34:04');

-- --------------------------------------------------------

--
-- Table structure for table `devices`
--

CREATE TABLE `devices` (
  `id` int(11) NOT NULL,
  `device_name` varchar(50) NOT NULL,
  `device_dep` varchar(20) NOT NULL,
  `device_uid` text NOT NULL,
  `device_date` date NOT NULL,
  `device_mode` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `devices`
--

INSERT INTO `devices` (`id`, `device_name`, `device_dep`, `device_uid`, `device_date`, `device_mode`) VALUES
(3, 'test', 'CSE', '028ec80c', '2025-01-06', 1);

-- --------------------------------------------------------

--
-- Table structure for table `fingerprints`
--

CREATE TABLE `fingerprints` (
  `id` int(11) NOT NULL,
  `fingerprint_id` varchar(50) NOT NULL,
  `fingerprint_data` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `notices`
--

CREATE TABLE `notices` (
  `id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `content` text NOT NULL,
  `posted_by` varchar(100) NOT NULL,
  `date` date NOT NULL,
  `file_url` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `notices`
--

INSERT INTO `notices` (`id`, `title`, `content`, `posted_by`, `date`, `file_url`) VALUES
(8, 'শারীরিক শিক্ষা ও ক্রীড়া বিজ্ঞান বিভাগে স্নাতকোত্তর ভর্তি বিজ্ঞপ্তি-২০২৪ (শিক্ষাবর্ষ ২০২২-২০২৩)', 'circular,postgraduate,admission', 'Staff', '2025-01-02', '/static/uploads/-2024__2022-2023.pdf'),
(9, 'শীতকালীন অবকাশে শহীদ মসিয়ূর রহমান হল খোলা রাখা এবং হলের আবাসিক শিক্ষার্থীদের জন্য নির্দেশনা', 'circular', 'Staff', '2025-01-04', '/static/uploads/24.12.24._24.pdf'),
(10, 'Vacation', 'v', 'Staff', '2025-01-02', '/static/uploads/24.12.24._24.pdf');

-- --------------------------------------------------------

--
-- Table structure for table `pwd_reset`
--

CREATE TABLE `pwd_reset` (
  `pwd_reset_id` int(11) NOT NULL,
  `pwd_reset_email` varchar(50) NOT NULL,
  `pwd_reset_selector` text NOT NULL,
  `pwd_reset_token` longtext NOT NULL,
  `pwd_reset_expires` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `result`
--

CREATE TABLE `result` (
  `roll_number` varchar(50) NOT NULL,
  `course_code` varchar(20) NOT NULL,
  `exam_type` varchar(50) NOT NULL,
  `marks` decimal(5,2) NOT NULL,
  `session` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `result`
--

INSERT INTO `result` (`roll_number`, `course_code`, `exam_type`, `marks`, `session`) VALUES
('2', 'CSE 2201', 'CT-1', 10.00, NULL),
('210100', 'CSE 2201', 'CT-1', 5.00, NULL),
('210101', 'CSE 1001', 'ASSIGNMENT-2', 10.00, NULL),
('210101', 'CSE 1001', 'CT-1', 5.00, NULL),
('210101', 'CSE 1101', 'CT-1', 10.00, '1-1'),
('210101', 'CSE 1101', 'QUIZ-1', 5.00, NULL),
('210101', 'CSE 1102', 'CT-1', 5.00, NULL),
('210101', 'CSE101', 'CT-1', 9.00, NULL),
('210102', 'CSE 1001', 'ASSIGNMENT-2', 10.00, NULL),
('210102', 'CSE 1001', 'CT-1', 6.00, NULL),
('210102', 'CSE 1101', 'QUIZ-1', 4.00, '1-1'),
('210102', 'CSE 1102', 'CT-1', 8.00, NULL),
('210102', 'CSE101', 'CT-1', 9.00, NULL),
('210102', 'CSE101', 'CT-2', 3.00, NULL),
('210103', 'CSE 1001', 'ASSIGNMENT-2', 10.00, NULL),
('210103', 'CSE 1001', 'CT-1', 7.00, NULL),
('210103', 'CSE 1101', 'QUIZ-1', 5.00, NULL),
('210103', 'CSE 1102', 'CT-1', 6.00, NULL),
('210103', 'CSE101', 'CT-1', 5.00, NULL),
('210104', 'CSE 1001', 'ASSIGNMENT-2', 10.00, NULL),
('210104', 'CSE 1001', 'CT-1', 8.00, NULL),
('210104', 'CSE 1101', 'QUIZ-1', 5.00, NULL),
('210104', 'CSE 1102', 'CT-1', 4.00, NULL),
('210104', 'CSE101', 'CT-1', 3.00, NULL),
('210105', 'CSE 1001', 'ASSIGNMENT-2', 10.00, NULL),
('210105', 'CSE 1001', 'CT-1', 9.00, NULL),
('210106', 'CSE 1001', 'ASSIGNMENT-2', 10.00, NULL),
('210106', 'CSE 1001', 'CT-1', 10.00, NULL),
('210107', 'CSE 1001', 'ASSIGNMENT-2', 10.00, NULL),
('210107', 'CSE 1001', 'CT-1', 11.00, NULL),
('210108', 'CSE 1001', 'ASSIGNMENT-2', 10.00, NULL),
('210108', 'CSE 1001', 'CT-1', 12.00, NULL),
('210124', 'CSE 2201', 'CT-1', 9.00, NULL),
('21013', 'CSE 2201', 'CT-1', 8.00, NULL),
('210130', 'CSE 2201', 'CT-1', 5.00, NULL),
('210135', 'CSE 2201', 'CT-1', 7.00, NULL),
('210143', 'CSE 2201', 'CT-1', 6.00, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `staff`
--

CREATE TABLE `staff` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(255) NOT NULL,
  `mobile_number` varchar(15) NOT NULL,
  `user_type` varchar(50) NOT NULL,
  `department` varchar(255) NOT NULL,
  `designation` varchar(255) NOT NULL,
  `father_name` varchar(255) NOT NULL,
  `mother_name` varchar(255) NOT NULL,
  `present_address` text NOT NULL,
  `permanent_address` text NOT NULL,
  `dob` date DEFAULT NULL,
  `photo` varchar(255) DEFAULT NULL,
  `password` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `staff`
--

INSERT INTO `staff` (`id`, `name`, `email`, `mobile_number`, `user_type`, `department`, `designation`, `father_name`, `mother_name`, `present_address`, `permanent_address`, `dob`, `photo`, `password`) VALUES
(1, 'sammo', '10.cse@student.just.edu.bd', '01561234567', 'staff', 'Mechanical Engineering', 'Section Officer', '', '', '', '', NULL, NULL, '$5$rounds=535000$0zrWE5Bq4Sx16QWV$swTYw0oaAL2.0xHEmh5714L5RXg/m.o0MVRBOO3HMi9');

-- --------------------------------------------------------

--
-- Table structure for table `student`
--

CREATE TABLE `student` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `roll_number` varchar(50) NOT NULL,
  `semester` varchar(10) DEFAULT NULL,
  `session` varchar(20) NOT NULL,
  `email` varchar(255) NOT NULL,
  `mobile_number` varchar(15) NOT NULL,
  `user_type` varchar(50) NOT NULL,
  `department` varchar(255) NOT NULL,
  `reg_no` varchar(50) NOT NULL,
  `father_name` varchar(255) NOT NULL,
  `mother_name` varchar(255) NOT NULL,
  `present_address` text NOT NULL,
  `permanent_address` text NOT NULL,
  `dob` date DEFAULT NULL,
  `photo` varchar(255) DEFAULT NULL,
  `password` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `student`
--

INSERT INTO `student` (`id`, `name`, `roll_number`, `semester`, `session`, `email`, `mobile_number`, `user_type`, `department`, `reg_no`, `father_name`, `mother_name`, `present_address`, `permanent_address`, `dob`, `photo`, `password`) VALUES
(1, 'John Doe', '210101', '1-1', '2023-24', '', '', '', '', '', '', '', '', '', NULL, NULL, ''),
(2, 'Jane Smith', '210102', '1-1', '2023-24', '', '', '', '', '', '', '', '', '', NULL, NULL, ''),
(3, 'Alice Johnson', '210103', '1-1', '2023-24', '', '', '', '', '', '', '', '', '', NULL, NULL, ''),
(4, 'Bob Brown', '210104', '1-1', '2023-24', '', '', '', '', '', '', '', '', '', NULL, NULL, ''),
(5, 'Charlie Green', '210105', '1-1', '2023-24', '', '', '', '', '', '', '', '', '', NULL, NULL, ''),
(6, 'Diana White', '210106', '1-1', '2023-24', '', '', '', '', '', '', '', '', '', NULL, NULL, ''),
(7, 'Ethan Black', '210107', '1-1', '2023-24', '', '', '', '', '', '', '', '', '', NULL, NULL, ''),
(8, 'Fiona Blue', '210108', '1-1', '2023-24', '', '', '', '', '', '', '', '', '', NULL, NULL, ''),
(9, 'A', '1', '1-1', '2020-21', '1.cse@student.just.edu.bd', '01561234567', 'student', 'CSE', '55132', 'egfeqf', 'awfeqw4rf', 'eqfq3etf', 'qefqe3f', '2025-01-04', NULL, '$5$rounds=535000$vxfBLESlNfavAaTo$ICKUqvyULKCBf8fRqVRIM8NC4WgNIlX5ytx3lIxlok3'),
(10, 'Fahim Foysal', '210143', '2-2', '2021-22', '210143.cse@student.just.edu.bd', '01928541335', 'student', 'CSE', '2101', 'uihjip', 'ulinuin', 'uhok', 'uhjipunh', '2025-01-09', NULL, '$5$rounds=535000$6XfpuMvf1MzHjawx$VujXUD25Aq7NNTVuXaZsN.gucmvK7JMTHGMKNqP48t/'),
(11, 'Dipan sarder', '210130', '2-2', '2021-22', '210130.cse@student.just.edu.bd', '01300000000', 'student', 'CSE', '', '', '', '', '', NULL, NULL, '$5$rounds=535000$2cnwi9HGQGFwmg/V$PkK1RIL3CjCiqcFFKjE51or.OayPIgHZNleykSxN7QD'),
(12, 'Mehedi Hasan Sammo', '210124', '2-2', '2021-22', '210124.cse@student.just.edu.bd', '01561234567', 'student', 'CSE', '', '', '', '', '', NULL, NULL, '$5$rounds=535000$cKxCr.WakvHXTZGm$pIRVwORMpJyxAf/5l85VrwRdIvtHxaovW7psIPr6jU1'),
(13, 'Tanim Hasan', '210135', '2-2', '2021-22', '210135.cse@student.just.edu.bd', '01561234567', 'student', 'CSE', '', '', '', '', '', NULL, NULL, '$5$rounds=535000$iRrZHSKS1f2kQ0Oy$ECb7CVWcQboN5gDCgYFBFDqlo3ZqFGp6NAYaf.jKDx0'),
(14, 'sammo', '210100', '2-2', '2021-22', '210100.cse@student.just.edu.bd', '01561234567', 'student', 'CSE', '', '', '', '', '', NULL, NULL, '$5$rounds=535000$Qig2jpQ1kKr.C44f$pBk2yg4NO0pe0OczLcNyYIY4O9Tk6OXjRPlrjMNQTL0'),
(15, 'Dipan Sardar', '21013', '2-2', '2021-22', '21013.cse1@student.just.edu.bd', '01751682260', 'student', 'CSE', '', '', '', '', '', NULL, NULL, '$5$rounds=535000$2QZX1Tpl0e.15aY.$EJBLN8IrHvTosxr/PqtSZQNIsRR7R4A7MImLW9qxsQ8'),
(16, 'Md.rabbi', '100', NULL, '2021-22', '100.cse@student.just.edu.bd', '01561234567', 'student', 'CSE', '', '', '', '', '', NULL, NULL, '$5$rounds=535000$pQNLH0.2irhbGtwI$Q6enAy6af20KSP0Wr.OCeO8Fv0M6qyXUYk5RprXI3s8'),
(17, 'Md.rabbi', '2', '2-2', '2021-22', '210106.cse@student.just.edu.bd', '1561234567', 'student', 'CSE', '65', 'ds', 'mmm', 'bv', 'gfd', '2025-01-01', NULL, '$5$rounds=535000$MRtTdmqEbo5dYDgb$BPRtMmiawqklCG3ysiDm/rkMxqOt1B5Sk7sXdde0faB');

-- --------------------------------------------------------

--
-- Table structure for table `student_course_assign`
--

CREATE TABLE `student_course_assign` (
  `roll_number` varchar(50) NOT NULL,
  `session` varchar(20) NOT NULL,
  `semester` varchar(20) NOT NULL,
  `course_code` varchar(20) NOT NULL,
  `course_name` varchar(100) DEFAULT NULL,
  `department` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `student_course_assign`
--

INSERT INTO `student_course_assign` (`roll_number`, `session`, `semester`, `course_code`, `course_name`, `department`) VALUES
('210100', '2021-22', '2-2', 'CSE 2201', 'Data communication', NULL),
('210100', '2021-22', '2-2', 'CSE 2205', 'PHYSICS', NULL),
('210106', '2023-2024', '1-1', 'CSE 1001', 'COMPUTER', NULL),
('210107', '2023-2024', '1-1', 'CSE 1001', 'COMPUTER', NULL),
('210108', '2023-2024', '1-1', 'CSE 1001', 'COMPUTER', NULL),
('210124', '2021-22', '2-2', 'CSE 2201', 'Data communication', NULL),
('210124', '2021-22', '2-2', 'CSE 2205', 'PHYSICS', NULL),
('21013', '2021-22', '2-2', 'CSE 2201', 'Data communication', NULL),
('210130', '2021-22', '2-2', 'CSE 2201', 'Data communication', NULL),
('210130', '2021-22', '2-2', 'CSE 2205', 'PHYSICS', NULL),
('210135', '2021-22', '2-2', 'CSE 2201', 'Data communication', NULL),
('210135', '2021-22', '2-2', 'CSE 2205', 'PHYSICS', NULL),
('210143', '2021-22', '2-2', 'CSE 2201', 'Data communication', NULL),
('210143', '2021-22', '2-2', 'CSE 2205', 'PHYSICS', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `teacher`
--

CREATE TABLE `teacher` (
  `teacher_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(255) NOT NULL,
  `mobile_number` varchar(15) NOT NULL,
  `user_type` varchar(50) NOT NULL,
  `department` varchar(255) NOT NULL,
  `designation` varchar(255) NOT NULL,
  `father_name` varchar(255) NOT NULL,
  `mother_name` varchar(255) NOT NULL,
  `present_address` text NOT NULL,
  `permanent_address` text NOT NULL,
  `dob` date DEFAULT NULL,
  `photo` varchar(255) DEFAULT NULL,
  `password` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `teacher`
--

INSERT INTO `teacher` (`teacher_id`, `name`, `email`, `mobile_number`, `user_type`, `department`, `designation`, `father_name`, `mother_name`, `present_address`, `permanent_address`, `dob`, `photo`, `password`) VALUES
(1, 'juytf', '2101.cse@student.just.edu.bd', '01561234567', 'teacher', 'EEE', 'Professor', '', '', '', '', NULL, NULL, '$5$rounds=535000$t1i6mwmtMsAsg96s$BZfipBkXp8MSD6mCTJuj7NKYux.qKSomanS9Sz2qyi8'),
(2, 'Monishanker Halder', 'm.halder@just.edu.bd', '01561234567', 'teacher', 'CSE', 'Assistant Professor', '', '', '', '', NULL, 'halder.jpeg', '$5$rounds=535000$zofqqhVk6kMuTo0L$KghxpFqIobDyJZLXlvtP3PxDZqDp.iPBItIZ.CJbaN9'),
(3, 'ty', '00.cse@student.just.edu.bd', '01561234567', 'teacher', 'Computer Science', 'Professor', '', '', '', '', NULL, NULL, '$5$rounds=535000$qYCMvenbRS9HnShZ$BOuekRwtBWtNeXBMvxJIThAHu8mjfpik5d95MwxmwM4');

-- --------------------------------------------------------

--
-- Table structure for table `teacher_course_assign`
--

CREATE TABLE `teacher_course_assign` (
  `id` int(11) NOT NULL,
  `teacher_name` varchar(255) NOT NULL,
  `department` varchar(100) NOT NULL,
  `session` varchar(20) NOT NULL,
  `semester` varchar(20) NOT NULL,
  `course_code` varchar(50) NOT NULL,
  `course_name` varchar(255) NOT NULL,
  `email` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `teacher_course_assign`
--

INSERT INTO `teacher_course_assign` (`id`, `teacher_name`, `department`, `session`, `semester`, `course_code`, `course_name`, `email`) VALUES
(3, 'Monishanker Halder', 'CSE', '2021-22', '2-2', 'CSE 2208', 'SDP-1', 'm.halder@just.edu.bd'),
(4, 'Monishanker Halder', 'CSE', '2021-22', '2-2', 'CSE 2205', 'MATH', 'm.halder@just.edu.bd');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(30) NOT NULL DEFAULT 'None',
  `serialnumber` double NOT NULL DEFAULT 0,
  `gender` varchar(10) NOT NULL DEFAULT 'None',
  `email` varchar(50) NOT NULL DEFAULT 'None',
  `fingerprint_id` int(11) NOT NULL,
  `fingerprint_select` tinyint(1) NOT NULL DEFAULT 0,
  `user_date` date NOT NULL,
  `device_uid` varchar(20) NOT NULL DEFAULT '0',
  `device_dep` varchar(20) NOT NULL DEFAULT '0',
  `del_fingerid` tinyint(1) NOT NULL DEFAULT 0,
  `add_fingerid` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `serialnumber`, `gender`, `email`, `fingerprint_id`, `fingerprint_select`, `user_date`, `device_uid`, `device_dep`, `del_fingerid`, `add_fingerid`) VALUES
(9, 'Shihab', 210108, 'Male', 'None', 8, 0, '2025-01-08', '028ec80c', 'CSE', 0, 0),
(10, 'Siam', 210113, 'Male', 'None', 9, 0, '2025-01-08', '028ec80c', 'CSE', 0, 0),
(11, 'Sammo', 210124, 'Male', 'None', 10, 0, '2025-01-08', '028ec80c', 'CSE', 0, 0),
(12, 'Dipan', 210130, 'Male', 'None', 11, 0, '2025-01-08', '028ec80c', 'CSE', 0, 0),
(13, 'Rabbi', 210106, 'Male', 'None', 1, 0, '2025-01-08', '028ec80c', 'CSE', 0, 0),
(14, 'Fahim Foysal', 210143, 'Male', 'None', 2, 0, '2025-01-08', '028ec80c', 'CSE', 0, 0),
(15, 'None', 0, 'None', 'None', 5, 0, '2025-01-08', '028ec80c', 'CSE', 0, 0),
(16, 'Foysal', 210144, 'Male', 'None', 12, 0, '2025-01-08', '028ec80c', 'CSE', 0, 0),
(17, 'Ashik', 210110, 'Male', 'None', 13, 0, '2025-01-08', '028ec80c', 'CSE', 0, 0),
(18, 'Raj', 53, 'Male', 'None', 14, 0, '2025-01-08', '028ec80c', 'CSE', 0, 0),
(19, 'Atik', 52, 'Male', 'None', 15, 0, '2025-01-08', '028ec80c', 'CSE', 0, 0),
(20, 'Parvez', 210114, 'Male', 'None', 16, 0, '2025-01-08', '028ec80c', 'CSE', 0, 0),
(21, 'AdnAN', 210150, 'Male', 'None', 17, 0, '2025-01-08', '028ec80c', 'CSE', 0, 0),
(22, 'ASIK', 210118, 'Male', 'None', 18, 0, '2025-01-08', '028ec80c', 'CSE', 0, 0),
(24, 'ROBI', 210107, 'Male', 'None', 19, 0, '2025-01-08', '028ec80c', 'CSE', 0, 0),
(25, 'SARDER', 210131, 'Male', 'None', 20, 0, '2025-01-08', '028ec80c', 'CSE', 0, 0),
(26, 'CHOTON', 210126, 'Male', 'None', 21, 0, '2025-01-08', '028ec80c', 'CSE', 0, 0),
(27, 'Fahim43', 2101043, 'Male', 'None', 22, 0, '2025-01-11', '028ec80c', 'CSE', 0, 0),
(28, 'Tanim', 210135, 'Male', 'None', 23, 0, '2025-01-17', '028ec80c', 'CSE', 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `userss`
--

CREATE TABLE `userss` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `mobile_number` bigint(20) NOT NULL,
  `user_type` varchar(50) NOT NULL,
  `session` varchar(10) DEFAULT NULL,
  `roll_number` int(11) DEFAULT NULL,
  `designation` varchar(50) DEFAULT NULL,
  `password` varchar(100) NOT NULL,
  `department` varchar(100) NOT NULL,
  `reg_no` varchar(100) NOT NULL DEFAULT '',
  `father_name` varchar(100) NOT NULL DEFAULT '',
  `mother_name` varchar(100) NOT NULL DEFAULT '',
  `present_address` text NOT NULL DEFAULT '',
  `permanent_address` varchar(100) NOT NULL DEFAULT '',
  `dob` date DEFAULT NULL,
  `photo` varchar(255) NOT NULL DEFAULT '',
  `semester` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `userss`
--

INSERT INTO `userss` (`id`, `name`, `email`, `mobile_number`, `user_type`, `session`, `roll_number`, `designation`, `password`, `department`, `reg_no`, `father_name`, `mother_name`, `present_address`, `permanent_address`, `dob`, `photo`, `semester`) VALUES
(30, '2', '121.cse@student.just.edu.bd', 1561234567, 'teacher', NULL, NULL, 'Professor', '$5$rounds=535000$hDZCxkK14H4PFGLR$VDEybqkyARd4ehh14eY35Uf7buNTE81paTIB19XEaC8', 'Civil Engineering', '', '', '', '', '', NULL, 'Gmail-logo.png', NULL),
(31, 'Dr. Syed Md. Galib', 'galib.cse@just.edu.bd', 1781408274, 'chairman', NULL, NULL, 'Chairman', '$5$rounds=535000$owDV/phyRORXOO4c$gCPQcm3SvnfngkQJZ42DdXPSB8jotP6pZUtyIMWEfi1', 'Computer Science', '', '', '', '', '', NULL, 'Galib.jpeg', NULL),
(32, 'Monishanker Halder', 'm.halder@just.edu.bd', 1727653125, 'teacher', NULL, NULL, 'Assistant Professor', '$5$rounds=535000$1Txg2cxMDMpPGrwF$HaQoj.l7UZRCDxsi00xLuavkDjZxT2cPvQ6UgGPCP24', 'CSE', '', '', '', '', '', NULL, 'halder.jpeg', NULL),
(33, 'Dipan sarder', '210132.cse@student.just.edu.bd', 1751682260, 'staff', NULL, NULL, 'Section Officer', '$5$rounds=535000$Y/Y/7SpOw24P9/Pn$cR7QgoobTJSvCWjYx6G7HttLR1jGfGFU4yYISzVWWm3', 'Computer Science', '', '', '', '', '', NULL, 'photo_2024-11-23_14-26-57.jpg', NULL),
(35, 'Rakib Hasan  Shihab', '210108.cse@student.just.edu.bd', 1715134718, 'student', '2021-22', 210108, NULL, '$5$rounds=535000$qyNaoMQzZWXj.j4f$tCZsWnEwEHvobpRrGmWvUzvhOWuIu/D6n9VzlIjvWXC', 'CSE', '2101007', 'Farid uddin Ahmed', 'Sheuly Begum', 'palbari', 'Barguna', '2001-04-21', 'shisab.jpg', NULL),
(36, 'Pranto Bala', 'prantobala@gmail.com', 1777501254, 'student', '2021-22', 210102, NULL, '$5$rounds=535000$MZfu1Kn61bexNNT.$0qLUekiXa2Har7PJa3U.wYnlzrhEbhO/hYB.eGCO5g9', 'CSE', '', '', '', '', '', NULL, '', NULL),
(37, '2', '2.cse@student.just.edu.bd', 1561234567, 'student', '2020-21', 1, NULL, '$5$rounds=535000$4YANMOF7j6Pioo03$AMGiGo5yna7pHzhUBQB.J5rYr0/CB4Q4Bx1z/dIN9.2', 'BBA', '', '', '', '', '', NULL, '', NULL),
(38, 'a', 'a@a.com', 1561234567, 'student', '2018-19', 12, NULL, '$5$rounds=535000$oqnl1irOIy8sVycT$0uWHeqVLcAH8/l4Z5X58/8s031ROUe16O1ayOI9NDg4', 'CSE', '', '', '', '', '', NULL, '', NULL),
(45, '', '1.cse@student.just.edu.bd', 0, 'student', NULL, NULL, NULL, '$5$rounds=535000$vxfBLESlNfavAaTo$ICKUqvyULKCBf8fRqVRIM8NC4WgNIlX5ytx3lIxlok3', '', '', '', '', '', '', NULL, '', NULL),
(46, '', '210143.cse@student.just.edu.bd', 0, 'student', NULL, NULL, NULL, '$5$rounds=535000$6XfpuMvf1MzHjawx$VujXUD25Aq7NNTVuXaZsN.gucmvK7JMTHGMKNqP48t/', '', '', '', '', '', '', NULL, 'IMG_6152.JPG', NULL),
(47, '', '210130.cse@student.just.edu.bd', 0, 'student', NULL, NULL, NULL, '$5$rounds=535000$2cnwi9HGQGFwmg/V$PkK1RIL3CjCiqcFFKjE51or.OayPIgHZNleykSxN7QD', '', '', '', '', '', '', NULL, '', NULL),
(48, '', '210124.cse@student.just.edu.bd', 0, 'student', NULL, NULL, NULL, '$5$rounds=535000$cKxCr.WakvHXTZGm$pIRVwORMpJyxAf/5l85VrwRdIvtHxaovW7psIPr6jU1', '', '', '', '', '', '', NULL, '', NULL),
(49, '', '210135.cse@student.just.edu.bd', 0, 'student', NULL, NULL, NULL, '$5$rounds=535000$iRrZHSKS1f2kQ0Oy$ECb7CVWcQboN5gDCgYFBFDqlo3ZqFGp6NAYaf.jKDx0', '', '', '', '', '', '', NULL, '', NULL),
(50, '', '210100.cse@student.just.edu.bd', 0, 'student', NULL, NULL, NULL, '$5$rounds=535000$Qig2jpQ1kKr.C44f$pBk2yg4NO0pe0OczLcNyYIY4O9Tk6OXjRPlrjMNQTL0', '', '', '', '', '', '', NULL, '', NULL),
(51, '', '21013.cse1@student.just.edu.bd', 0, 'student', NULL, NULL, NULL, '$5$rounds=535000$2QZX1Tpl0e.15aY.$EJBLN8IrHvTosxr/PqtSZQNIsRR7R4A7MImLW9qxsQ8', '', '', '', '', '', '', NULL, '', NULL),
(52, '', '2101.cse@student.just.edu.bd', 0, 'teacher', NULL, NULL, NULL, '$5$rounds=535000$t1i6mwmtMsAsg96s$BZfipBkXp8MSD6mCTJuj7NKYux.qKSomanS9Sz2qyi8', '', '', '', '', '', '', NULL, '', NULL),
(54, '', '11.cse@student.just.edu.bd', 0, 'chairman', NULL, NULL, NULL, '$5$rounds=535000$PnZrneuko9xWjIOa$NakR3qPDyxdeOdtcTStU2cgF.ju.NHsbGUWUiitcOT7', '', '', '', '', '', '', NULL, '', NULL),
(55, '', '210.cse@student.just.edu.bd', 0, 'teacher', NULL, NULL, NULL, '$5$rounds=535000$FxMXUzrCmQEnl51b$sGRfUfYF8ik4SEQvvxyulNKHJ4GHrorUtg0yXC4DAXB', '', '', '', '', '', '', NULL, '', NULL),
(56, '', '10.cse@student.just.edu.bd', 0, 'staff', NULL, NULL, NULL, '$5$rounds=535000$0zrWE5Bq4Sx16QWV$swTYw0oaAL2.0xHEmh5714L5RXg/m.o0MVRBOO3HMi9', '', '', '', '', '', '', NULL, '', NULL),
(58, '', '100.cse@student.just.edu.bd', 0, 'student', NULL, NULL, NULL, '$5$rounds=535000$pQNLH0.2irhbGtwI$Q6enAy6af20KSP0Wr.OCeO8Fv0M6qyXUYk5RprXI3s8', '', '', '', '', '', '', NULL, '', NULL),
(59, '', '101.cse@student.just.edu.bd', 0, 'teacher', NULL, NULL, NULL, '$5$rounds=535000$zofqqhVk6kMuTo0L$KghxpFqIobDyJZLXlvtP3PxDZqDp.iPBItIZ.CJbaN9', '', '', '', '', '', '', NULL, '', NULL),
(60, 'Md.rabbi', '210106.cse@student.just.edu.bd', 1561234567, 'student', '2021-22', 2, NULL, '$5$rounds=535000$MRtTdmqEbo5dYDgb$BPRtMmiawqklCG3ysiDm/rkMxqOt1B5Sk7sXdde0faB', 'CSE', '65', 'ds', 'mmm', 'bv', 'gfd', '2025-01-01', '', '2-2'),
(61, 'ty', '00.cse@student.just.edu.bd', 1561234567, 'teacher', NULL, NULL, 'Professor', '$5$rounds=535000$qYCMvenbRS9HnShZ$BOuekRwtBWtNeXBMvxJIThAHu8mjfpik5d95MwxmwM4', 'Computer Science', '', '', '', '', '', NULL, '', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `users_logs`
--

CREATE TABLE `users_logs` (
  `id` int(11) NOT NULL,
  `username` varchar(100) NOT NULL,
  `serialnumber` double NOT NULL,
  `fingerprint_id` int(5) NOT NULL,
  `device_uid` varchar(20) NOT NULL,
  `device_dep` varchar(20) NOT NULL,
  `checkindate` date NOT NULL,
  `timein` time NOT NULL,
  `timeout` time NOT NULL,
  `fingerout` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `users_logs`
--

INSERT INTO `users_logs` (`id`, `username`, `serialnumber`, `fingerprint_id`, `device_uid`, `device_dep`, `checkindate`, `timein`, `timeout`, `fingerout`) VALUES
(2, 'Fahim Foysal', 210143, 2, '028ec80c', 'CSE', '2025-01-08', '04:39:07', '04:40:30', 1),
(3, 'Dipan', 210130, 11, '028ec80c', 'CSE', '2025-01-08', '04:39:44', '13:48:30', 1),
(4, 'Sammo', 210124, 10, '028ec80c', 'CSE', '2025-01-08', '04:40:11', '04:43:29', 1),
(5, 'Rabbi', 210106, 1, '028ec80c', 'CSE', '2025-01-08', '04:42:11', '13:49:31', 1),
(6, 'Siam', 210113, 9, '028ec80c', 'CSE', '2025-01-08', '04:42:49', '04:43:02', 1),
(7, 'Sammo', 210124, 10, '028ec80c', 'CSE', '2025-01-08', '04:43:38', '04:43:44', 1),
(8, 'Fahim Foysal', 210143, 2, '028ec80c', 'CSE', '2025-01-08', '05:12:49', '05:12:57', 1),
(9, 'Fahim Foysal', 210143, 2, '028ec80c', 'CSE', '2025-01-08', '05:14:32', '05:30:51', 1),
(10, 'None', 0, 5, '028ec80c', 'CSE', '2025-01-08', '05:29:17', '05:29:27', 1),
(11, 'Sammo', 210124, 10, '028ec80c', 'CSE', '2025-01-08', '05:29:35', '05:29:41', 1),
(12, 'Siam', 210113, 9, '028ec80c', 'CSE', '2025-01-08', '05:29:52', '05:30:12', 1),
(13, 'Fahim Foysal', 210143, 2, '028ec80c', 'CSE', '2025-01-08', '05:30:57', '05:34:33', 1),
(14, 'Fahim Foysal', 210143, 2, '028ec80c', 'CSE', '2025-01-08', '05:34:39', '14:15:52', 1),
(15, 'None', 0, 12, '028ec80c', 'CSE', '2025-01-08', '13:46:51', '13:47:04', 1),
(16, 'Sammo', 210124, 10, '028ec80c', 'CSE', '2025-01-08', '13:48:56', '14:09:07', 1),
(17, 'Dipan', 210130, 11, '028ec80c', 'CSE', '2025-01-08', '13:49:08', '13:49:38', 1),
(18, 'Ashik', 210110, 13, '028ec80c', 'CSE', '2025-01-08', '14:02:41', '14:03:38', 1),
(19, 'Raj', 53, 14, '028ec80c', 'CSE', '2025-01-08', '14:03:25', '14:03:32', 1),
(20, 'Atik', 52, 15, '028ec80c', 'CSE', '2025-01-08', '14:07:56', '14:08:03', 1),
(21, 'Ashik', 210110, 13, '028ec80c', 'CSE', '2025-01-08', '14:08:18', '14:16:07', 1),
(22, 'Raj', 53, 14, '028ec80c', 'CSE', '2025-01-08', '14:08:32', '14:46:17', 1),
(23, 'Foysal', 210144, 12, '028ec80c', 'CSE', '2025-01-08', '14:08:48', '14:08:57', 1),
(24, 'Rabbi', 210106, 1, '028ec80c', 'CSE', '2025-01-08', '14:09:17', '14:15:43', 1),
(25, 'Foysal', 210144, 12, '028ec80c', 'CSE', '2025-01-08', '14:09:56', '14:15:17', 1),
(26, 'AdnAN', 210150, 17, '028ec80c', 'CSE', '2025-01-08', '14:13:57', '14:14:38', 1),
(27, 'Parvez', 210114, 16, '028ec80c', 'CSE', '2025-01-08', '14:14:20', '14:14:48', 1),
(28, 'Foysal', 210144, 12, '028ec80c', 'CSE', '2025-01-08', '14:15:29', '14:51:15', 1),
(29, 'Dipan', 210130, 11, '028ec80c', 'CSE', '2025-01-08', '14:15:37', '15:42:36', 1),
(30, 'Fahim Foysal', 210143, 2, '028ec80c', 'CSE', '2025-01-08', '14:16:00', '00:00:00', 0),
(31, 'Parvez', 210114, 16, '028ec80c', 'CSE', '2025-01-08', '14:16:17', '14:16:32', 1),
(32, 'Ashik', 210110, 13, '028ec80c', 'CSE', '2025-01-08', '14:16:24', '14:16:49', 1),
(33, 'Parvez', 210114, 16, '028ec80c', 'CSE', '2025-01-08', '14:18:45', '00:00:00', 0),
(34, 'AdnAN', 210150, 17, '028ec80c', 'CSE', '2025-01-08', '14:18:57', '00:00:00', 0),
(35, 'Ashik', 210110, 13, '028ec80c', 'CSE', '2025-01-08', '14:45:48', '14:51:05', 1),
(36, 'Foysal', 210144, 12, '028ec80c', 'CSE', '2025-01-08', '14:57:47', '15:32:56', 1),
(37, 'ROBI', 210107, 19, '028ec80c', 'CSE', '2025-01-08', '15:32:15', '15:40:39', 1),
(38, 'Ashik', 210110, 13, '028ec80c', 'CSE', '2025-01-08', '15:32:40', '15:40:01', 1),
(39, 'Rabbi', 210106, 1, '028ec80c', 'CSE', '2025-01-08', '15:33:03', '00:00:00', 0),
(40, 'Foysal', 210144, 12, '028ec80c', 'CSE', '2025-01-08', '15:33:23', '15:34:02', 1),
(41, 'Foysal', 210144, 12, '028ec80c', 'CSE', '2025-01-08', '15:34:28', '15:40:08', 1),
(42, 'SARDER', 210131, 20, '028ec80c', 'CSE', '2025-01-08', '15:37:43', '15:37:48', 1),
(43, 'SARDER', 210131, 20, '028ec80c', 'CSE', '2025-01-08', '15:40:19', '15:41:12', 1),
(44, 'Raj', 53, 14, '028ec80c', 'CSE', '2025-01-08', '15:40:45', '15:41:06', 1),
(45, 'Ashik', 210110, 13, '028ec80c', 'CSE', '2025-01-08', '15:40:51', '15:41:41', 1),
(46, 'ROBI', 210107, 19, '028ec80c', 'CSE', '2025-01-08', '15:41:00', '15:41:35', 1),
(47, 'Foysal', 210144, 12, '028ec80c', 'CSE', '2025-01-08', '15:42:05', '15:42:14', 1),
(48, 'Ashik', 210110, 13, '028ec80c', 'CSE', '2025-01-08', '15:43:07', '15:43:31', 1),
(51, 'Ashik', 210110, 13, '028ec80c', 'CSE', '2025-01-08', '15:44:27', '15:48:45', 1),
(52, 'ROBI', 210107, 19, '028ec80c', 'CSE', '2025-01-08', '15:48:54', '15:50:58', 1),
(53, 'Ashik', 210110, 13, '028ec80c', 'CSE', '2025-01-08', '15:50:45', '15:51:07', 1),
(54, 'Ashik', 210110, 13, '028ec80c', 'CSE', '2025-01-08', '15:53:21', '15:53:28', 1),
(55, 'CHOTON', 210126, 21, '028ec80c', 'CSE', '2025-01-08', '15:59:58', '16:00:07', 1),
(56, 'Fahim Foysal', 210143, 2, '028ec80c', 'CSE', '2025-01-11', '11:50:39', '11:52:52', 1),
(57, 'None', 0, 5, '028ec80c', 'CSE', '2025-01-11', '11:50:47', '00:00:00', 0),
(58, 'Fahim Foysal', 210143, 2, '028ec80c', 'CSE', '2025-01-11', '11:53:00', '11:53:12', 1),
(59, 'Fahim Foysal', 210143, 2, '028ec80c', 'CSE', '2025-01-11', '14:52:38', '14:53:02', 1),
(60, 'Fahim Foysal', 210143, 2, '028ec80c', 'CSE', '2025-01-12', '12:15:23', '12:23:47', 1),
(61, 'None', 0, 5, '028ec80c', 'CSE', '2025-01-12', '12:15:29', '12:15:43', 1),
(62, 'Parvez', 210114, 16, '028ec80c', 'CSE', '2025-01-12', '12:23:09', '00:00:00', 0),
(63, 'Fahim43', 2101043, 22, '028ec80c', 'CSE', '2025-01-12', '12:23:55', '00:00:00', 0),
(64, 'Fahim Foysal', 210143, 2, '028ec80c', 'CSE', '2025-01-12', '12:27:00', '12:47:42', 1),
(65, 'Tanim', 210135, 23, '028ec80c', 'CSE', '2025-01-18', '00:01:32', '00:01:47', 1),
(66, 'Fahim Foysal', 210143, 2, '028ec80c', 'CSE', '2025-01-18', '00:02:27', '00:02:36', 1),
(67, 'None', 0, 5, '028ec80c', 'CSE', '2025-01-18', '00:03:44', '00:00:00', 0),
(68, 'Fahim Foysal', 210143, 2, '028ec80c', 'CSE', '2025-01-18', '00:04:08', '00:04:31', 1),
(69, 'Fahim Foysal', 210143, 2, '028ec80c', 'CSE', '2025-01-18', '00:05:05', '00:05:48', 1),
(70, 'Fahim Foysal', 210143, 2, '028ec80c', 'CSE', '2025-01-18', '00:06:27', '00:00:00', 0);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admin`
--
ALTER TABLE `admin`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `chairman`
--
ALTER TABLE `chairman`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `classes`
--
ALTER TABLE `classes`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `course`
--
ALTER TABLE `course`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `course_code` (`course_code`);

--
-- Indexes for table `course_feedback`
--
ALTER TABLE `course_feedback`
  ADD PRIMARY KEY (`id`),
  ADD KEY `roll_number` (`roll_number`),
  ADD KEY `course_code` (`course_code`);

--
-- Indexes for table `devices`
--
ALTER TABLE `devices`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `fingerprints`
--
ALTER TABLE `fingerprints`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `notices`
--
ALTER TABLE `notices`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `pwd_reset`
--
ALTER TABLE `pwd_reset`
  ADD PRIMARY KEY (`pwd_reset_id`);

--
-- Indexes for table `result`
--
ALTER TABLE `result`
  ADD PRIMARY KEY (`roll_number`,`course_code`,`exam_type`);

--
-- Indexes for table `staff`
--
ALTER TABLE `staff`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `student`
--
ALTER TABLE `student`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `roll_number` (`roll_number`);

--
-- Indexes for table `student_course_assign`
--
ALTER TABLE `student_course_assign`
  ADD PRIMARY KEY (`roll_number`,`course_code`);

--
-- Indexes for table `teacher`
--
ALTER TABLE `teacher`
  ADD PRIMARY KEY (`teacher_id`);

--
-- Indexes for table `teacher_course_assign`
--
ALTER TABLE `teacher_course_assign`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_assignment` (`teacher_name`,`session`,`semester`,`course_code`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `userss`
--
ALTER TABLE `userss`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `users_logs`
--
ALTER TABLE `users_logs`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `admin`
--
ALTER TABLE `admin`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `chairman`
--
ALTER TABLE `chairman`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `classes`
--
ALTER TABLE `classes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `course`
--
ALTER TABLE `course`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `course_feedback`
--
ALTER TABLE `course_feedback`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `devices`
--
ALTER TABLE `devices`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `fingerprints`
--
ALTER TABLE `fingerprints`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `notices`
--
ALTER TABLE `notices`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `pwd_reset`
--
ALTER TABLE `pwd_reset`
  MODIFY `pwd_reset_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `staff`
--
ALTER TABLE `staff`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `student`
--
ALTER TABLE `student`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `teacher`
--
ALTER TABLE `teacher`
  MODIFY `teacher_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `teacher_course_assign`
--
ALTER TABLE `teacher_course_assign`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

--
-- AUTO_INCREMENT for table `userss`
--
ALTER TABLE `userss`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=62;

--
-- AUTO_INCREMENT for table `users_logs`
--
ALTER TABLE `users_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=71;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `course_feedback`
--
ALTER TABLE `course_feedback`
  ADD CONSTRAINT `course_feedback_ibfk_1` FOREIGN KEY (`roll_number`) REFERENCES `student` (`roll_number`),
  ADD CONSTRAINT `course_feedback_ibfk_2` FOREIGN KEY (`course_code`) REFERENCES `course` (`course_code`);

--
-- Constraints for table `student_course_assign`
--
ALTER TABLE `student_course_assign`
  ADD CONSTRAINT `student_course_assign_ibfk_1` FOREIGN KEY (`roll_number`) REFERENCES `student` (`roll_number`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
