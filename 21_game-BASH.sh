#!/bin/bash

total=0
declare last_turn

function winner_check () {
	if [ $total -eq 21 ]; then
		echo "Game is over"
		echo "The winnner is $last_turn"
		exit
	elif [ $total -gt 21 ]; then
		echo "Game is over"
		echo "Noone won"
		exit
	fi
}

function player () {
	echo "Player's turn..."
	echo -n "Enter 1, 2 or 3: "
	read num
	if [ $num -ne 1 ] && [ $num -ne 2 ] && [ $num -ne 3 ]; then
		echo "Wrong input"
		read -p "Press enter to continue"	
		return 1
	fi
	total=$((num + total))
	last_turn="Player"
	return 0
}

function ai () {
	echo "AI makes turn..."
	sleep 1
	if [ $total -le $((21 - 3)) ]; then
		total=$((total + 3))
	elif [ $total -le $((21 - 2)) ]; then
		total=$((total + 2))
	elif [ $total -le $((21 - 1)) ]; then
		total=$((total + 1))
	fi
	last_turn="AI"
}

function clearscreen () {
	for((i = 0;i < $1;i ++)); do
		echo -ne "\E[1F"
		echo -ne "\E[2K"
	done
}

function main () {
	while [ "$choice" != "TRUE" ]; do
		echo "Choose who goes first, AI or PLAYER: "
		read "turn"
		if [ "$turn" != "AI" ] && [ "$turn" != "PLAYER" ]; then
			echo "Wrong input, try again..."
			read -p "Press key to continue"
			clearscreen 4
			choice="FALSE"
			continue
		fi
		choice="TRUE"
		clearscreen 2
	done
	
	while [ $total -lt 21 ]; do	
		echo "Total: $total"
		if [ "$turn" == "PLAYER" ]; then
			player
			if [ $? -eq 1 ]; then
				clearscreen 5
				continue
			else
				winner_check
				clearscreen 3
			fi
			turn="AI"
		elif [ "$turn" == "AI" ]; then
			ai
			winner_check
			clearscreen 2
			turn="PLAYER"
		fi
	done
}

main
exit
