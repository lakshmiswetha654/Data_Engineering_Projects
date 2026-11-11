# Project Review Questions and Answers
### Answers to the eight review questions from the Online Learning Enrollments Case Study, written in the context of this project (Lakeflow Spark Declarative Pipelines on Azure Databricks).
## 1. Why do we keep the raw data in Bronze instead of cleaning the file directly?
- We keep the original data in the Bronze layer because it helps us preserve the raw data without losing any information.
- If we make a mistake during cleaning, we can go back to the original data and process it again.
## 2.	Why do we use LOWER for emails but INITCAP for category names?
- *LOWER()* converts email addresses into lowercase to maintain consistency and avoid duplicate learner records.
- *INITCAP()* convert the category names into proper title case(camel case), making them more professional and consistent.
## 3.	How many learners were double-counted before the email fix, and why does it matter?
Before email fix 47 learners were double counted because their email addresses had different uppercase and lowercase formats.
After applying *Lower()*, both cases converts into lowercase. This prevent duplicate learner counting and gives accurate business report.
## 4.	Why can enrollment_id find duplicates but learner_email cannot?
- *enrollment_id* identifies each enrollment record uniquely, while email identifies the learner.
- One learner can enroll in multiple courses, so the same email can appears multiple times.
- Therefore, we use *enrollment_id* to identify duplicate enrollment records.
## 5.	Why are progress values of 0 and 100 valid, but 120 is rejected?
Progress represent the course completion percentage.
- 0 means the learner has not started.
- 100 means the learner has completed the course.
- 150 is invalid because progress cannot exceed 100%.
Therefore, we accept values between 0 to 100 and reject the values outside this range.
## 6.	Why do we leave a blank rating as NULL instead of replacing it with 0?
- NULL means the learner has not provided the rating.
- 0 means it is a actual numeric value the learner has given.
So, keeping NULL help us avoid incorrect average.
## 7.	Which category earns the most revenue, and which has the best completion rate?
**Data Science** category earns the most revenue and **Graphic Design**category has the best completion rate.
## 8.	Which dashboard tool did you choose, and why?
I selected Databricks AI/BI dashboard tool because it allow us to create interactive dashboards directly within the Databricks platform without needing a separate BI tool.
