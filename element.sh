PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

if [[ -z $1 ]]
then 
  echo "Please provide an element as an argument."
else
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    QUERY_RESULT=$($PSQL "select atomic_number, symbol, name, atomic_mass, melting_point_celsius, boiling_point_celsius, type from properties inner join elements using(atomic_number) inner join types using(type_id) WHERE atomic_number='$1'")
  elif [[ $1 =~ ^[A-Z][a-z]{0,1}$ ]]
  then
    QUERY_RESULT=$($PSQL "select atomic_number, symbol, name, atomic_mass, melting_point_celsius, boiling_point_celsius, type from properties inner join elements using(atomic_number) inner join types using(type_id) WHERE symbol='$1'")
  else
    QUERY_RESULT=$($PSQL "select atomic_number, symbol, name, atomic_mass, melting_point_celsius, boiling_point_celsius, type from properties inner join elements using(atomic_number) inner join types using(type_id) WHERE name='$1'")
  fi

  if [[ -z $QUERY_RESULT ]]
  then
    echo -e "I could not find that element in the database."
  else
    echo $QUERY_RESULT | while IFS=' | ' read ATOMIC_NUMBER SYMBOL NAME MASS MELTING_POINT BOILING_POINT TYPE
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    done
  fi
fi