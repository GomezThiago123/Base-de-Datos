select * from crime_scene_report
WHERE date = 20180115 AND type like "MURDER" AND city like 'sql city'

/*date	    type	        description	                                          city
20180115	murder	Security footage shows that there were 2 witnesses. 
The first witness lives at the last house on "Northwestern Dr".
 The second witness, named Annabel, lives somewhere on "Franklin Ave".	SQL City*/

select * from person
where name like "annabel%" and address_street_name like "Franklin Ave"

/*id	name	license_id	address_number	address_street_name	ssn
16371	Annabel Miller	490173	103	Franklin Ave	318771143*/

 select * from person
where address_street_name like "Northwestern Dr"
ORDER BY address_number DESC limit 1;

/*id	name	license_id	address_number	address_street_name	ssn
14887	Morty Schapiro	118009	4919	Northwestern Dr	111564949*/

select * from interview i
inner join person p ON p.id = i.person_id 
where name like "annabel miller" or name like "Morty Schapiro"

/*person_id	transcript	id	name	license_id	address_number	address_street_name	ssn
14887	I heard a gunshot and then saw a man run out. 
He had a "Get Fit Now Gym" bag. The membership number on the bag started with "48Z".
 Only gold members have those bags. The man got into a car with a plate that included "H42W".
 	14887	Morty Schapiro	118009	4919	Northwestern Dr	111564949


16371	I saw the murder happen, 
and I recognized the killer from my gym when I was working out last week on January the 9th.
	16371	Annabel Miller	490173	103	Franklin Ave	318771143*/

select * from get_fit_now_member gm
inner join person p ON p.id = gm.person_id 
inner join drivers_license dl ON p.license_id = dl.id
WHERE dl.plate_number like '%H42W%' AND gm.id like '48Z%' AND membership_status = 'gold'

/*id	person_id	name	membership_start_date	membership_status	id	name	license_id	address_number	address_street_name	ssn	id	age	height	eye_color	hair_color	gender	plate_number	car_make	car_model
48Z55	67318	Jeremy Bowers	20160101	gold	67318	Jeremy Bowers	423327	530	Washington Pl, Apt 3A	871539279	423327	30	70	brown	brown	male	0H42W2	Chevrolet	Spark LS*/

select * from interview i
inner join person p ON p.id = i.person_id 
where name like "Jeremy Bowers"

/*I was hired by a woman with a lot of money. 
I don't know her name but I know she's around 5'5" (65") or 5'7" (67").
 She has red hair and she drives a Tesla Model S. 
I know that she attended the SQL Symphony Concert 3 times in December 2017.*/

select * from person p
inner join drivers_license dl ON dl.id = p.license_id
inner join facebook_event_checkin fc ON fc.person_id = p.id
where car_make like "tesla" AND car_model = "Model S" AND (height BETWEEN 65 AND 67) AND hair_color = "red" 
AND fc.event_name like "SQL Symphony Concert"

/*name             dato:
  Miranda Priestly Fue a un concierto 3 veces en diciembre*/

  