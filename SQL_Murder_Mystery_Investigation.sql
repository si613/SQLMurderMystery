-- A crime has taken place and the detective needs your help. The detective gave you the crime scene report, but you somehow lost it. 
-- You vaguely remember that the crime was a ?murder? that occurred sometime on ?Jan.15, 2018,? and that it took place in ?SQL City?. 
-- Start by retrieving the corresponding crime scene report from the police department’s database.

SELECT * FROM CRIME_SCENE_REPORT
WHERE DATE=20180115
AND CITY LIKE 'SQL CITY'
AND TYPE LIKE 'MURDER'

--Security footage shows that there were 2 witnesses. The first witness lives at the last house on "Northwestern Dr". 
--The second witness, named Annabel, lives somewhere on "Franklin Ave".

SELECT * FROM PERSON
WHERE ADDRESS_STREET_NAME LIKE 'NORTHWESTERN DR'
ORDER BY ADDRESS_NUMBER ASC

-- 14887	Morty Schapiro	118009	4919	Northwestern Dr	111564949

SELECT * FROM PERSON
WHERE ADDRESS_STREET_NAME LIKE 'FRANKLIN AVE'
AND NAME LIKE '%ANNABEL%'

-- 16371	Annabel Miller	490173	103	Franklin Ave	318771143

-- Since these are the two witnesses, let us now investigate if they gave an interview:

SELECT * FROM INTERVIEW
WHERE PERSON_ID=14887 
OR PERSON_ID=16371

--Morty's interview:
--I heard a gunshot and then saw a man run out. He had a "Get Fit Now Gym" bag. 
--The membership number on the bag started with "48Z". 
--Only gold members have those bags. The man got into a car with a plate that included "H42W".

--Annabel's interview: 
--I saw the murder happen, and I recognized the killer from my gym when I was working out last week on January the 9th.


--Here, we have several clues regarding the killer's gym membership, car license number and the killer's gym checkin on January 9th.

SELECT * FROM get_fit_now_member
WHERE ID LIKE '48Z%'
AND MEMBERSHIP_STATUS LIKE 'GOLD'

--48Z55	67318	Jeremy Bowers	20160101	gold

-- Let us cross check Jeremy's car details as well

SELECT * FROM PERSON
WHERE ID=67318

SELECT * FROM DRIVERS_LICENSE 
WHERE ID=423327

--Crosschecking the witness' description of car plate number
SELECT * FROM DRIVERS_LICENSE 
WHERE PLATE_NUMBER LIKE '%H42W%'

-- Investigating Morty's statements, our suspect is Jeremy Bowers

--Let us investigate Annabel's claims as well


SELECT * FROM get_fit_now_check_in
WHERE CHECK_IN_DATE=20180109

--Jeremy is now our prime suspect as both witness claims match

-- As a final confirmation, let us check where the witnesses themselves were on the day of the murder

SELECT * FROM facebook_event_checkin
WHERE PERSON_ID=16371 -- Annabel (witness)
OR PERSON_ID= 14887 -- Morty (witness)
OR PERSON_ID= 67318 -- Jeremy (prime suspect)


--Our killer is most likely to be Jeremy Bowers


--Checking the solution (as specified by the trigger)

INSERT INTO solution VALUES (1, 'Jeremy Bowers');
SELECT value FROM solution;

--The message received was:- 

--Congrats, you found the murderer! 
--But wait, there's more... If you think you're up for a challenge, try querying the interview transcript of the murderer to find the real villain behind this crime. 
--If you feel especially confident in your SQL skills, try to complete this final step with no more than 2 queries. 
--Use this same INSERT statement with your new suspect to check your answer.  


--From our earlier investigation, we stumbled upon Jeremy's check-in at the SQL Symphony Concert. We will hold onto that lead for now

--Checking Jeremy's interview

SELECT * FROM INTERVIEW
WHERE PERSON_ID=67318

--His Interview:- 
-- I was hired by a woman with a lot of money. I don't know her name but I know she's around 5'5" (65") or 5'7" (67"). 
-- She has red hair and she drives a Tesla Model S. I know that she attended the SQL Symphony Concert 3 times in December 2017.  

--Investigating the leads given by Jeremy Bowers:

SELECT * FROM DRIVERS_LICENSE 
WHERE GENDER LIKE 'FEMALE'
AND HAIR_COLOR LIKE 'RED'
AND CAR_MAKE LIKE 'TESLA'
AND CAR_MODEL LIKE 'MODEL S'

--202298	68	66	green	red	female	500123	Tesla	Model S
--291182	65	66	blue	red	female	08CM64	Tesla	Model S
--918773	48	65	black	red	female	917UU3	Tesla	Model S
-- We have narrowed it down to THREE people. 

--Let us crosscheck Jeremy's claims and the person's details

SELECT * FROM PERSON 
WHERE LICENSE_ID=202298
OR LICENSE_ID=291182
OR LICENSE_ID=918773

--78881	Red Korb	918773	107	Camerata Dr	961388910
--90700	Regina George	291182	332	Maple Ave	337169072
--99716	Miranda Priestly	202298	1883	Golden Ave	987756388

--Checking their wealth

SELECT * FROM INCOME 
WHERE SSN=961388910
OR SSN=337169072
OR SSN=987756388

-- Income = 
--278000 (wealthy, assuming USD) - red korb
--310,000 (wealthier, assuming USD) - miranda priestly

-- Miranda is more of a suspect here, but checking for both:-


SELECT * FROM facebook_event_checkin
WHERE EVENT_NAME LIKE 'SQL SYMPHONY CONCERT'
AND DATE LIKE '201712%' 
AND (PERSON_ID = 78881 --redkorb
OR PERSON_ID=99716) --miranda

-- From our earlier lead, we noticed Jeremy Bowers attended the SQL Symphony concert at 20171206. 
--This matches Miranda's location and date as well.

--Our mastermind is Miranda. Let's confirm

INSERT INTO solution VALUES (1, 'Miranda Priestly');
SELECT value FROM solution;

--The message received was:-
--Congrats, you found the brains behind the murder! 
--Everyone in SQL City hails you as the greatest SQL detective of all time. 
--Time to break out the champagne!