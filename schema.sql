-- Database: usa_crime
  
ALTER TABLE IF EXISTS public."Incident" DROP CONSTRAINT IF EXISTS "Incident_incidentID_fkey";

ALTER TABLE IF EXISTS public."Incident_Crime_Offender" DROP CONSTRAINT IF EXISTS "Incident_Crime_Offender_crimeID_fkey";

ALTER TABLE IF EXISTS public."Incident_Crime_Offender" DROP CONSTRAINT IF EXISTS "Incident_Crime_Offender_incidentID_fkey";

ALTER TABLE IF EXISTS public."Incident_Crime_Offender" DROP CONSTRAINT IF EXISTS "Incident_Crime_Offender_offenderID_fkey";

ALTER TABLE IF EXISTS public."Incident_Victim" DROP CONSTRAINT IF EXISTS "Incident_Victim_Incident_incidentID_fkey";

ALTER TABLE IF EXISTS public."Incident_Victim" DROP CONSTRAINT IF EXISTS "Incident_Victim_Victim_victimID_fkey";



DROP TABLE IF EXISTS public."Crime";

CREATE TABLE IF NOT EXISTS public."Crime"
(
    "crimeID" bigint NOT NULL,
    "crimeTypeDesc" character varying(250) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT "Crime_pkey" PRIMARY KEY ("crimeID")
);

DROP TABLE IF EXISTS public."Incident";

CREATE TABLE IF NOT EXISTS public."Incident"
(
    "incidentID" bigint NOT NULL,
    date date,
    location character varying(250) COLLATE pg_catalog."default",
    CONSTRAINT "Incident_pkey" PRIMARY KEY ("incidentID")
);

DROP TABLE IF EXISTS public."Incident_Crime_Offender";

CREATE TABLE IF NOT EXISTS public."Incident_Crime_Offender"
(
    "incidentID" bigint NOT NULL,
    "offenderID" bigint NOT NULL,
    "crimeID" bigint NOT NULL
);

DROP TABLE IF EXISTS public."Incident_Victim";

CREATE TABLE IF NOT EXISTS public."Incident_Victim"
(
    "incidentID" bigint NOT NULL,
    "victimID" bigint NOT NULL
);

DROP TABLE IF EXISTS public."Offender";

CREATE TABLE IF NOT EXISTS public."Offender"
(
    "offenderID" bigint NOT NULL,
    "firstName" character varying(250) COLLATE pg_catalog."default",
    "lastName" character varying(250) COLLATE pg_catalog."default",
    age integer,
    sex character varying(250) COLLATE pg_catalog."default",
    race character varying(250) COLLATE pg_catalog."default",
    ethnicity character varying(250) COLLATE pg_catalog."default",
    CONSTRAINT "Offender_pkey" PRIMARY KEY ("offenderID")
);

DROP TABLE IF EXISTS public."State";

CREATE TABLE IF NOT EXISTS public."State"
(
    "stateID" bigint NOT NULL,
    "stateName" character varying(250) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT "State_pkey" PRIMARY KEY ("stateID")
);

DROP TABLE IF EXISTS public."Victim";

CREATE TABLE IF NOT EXISTS public."Victim"
(
    "victimID" bigint NOT NULL,
    age integer,
    sex character varying(250) COLLATE pg_catalog."default",
    race character varying(250) COLLATE pg_catalog."default",
    ethnicity character varying(250) COLLATE pg_catalog."default",
    CONSTRAINT "Victim_pkey" PRIMARY KEY ("victimID")
);

ALTER TABLE IF EXISTS public."Incident"
    ADD CONSTRAINT "Incident_incidentID_fkey" FOREIGN KEY ("incidentID")
    REFERENCES public."State" ("stateID") MATCH SIMPLE
    ON UPDATE CASCADE
    ON DELETE CASCADE
    NOT VALID;
CREATE INDEX IF NOT EXISTS "Incident_pkey"
    ON public."Incident"("incidentID");


ALTER TABLE IF EXISTS public."Incident_Crime_Offender"
    ADD CONSTRAINT "Incident_Crime_Offender_crimeID_fkey" FOREIGN KEY ("crimeID")
    REFERENCES public."Crime" ("crimeID") MATCH SIMPLE
    ON UPDATE CASCADE
    ON DELETE CASCADE
    NOT VALID;


ALTER TABLE IF EXISTS public."Incident_Crime_Offender"
    ADD CONSTRAINT "Incident_Crime_Offender_incidentID_fkey" FOREIGN KEY ("incidentID")
    REFERENCES public."Incident" ("incidentID") MATCH SIMPLE
    ON UPDATE CASCADE
    ON DELETE CASCADE
    NOT VALID;


ALTER TABLE IF EXISTS public."Incident_Crime_Offender"
    ADD CONSTRAINT "Incident_Crime_Offender_offenderID_fkey" FOREIGN KEY ("offenderID")
    REFERENCES public."Offender" ("offenderID") MATCH SIMPLE
    ON UPDATE CASCADE
    ON DELETE CASCADE
    NOT VALID;


ALTER TABLE IF EXISTS public."Incident_Victim"
    ADD CONSTRAINT "Incident_Victim_Incident_incidentID_fkey" FOREIGN KEY ("incidentID")
    REFERENCES public."Incident" ("incidentID") MATCH SIMPLE
    ON UPDATE CASCADE
    ON DELETE CASCADE
    NOT VALID;


ALTER TABLE IF EXISTS public."Incident_Victim"
    ADD CONSTRAINT "Incident_Victim_Victim_victimID_fkey" FOREIGN KEY ("victimID")
    REFERENCES public."Victim" ("victimID") MATCH SIMPLE
    ON UPDATE CASCADE
    ON DELETE CASCADE
    NOT VALID;
    
