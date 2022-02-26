#!/bin/bash

declare -a rnd_num_pos
current_active_cell=15

function randomize() {
	tile_num=1
	for rnd_num in $(shuf -i 1-15 -n 15 --random-source=/dev/random); do
		rnd_num_pos[$tile_num]=$rnd_num
		tile_num=$((tile_num + 1))
	done
}

function draw() {
	for((row = 0;row <= 12;row = row + 4)); do
		for((i = 1;i <= 4;i ++)); do
			echo -n " -- "
		done
		echo
		for((i = 1;i <= 4;i ++)); do
			if [ -z ${rnd_num_pos[$(($row + $i))]} ] && \
			[ $current_active_cell -eq $((row + i)) ]; then
				echo -ne "|\033[7m  \033[0m|"
				continue
			elif [ -z ${rnd_num_pos[$(($row + $i))]} ]; then
				echo -n "|  |"
				continue
			fi

			if [ ${rnd_num_pos[$(($row + $i))]} -gt 9 ] && \
			[ $current_active_cell -eq $((row +i)) ]; then
				echo -ne "|\033[7m${rnd_num_pos[$(($row + $i))]}\033[0m|"
				continue
			elif [ ${rnd_num_pos[$(($row + $i))]} -gt 9 ]; then
				echo -n "|${rnd_num_pos[$(($row + $i))]}|"
				continue
			fi

			if [ ${rnd_num_pos[$(($row + $i))]} -lt 10 ] && \
			[ $current_active_cell -eq $((row + i)) ]; then
				echo -ne "|\033[7m ${rnd_num_pos[$(($row + $i))]}\033[0m|"
				continue
			elif [ ${rnd_num_pos[$(($row + $i))]} -lt 10 ]; then
				echo -n "| ${rnd_num_pos[$(($row + $i))]}|"
			fi
		done
		echo
		for((i = 1;i <= 4;i ++)); do
			echo -n " -- "
		done
		echo
	done
}

function input() {
	read -s -n 1 key
	case $key in
		w|k)
			if [ $current_active_cell -lt 5 ]; then
				false
			else
				current_active_cell=$((current_active_cell - 4))
			fi;;
		a|h) 
			if [ $current_active_cell -eq 1 ]; then
				false
			else
				current_active_cell=$((current_active_cell - 1))
			fi;;
		s|j)
			if [ $current_active_cell -gt 12 ]; then
				false
			else
				current_active_cell=$((current_active_cell + 4))
			fi;;
		d|l)
			if [ $current_active_cell -eq 16 ]; then
				false
			else
				current_active_cell=$((current_active_cell + 1))
			fi;;
		f)
			if [ -z ${rnd_num_pos[$((current_active_cell + 1))]} ] && \
			[ $current_active_cell -lt 16 ] && \
			[ $current_active_cell -ne 12 ] && \
			[ $current_active_cell -ne 8 ] && \
			[ $current_active_cell -ne 4 ]; then
				rnd_num_pos[$((current_active_cell + 1))]=${rnd_num_pos[$current_active_cell]}
				unset "rnd_num_pos[$current_active_cell]"
			fi

			if [ -z ${rnd_num_pos[$((current_active_cell - 1))]} ] && \
			[ $current_active_cell -gt 1 ] && \
	       		[ $current_active_cell -ne 5 ] && \
			[ $current_active_cell -ne 9 ] && \
			[ $current_active_cell -ne 13 ]; then
				rnd_num_pos[$((current_active_cell - 1))]=${rnd_num_pos[$current_active_cell]}
				unset "rnd_num_pos[$current_active_cell]"
			fi

			if [ -z ${rnd_num_pos[$((current_active_cell - 4))]} ] && \
			[ $((current_active_cell - 4)) -gt 0 ]; then
				rnd_num_pos[$((current_active_cell - 4))]=${rnd_num_pos[$current_active_cell]}
				unset "rnd_num_pos[$current_active_cell]"
			fi

			if [ -z ${rnd_num_pos[$((current_active_cell + 4))]} ] && \
			[ $((current_active_cell + 4)) -lt 17 ]; then
				rnd_num_pos[$((current_active_cell + 4))]=${rnd_num_pos[$current_active_cell]}
				unset "rnd_num_pos[$current_active_cell]"
			fi;;
	esac
}

function main() {
	randomize
	while true; do
		draw
		input
	
		for((i = 1;i <= 12;i ++)); do
			echo -ne "\033[1A"
			echo -ne "\033[K"
		done
		
		cell=1
		right_order_cells=0

		if [ -z ${rnd_num_pos[$cell]} ]; then
			continue
		fi

		if [ ${rnd_num_pos[$cell]} -eq 1 ]; then
			right_order_cells=1
		fi
		for((cell = 1;cell < 15;cell ++)); do
			if [ -z $((${rnd_num_pos[$((cell + 1))]})) ]; then
				break
			fi

			if [ ${rnd_num_pos[$((cell + 1))]} -eq ${rnd_num_pos[$((cell + 1))]} ]; then
				right_order_cells=$((right_order_cells + 1))
				continue
			else
				break
			fi
		done
		if [ $right_order_cells -eq 15 ]; then
			echo Game Finished
			return
		fi
	done
}

main
exit
