function display_game(player1_moveMap, player1_moves, player2_moveMap, player2_moves)
	#Convert to string for display
	println("\n[*] Game render")
	#if len(instance)==8:	#Integrity check
	if true
		AX1 = ""
		AX2 = ""
		AY1 = ""
		AY2 = ""
		BX1 = ""
		BX2 = ""
		BY1 = ""
		BY2 = ""
		#---
		#Update player 1 vars
		i=1
		for val in player1_moveMap
			if val=="AX"
				AX1 = player1_moves[i]
			elseif val=="AY"
				AY1 = player1_moves[i]
			elseif val=="BX"
				BX1 = player1_moves[i]
			elseif val=="BY"
				BY1 = player1_moves[i]
			end
			i+=1
		end
		#update player 2 vars
		i=1
		for val in player2_moveMap
			if val=="AX"
				AX2 = player2_moves[i]
			elseif val=="AY"
				AY2 = player2_moves[i]
			elseif val=="BX"
				BX2 = player2_moves[i]
			elseif val=="BY"
				BY2 = player2_moves[i]
			end
			i+=1
		end
		#---
		print("\t        +")
		for i in 1:23
			print("-")
		end
		println()
		println("\t        |\tPlayer 2")
		print("\t        |")
		for i in 1:23
			print("-")
		end
		println("\n\t        |     X\t   |\t Y")
		for i in 1:40
			print("-")
		end
		print("\nPlayer 1")
		print("  |  A  |")
		print("   (", AX1 ,",", AX2 ,")  |")
		print("   (", AY1 ,",", AY2 ,")")
		print("\n\t  |")
		for i in 1:29
			print("-")
		end
		print("\n\t  |  B  |")
		print("   (", BX1,",", BX2 ,")  |")
		println("   (", BY1 ,",", BY2 ,")")
		for i in 1:40
			print("-")
		end
		println()
	else	#Corrupted
		println("\nInstance corrupted.")
	end
end

function is_gameDone(p1, p2)
	return p1+p2>0
end

function unicity_check(moveMap, moveMaps)
	return (moveMap in moveMaps)==false
end

function render_report(player1_moveMap, player1_moves, player2_moveMap, player2_moves)
	AX1 = -1
	AX2 = -1
	AY1 = -1
	AY2 = -1
	BX1 = -1
	BX2 = -1
	BY1 = -1
	BY2 = -1
	#---
	#Update player 1 vars
	i=1
	for val in player1_moveMap
		if val=="AX"
			AX1 = player1_moves[i]
		elseif val=="AY"
			AY1 = player1_moves[i]
		elseif val=="BX"
			BX1 = player1_moves[i]
		elseif val=="BY"
			BY1 = player1_moves[i]
		end
		i+=1
	end
	#update player 2 vars
	i=1
	for val in player2_moveMap
		if val=="AX"
			AX2 = player2_moves[i]
		elseif val=="AY"
			AY2 = player2_moves[i]
		elseif val=="BX"
			BX2 = player2_moves[i]
		elseif val=="BY"
			BY2 = player2_moves[i]
		end
		i+=1
	end
	#---
	# Check for player 1
	# 1 - str
	println("\n[*] Report - Improve it if you wish and can.")
	if AX1>BX1 && AY1>BY1
		#strongly - A
		println("\n[Player 1] Stricly dominant: A")
	elseif BX1>AX1 && BY1>AY1
		#strongly - B
		println("\n[Player 1] Stricly dominant: B")
	end
	# 2 - Wkl
	if (AX1>BX1 && AY1<BY1) || (AX1<BX1 && AY1>BX1)
		#weakly - A or B
		println("\n[Player 1] Weakly dominant: A")
	end

	# 2 - str
	if AX2>BX2 && AY2>BY2
		#strongly - A
		println("\n[Player 2] Stricly dominant: X")
	elseif BX2>AX2 && BY2>AY2
		#strongly - B
		println("\n[Player 2] Stricly dominant: Y")
	end
	# 2 - Wkl
	if (AX2>BX2 && AY2<BY2) || (AX2<BX2 && AY2>BX2)
		#weakly - A or B
		println("\n[Player 2] Weakly dominant: X")
	end
	println()
