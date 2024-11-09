## this file is designed to parse data into something insertable for the pgSQL spreadsheet

import csv
import names
import random
from dataConversion import getAge, sex_code, race_id, ethnicity_id, relationship_code, relationship_id, location_id, crime_code

OFFENDERS = []

### dict with key of incident, value is a list of [[Offenders, Offenders, ..][ crime, crime, ..]]
INCIDENT_CRIME_OFFENDER = {}
INCIDENT_VICTIM = []


def isNull(val):
    if val == 'NULL':
        return 'NULL'
    else:
        return f'\'{val}\''


def insertOffenders(FILE_TO_READ, FILE_TO_WRITE):
    '''
    FILE_TO_READ: NIBRS_OFFENDER for specific state
    FILE_TO_WRITE: BLANK CSV SHEET
    '''
    DATA_LIST = []

    with open(FILE_TO_READ, newline='') as csvfile:
        listOfLines = csv.reader(csvfile, delimiter=',', quotechar='|')
        for index, row in enumerate(listOfLines):
            randNum = random.randint(1, 150000)
            if index != 0 and randNum <= 80 and len(OFFENDERS) <= 300 :
                newRow = [0,0,0,0,0,0,0]
                ## handles offender ID:
                newRow[0] = row[1]
                OFFENDERS.append(row[1])

                ## handles incidents
                if row[2] not in INCIDENT_CRIME_OFFENDER.keys():
                    INCIDENT_CRIME_OFFENDER[row[2]] = [[row[1]],[]]
                else:
                    INCIDENT_CRIME_OFFENDER[row[2]][0].append(row[1])
                

                ## handles sex
                sex = sex_code[row[6]]
                newRow[4] = sex

                ## handles first name
                if sex == 'Male':
                    newRow[1] = names.get_first_name(gender='male')
                if sex == 'Female':
                    newRow[1] = names.get_first_name(gender='female')
                else:
                    newRow[1] = names.get_first_name()
            
                ## handles last name
                newRow[2] = names.get_last_name()

                ## handles age
                ageID = int(row[4])
                newRow[3] = getAge(ageID)

                ## handles race
                race = race_id[row[7]]
                newRow[5] = race

                ## handles ethnicity
                ethnicity = ethnicity_id[row[8]]
                newRow[6] = ethnicity
                DATA_LIST.append(newRow)


    with open(FILE_TO_WRITE, 'a', newline='') as csvfile2:
        spamwriter = csv.writer(csvfile2, delimiter='\n',
                                quotechar=' ', quoting=csv.QUOTE_MINIMAL)
        insertionList = []
        for row in DATA_LIST:
                insertionStr = f"INSERT INTO public.\"Offender\"(\"offenderID\", \"firstName\", \"lastName\", age, sex, race, ethnicity) VALUES ({row[0]}, \'{row[1]}\', \'{row[2]}\', {row[3]}, \'{row[4]}\', \'{row[5]}\', \'{row[6]}\' );"
                insertionList.append(insertionStr)
        spamwriter.writerow(insertionList)


def insertIncidents(FILE_TO_READ_INCIDENT, FILE_TO_READ_OFFENSE,FILE_TO_WRITE,STATE_ID):
    '''
    csv should be in the format incident_id,date,locationID,empty
    '''
    DATA_LIST = []

    with open(FILE_TO_READ_INCIDENT, newline='') as csvfile:
        listOfLines = csv.reader(csvfile, delimiter=',', quotechar='|')
        for row in listOfLines:
            if row[2] in INCIDENT_CRIME_OFFENDER.keys():
                newRow = [0,0,0,0]
                ## INCIDENt ID
                newRow[0] = row[2]

                ## DATE
                date = row[6]
                newRow[1] = date
    
                with open(FILE_TO_READ_OFFENSE, newline='') as csvfile2:
                    listOfLines2 = csv.reader(csvfile2, delimiter=',', quotechar='|')
                    for row2 in listOfLines2:
                        if row2[2] == row[2]:
                            ##handles location
                            location = location_id[row2[5]]
                            newRow[2] = location

                            ##handles state
                            newRow[3] = STATE_ID

                            ##handles crime (for later use with Incident_Crime_Offender)
                            crime = crime_code[row2[3]]
                            INCIDENT_CRIME_OFFENDER[row[2]][1].append(crime)
                DATA_LIST.append(newRow)
    

    with open(FILE_TO_WRITE, 'a', newline='') as csvfile2:
        spamwriter = csv.writer(csvfile2, delimiter='\n',
                                quotechar=' ', quoting=csv.QUOTE_MINIMAL)
        insertionList = []
        for row in DATA_LIST:
                insertionStr = f"INSERT INTO public.\"Incident\"(\"incidentID\", date, location, \"stateID\") VALUES ({row[0]}, \'{row[1]}\', \'{row[2]}\', {row[3]});"
                insertionList.append(insertionStr)
        spamwriter.writerow(insertionList)



