#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo "$($PSQL "TRUNCATE TABLE games, teams")"
cat games.csv | while IFS="," read  yr rd wnr opnt wnrg opntg
do 
  if [[ $yr != 'year' ]]
  then
    teamwnr=$($PSQL "SELECT team_id FROM teams WHERE name LIKE '$wnr'")
    teamopnt=$($PSQL "SELECT team_id FROM teams WHERE name LIKE '$opnt'")
    if [[ -z $teamwnr ]]
    then
      echo "$($PSQL "INSERT INTO teams(name) VALUES('$wnr')")"
      teamwnr=$($PSQL "SELECT team_id FROM teams WHERE name LIKE '$wnr'")
    fi
    if [[ -z $teamopnt ]]
    then
      echo "$($PSQL "INSERT INTO teams(name) VALUES('$opnt')")"
      teamopnt=$($PSQL "SELECT team_id FROM teams WHERE name LIKE '$opnt'")
    fi
    echo "$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($yr, '$rd', $teamwnr, $teamopnt, $wnrg, $opntg)")"
  fi
done