end


intialPostions = [-1, -1, -1, -1, -1, -1, -1, -1]
currentPlayer = 1
player1_max = 4
player1_moveMap = Any[]
player1_moves = Any[]
player2_max = 4
player2_moveMap = Any[]
player2_moves = Any[]
display_game(player1_moveMap, player1_moves, player2_moveMap, player2_moves)

#Play -> player 1 -> player 2 -> loop
while -1 in intialPostions
	global player1_max = player1_max
	global player2_max = player2_max
	global player1_moves = player1_moves
	global player2_moves = player2_moves
	global player1_moveMap = player1_moveMap
	global player2_moveMap = player2_moveMap
	global currentPlayer = currentPlayer

	if is_gameDone(player1_max, player2_max)==false
		render_report(player1_moveMap, player1_moves, player2_moveMap, player2_moves)
		print("\nGame done...\n")
		break
	end

	if currentPlayer==1
		println("\nCURRENT PLAYER : 1 (Moves left: ", player1_max,")\n")
		#Check for left moves
		if player1_max>0	#valid
			print("Choose between A and B (case sensitive): ")
			askAB = readline(stdin)
			if askAB!="A" && askAB!="B"	#invalid strategies
				println("\nInvalid strategies, ending game...\n[suggestion] Improve the game to support a recursie loop for this case\n")
				break
			else
				print("Choose between X and Y (case sensitive): ")
				askXY = readline(stdin)
				if askXY!="X" && askXY!="Y"
					println("\nInvalid move, ending game...\n[suggestion] Improve the game to support a recursie loop for this case\n")
					break
				else
					print("Enter your move between 0 and 10: ")
					askValue = parse(Int64, readline(stdin))
					if askValue>10
						println("\nInvalid move, ending game...\n[suggestion] Improve the game to support a recursie loop for this case\n")
						break
					else	#ok
						moveMap = askAB * askXY
						if unicity_check(moveMap, player1_moveMap)
							push!(player1_moveMap, moveMap)
							push!(player1_moves, askValue)
							player1_max-=1
							#Update current player
							currentPlayer=2
						else
							println("\nAlready played strategy, ending game...\n[suggestion] Improve the game to support a recursie loop for this case\n")
							break
						end
					end
				end
			end
		else	#continue to player 2
			currentPlayer==2
			continue
		end
	elseif currentPlayer==2
		println("\nCURRENT PLAYER : 2 (Moves left: ", player2_max ,")\n")
		#Check for left moves
		if player2_max>0	#valid
			print("Choose between A and B (case sensitive): ")
			askAB = readline(stdin)
			if askAB!="A" && askAB!="B"	#invalid strategies
				println("\nInvalid strategies, ending game...\n[suggestion] Improve the game to support a recursie loop for this case\n")
				break
			else
				print("Choose between X and Y (case sensitive): ")
				askXY = readline(stdin)
				if askXY!="X" && askXY!="Y"
					println("\nInvalid move, ending game...\n[suggestion] Improve the game to support a recursie loop for this case\n")
					break
				else
					print("Enter your move between 0 and 10: ")
					askValue = parse(Int64, readline(stdin))
					if askValue>10
						println("\nInvalid move, ending game...\n[suggestion] Improve the game to support a recursie loop for this case\n")
						break
					else	#ok
						moveMap = askAB * askXY
						if unicity_check(moveMap, player2_moveMap)
							push!(player2_moveMap, moveMap)
							push!(player2_moves, askValue)
							player2_max-=1
							#Update current player
							currentPlayer=1
						else
							println("\nAlready played strategy, ending game...\n[suggestion] Improve the game to support a recursie loop for this case\n")
							break
						end
					end
				end
			end
		else	#continue to player 1
			currentPlayer==1
			continue
		end
	end

	#Display maps
	println("\n", player1_moveMap ," -> ", player1_moves ,"\n", player2_moveMap ," -> ", player2_moves)
	display_game(player1_moveMap, player1_moves, player2_moveMap, player2_moves)
end