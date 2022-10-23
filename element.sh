#! /bin/bash

PSQL="psql -U freecodecamp --dbname=periodic_table --no-align --tuples-only -c"
MY_ARRAY=("" "metal" "nonmetal" "metalloid")

#if an arg is provided
if ! [[ -z $1 ]]
then
  #check if it's a number
  REGEX_ATOMIC_NUMBER='^[0-9]+$'
  if [[ $1 =~ $REGEX_ATOMIC_NUMBER ]] 
  #yes? Look for the atomic_number
  then
    RESULT_ATO_NUMBER=$($PSQL "SELECT e.atomic_number, e.symbol, e.name, p.type_id, p.atomic_mass, p.boiling_point_celsius, p.melting_point_celsius FROM elements e INNER JOIN properties p ON p.atomic_number=e.atomic_number WHERE e.atomic_number=$1")
    #check it returns a result
    if [[ -z $RESULT_ATO_NUMBER ]]
    #if not
    then
      echo "I could not find that element in the database."
    #if yes return the value 
    else
    IFS='|' read A S N T AM BP MP < <(echo $RESULT_ATO_NUMBER)
    echo "The element with atomic number $A is $N ($S). It's a ${MY_ARRAY[$T]}, with a mass of $AM amu. $N has a melting point of $MP celsius and a boiling point of $BP celsius."
    fi
  elif [[ $1 =~ [A-Z]|\w+ ]] 
  then
    #look for symbol
    RESULT_SYMBOL=$($PSQL "SELECT e.atomic_number, e.symbol, e.name, p.type_id, p.atomic_mass, p.boiling_point_celsius, p.melting_point_celsius FROM elements e INNER JOIN properties p ON p.atomic_number=e.atomic_number WHERE e.symbol='$1'")
    #check it returns a result
    if ! [[ -z $RESULT_SYMBOL ]]
    #if yes
    then
      IFS='|' read A S N T AM BP MP < <(echo $RESULT_SYMBOL)
      echo "The element with atomic number $A is $N ($S). It's a ${MY_ARRAY[$T]}, with a mass of $AM amu. $N has a melting point of $MP celsius and a boiling point of $BP celsius."
    #if no 
    #look for name
    else
      RESULT_NAME=$($PSQL "SELECT e.atomic_number, e.symbol, e.name, p.type_id, p.atomic_mass, p.boiling_point_celsius, p.melting_point_celsius FROM elements e INNER JOIN properties p ON p.atomic_number=e.atomic_number WHERE e.name='$1'")
      #check it returns a result
      if ! [[ -z $RESULT_NAME ]]
      #if yes
      then
        IFS='|' read A S N T AM BP MP < <(echo $RESULT_NAME)
        echo "The element with atomic number $A is $N ($S). It's a ${MY_ARRAY[$T]}, with a mass of $AM amu. $N has a melting point of $MP celsius and a boiling point of $BP celsius."
      else
      echo "I could not find that element in the database."
      fi
    fi
  fi
#no args provided
else
  echo "Please provide an element as an argument."
fi

