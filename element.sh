PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# Check if the user has provided an argument
if [[ -z "$1" ]]; then
  echo "Please provide an element as an argument."
  else
    # Save user's input in a variable
	userInput=$1
	# If user's input is a number, query for atomic number
	if [[ "$userInput" =~ ^[0-9]+$ ]]; then
	  elementDetails=$($PSQL "SELECT 
							  e.atomic_number, 
							  e.name, 
							  e.symbol, 
							  p.atomic_mass, 
							  p.melting_point_celsius, 
							  p.boiling_point_celsius, 
							  t.type
							FROM elements e
							JOIN properties p USING (atomic_number)
							JOIN types t USING (type_id)
							WHERE e.atomic_number = $1;")
	else
	# If user's input is not a number, query for symbol or name
	  elementDetails=$($PSQL "SELECT 
							  e.atomic_number, 
							  e.name, 
							  e.symbol, 
							  p.atomic_mass, 
							  p.melting_point_celsius, 
							  p.boiling_point_celsius, 
							  t.type
							FROM elements e
							JOIN properties p USING (atomic_number)
										JOIN types t USING (type_id)
							WHERE e.symbol = '$1' OR e.name = '$1';")
	fi

	# Check if a result was found
	if [[ -n "$elementDetails" ]]; then
	  # Format the result
	  atomicNumber=$(echo $elementDetails | cut -d '|' -f 1)
	  name=$(echo $elementDetails | cut -d '|' -f 2)
	  symbol=$(echo $elementDetails | cut -d '|' -f 3)
	  mass=$(echo $elementDetails | cut -d '|' -f 4)
	  meltingPointCelsius=$(echo $elementDetails | cut -d '|' -f 5)
	  boilingPointCelsius=$(echo $elementDetails | cut -d '|' -f 6)
	  type=$(echo $elementDetails | cut -d '|' -f 7)

	  # Format the output message
	  result="The element with atomic number $atomicNumber is $name ($symbol). It's a $type, with a mass of $mass amu. $name has a melting point of $meltingPointCelsius celsius and a boiling point of $boilingPointCelsius celsius."
	else
	  result="I could not find that element in the database."
	fi

	echo $result
fi


