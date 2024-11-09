

-- this procedure is designed to clear the record of an offender given their offenderID.
-- this includes clearing any incidents the offender was involved in if they were the only offender.
CREATE OR REPLACE PROCEDURE clearOffender( IN offender_id BIGINT)
LANGUAGE plpgsql
AS $$
    BEGIN
    DELETE FROM "Incident_Crime_Offender" ico
    WHERE ico."offenderID" = offender_id;

    DELETE FROM "Offender" o
    WHERE o."offenderID" = offender_id;

    DELETE FROM "Incident" i
    WHERE i."incidentID" IN (
        SELECT ii."incidentID"
        FROM "Incident" AS ii
        LEFT JOIN "Incident_Crime_Offender" AS icoo ON ii."incidentID" = icoo."incidentID"
        WHERE icoo."incidentID" IS NULL 
    );

END;
$$;


-- This procedure is designed to remove incidents given an incidentID
CREATE OR REPLACE PROCEDURE clearIncident(IN incident_id BIGINT)
LANGUAGE plpgsql 
AS $$
BEGIN

    DELETE FROM "Incident_Victim" iv
    WHERE iv."incidentID" = incident_id;

    DELETE FROM "Incident_Crime_Offender" ico
    WHERE ico."incidentID" = incident_id;

    DELETE FROM "Incident" i
    WHERE i."incidentID" = incident_id;

END;
$$;

-- this procedure is designed to clear record of a victim given victimID
CREATE OR REPLACE PROCEDURE clearVictim(IN victim_id BIGINT)
LANGUAGE plpgsql 
AS $$
BEGIN
    DELETE FROM "Incident_Victim" iv
    WHERE iv."victimID" = victim_id;

    DELETE FROM "Victim" v
    WHERE v."victimID" = victim_id;
END;
$$;


-- this function is designed to update a pre-existing offender's information
CREATE OR REPLACE PROCEDURE updateOffenderInfo(
    IN offender_id BIGINT,
    IN first_name VARCHAR,
    IN last_name VARCHAR,
    IN ageIn INTEGER,
    IN sexIn VARCHAR,
    IN raceIn VARCHAR,
    IN ethnicityIn VARCHAR
)
LANGUAGE plpgsql 
AS $$
BEGIN
    UPDATE "Offender"
    SET 
        "firstName" = first_name,
        "lastName" = last_name,
        age = ageIn,
        sex = sexIn,
        race = raceIn,
        ethnicity = ethnicityIn
    WHERE 
        "offenderID" = offender_id;
END;
$$;

--- this function is designed to update a pre-existing victim's information
CREATE OR REPLACE PROCEDURE updateVictimInfo(
    IN victim_id BIGINT,
    IN ageIn INTEGER,
    IN sexIn VARCHAR,
    IN raceIn VARCHAR,
    IN ethnicityIn VARCHAR
)
LANGUAGE plpgsql 
AS $$
BEGIN
    UPDATE "Victim"
    SET 
        age = ageIn,
        sex = sexIn,
        race = raceIn,
        ethnicity = ethnicityIn
    WHERE 
        "victimID" = victim_id;
END;
$$;



