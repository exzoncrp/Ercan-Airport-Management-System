--------------------------------------------------------------------------------
-- AIRPORT MANAGEMENT INFORMATION SYSTEM - DATABASE SCHEMA & SAMPLE DATA
--------------------------------------------------------------------------------

-- SECTION 1: DATA DEFINITION LANGUAGE (DDL) - TABLE CREATIONS
-- This section defines the structure of the database including all constraints.

--------------------------------------------------------------------------------
-- 1. Table: Employee 
CREATE TABLE Employee (
    ssn INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    union_membership_no VARCHAR(50) NOT NULL
);

-- 2. Table: Traffic_Controller 
CREATE TABLE Traffic_Controller (
    ssn INT PRIMARY KEY,
    last_exam_date DATE,
    FOREIGN KEY (ssn) REFERENCES Employee(ssn) ON DELETE CASCADE
);

-- 3. Table: Technician 
CREATE TABLE Technician (
    ssn INT PRIMARY KEY,
    FOREIGN KEY (ssn) REFERENCES Employee(ssn) ON DELETE CASCADE
);

-- 4. Table: Airline 
CREATE TABLE Airline (
    airline_id INT AUTO_INCREMENT PRIMARY KEY,
    airline_name VARCHAR(100) NOT NULL,
    contact_email VARCHAR(100)
);

-- 5. Table: Airplane 
CREATE TABLE Airplane (
    plane_no INT PRIMARY KEY,
    model_no VARCHAR(50) NOT NULL,
    capacity INT,
    airline_id INT,
    FOREIGN KEY (airline_id) REFERENCES Airline(airline_id) ON DELETE SET NULL
);

-- 6. Table: Technician_Expertise 
CREATE TABLE Technician_Expertise (
    expertise_id INT AUTO_INCREMENT PRIMARY KEY,
    tech_ssn INT,
    model_no VARCHAR(50) NOT NULL,
    FOREIGN KEY (tech_ssn) REFERENCES Technician(ssn) ON DELETE CASCADE
);

-- 7. Table: Hangar 
CREATE TABLE Hangar (
    hangar_no INT PRIMARY KEY,
    location VARCHAR(100) NOT NULL
);

-- 8. Table: Airplane_Hangar 
CREATE TABLE Airplane_Hangar (
    movement_id INT AUTO_INCREMENT PRIMARY KEY,
    plane_no INT,
    hangar_no INT,
    date_in DATETIME NOT NULL,
    date_out DATETIME,
    FOREIGN KEY (plane_no) REFERENCES Airplane(plane_no) ON DELETE CASCADE,
    FOREIGN KEY (hangar_no) REFERENCES Hangar(hangar_no) ON DELETE CASCADE
);

-- 9. Table: Test 
CREATE TABLE Test (
    test_id INT PRIMARY KEY,
    test_name VARCHAR(100) NOT NULL
);

-- 10. Table: Testing_Event 
CREATE TABLE Testing_Event (
    event_id INT AUTO_INCREMENT PRIMARY KEY,
    plane_no INT,
    tech_ssn INT,
    test_id INT,
    event_date DATE NOT NULL,
    hours_spent DECIMAL(5,2),
    score INT,
    FOREIGN KEY (plane_no) REFERENCES Airplane(plane_no) ON DELETE CASCADE,
    FOREIGN KEY (tech_ssn) REFERENCES Technician(ssn) ON DELETE CASCADE,
    FOREIGN KEY (test_id) REFERENCES Test(test_id) ON DELETE CASCADE
);

-- 11. Table: Flight 
CREATE TABLE Flight (
    flight_no VARCHAR(20) PRIMARY KEY,
    plane_no INT,
    destination VARCHAR(100) NOT NULL,
    departure_time DATETIME NOT NULL,
    arrival_time DATETIME NOT NULL,
    FOREIGN KEY (plane_no) REFERENCES Airplane(plane_no) ON DELETE CASCADE
);

--------------------------------------------------------------------------------
-- SECTION 2: DATA MANIPULATION LANGUAGE (DML) - SAMPLE DATA
-- This section populates the tables with records.

--------------------------------------------------------------------------------
-- Insert: Basic Entities
INSERT INTO Employee (ssn, name, union_membership_no) VALUES
(101, 'Ahmet Yilmaz', 'U-1001'), (102, 'Ayse Demir', 'U-1002'), (103, 'Mehmet Kaya', 'U-1003'),
(104, 'Fatma Celik', 'U-1004'), (105, 'Ali Veli', 'U-1005'), (106, 'Canan Yildiz', 'U-1006'),
(107, 'Burak Tekin', 'U-1007'), (108, 'Zeynep Sahin', 'U-1008'), (109, 'Oguz Kurt', 'U-1009'),
(110, 'Elif Aslan', 'U-1010');

INSERT INTO Hangar (hangar_no, location) VALUES
(1, 'North Terminal'), (2, 'South Terminal');

INSERT INTO Test (test_id, test_name) VALUES
(1, 'Engine Maintenance'), (2, 'Landing Gear Inspection'), (3, 'Avionics System Test');

INSERT INTO Airline (airline_name, contact_email) VALUES
('Turkish Airlines', 'info@thy.com'), ('Pegasus', 'info@flypgs.com');

-- Insert: Specialized Roles
INSERT INTO Traffic_Controller (ssn, last_exam_date) VALUES
(101, '2025-10-15'), (102, '2026-02-20'), (106, '2025-11-10'), (107, '2026-03-05');

INSERT INTO Technician (ssn) VALUES (103), (104), (105), (108), (109), (110);

-- Insert: Airplanes
INSERT INTO Airplane (plane_no, model_no, capacity, airline_id) VALUES
(1001, 'Boeing 737', 189, 1), (1002, 'Airbus A320', 180, 2), (1003, 'Boeing 777', 300, 1),
(1004, 'Airbus A330', 250, 1), (1005, 'Boeing 737', 189, 2), (1006, 'Airbus A320', 180, 1);

-- Insert: Operational Data
INSERT INTO Technician_Expertise (tech_ssn, model_no) VALUES
(103, 'Boeing 737'), (103, 'Boeing 777'), (104, 'Airbus A320'), (108, 'Airbus A330'),
(109, 'Boeing 737'), (110, 'Boeing 777');

INSERT INTO Testing_Event (plane_no, tech_ssn, test_id, event_date, hours_spent, score) VALUES
(1001, 103, 1, '2026-05-11', 4.5, 95), (1002, 104, 2, '2026-05-12', 2.0, 85),
(1003, 103, 3, '2026-05-01', 5.0, 100), (1004, 108, 1, '2026-05-10', 6.0, 90),
(1005, 109, 2, '2026-05-12', 3.5, 75);

INSERT INTO Airplane_Hangar (plane_no, hangar_no, date_in, date_out) VALUES
(1001, 1, '2026-05-10 10:00:00', '2026-05-12 08:00:00'),
(1002, 2, '2026-05-11 15:00:00', NULL),
(1006, 1, '2026-05-13 18:00:00', NULL);

INSERT INTO Flight (flight_no, plane_no, destination, departure_time, arrival_time) VALUES
('TK101', 1001, 'Istanbul', '2026-05-13 12:00:00', '2026-05-13 13:30:00'),
('PC404', 1005, 'Antalya', '2026-05-15 10:00:00', '2026-05-15 11:30:00');