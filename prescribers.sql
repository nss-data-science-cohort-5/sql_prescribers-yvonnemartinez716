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
--
SELECT npi, specialty_description
FROM prescriber
GROUP BY npi, specialty_description

SELECT npi, SUM(total_claim_count)
FROM prescription as pres

    --b. Which specialty had the most total number of claims for opioids?

    --c. **Challenge Question:** Are there any specialties that appear in the prescriber table that have no associated prescriptions in the prescription table?

    --d. **Difficult Bonus:** *Do not attempt until you have solved all other problems!* For each specialty, report the percentage of total claims by that specialty which are for opioids. Which specialties have a high percentage of opioids?


