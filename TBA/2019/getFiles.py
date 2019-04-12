from pytba import api as tba
from pytba import VERSION
import numpy as np
from datetime import datetime
import os

tba.set_api_key("Richard Sims", "FRC686", VERSION)

# get list of Chesapeake District Teams
chs_team_list = tba.tba_get('district/chs/2019/teams')
chs_teams = np.zeros(len(chs_team_list))
for t in range(0, len(chs_team_list)):
    chs_teams[t] = chs_team_list[t]['team_number']

directory = "data"
if not os.path.exists(directory):
    os.makedirs(directory)

filename = directory + "/chs_teams.csv"
with open(filename, 'wb') as csvFile:
    np.savetxt(csvFile, chs_teams, '%d', delimiter=",")







event_list = tba.tba_get('events/2019')

# get list of event names
rec = np.zeros(len(event_list), dtype=[('event_key','U16'), ('event_name','U80')])
for e in range(0, len(event_list)):
    rec[e] = ( event_list[e]['key'], event_list[e]['name'] )

directory = "data"
if not os.path.exists(directory):
    os.makedirs(directory)

filename = directory + "/events.csv"
with open(filename, 'wb') as csvFile:
    np.savetxt(csvFile, rec, '%s', delimiter=",")











for event in event_list:
    
    event_start_date = datetime.strptime(event['start_date'], '%Y-%m-%d')    # convert date string to date structure
    
    if (event['official'] == True) and (event_start_date <= datetime.today()) and (event['event_type'] >= 0) and (event['event_type'] <= 4):

        print(event['key'])

        event_key = event['key']
        event_results = tba.event_get(event_key)
        matches = event_results.matches

        numMatches = len(matches)
        
        rec = np.zeros(2*numMatches, dtype=[('match','i4'),
                                            ('comp', 'U4'),
                                            ('alliance', 'U4'),
                                            ('team1', 'i4'),
                                            ('team2', 'i4'),
                                            ('team3', 'i4'),
                                            ('score', 'i4'),
                                            ('totalPoints', 'i4'),
                                            ('autoPoints', 'i4'),
                                            ('teleopPoints', 'i4'),
                                            ('hatchPanelPoints', 'i4'),
                                            ('cargoPoints', 'i4'),
                                            ('habClimbPoints', 'i4'),
                                            ('foulPoints', 'i4'),
                                            ('adjustPoints', 'i4'),
                                            ('sandStormBonusPoints', 'i4')])
    
        alliances = {'blue', 'red'}
        row = 0
        
        for m in range(0, numMatches):
        
            match = matches[m]
        
        
            if (match['alliances']['red']['score'] > 0) or (match['alliances']['blue']['score'] > 0):
                
                for alliance in alliances:
        
                    team1 = int(match['alliances'][alliance]['teams'][0].replace("frc", ""))
                    team2 = int(match['alliances'][alliance]['teams'][1].replace("frc", ""))
                    team3 = int(match['alliances'][alliance]['teams'][2].replace("frc", ""))
            
                    rec[row] = (  match['match_number'],
                                  match['comp_level'],
                                  alliance,
                                  team1,
                                  team2,
                                  team3,
                                  match['alliances'][alliance]['score'],
                                  match['score_breakdown'][alliance]['totalPoints'],
                                  match['score_breakdown'][alliance]['autoPoints'],
                                  match['score_breakdown'][alliance]['teleopPoints'],
                                  match['score_breakdown'][alliance]['hatchPanelPoints'],
                                  match['score_breakdown'][alliance]['cargoPoints'],
                                  match['score_breakdown'][alliance]['habClimbPoints'],
                                  match['score_breakdown'][alliance]['foulPoints'],
                                  match['score_breakdown'][alliance]['adjustPoints'],
                                  match['score_breakdown'][alliance]['sandStormBonusPoints']
                                  )
            
                    row += 1
            
            else:
                
                for alliance in alliances:
        
                    team1 = int(match['alliances'][alliance]['teams'][0].replace("frc", ""))
                    team2 = int(match['alliances'][alliance]['teams'][1].replace("frc", ""))
                    team3 = int(match['alliances'][alliance]['teams'][2].replace("frc", ""))
            
                    rec[row] = (  match['match_number'],
                                  match['comp_level'],
                                  alliance,
                                  team1,
                                  team2,
                                  team3,
                                  0, #match['alliances'][alliance]['score'],
                                  0, #match['score_breakdown'][alliance]['totalPoints'],
                                  0, #match['score_breakdown'][alliance]['autoPoints'],
                                  0, #match['score_breakdown'][alliance]['teleopPoints'],
                                  0, #match['score_breakdown'][alliance]['hatchPanelPoints'],
                                  0, #match['score_breakdown'][alliance]['cargoPoints'],
                                  0, #match['score_breakdown'][alliance]['habClimbPoints'],
                                  0, #match['score_breakdown'][alliance]['foulPoints'],
                                  0, #match['score_breakdown'][alliance]['adjustPoints'],
                                  0  #match['score_breakdown'][alliance]['sandStormBonusPoints']
                                  )
            
                    row += 1

        rec = rec[0:row]    # remove unused rows
        
        if row == 0:
            continue
        
        names = rec.dtype.names
        header = ','.join(names) + '\n'
        
        if not os.path.exists('data'):
            os.makedirs('data')
            
        directory = "data/week" + str(event['week'])
        if not os.path.exists(directory):
            os.makedirs(directory)
        
        filename = directory + "/" + event_key + ".csv"
        with open(filename, 'wb') as csvFile:
            csvFile.write(header.encode())
            np.savetxt(csvFile, rec, '%s', delimiter=",")
