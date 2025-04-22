function [Population, Fitness] = ChangeResponse(Problem, Population, zeta)
    N = floor(length(Population) * zeta / 2) * 2;
    Selected = randperm(length(Population), N);
    
    %% Chaotic Maps
    ch(1) = rand;
    for i = 1 : N-1
        ch(i + 1) = 3.7 * ch(i) * (1 - ch(i));
    end

    if mean(ch) > zeta
        Population(Selected) = Nominal_Convergence(Problem, Population(Selected));
    else
        G_Pop = Problem.Evaluation(gaussian_mutation(Population.decs, Problem.lower, Problem.upper));
        Population(Selected) = KNN(G_Pop, N);
    end

    unSelected = setdiff(1:length(Population), Selected);
    Population(unSelected) = Problem.Evaluation(Population(unSelected).decs);
    Fitness = CalFitness(Population.objs);
    %[Population,Fitness]   = KNN([Population Population(Selected)], length(Population));
end