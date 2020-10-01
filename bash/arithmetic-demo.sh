#!/bin/bash
#
# this script demonstrates doing arithmetic

# Task 1: Remove the assignments of numbers to the first and second number variables. Use one or more read commands to get 3 numbers from the user.
# Task 2: Change the output to only show:
#    the sum of the 3 numbers with a label
#    the product of the 3 numbers with a label

echo "Please enter three numbers"
read -p "First numbet: " firstnum
read -p "Second numbet: " secondnum
read -p "Third numbet: " thirdnum
sum=$((firstnum + secondnum + thirdnum))
productoof3=$((firstnum * secondnum * thirdnum))


cat <<EOF
the sum of the 3 numbers is $sum
the product of 3 numbers is $productoof3
EOF
