
CREATE TABLE IF NOT EXISTS constituencywise_details (
s_n int,
candidate varchar(100),
Party varchar(100),
evm_votes int,
postal_votes int,
total_votes int,
percent_of_votes float,
contituency_id varchar(50)
);

SELECT * FROM constituencywise_details;


DROP TABLE IF EXISTS constituencywise_results;

CREATE TABLE IF NOT EXISTS constituencywise_results (
s_no int,
parliament_constituency varchar(100) UNIQUE,
constituency_name varchar(100),
winning_candidate varchar(100),
total_votes int,
margin int,
contituency_id varchar(100) PRIMARY KEY,
party_id int
);

SELECT * FROM constituencywise_results;

CREATE TABLE IF NOT EXISTS partywise_results (
party varchar(150),
won int,
party_id int PRIMARY KEY
);

SELECT * FROM partywise_results;


CREATE TABLE IF NOT EXISTS statewise_results (
constituency varchar(150),
const_no int,
parliament_constituency varchar(100) PRIMARY KEY,
leading_candidate varchar(150),
trailing_candidate varchar(150) NULL,
margin int,
status varchar(100),
state_id varchar(100),
states varchar(100)
);

SELECT * FROM  statewise_results;

CREATE TABLE IF NOT EXISTS states (
state_id varchar(100) PRIMARY KEY,
states varchar(100)
);

SELECT * FROM states;

--1.Total seats

SELECT DISTINCT COUNT(parliament_constituency) AS total_seats
FROM constituencywise_results;

--2. what are the total number of seats available for elcetions in each state.

SELECT s.states AS state_name,
COUNT(cr.parliament_constituency) AS Total_seats
FROM constituencywise_results cr
INNER JOIN statewise_results sr ON cr.parliament_constituency = sr.parliament_constituency
INNER JOIN states s ON sr.state_id = s.state_id
GROUP BY s.states;

--3. Tptal seats won by NDA Alliance.
SELECT
    SUM(won) AS nda_total_seats_won
FROM
    partywise_results
WHERE
    party IN (
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


--4. seats won by each NDA alliance parties
SELECT
    party AS party_name,
	won AS seats_won
FROM
    partywise_results
WHERE
    party IN (
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
    )
ORDER BY seats_won DESC;



--5. Total seats won by I.N.D.I.A alliance.

SELECT SUM (CASE WHEN party IN (
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
            ) 
            THEN won
            ELSE 0 
        END
    ) AS india_total_seats_won
FROM 
    partywise_results;


--6. seats won by each I.N.D.I.A ALLIANCE PARTIES.
SELECT party, won
FROM partywise_results   
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
            )
ORDER BY won DESC;


--7.Add new column field in table partywise_results to get the Party Alliance as NDA, I.N.D.I.A and OTHER
--creating a column
ALTER TABLE partywise_results
ADD party_alliance varchar(50);

SELECT * FROM partywise_results;

--to adding  values to the newly created column
--i.e., updating partywise table

--a). adding india alliance parties 

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

SELECT * FROM partywise_results;

--b).adding nda parties

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

--c)updating non alliance parties as others.
UPDATE partywise_results
SET party_alliance = 'OTHER'
WHERE party_alliance IS NULL;

SELECT * FROM partywise_results;

--8. Which party alliance (NDA, I.N.D.I.A, or OTHER) won the most seats across all states?

SELECT 
    p.party_alliance,
    COUNT(cr.contituency_id) AS seats_won
FROM 
    constituencywise_results cr
JOIN 
    partywise_results p ON cr.party_id = p.party_id
WHERE 
    p.party_alliance IN ('NDA', 'I.N.D.I.A', 'OTHER')
GROUP BY 
    p.party_alliance
ORDER BY 
    seats_won DESC;

--9.Winning candidate's name, their party name, total votes, and the margin of victory for a specific state and constituency?
SELECT cr.winning_candidate, p.party, p.party_alliance, cr.total_Votes, cr.margin, cr.constituency_name, s.states
FROM constituencywise_results cr
JOIN partywise_results p ON cr.party_id = p.party_id
JOIN statewise_results sr ON cr.parliament_constituency = sr.parliament_constituency
JOIN states s ON sr.state_id = s.state_id
WHERE s.states = 'Karnataka' AND cr.constituency_name = 'BANGALORESOUTH';


--10.What is the distribution of EVM votes versus postal votes for candidates in a specific constituency?
SELECT 
    cd.candidate,
    cd.party,
    cd.evm_votes,
    cd.postal_votes,
    cd.total_votes,
    cr.constituency_Name
