#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  # Kiểm tra xem input là số hay chữ
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    CONDITION="elements.atomic_number = $1"
  else
    CONDITION="elements.symbol = '$1' OR elements.name = '$1'"
  fi

  # Truy vấn dữ liệu
  RESULT=$($PSQL "SELECT elements.atomic_number, elements.symbol, elements.name, properties.atomic_mass, properties.melting_point_celsius, properties.boiling_point_celsius, types.type FROM elements JOIN properties ON elements.atomic_number = properties.atomic_number JOIN types ON properties.type_id = types.type_id WHERE $CONDITION")

  if [[ -z $RESULT ]]
  then
    echo "I could not find that element in the database."
  else
    # Parse và in kết quả
    echo "$RESULT" | while read ATOMIC_NUMBER BAR SYMBOL BAR NAME BAR MASS BAR MELTING BAR BOILING BAR TYPE
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
    done
  fi
fi
