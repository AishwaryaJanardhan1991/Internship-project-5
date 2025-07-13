create database itunemusic;
use itunemusic;

create table album (
album_id int,
title varchar (500),
artist_id int 
);
desc album;


load data infile "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Project files internship/Dataset/album(in).csv"
into table album
character set utf8mb4
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\r\n'
ignore 1 rows;
select * from album;

create table artist (
artist_id int primary key,
name varchar (250));
desc artist;

load data infile "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Project files internship/Dataset/artist 1(in).csv"
into table artist
character set utf8mb4
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\r\n'
ignore 1 rows;
select * from artist;

create table customer (
customer_id int,
first_name varchar (200),
last_name varchar (200),
company varchar (200),
address varchar (250),
city varchar (100),
state varchar(150) null,
country varchar (100),
postal_code varchar (100) null,
phone varchar (50) null,
fax varchar (100) null,
email varchar (100),
support_rep_id int null);
desc customer;

load data infile "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Project files internship/Dataset/customer(in).csv"
into table customer
character set utf8mb4
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\r\n'
ignore 1 rows;
select * from customer;

create table employee (
employee_id int,
last_name varchar(50),
first_name varchar (50),
title varchar (150),
reports_to varchar(10) null,
levels varchar(5),
birthdate datetime,
hire_date datetime,
address varchar(200),
city varchar(100),
state varchar (10),
country varchar(70),
postal_code varchar(50),
phone varchar(20),
fax varchar(50),email varchar(100));
desc employee;

load data infile "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Project files internship/Dataset/employee 2(in).csv"
into table employee
character set utf8mb4
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\r\n'
ignore 1 rows;
select * from employee;

create table genre (
genre_id int,
name varchar (50));
desc genre;

load data infile "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Project files internship/Dataset/genre.csv"
into table genre
character set utf8mb4
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\r\n'
ignore 1 rows;
select * from genre;

create table invoice_line (
invoice_line_id int,
invoice_id int,
track_id int,
unit_price float,
quantity int);
desc invoice_line;

load data infile "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Project files internship/Dataset/invoice_line.csv"
into table invoice_line
character set utf8mb4
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\r\n'
ignore 1 rows;
select * from invoice_line;

create table invoice (
invoice_id int,
customer_id int,
invoice_date datetime,
billing_address varchar(200),
billing_city varchar(50),
billing_state varchar(20),
billing_country varchar (50),
billing_postal_code varchar(75),
total float);
desc invoice;

load data infile "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Project files internship/Dataset/invoice.csv"
into table invoice
character set utf8mb4
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\r\n'
ignore 1 rows;
select * from invoice;

create table media_type (
media_type_id int,
name varchar(150));
desc media_type;

load data infile "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Project files internship/Dataset/media_type.csv"
into table media_type
character set utf8mb4
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\r\n'
ignore 1 rows;
select * from media_type;

create table playlist_track (
playlist_id int,
track_id int);
desc playlist_track;

load data infile "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Project files internship/Dataset/playlist_track.csv"
into table playlist_track
character set utf8mb4
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\r\n'
ignore 1 rows;
select * from playlist_track;

create table playlist (
playlist_id int,
name varchar (100));
desc playlist;

load data infile "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Project files internship/Dataset/playlist.csv"
into table playlist
character set utf8mb4
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\r\n'
ignore 1 rows;
select * from playlist;

-- adding one more column name track
create table track (
track_id int,
name varchar (200),
album_id int,
media_type_id int,
genre_id int,
composer varchar (250),
milliseconds int,
bytes int,
unit_price float);
desc track;

load data infile "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Project files internship/Dataset/track.csv" 
into table track
character set utf8mb4
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\r\n'
ignore 1 rows;
select * from track;

alter table album
add foreign key (artist_id) references artist(artist_id);


-- Artist & Album Overview
-- How many albums does each artist have?
select ar.name as artist_name, count(al.album_id) as total_albums
from artist ar
join album al on ar.artist_id = al.artist_id
group by ar.artist_id
order by total_albums desc
limit 10;

-- Track Revenue Analysis
--  Which tracks generated the most revenue?
select
t.name as track_name,
sum(il.unit_price * il.quantity) as total_revenue
from track t
join invoice_line il on t.track_id = il.track_id
group by t.track_id, t.name
order by total_revenue desc
limit 10;

-- Invoice Trend by Country
-- Revenue generated by country
select 
i.billing_country,
sum(i.total) as total_revenue
from invoice i
group by i.billing_country
order by total_revenue desc;

-- genre popularity
-- which genres are most popular based on track count?
select g.genre_id, g.name as genre,
count(t.track_id) as total_tracks
from genre g
join track t on g.genre_id = t.genre_id
group by g.genre_id, g.name
order by total_tracks desc;

-- Media type Analysis
-- Distribution of track by media
select 
m.name as media_type, count(t.track_id) as track_count
from media_type m
join track t on m.media_type_id = t.media_type_id
group by m.media_type_id, m.name
order by track_count desc;

-- Top customers by spending
-- who are the highest paying customers?
select c.first_name, c.last_name,
sum(i.total) as total_spent
from customer c
join invoice i on c.customer_id = i.customer_id
group by c.customer_id, c.first_name, c.last_name
order by total_spent desc
limit 10;

-- playlist insights
-- which playlist have most tracks
select 
p.name as playlist_name,
count(pt.track_id) as track_count
from playlist p
join playlist_track pt on p.playlist_id = pt.playlist_id
group by p.playlist_id, p.name
order by track_count desc;