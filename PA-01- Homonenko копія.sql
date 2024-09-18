
CREATE DATABASE Gym_hw1;


USE Gym_hw1;


CREATE TABLE Members (
    MemberID INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(20)
);


CREATE TABLE Coaches (
    coachID INT AUTO_INCREMENT PRIMARY KEY,
    coach_name VARCHAR(100),
    class_type VARCHAR(100)
);


CREATE TABLE Classes (
    classID INT AUTO_INCREMENT PRIMARY KEY,
    class_name VARCHAR(100),
    class_time TIME,
    coachID INT,
    FOREIGN KEY (coachID) REFERENCES Coaches(coachID)
);


CREATE TABLE Memberships (
    membershipID INT AUTO_INCREMENT PRIMARY KEY,
    memberID INT,
    start_date DATE,
    end_date DATE,
    price DECIMAL(10, 2),
    FOREIGN KEY (memberID) REFERENCES Members(memberID),
    CONSTRAINT no_overlap UNIQUE (memberID, start_date, end_date)
);

CREATE TABLE Gym_Visits (
    visitID INT AUTO_INCREMENT PRIMARY KEY,
    memberID INT,
    visit_date DATE,
    duration DECIMAL(4, 2), 
    FOREIGN KEY (memberID) REFERENCES Members(memberID)
);


CREATE TABLE Class_Attendances (
    attendanceID INT AUTO_INCREMENT PRIMARY KEY,
    visitID INT,
    classID INT,
    FOREIGN KEY (visitID) REFERENCES Gym_Visits(visitID),
    FOREIGN KEY (classID) REFERENCES Classes(classID)
);


INSERT INTO Members (first_name, last_name, email, phone) VALUES
('Vlada', 'Hamon', 'ladusya@gmail.com', '5374-114'),
('Alyona', 'Parkhomets', 'allyioz@gmail.com', '6374-297'),
('My', 'Boo', 'myboo@gmail.com', '354-2837'),
('My', 'Mom', 'maryna@gmail.com', '555-4321'),
('My', 'Dad', 'serg@gmail.com', '3765-483');


INSERT INTO Coaches (coach_name, class_type) VALUES
('Vanya', 'Cardio'),
('Max', 'Yoga'),
('Alyona', 'Strength Training'),
('Daria', 'Pilates');

INSERT INTO Classes (class_name, class_time, coachID) VALUES
('Cardio', '09:00:00', 1),
('Yoga', '10:00:00', 2),
('Strength', '12:00:00', 3),
('Pilates', '19:30:00', 4);


INSERT INTO Memberships (memberID, start_date, end_date, price) VALUES
(1, '2024-01-01', '2024-03-31', 150.00), 
(2, '2024-02-01', '2024-12-31', 500.00), 
(3, '2024-03-01', '2024-06-30', 180.00), 
(4, '2024-04-01', '2024-07-31', 200.00), 
(1, '2024-04-01', '2024-12-31', 400.00), 
(3, '2024-07-01', '2024-09-30', 120.00), 
(5, '2024-09-01', '2025-08-31', 600.00);

INSERT INTO Gym_Visits (memberID, visit_date, duration) VALUES
(1, '2024-08-01', 1.50),
(1, '2024-08-05', 2.00),
(2, '2024-08-10', 1.00),
(3, '2024-08-15', 1.50),
(4, '2024-08-20', 2.50),
(5, '2024-08-25', 3.00);


INSERT INTO Class_Attendances (visitID, classID) VALUES
(1, 1), 
(2, 2), 
(3, 1), 
(4, 3), 
(5, 4), 
(6, 2);

SELECT 
    m.first_name, 
    m.last_name, 
    c.class_name, 
    co.coach_name, 
    COUNT(gv.visitID) AS total_visits,
    SUM(gv.duration) AS total_hours,
    mem.price AS membership_fee
FROM 
    Members m
JOIN 
    Gym_Visits gv ON m.MemberID = gv.memberID
JOIN 
    Class_Attendances ca ON gv.visitID = ca.visitID
JOIN 
    Classes c ON ca.classID = c.classID
JOIN 
    Coaches co ON co.coachID = c.coachID
JOIN 
    Memberships mem ON mem.memberID = m.MemberID
WHERE 
    gv.visit_date BETWEEN '2024-01-01' AND '2024-12-31'
GROUP BY 
    m.first_name, 
    m.last_name, 
    c.class_name, 
    co.coach_name, 
    mem.price
ORDER BY 
    total_visits DESC, 
    total_hours DESC;
WITH VisitDurations AS (
    SELECT memberID, SUM(duration) AS total_hours
    FROM Gym_Visits
    GROUP BY memberID
)
SELECT m.first_name, m.last_name, vd.total_hours
FROM Members m
JOIN VisitDurations vd ON m.MemberID = vd.memberID;



  
   

    
