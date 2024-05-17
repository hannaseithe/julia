struct simTab
    tab
    nb
    b
    gce
    rs
end

function simTabCon(tab)
        b = size(tab,1) - 1
        nb = size(tab,2) - 2 - b
        simTab(tab,nb,b,b+1,nb+b+1)
end

Base.copy(t::simTab) = simTab(t.tab,t.nb,t.b,t.gce,t.rs)


function selectPivotColumn(t)
    #iterate over nonbase var columns and base var rows to find pivot columns
    result = [1,1]
    for i in 1:t.b
        for j in 1:t.nb
            if (t.tab[i,j] != 0)
                if t.tab[result...] != 0 
                    old = (t.tab[result[1],t.rs]*t.tab[t.gce,result[2]])/t.tab[result...]
                    new = (t.tab[i,t.rs]*t.tab[t.gce,j])/t.tab[i,j]
                    if new > old
                        result = [i,j]
                    end
                else 
                    result = [i,j]
                end
            end
        end
    end
    return result[2]
end

function selectPivotElement(t) 
    col = selectPivotColumn(t)
    val = 0
    ind = 0
    for i in 1:t.b
        if (val == 0) & (t.tab[i,col] != 0)
            val = t.tab[i,t.b]/t.tab[i,col]
            ind = i
        else 
            new = t.tab[i,t.b]/t.tab[i,col]
            if new < val
                val = new
                ind = i
            end
        end
    end
    return [ind,col]
end

function gceUnderZero(t)
    result = false
    for i in 1:t.rs-1
        if t.tab[t.gce,i] < 0
            result = true
        end
    end
    return result
end

function simplex(t)
    piv = selectPivotElement(t)
    nt = copy(t)
    index = 0
    while (gceUnderZero(t)) & (index < 30)
        println(index)
        index = index + 1
        for i in 1:t.rs
            t.tab[piv[1],i] = t.tab[piv[1],i]/t.tab[piv...]
        end
        for i in 1:t.gce
            t.tab[i, piv[2]] = -t.tab[i, piv[2]]/t.tab[piv...]
        end
        t.tab[piv...] = 1/t.tab[piv...]
        for i in 1:t.gce
            for j in 1:t.rs
                if (i != piv[1]) & (j != piv[2])
                t.tab[i,j] = t.tab[i,j] - t.tab[piv[1],j] * t.tab[i,piv[2]] / t.tab[piv...]
                end
            end
        end
    end
    println(t.tab)

end

tab1 = [5 8 1 0 0 700 0
1 1 0 1 0 100 0
0 1 0 0 1 60 0
-1 -2 0 0 0 0 0]

stab1 = simTabCon(tab1)
simplex(stab1)