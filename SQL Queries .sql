use india_election_results;
CREATE TABLE constituencywise_details (
    Serial_No INT,
    Candidate VARCHAR(100),
    Party VARCHAR(100),
    EVM_Votes INT,
    Postal_Votes INT,
    Total_Votes INT,
    Percentage_of_Votes DECIMAL(5,2),
    Constituency_ID VARCHAR(50)
);


LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/constituencywise_details.csv'
INTO TABLE constituencywise_details
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;
ALTER TABLE `india_election_results`.`constituencywise_results` 
CHANGE COLUMN `Parliament Constituency` `Parliament Constituency` VARCHAR(255) NOT NULL,
CHANGE COLUMN `Constituency ID` `Constituency ID` VARCHAR(100) NOT NULL,
ADD PRIMARY KEY (`Parliament Constituency`, `Constituency ID`);
-- 1 Total Seats
SELECT distinct count(Parliament_Constituency )AS Total_Seats from constituencywise_results; 

-- 2 What is the total number of seats available for elections in each state-- 
SELECT S.State as State_Name, count(CR.Parliament_Constituency )AS Total_Seats 
FROM constituencywise_results CR INNER JOIN statewise_results SR
ON CR.Parliament_Constituency =SR.Parliament_Constituency
INNER JOIN states S ON SR.state_ID = S.state_ID
GROUP BY S.state
ORDER BY S.state asc;


-- 3 Total Seats Won by NDA Allianz
 SELECT 
    SUM(CASE 
            WHEN party IN (
                'Bharatiya Janata Party - BJP', 
                'Telugu Desam - TDP', 
				'Janata Dal  (United) - JD(U)',
                'Shiv Sena - SHS', 
                'AJSU Party - AJSUP', 
                'Apna Dal (Soneylal) - ADAL', 
                'Asom Gana Parishad - AGP',
                'Hindustani Awam Morcha (Secular) - HAMS', 
                'Janasena Party - JnP', 
				'Janata Dal  (Secular) - JD(S)',
                'Lok Janshakti Party(Ram Vilas) - LJPRV', 
                'Nationalist Congress Party - NCP',
                'Rashtriya Lok Dal - RLD', 
                'Sikkim Krantikari Morcha - SKM'
            ) THEN Won
            ELSE 0 
        END) AS NDA_Total_Seats_Won
FROM 
    partywise_results;


-- 4 Seats Won by NDA Allianz Parties

SELECT 
Party as Party_Name,
Won as Seats_Won
FROM 
    partywise_results
where Party IN (
                'Bharatiya Janata Party - BJP', 
                'Telugu Desam - TDP', 
				'Janata Dal  (United) - JD(U)',
                'Shiv Sena - SHS', 
                'AJSU Party - AJSUP', 
                'Apna Dal (Soneylal) - ADAL', 
                'Asom Gana Parishad - AGP',
                'Hindustani Awam Morcha (Secular) - HAMS', 
                'Janasena Party - JnP', 
				'Janata Dal  (Secular) - JD(S)',
                'Lok Janshakti Party(Ram Vilas) - LJPRV', 
                'Nationalist Congress Party - NCP',
                'Rashtriya Lok Dal - RLD', 
                'Sikkim Krantikari Morcha - SKM')
order by Seats_Won desc;

-- 5 Total Seats Won by I.N.D.I.A. Allianz
SELECT SUM(CASE WHEN Party IN (
                'Indian National Congress - INC',
                'Aam Aadmi Party - AAAP',
                'All India Trinamool Congress - AITC',
                'Bharat Adivasi Party - BHRTADVSIP',
                'Communist Party of India  (Marxist) - CPI(M)',
                'Communist Party of India  (Marxist-Leninist)  (Liberation) - CPI(ML)(L)',
                'Communist Party of India - CPI',
                'Dravida Munnetra Kazhagam - DMK',
                'Indian Union Muslim League - IUML',
                'Nat`Jammu & Kashmir National Conference - JKN',
                'Jharkhand Mukti Morcha - JMM',
                'Jammu & Kashmir National Conference - JKN',
                'Kerala Congress - KEC',
                'Marumalarchi Dravida Munnetra Kazhagam - MDMK',
                'Nationalist Congress Party Sharadchandra Pawar - NCPSP',
                'Rashtriya Janata Dal - RJD',
                'Rashtriya Loktantrik Party - RLTP',
                'Revolutionary Socialist Party - RSP',
                'Samajwadi Party - SP',
                'Shiv Sena (Uddhav Balasaheb Thackrey) - SHSUBT',
                'Viduthalai Chiruthaigal Katchi - VCK'
            ) THEN Won
            ELSE 0 
        END) AS INDIA_Total_Seats_Won
