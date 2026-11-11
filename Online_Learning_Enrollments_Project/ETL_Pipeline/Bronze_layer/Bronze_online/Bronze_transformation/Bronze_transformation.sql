CREATE OR REFRESH streaming table bronze_online_enrollments AS 
select *,
       _metadata.file_name AS source_file,
       current_timestamp() AS loaded_at
       FROM STREAM read_files('/Volumes/online_learning_enrollment_project/default/online_volume/',
       format => 'csv',
       header => 'true');



