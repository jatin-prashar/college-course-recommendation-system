-- Create students table
CREATE TABLE students (
    student_id VARCHAR(10) PRIMARY KEY,
    name VARCHAR(100),
    major VARCHAR(50),
    year INT,
    cgpa NUMERIC(3, 2)
);

-- Create courses table
CREATE TABLE courses (
    course_id VARCHAR(10) PRIMARY KEY,
    name VARCHAR(100),
    department VARCHAR(50),
    level VARCHAR(20),
    category VARCHAR(50)
);

-- Create enrollments table
CREATE TABLE enrollments (
    student_id VARCHAR(10),
    course_id VARCHAR(10),
    grade NUMERIC(3, 1),
    PRIMARY KEY (student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);

-- Create interests table
CREATE TABLE interests (
    student_id VARCHAR(10),
    interest_area VARCHAR(50),
    FOREIGN KEY (student_id) REFERENCES students(student_id)
);

-- Insert sample data into students
INSERT INTO students VALUES 
('S001', 'Aarav Mehta', 'Computer Science', 2, 8.5),
('S002', 'Sara Iqbal', 'IT', 3, 9.1),
('S003', 'Rohan Verma', 'Electronics', 1, 7.8);

-- Insert sample data into courses
INSERT INTO courses VALUES 
('C101', 'Introduction to AI', 'Computer Science', 'Basic', 'AI'),
('C102', 'Deep Learning', 'Computer Science', 'Advanced', 'AI'),
('C103', 'Web Development', 'IT', 'Intermediate', 'Web Dev'),
('C104', 'Financial Analytics', 'Management', 'Advanced', 'Finance');

-- Insert sample data into enrollments
INSERT INTO enrollments VALUES 
('S001', 'C101', 9.0),
('S002', 'C102', 8.5),
('S003', 'C103', 7.0),
('S001', 'C103', 8.0);

-- Insert sample data into interests
INSERT INTO interests VALUES 
('S001', 'AI'),
('S001', 'Web Dev'),
('S002', 'AI'),
('S003', 'Finance');

 -- What courses are most popular?
 SELECT c.name AS course_name, COUNT(*) AS total_enrollments
FROM enrollments e
JOIN courses c ON e.course_id = c.course_id
GROUP BY c.name
ORDER BY total_enrollments DESC;

-- Which courses have the highest average grades?
SELECT c.name AS course_name, ROUND(AVG(e.grade), 2) AS avg_grade
FROM enrollments e
JOIN courses c ON e.course_id = c.course_id
GROUP BY c.name
ORDER BY avg_grade DESC;

-- Top-performing students and what they study
SELECT name, major, cgpa
FROM students
ORDER BY cgpa DESC
LIMIT 5;

 -- Are students pursuing courses aligned with their interests?
 SELECT s.name, i.interest_area, c.name AS enrolled_course
FROM students s
JOIN interests i ON s.student_id = i.student_id
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON c.course_id = e.course_id
WHERE i.interest_area = c.category;

 -- Course Recommendation Engine
 SELECT c.course_id, c.name AS recommended_course
FROM courses c
JOIN interests i ON c.category = i.interest_area
WHERE i.student_id = 'S001'
AND c.course_id NOT IN (
    SELECT course_id FROM enrollments WHERE student_id = 'S001'
);

-- What electives are top 10% students taking?
SELECT c.name, COUNT(*) AS top_student_count
FROM enrollments e
JOIN students s ON s.student_id = e.student_id
JOIN courses c ON c.course_id = e.course_id
WHERE s.cgpa >= (
    SELECT PERCENTILE_CONT(0.9) WITHIN GROUP (ORDER BY cgpa)
    FROM students
)
GROUP BY c.name
ORDER BY top_student_count DESC;

 -- Identify weak performers in each course
SELECT s.name, c.name AS course_name, e.grade,
ROUND(AVG(e.grade) OVER (PARTITION BY c.course_id), 2) AS avg_grade
FROM enrollments e
JOIN students s ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id
ORDER BY c.name, e.grade;

 -- Top ranked students within departments
 SELECT student_id, name, major, cgpa,
       RANK() OVER (PARTITION BY major ORDER BY cgpa DESC) AS dept_rank
FROM students
ORDER BY major, dept_rank;