def insertVictims(FILE_TO_READ,FILE_TO_WRITE):
    '''
    params: .csv file to read, .csv file to write to
    returns: none

    creates a CSV file of offenders.

    '''
    DATA_LIST = []

    with open(FILE_TO_READ, newline='') as csvfile:
        listOfLines = csv.reader(csvfile, delimiter=',', quotechar='|')
        for row in listOfLines:
            if row[2] in INCIDENT_CRIME_OFFENDER.keys():
                newRow = [0,0,0,0,0]
                INCIDENT_VICTIM.append((row[2], row[1]))
                
                ## handles victimID
                newRow[0] = row[1]
                ## handles sex
                sex = sex_code[row[10]]
                newRow[2] = sex

                ## handles age
                ageID = int(row[8])
                newRow[1] = getAge(ageID)

                ## handles race
                race = race_id[row[11]]
                newRow[3] = race

                ## handles ethnicity
                ethnicity = ethnicity_id[row[12]]
                newRow[4] = ethnicity
                DATA_LIST.append(newRow)


    with open(FILE_TO_WRITE, 'a', newline='') as csvfile2:
        spamwriter = csv.writer(csvfile2, delimiter='\n',
                                quotechar=' ', quoting=csv.QUOTE_MINIMAL)
        insertionList = []
        for row in DATA_LIST:
                insertionStr = f"INSERT INTO public.\"Victim\"(\"victimID\", age, sex, race, ethnicity) VALUES ({row[0]}, {row[1]}, {isNull(row[2])}, {isNull(row[3])}, {isNull(row[4])});"
                insertionList.append(insertionStr)
        spamwriter.writerow(insertionList)


def insertIncidentVictims(FILE_TO_WRITE):

    with open(FILE_TO_WRITE, 'a', newline='') as csvfile2:
        spamwriter = csv.writer(csvfile2, delimiter='\n',
                                quotechar=' ', quoting=csv.QUOTE_MINIMAL)
        DATA_LIST = []
        for tup in INCIDENT_VICTIM:
            insertionStr = f"INSERT INTO public.\"Incident_Victim\"(\"incidentID\", \"victimID\") VALUES ({tup[0]}, {tup[1]});"
            DATA_LIST.append(insertionStr)
        spamwriter.writerow(DATA_LIST)
    

def insertIncidentCrimeOffender(FILE_TO_WRITE):
    DATA_LIST = []
    for key in INCIDENT_CRIME_OFFENDER:
        offendersList = INCIDENT_CRIME_OFFENDER[key][0]
        crimesList = INCIDENT_CRIME_OFFENDER[key][1]
        for offender in offendersList:
            for crime in crimesList:
                dataTup = (key, offender, crime )
                DATA_LIST.append(dataTup)
    with open(FILE_TO_WRITE, 'a', newline='') as csvfile2:
        spamwriter = csv.writer(csvfile2, delimiter='\n',
                                quotechar=' ', quoting=csv.QUOTE_MINIMAL)
        inserts = []
        for tup in DATA_LIST:
            insertionStr = f"INSERT INTO public.\"Incident_Crime_Offender\" (\"incidentID\", \"offenderID\", \"crimeID\") VALUES( {tup[0]}, {tup[1]}, {tup[2]});"
            inserts.append(insertionStr)
        spamwriter.writerow(inserts)
            
    

insertOffenders('NIBRS_OFFENDER.csv', 'DATA.sql')
insertIncidents('NIBRS_incident.csv', 'NIBRS_OFFENSE.csv', 'DATA.sql', 56)
insertVictims('NIBRS_VICTIM.csv', 'DATA.sql')
insertIncidentVictims('DATA.sql')
insertIncidentCrimeOffender('DATA.sql')