FROM 
    constituencywise_details cd
JOIN 
    constituencywise_results cr ON cd.contituency_id = cr.contituency_id
WHERE 
    cr.constituency_name = 'CHITRADURGA'
ORDER BY cd.total_votes DESC;


--11.Which parties won the most seats in s State, and how many seats did each party win?

SELECT p.party,
COUNT(cr.contituency_id) AS seats_won
FROM constituencywise_results cr
JOIN partywise_results p ON cr.party_id = p.party_id
JOIN statewise_results sr ON cr.parliament_constituency = sr.parliament_constituency
JOIN states s ON sr.state_id = s.state_id
WHERE s.states = 'Karnataka'
GROUP BY p.party
ORDER BY seats_won DESC;

--12.What is the total number of seats won by each party alliance (NDA, I.N.D.I.A, and OTHER) in each state for the India Elections 2024
SELECT 
    s.states AS state_name,
    SUM(CASE WHEN p.party_alliance = 'NDA' THEN 1 ELSE 0 END) AS NDA_seats_won,
    SUM(CASE WHEN p.party_alliance = 'I.N.D.I.A' THEN 1 ELSE 0 END) AS INDIA_seats_won,
	SUM(CASE WHEN p.party_alliance = 'OTHER' THEN 1 ELSE 0 END) AS OTHER_seats_won
FROM 
    constituencywise_results cr
JOIN 
    partywise_results p ON cr.party_id = p.party_id
JOIN 
    statewise_results sr ON cr.parliament_constituency = sr.parliament_constituency
JOIN 
    states s ON sr.state_id = s.state_id
WHERE 
    p.party_alliance IN ('NDA', 'I.N.D.I.A',  'OTHER')  -- Filter for NDA and INDIA alliances
GROUP BY 
    s.states
ORDER BY 
    s.states;


--13.Which candidate received the highest number of EVM votes in each constituency (Top 10)?

SELECT 
    cr.constituency_name,
    cd.contituency_id,
    cd.candidate,
    cd.evm_votes
FROM 
    constituencywise_details cd
JOIN 
    constituencywise_results cr ON cd.contituency_id = cr.contituency_id
WHERE 
    cd.evm_votes = (
        SELECT MAX(cd1.evm_votes)
        FROM constituencywise_details cd1
        WHERE cd1.contituency_id = cd.Contituency_id
    )
ORDER BY 
    cd.evm_votes DESC LIMIT 10;

--14.Which candidate won and which candidate was the runner-up in each constituency of State for the 2024 elections?
WITH RankedCandidates AS (
    SELECT 
        cd.contituency_id, cd.candidate, cd.party, cd.evm_votes, cd.postal_votes,
        cd.evm_votes + cd.postal_votes AS total_votes,
    ROW_NUMBER() OVER (PARTITION BY cd.contituency_id ORDER BY cd.evm_votes + cd.postal_votes DESC) AS voterank
    FROM constituencywise_details cd
    JOIN constituencywise_results cr ON cd.contituency_id = cr.contituency_id
    JOIN statewise_results sr ON cr.parliament_constituency = sr.parliament_constituency
    JOIN states s ON sr.state_id = s.state_id
    WHERE s.states = 'Karnataka'
)

SELECT 
    cr.constituency_name,
    MAX(CASE WHEN rc.voterank = 1 THEN rc.candidate END) AS winning_candidate,
    MAX(CASE WHEN rc.voterank = 2 THEN rc.candidate END) AS runnerup_candidate
FROM RankedCandidates rc
JOIN constituencywise_results cr ON rc.contituency_id = cr.contituency_id
GROUP BY cr.constituency_name
ORDER BY cr.constituency_Name;

--15.For the state of karnataka, what are the total number of seats, total number of candidates, total number of parties, total votes (including EVM and postal), and the breakdown of EVM and postal votes?
SELECT 
    COUNT(DISTINCT cr.contituency_id) AS total_seats,
    COUNT(DISTINCT cd.candidate) AS total_candidates,
    COUNT(DISTINCT p.party) AS total_parties,
    SUM(cd.evm_votes + cd.postal_votes) AS total_votes,
    SUM(cd.evm_votes) AS total_evm_votes,
    SUM(cd.postal_votes) AS total_postal_votes
FROM constituencywise_results cr
JOIN constituencywise_details cd ON cr.contituency_id = cd.contituency_id
JOIN statewise_results sr ON cr.parliament_constituency = sr.parliament_constituency
JOIN states s ON sr.state_id = s.state_id
JOIN partywise_results p ON cr.party_id = p.party_id
WHERE s.states = 'Karnataka';














































































































