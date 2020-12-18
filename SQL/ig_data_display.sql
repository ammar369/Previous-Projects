#1- show 5 oldest users
SELECT * FROM users
ORDER BY created_at
Limit 5;

#2- show day of week most users registered on
# 1 = sunday, 7 = saturday for DAYOFWEEK()
SELECT
    DAYNAME(created_at) AS day,
    COUNT(*) AS total
FROM users
GROUP BY day
ORDER BY total DESC;


#3- display users who haven't posted any photos
SELECT 
    users.username,
    photos.image_url
FROM users
LEFT JOIN photos
    ON users.id = photos.user_id
    WHERE photos.id IS NULL;
    
    
#4- most popular photo and who posted it
SELECT
    users.username,
    photos.image_url,
    COUNT(*) AS total_likes
FROM photos
INNER JOIN likes
    ON likes.photo_id = photos.id
INNER JOIN users
    ON users.id = photos.user_id
GROUP BY photos.id
ORDER BY total_likes DESC
LIMIT 1;


#5- how many times does the average user post (total photos/ total users)
SELECT
    (SELECT COUNT(*) FROM photos) / (SELECT COUNT(*) FROM users) AS avg_count;


#6- top 5 most used hashtags
SELECT 
    tag_id,
    COUNT(*) AS tag_count
FROM photo_tags 
GROUP BY tag_id
ORDER BY tag_count DESC
LIMIT 5;

#7-find users that have liked every photo
SELECT 
    username,
    COUNT(*) AS num_likes
FROM likes
INNER JOIN users
    ON users.id = likes.user_id
GROUP BY user_id
HAVING num_likes = (SELECT COUNT(*) FROM photos);


#8- find users who haven't commented on any photo
SELECT
    users.username
FROM users
LEFT JOIN comments
    ON comments.user_id = users.id
    WHERE comments.id IS NULL;

    
#9- percentage of users who have never commented on a photo OR commented on every photo
SELECT (
(SELECT COUNT(*) FROM (
    SELECT
        COUNT(DISTINCT comments.photo_id) AS commented_pics
    FROM users
    LEFT JOIN comments
        ON comments.user_id = users.id
    GROUP BY users.id
    HAVING 
        commented_pics = (SELECT COUNT(*) FROM photos)    OR
        commented_pics = 0
) AS num_celeb_or_bot)
    
/
    
(SELECT COUNT(*) FROM users)
    
*
    
(SELECT 100)
    ) AS percent_celeb_or_bot;

#shows users with comments on every photo
SELECT
    users.id,
    users.username,
    COUNT(DISTINCT comments.photo_id) AS commented_pics
FROM users
LEFT JOIN comments
    ON comments.user_id = users.id
GROUP BY users.id
HAVING commented_pics = (SELECT COUNT(*) FROM photos);

#shows if any user commented on the same photo more than once
SELECT 
    users.id,
    comments.photo_id,
    COUNT(*) as num_comments
FROM comments
INNER JOIN users
    ON users.id = comments.user_id
GROUP BY users.id, comments.photo_id
HAVING num_comments > 1;
