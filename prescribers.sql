--Which prescriber had the highest total number of claims (totaled over all drugs)? Report the npi and the total number of claims.
   -- b. Repeat the above, but this time report the nppes_provider_first_name, nppes_provider_last_org_name,  specialty_description, and the total number of claims.
SELECT *
FROM prescriber as p
INNER JOIN
(SELECT npi, SUM(total_claim_count)
FROM prescription
GROUP BY npi
ORDER BY SUM(total_claim_count) DESC
LIMIT 1) AS max_npi
on p.npi = max_npi.npi

--2. a. Which specialty had the most total number of claims (totaled over all drugs)?

SELECT specialty_description, SUM(drug.total_claim_count) as total_drug
FROM prescriber AS p
INNER JOIN prescription as drug
USING (npi)
GROUP BY specialty_description
ORDER BY total_drug desc
LIMIT 1;


 --b. Which specialty had the most total number of claims for opioids?
SELECT specialty_description, SUM(total_claim_count) as total_drug
FROM prescriber AS p
INNER JOIN prescription as script
USING (npi)
INNER JOIN drug
USING (drug_name)
WHERE opioid_drug_flag = 'Y'
GROUP BY specialty_description
ORDER BY total_drug desc


    --c. **Challenge Question:** Are there any specialties that appear in the prescriber table that have no associated prescriptions in the prescription table?
/*
SELECT DISTINCT specialty_description
FROM prescriber
FULL JOIN prescription
using (npi)
WHERE drug_name is null
*/
    --d. **Difficult Bonus:** *Do not attempt until you have solved all other problems!* For each specialty, report the percentage of total claims by that specialty which are for opioids. Which specialties have a high percentage of opioids?

--3. a. Which drug (generic_name) had the highest total drug cost?
SELECT generic_name, MAX(total_drug_cost)
FROM drug
INNER JOIN prescription
USING (drug_name)
GROUP BY generic_name
ORDER BY MAX(total_drug_cost) desc;

    --b. Which drug (generic_name) has the hightest total cost per day? **Bonus: Round your cost per day column to 2 decimal places. Google ROUND to see how this works.
SELECT generic_name, total_drug_cost/total_day_supply AS cost_per_day
FROM prescription
INNER JOIN drug
USING (drug_name)
GROUP BY generic_name, cost_per_day
ORDER BY cost_per_day desc

/*
4. a. For each drug in the drug table, return the drug name and then a column named 'drug_type' which says 
'opioid' for drugs which have opioid_drug_flag = 'Y', says 'antibiotic' for those drugs which have
antibiotic_drug_flag = 'Y', and says 'neither' for all other drugs.

    b. Building off of the query you wrote for part a, determine whether more was spent (total_drug_cost) on opioids or on antibiotics. Hint: Format the total costs as MONEY for easier comparision.
*/

SELECT drug_type, SUM(total_drug_cost :: MONEY)
FROM prescription as p
FULL JOIN
(SELECT drug_name,
 CASE WHEN opioid_drug_flag = 'Y' THEN 'opioid'
        -- Second case
        WHEN antibiotic_drug_flag = 'Y' THEN 'antibiotic'
        -- Else clause + end
        ELSE 'neither' 
		END AS drug_type
FROM drug) AS flags
USING (drug_name)
WHERE drug_type = 'opioid' OR drug_type = 'antibiotic'
GROUP BY drug_type
order by SUM(total_drug_cost:: MONEY) desc;

/*
5. a. How many CBSAs are in Tennessee? **Warning:** The cbsa table contains information for all states, not just Tennessee.

    b. Which cbsa has the largest combined population? Which has the smallest? Report the CBSA name and total population.

    c. What is the largest (in terms of population) county which is not included in a CBSA? Report the county name and population.
*/


















