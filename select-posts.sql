select post_title as title, post_date as date, post_content as Content from wp_posts where post_type LIKE 'post' and post_status = 'publish' group by post_title order by post_date DESC\G;
