College Course Recommendation System (SQL Project)
This project uses PostgreSQL to create a full-featured data analysis and recommendation system for students based on their academic performance, interests, and course history. It demonstrates SQL concepts from beginner to advanced, including JOINS, window functions, Common Table Expressions (CTEs), and subqueries.

🛠️ Built With

PostgreSQL (tested on version 13+)

pgAdmin 4

SQL (Standard with PostgreSQL extensions)

CSV-based dataset (200 students, 20 courses, 500+ enrollments)

📁 Project Structure

File	Description
students.csv	Contains 200 student records
courses.csv	Contains 20 available course entries
enrollments.csv	Contains 500+ course enrollment records
interests.csv	Students' preferred course categories
SQL queries	Joins, Window Functions, CTEs for insights

📊 Schema Overview

🧑 students

student_id (PK)

name

major

year

cgpa

📘 courses

course_id (PK)

name

department

level

category

📝 enrollments

student_id (FK)

course_id (FK)

grade

❤️ interests

student_id (FK)

interest_area

🧠 Key SQL Features Covered

✅ Basic Queries

SELECT, WHERE, ORDER BY, GROUP BY

COUNT, AVG, ROUND

✅ Joins

INNER JOIN

LEFT JOIN, RIGHT JOIN

FULL OUTER JOIN

✅ Window Functions

RANK, DENSE_RANK, ROW_NUMBER

AVG() OVER(PARTITION BY ...)

Comparison with course average

✅ CTEs (Common Table Expressions)

Subqueries with WITH

Filtering after window functions

Building reusable views for recommendations

✅ Example: Identify Students Below Course Average

This query finds students whose grade in a course is lower than the average grade for that course.

WITH course_grades AS (
SELECT
s.name,
c.name AS course_name,
e.grade,
ROUND(AVG(e.grade) OVER (PARTITION BY c.course_id), 2) AS avg_grade
FROM enrollments e
JOIN students s ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id
)
SELECT *
FROM course_grades
WHERE grade < avg_grade
ORDER BY course_name, grade;

🧠 Sample Analysis Tasks

Top courses by popularity (enrollments)

Highest average grade courses

Personalized course recommendations

Students misaligned with their interests

Department-wise CGPA rankings

🚀 How to Run This Project

Import the CSVs into PostgreSQL using pgAdmin 4 or psql

Create tables with appropriate constraints (see schema above)

Load sample data:

Right-click → Import/Export → CSV

Run queries from the SQL Query Tool in pgAdmin

📝 License

This project is free for educational and academic use.

📬 Contact

