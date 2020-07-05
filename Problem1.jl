

function output(a)
    print(a)
end

N = 9

#Input - replaces zeros with a set of number 0-9
#Better solution - allocation zero set substitute programmatically.
"""
Example input.
Contraints: Adjacents letters !=
[[8,0,0,0,0,0,0,0,0],
 [0,0,3,6,0,0,0,0,0],
 [0,7,0,0,9,0,2,0,0],
 [0,5,0,0,0,7,0,0,0],
 [0,0,0,0,4,5,7,0,0],
 [0,0,0,1,0,0,0,3,0],
 [0,0,1,0,0,0,0,6,8],
 [0,0,8,5,0,0,0,1,0],
 [0,9,0,0,0,0,4,0,0]]
"""
field = Any[[8,Set(collect(1:9)),Set(collect(1:9)),Set(collect(1:9)),Set(collect(1:9)),Set(collect(1:9)),Set(collect(1:9)),Set(collect(1:9)),Set(collect(1:9))],
         [Set(collect(1:9)),Set(collect(1:9)),3,6,Set(collect(1:9)),Set(collect(1:9)),Set(collect(1:9)),Set(collect(1:9)),Set(collect(1:9))],
         [Set(collect(1:9)),7,Set(collect(1:9)),Set(collect(1:9)),9,Set(collect(1:9)),2,Set(collect(1:9)),Set(collect(1:9))],
         [Set(collect(1:9)),5,Set(collect(1:9)),Set(collect(1:9)),Set(collect(1:9)),7,Set(collect(1:9)),Set(collect(1:9)),Set(collect(1:9))],
         [Set(collect(1:9)),Set(collect(1:9)),Set(collect(1:9)),Set(collect(1:9)),4,5,7,Set(collect(1:9)),Set(collect(1:9))],
         [Set(collect(1:9)),Set(collect(1:9)),Set(collect(1:9)),1,Set(collect(1:9)),Set(collect(1:9)),Set(collect(1:9)),3,Set(collect(1:9))],
         [Set(collect(1:9)),Set(collect(1:9)),1,Set(collect(1:9)),Set(collect(1:9)),Set(collect(1:9)),Set(collect(1:9)),6,8],
         [Set(collect(1:9)),Set(collect(1:9)),8,5,Set(collect(1:9)),Set(collect(1:9)),Set(collect(1:9)),1,Set(collect(1:9))],
         [Set(collect(1:9)),9,Set(collect(1:9)),Set(collect(1:9)),Set(collect(1:9)),Set(collect(1:9)),4,Set(collect(1:9)),Set(collect(1:9))]]

function print_field(field)
    global N = N
    if field==false
        output("No solution")
        return
    end
    for i in 1:N
        for j in 1:N
            cell = field[i][j]
            if cell == 0 || typeof(cell)==Set{Int64}
                output(".")
            else
                output(cell)
            end
            if j % 3 == 0 && j < 9
                output(" |")
            end
            if j != 9
                output(" ")
            end
        end
        output("\n")
        if i % 3 == 0 && i < 9
            output("- - - + - - - + - - -\n")
        end
    end
end

state = field


function done(state)
    for row in state
        for cell in row
            if typeof(cell)==Set{Int64}
                return false
            end
        end
    end
    return true
end


function propagate_step(state)
    global N = N
    new_units = false

    for i in 1:N
        row = state[i]
        tmp = [x for x in row if typeof(x)!=Set{Int64}]
        valueS = Set(tmp)
        for j in 1:N
            if typeof(state[i][j])==Set{Int64}
                println(state[i][j], valueS)
                state[i][j] = setdiff(state[i][j], valueS)
                println(state[i][j])
                if length(state[i][j]) == 1
                    state[i][j] = pop!(state[i][j])
                    new_units = true
                elseif length(state[i][j]) == 0
                    return (false, nothing)
                end
            end
        end
    end

    for j in 1:N
        column = [state[x][j] for x in 1:N]
        tmp = [x for x in column if typeof(x)!=Set{Int64}]
        valueS = Set(tmp)
        for i in 1:N
            println(typeof(state[i][j]))
            if typeof(state[i][j])==Set{Int64}
                state[i][j] = setdiff(state[i][j], valueS)
                if length(state[i][j]) == 1
                    state[i][j] = pop!(state[i][j])
                    new_units = true
                elseif length(state[i][j]) == 0
                    return (false, nothing)
                end
            end
        end
    end

    for x in 1:2
        for y in 1:2
            valueS = Set()
            for i in 2*x:2*x+2
                for j in 2*y:2*y+2
                    cell = state[i][j]
                    if typeof(cell)!=Set{Int64}
                        push!(valueS, cell)
                    end
                end
            end
            for i in 2*x:2*x+2
                for j in 2*y:2*y+2
                    if typeof(state[i][j])==Set{Int64}
                        state[i][j] = setdiff(state[i][j], valueS)
                        if length(state[i][j]) == 1
                            state[i][j] = pop!(state[i][j])
                            new_units = true
                        elseif length(state[i][j]) == 0
                            return (false, nothing)
                        end
                    end
                end
            end
        end
    end

    return (true, new_units)
end

function propagate(state)
    while true
        tmp = propagate_step(state)
        solvable = tmp[1]
        new_unit = tmp[2]
        if solvable==false
            println("\n[warning] Need tuning to your required accuracy level (dft. 65%)...\n")
            return false
        end
        if new_unit==false
            println("\n[warning] Need tuning to your required accuracy level (dft. 65%)...\n")
            return true
        end
    end
end


function solve(state)
    global N = N
    solvable = propagate(state)

    if solvable==false
        return nothing
    end

    if done(state)
        return state
    end

    for i in 1:N
        for j in 1:N
            cell = state[i][j]
            if typeof(cell)==Set{Int64}
                for value in cell
                    new_state = deepcopy(state)
                    new_state[i][j] = value
                    solved = solve(new_state)
                    if solved!=nothing
                        return solved
                    end
                end
                return nothing
            end
        end
    end
end

print_field(solve(state))