FROM partywise_results;
    
    
-- 6 Seats Won by I.N.D.I.A. Allianz Parties
SELECT 
Party as Party_Name,
Won as Seats_Won
FROM partywise_results
where Party IN (
                'Indian National Congress - INC',
                'Aam Aadmi Party - AAAP',
                'All India Trinamool Congress - AITC',
                'Bharat Adivasi Party - BHRTADVSIP',
                'Communist Party of India  (Marxist) - CPI(M)',
                'Communist Party of India  (Marxist-Leninist)  (Liberation) - CPI(ML)(L)',
                'Communist Party of India - CPI',
                'Dravida Munnetra Kazhagam - DMK',
                'Indian Union Muslim League - IUML',
                'Nat`Jammu & Kashmir National Conference - JKN',
                'Jharkhand Mukti Morcha - JMM',
                'Jammu & Kashmir National Conference - JKN',
                'Kerala Congress - KEC',
                'Marumalarchi Dravida Munnetra Kazhagam - MDMK',
                'Nationalist Congress Party Sharadchandra Pawar - NCPSP',
                'Rashtriya Janata Dal - RJD',
                'Rashtriya Loktantrik Party - RLTP',
                'Revolutionary Socialist Party - RSP',
                'Samajwadi Party - SP',
                'Shiv Sena (Uddhav Balasaheb Thackrey) - SHSUBT',
                'Viduthalai Chiruthaigal Katchi - VCK')
order by Seats_Won desc;

-- 7 Add new column field in table partywise_results to get the Party Allianz as NDA, I.N.D.I.A and OTHER 
ALTER TABLE partywise_results 
ADD party_alliance VARCHAR(50);
-- Step 1: Disable safe updates
SET SQL_SAFE_UPDATES = 0;
-- I.N.D.I.A Allianz
UPDATE partywise_results
SET party_alliance = 'I.N.D.I.A'
WHERE party IN (
    'Indian National Congress - INC',
    'Aam Aadmi Party - AAAP',
    'All India Trinamool Congress - AITC',
    'Bharat Adivasi Party - BHRTADVSIP',
    'Communist Party of India  (Marxist) - CPI(M)',
    'Communist Party of India  (Marxist-Leninist)  (Liberation) - CPI(ML)(L)',
    'Communist Party of India - CPI',
    'Dravida Munnetra Kazhagam - DMK',	
    'Indian Union Muslim League - IUML',
    'Jammu & Kashmir National Conference - JKN',
    'Jharkhand Mukti Morcha - JMM',
    'Kerala Congress - KEC',
    'Marumalarchi Dravida Munnetra Kazhagam - MDMK',
    'Nationalist Congress Party Sharadchandra Pawar - NCPSP',
    'Rashtriya Janata Dal - RJD',
    'Rashtriya Loktantrik Party - RLTP',
    'Revolutionary Socialist Party - RSP',
    'Samajwadi Party - SP',
    'Shiv Sena (Uddhav Balasaheb Thackrey) - SHSUBT',
    'Viduthalai Chiruthaigal Katchi - VCK'
);
-- NDA Allianz
UPDATE partywise_results
SET party_alliance = 'NDA'
WHERE party IN (
    'Bharatiya Janata Party - BJP',
    'Telugu Desam - TDP',
    'Janata Dal  (United) - JD(U)',
    'Shiv Sena - SHS',
    'AJSU Party - AJSUP',
    'Apna Dal (Soneylal) - ADAL',
    'Asom Gana Parishad - AGP',
    'Hindustani Awam Morcha (Secular) - HAMS',
    'Janasena Party - JnP',
    'Janata Dal  (Secular) - JD(S)',
    'Lok Janshakti Party(Ram Vilas) - LJPRV',
    'Nationalist Congress Party - NCP',
    'Rashtriya Lok Dal - RLD',
    'Sikkim Krantikari Morcha - SKM'
);
-- OTHER
UPDATE partywise_results
SET party_alliance = 'OTHER'
WHERE party_alliance IS NULL;

-- 8 Which party alliance (NDA, I.N.D.I.A, or OTHER) won the most seats across all states?
SELECT party_alliance , sum(Won) as seats
from partywise_results 
group by party_alliance
order by seats desc ;


-- 9 Winning candidate's name, their party name, total votes, and the margin of victory for a specific state and constituency?
SELECT CR.Winning_Candidate, P.Party, P.party_alliance, CR.Total_Votes, CR.Margin, 
S.State, SA.Constituency
from constituencywise_results CR 
join partywise_results P on CR.Party_ID = P.Party_ID
join statewise_results SA on CR.Parliament_Constituency = SA.Parliament_Constituency 
join states S on SA.State_ID = S.State_ID
where S.State ="Uttar Pradesh" and SA.Constituency = "Hathras";

