-- this function shows all crimes that a specific offender has been charged with
CREATE OR REPLACE FUNCTION showCrimes(offender_id BIGINT)
RETURNS TABLE(crimeID BIGINT, crimeTypeDesc VARCHAR)
LANGUAGE plpgsql
AS $$
    BEGIN
        RETURN QUERY
            SELECT c."crimeID", c."crimeTypeDesc"
            FROM "Incident_Crime_Offender" AS ico
            JOIN "Crime" AS c ON ico."crimeID" = c."crimeID"
            WHERE ico."offenderID" = offender_id;
    END;
$$;


-- this function shows all other offenders that were involved in an incident with the offenderID given
CREATE OR REPLACE FUNCTION showCompanions(offender_id INT)
RETURNS TABLE(companionID BIGINT, firstName VARCHAR, lastName VARCHAR)
LANGUAGE plpgsql
AS $$
    BEGIN
        RETURN QUERY
            SELECT o."offenderID", o."firstName", o."lastName"
            FROM "Offender" AS o
            JOIN "Incident_Crime_Offender" AS ico1 ON o."offenderID" = ico1."offenderID"
            JOIN "Incident_Crime_Offender" AS ico2 ON ico1."incidentID" = ico2."incidentID"
            WHERE ico2."offenderID" = offender_id
                AND ico1."offenderID" <> offender_id;
    END;
$$;

-- shows the incidence of each crime type in a given stateID
CREATE OR REPLACE FUNCTION crimeOccurence(state_id INT)
RETURNS TABLE(crimeTypeDesc VARCHAR, occurrence_count BIGINT)
LANGUAGE plpgsql
AS $$
    BEGIN
        RETURN QUERY
            SELECT c."crimeTypeDesc", COUNT(*) AS occurrence_count
            FROM "Incident" AS i
            JOIN "Incident_Crime_Offender" AS ico ON i."incidentID" = ico."incidentID"
            JOIN "Crime" AS c ON ico."crimeID" = c."crimeID"
            WHERE i."stateID" = state_id
            GROUP BY c."crimeTypeDesc"
            ORDER BY occurrence_count DESC;
    END;
$$;

-- shows all incidents that a specific victim has been involved in
CREATE OR REPLACE FUNCTION showVictimIncidents(victim_id INT)
RETURNS TABLE(incidentID BIGINT, date DATE, location VARCHAR, stateID BIGINT)
LANGUAGE plpgsql
AS $$
    BEGIN
        RETURN QUERY
            SELECT i."incidentID", i."date", i."location", i."stateID"
            FROM "Incident" AS i
            JOIN "Incident_Victim" AS iv ON i."incidentID" = iv."incidentID"
            WHERE iv."victimID" = victim_id;
    END;
$$;

-- shows the incidence of each crime type on a specific date range
CREATE OR REPLACE FUNCTION incidenceOfDate(start_date DATE, end_date DATE)
RETURNS TABLE(incident_count BIGINT)
LANGUAGE plpgsql
AS $$
    BEGIN
        RETURN QUERY
            SELECT COUNT(*) AS incident_count
            FROM "Incident" i
            WHERE i."date" BETWEEN start_date AND end_date;
    END;
$$;

