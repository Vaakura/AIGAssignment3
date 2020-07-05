mutable struct State
    reward
    actions
end

mutable struct Action
    resProb     #probability of reaching the resulting state and the resulting state in 2D array
    #[[probability, s'], [probability, s']...]
end

policy = []

#the actions
a0b = Action([])
a1b = Action([])
a0c = Action([])
a1c = Action([])
a2c = Action([])
a0d = Action([])
a1d = Action([])
a2d = Action([])

#create states for properties to be added
S0 = State(0, [])
S1 = State(0, [])
S2 = State(0, [])

#create the states with all known properties
S3 = State(100, [])
S4 = State(0, [])
S5 = State(0, [])

#add the 100% probability resProbs to their actions
push!(a0b.resProb, [1, S0])
push!(a0c.resProb, [1, S1])
push!(a0d.resProb, [1, S2])

singleStateCount = 0;

#==================================================================
0 < discount < 1
0 < probability < 1 {all probabilities of an action adding up to 1}
0 < reward < 100
===================================================================#

println("What is the discount value for the MDP? ")
discount = parse(Float64, readline(stdin))

println("\nWhat is the reward for State 0 (all blocks in box, none on table)? ")
S0.reward = parse(Float64, readline(stdin))
println("What is the probability of: ")
println("Reaching the state S0 with action a1b? ")
push!(a1b.resProb, [parse(Float16, readline(stdin)), S0])
println("Reaching the state S1 with action a1b? ")
push!(a1b.resProb, [parse(Float16, readline(stdin)), S1])
S0.actions = [a0b, a1b]

println("\nWhat is the reward for State 1 (only block B on the table)? ")
S1.reward = parse(Float64, readline(stdin))
println("What is the probability of: ")
println("Reaching the state S1 with action a1c? ")
push!(a1c.resProb, [parse(Float16, readline(stdin)), S1])
println("Reaching the state S4 with action a1c? ")
push!(a1c.resProb, [parse(Float16, readline(stdin)), S4])
println("Reaching the state S2 with action a1c? ")
push!(a1c.resProb, [parse(Float16, readline(stdin)), S2])
println("Reaching the state S1 with action a2c? ")
push!(a2c.resProb, [parse(Float16, readline(stdin)), S1])
println("Reaching the state S2 with action a2c? ")
push!(a2c.resProb, [parse(Float16, readline(stdin)), S2])
S1.actions = [a0c, a1c, a2c]

println("\nWhat is the reward for State 2 (Blocks B and C on the table, with C on top of B)? ")
S2.reward = parse(Float64, readline(stdin))
println("What is the probability of: ")
println("Reaching the state S2 with action a1d? ")
push!(a1d.resProb, [parse(Float16, readline(stdin)), S2])
println("Reaching the state S5 with action a1d? ")
push!(a1d.resProb, [parse(Float16, readline(stdin)), S5])
println("Reaching the state S3 with action a1d? ")
push!(a1d.resProb, [parse(Float16, readline(stdin)), S3])
println("Reaching the state S2 with action a2d? ")
push!(a2d.resProb, [parse(Float16, readline(stdin)), S2])
println("Reaching the state S3 with action a2d? ")
push!(a2d.resProb, [parse(Float16, readline(stdin)), S3])
S2.actions = [a0d, a1d, a2d]

#create array of states
states = [S0, S1, S2, S3, S4, S5]

#==================================================================
The MDP is process of choosing the best policy, or best path to a
goal state. This is accomplished using value iteration here using
the bellman equation to find the values.
===================================================================#

function V!(s)
    if length(s.actions) == 0
        return s.reward
    end
    max = 0
    for action in s.actions
        m = Q(s, action)
        if m > max
            max = m
            maxAct = action
        end
    end
    return [max, maxAct]
end

function Q!(st, a)
    QUtil = 0
    for s in a.resProb
        if s == st
            singleStateCount++
            if singleStateCount == 5
                singleStateCount = 0
                QUtil += s[1] * (s[2].reward + (discount * s[2].reward * s[1]))
                continue
            end
        end
        QUtil += s[1] * (s[2].reward + (discount * V(s[2])[1]))
    end
    return QUtil
end

for i in 1:3
    push!(policy, V(states[i])[2])
end

println("The optimal policy is:\n", join(policy, "\n"))