-- 10 What is the distribution of EVM votes versus postal votes for candidates in a specific constituency? 
select CD.EVM_Votes,
	   CD.Postal_Votes,
       CD.Total_Votes,
       CD.Candidate,
       CR.Constituency_Name
from constituencywise_results CR join constituencywise_details CD
on CR.Constituency_ID= CD.Constituency_ID
where CR.Constituency_Name="Hathras";

-- 11 Which parties won the most seats in a State, and how many seats did each party win?
 SELECT P.Party , COUNT(CR.Constituency_ID) as Seats_Won
 from constituencywise_results CR  
	join partywise_results P on CR.Party_ID = P.Party_ID
	join statewise_results SA on CR.Parliament_Constituency = SA.Parliament_Constituency 
	join states S on SA.State_ID = S.State_ID
    WHERE 
    s.state = 'Delhi' -- 'Uttar Pradesh'-- 
GROUP BY 
    p.Party
ORDER BY 
    Seats_Won DESC;
    
-- 12 What is the total number of seats won by each party alliance (NDA, I.N.D.I.A, and OTHER) in each state for the India Elections 2024
SELECT S.State, 
	  sum(CASE WHEN P.party_alliance='NDA' then 1 else 0 End) AS NDA_SEATS_WON,
      sum(CASE WHEN P.party_alliance='I.N.D.I.A' then 1 else 0 End) AS INDIA_SEATS_WON,
      sum(CASE WHEN P.party_alliance='OTHER' then 1 else 0 End) AS OTHER_SEATS_WON
FROM constituencywise_results CR  
	join partywise_results P on CR.Party_ID = P.Party_ID
	join statewise_results SA on CR.Parliament_Constituency = SA.Parliament_Constituency 
	join states S on SA.State_ID = S.State_ID
GROUP BY 
    S.State
ORDER BY 
    S.State; 
      
-- 13 Which candidate received the highest number of EVM votes in each constituency (Top 10)? 
SELECT 
    cr.Constituency_Name,
    cd.Constituency_ID,
    cd.Candidate,
    cd.EVM_Votes
FROM 
    constituencywise_details cd
JOIN (
    SELECT Constituency_ID, MAX(EVM_Votes) AS MaxVotes
    FROM constituencywise_details 
    GROUP BY Constituency_ID
) AS mv ON cd.Constituency_ID = mv.Constituency_ID AND cd.EVM_Votes = mv.MaxVotes
JOIN constituencywise_results cr ON cd.Constituency_ID = cr.Constituency_ID
ORDER BY cd.EVM_Votes DESC
LIMIT 10;

-- 14 Which candidate won and which candidate was the runner-up in each constituency of State for the 2024 elections?
WITH RANKEDCANDIDATE AS(
		SELECT cd.Constituency_ID,
			   cd.Candidate,
               cd.Party,
			   cd.EVM_Votes,
               cd.Postal_Votes,
               cd.Total_Votes ,
               row_number() OVER (partition by cd.Constituency_ID ORDER BY cd.Total_Votes desc) AS VOTERANK 
		FROM constituencywise_results CR 
			join constituencywise_details cd on cd.Constituency_ID = CR.Constituency_ID
			join statewise_results SA on CR.Parliament_Constituency = SA.Parliament_Constituency 
			join states S on SA.State_ID = S.State_ID
		    WHERE s.State = 'Delhi'
		)
SELECT  CR.Constituency_Name,
		MAX(case when VOTERANK= 1 THEN RC.Candidate END) AS Winning_Candidate,
        MAX(case when VOTERANK= 2 THEN RC.Candidate END) AS Runner_Up_Candidate
FROM RANKEDCANDIDATE RC
JOIN  constituencywise_results CR ON RC.Constituency_ID = CR.Constituency_ID
GROUP BY CR.Constituency_Name
ORDER BY CR.Constituency_Name;

-- 15 For the state of Maharashtra, what are the total number of seats, total number of candidates, total number of parties, 
-- total votes (including EVM and postal), and the breakdown of EVM and postal votes? 

SELECT COUNT(distinct cd.Constituency_ID) AS TOTAL_SEATS,
	   COUNT(distinct cd.Candidate) AS TOTAL_CANDIDATES,
	   COUNT(distinct P.Party) AS TOTAL_PARTIES,
	   SUM(cd.EVM_Votes) AS TOTAL_EVM_VOTES,
	   SUM(cd.Postal_Votes) AS TOTAL_POSTAL_VOTES,
	   SUM(cd.Total_Votes) AS TOTAL_VOTES 
FROM constituencywise_details cd
JOIN constituencywise_results cr ON cd.Constituency_ID= cr.Constituency_ID
join statewise_results SA on CR.Parliament_Constituency = SA.Parliament_Constituency 
join states S on SA.State_ID = S.State_ID
JOIN partywise_results p ON cr.Party_ID = p.Party_ID
WHERE s.State = 'Maharashtra';