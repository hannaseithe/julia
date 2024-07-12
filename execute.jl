include("optproblems.jl")
include("gradient.jl")
include("plot.jl")



#Plotting Call
lr = [-1.5,1.5]
PlotR2(Rosenbrock, GradientDecent, "Armijo", 100, lr,lr)
