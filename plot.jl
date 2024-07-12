using PlotlyJS

function PlotR2(f, method, stepmethod, NP,xlr,ylr)
    #now plot everything
    #plot contour
    x = LinRange(xlr...,NP)
    y = LinRange(ylr...,NP)
    z = [f([x[i];y[j]]) for i in eachindex(x) for j in eachindex(y)]
    z = reshape(z,NP,NP)
    
    #http://juliaplots.org/PlotlyJS.jl/stable/examples/contour/
    data = PlotlyJS.contour(z=z,x=x,y=y, 
        colorscale="Jet",
        contours=Dict(
        :coloring=>"lines",                   
        :start=>0, :end=>20, :size=>0.5
        )
    )
    x = [-1.2, 1.0]
    fx, gfx = f(x;evalGrad=true)
    s = -gfx
    opt, finalStep, it = method(f,x,1e-3,10000; stepMethod=stepmethod, collectIterates=true)
    println(opt)
    display(finalStep)
    gradientSteps = PlotlyJS.scatter(x=it[1, :],y=it[2, :], mode="lines")

    layout = PlotlyJS.Layout(title="Höhenlinien der Rosenbrock Funktion mit Iterationspfad, x0=(-1.2,1.0)")
    p = PlotlyJS.plot([data,gradientSteps],layout) #plots the function -> muss wohl aus irgendeinem Grund der letzte Aufruf sein, sonst wird das Fenster nicht geöffnet???
    #println("test")
end