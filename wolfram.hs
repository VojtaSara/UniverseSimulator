--  _    _ _   _ _______      ________ _____   _____ ______      
-- | |  | | \ | |_   _\ \    / /  ____|  __ \ / ____|  ____|     
-- | |  | |  \| | | |  \ \  / /| |__  | |__) | (___ | |__        
-- | |  | | . ` | | |   \ \/ / |  __| |  _  / \___ \|  __|       
-- | |__| | |\  |_| |_   \  /  | |____| | \ \ ____) | |____      
--  \____/|_|_\_|_____| _ \/ _ |______|_|  \_\_____/|______|___  
--  / ____|_   _|  \/  | |  | | |        /\|__   __/ __ \|  __ \ 
-- | (___   | | | \  / | |  | | |       /  \  | | | |  | | |__) |
--  \___ \  | | | |\/| | |  | | |      / /\ \ | | | |  | |  _  / 
--  ____) |_| |_| |  | | |__| | |____ / ____ \| | | |__| | | \ \ 
-- |_____/|_____|_|  |_|\____/|______/_/    \_\_|  \____/|_|  \_\

import Data.List
-- The simplified idea taken from Stephen Wolfram's book "Project to find
-- the fundamental theory of physics" is that our universe could be represented
-- with a (hyper)graph. Moreover, time is just some one universal rule that is 
-- applied to the graph every "Planck time" (discrete time required) which stays 
-- constant for the duration of all of time. 

-- This might seem strange, but if we would say that every single quark in the
-- universe is a vertex and all fundamental forces are (hyper)edges between 
-- quarks or something, it becomes more plausible, we just need an absolutely
-- insanely large (hyper)graph.

-- Another way to look at this is that a graph with some set of graph rewriting
-- rules is a sort of a grammar and is Turing complete. Seeing that, the
-- fundamental argument here is just that the universe can be simulated on a 
-- computer. 

-- The "Universal rule" is just graph rewriting as I said, it is a function
-- that takes in (hyper)edges and outputs some reconfiguration of the inputted
-- (hyper)edges possibly with new vertices. Two examples:

-- Rule ([X,Y],[X,Z]) -> ([Y,X],[Z,X])
-- finds all vertices that connect to two other vertices and
-- simply reverses edges in question. 
-- For example in the following graph, edges ([3,1],[3,4]) get pattern matched
-- in our rule and ([1,3],[4,3]) is outputted so those two edges get affected.

-- In the next iteration of the rule, edges ([1,2],[1,3]) and ([4,1],[4,3])
-- would be affected.

--  ┌──►2────────┐     ┌──►2────────┐
--  │            │     │            │
--  │            │     │            │
--  1◄────────┐  │     1───┐        │
--  ▲         │  │  ►  ▲   │        │  ► ...
--  │   ┌─────3◄─┘     │   └────►3◄─┘
--  │   │              │         ▲
--  │   ▼              │         │
--  └───4              └───4─────┘

-- Much more interesting are rules that add a new vertex, for example
-- Rule ([X,Y],[X,Z]) -> ([X,W],[W,Y],[X,Z])

-- Here it is again applied to our graph, again, the left side of the rule
-- pattern matches and the right side describes the new configuration.

--  ┌──►2────────┐     ┌──►2────────┐
--  │            │     │            │
--  │            │     │            │
--  1◄────────┐  │     1◄──┐        │
--  ▲         │  │  ►  ▲   │        │  ► ...
--  │   ┌─────3◄─┘     │   5◄────3◄─┘
--  │   │              │   │
--  │   ▼              │   ▼
--  └───4              └───4

-- And thats it! Rules can act on completely disconnected parts of the graph,
-- for example ([X,Y], [U,V]) on the left side of a rule would just pattern
-- match with any pair of edges.

--  _    _ _   _ _     
-- | |  | | | (_) |    
-- | |  | | |_ _| |___ 
-- | |  | | __| | / __|
-- | |__| | |_| | \__ \
--  \____/ \__|_|_|___/
--                                                   
-- First a function that gives all unique n-sized subsets of a given set
ntets x n = flatten (map permutate (filter (\e -> length e == n) (ntets' x)))
ntets' [] = [[]]
ntets' (x:xs) = ntets' xs ++ map (x:) (ntets' xs)
flatten [] = []
flatten (x:xs) = x ++ flatten xs

permutate :: (Eq a) => [a] -> [[a]]
permutate [] = [[]]
permutate l = [a:x | a <- l, x <- (permutate $ filter (\x -> x /= a) l)]

rmdups :: Eq a => [a] -> [a]
rmdups [] = []
rmdups (x : xs) = x : rmdups (filter (/= x) xs)

filterByArray all applied = 
    map (\(_,b) -> b) (filter (\(e,_) -> e /= []) (zip all applied))

nEmptyLists 0 = []
nEmptyLists n = foldr (.) id (replicate (n-1) (++ [[]])) [[]]

-- The following function removes all elements excluding first to occur
-- Could be probably simplified with a map / foldr but I can't see it now
-- e.g.: [[],[],[],[],[1],[],[2]] --> [[],[],[],[],[1],[],[]]]
delete_notfirst list = delete_notfirst' list 0   
delete_notfirst' (x:xs) n = 
    if x == [] 
        then delete_notfirst' xs (n+1) 
    else ((nEmptyLists n) ++ [x]) ++ (nEmptyLists (length xs) )

-- Generate num new elements
new_elems max num = take num [(max+1)..]

--   __  __       _         _             _      
--  |  \/  |     (_)       | |           (_)     
--  | \  / | __ _ _ _ __   | | ___   __ _ _  ___ 
--  | |\/| |/ _` | | '_ \  | |/ _ \ / _` | |/ __|
--  | |  | | (_| | | | | | | | (_) | (_| | | (__ 
--  |_|  |_|\__,_|_|_| |_| |_|\___/ \__, |_|\___|
--                                   __/ |       
--                                  |___/        

-- Here, we can define different rules, rules can add new elements,
-- but for that, the number of added elements has to be added accordingly
-- into rule_params. The rule rank is how many hyperedges are on the input
-- of the rule.

rule1 [] [[a,b],[x,y]] = if a == x then [[y,x],[b,a]] else []
-- Params: (Rule rank, New element count)
rule1_params :: (Int,Int)
rule1_params = (2, 0)

rule2 [z] [[a,b],[x,y]] = if a == x then [[a,z],[z,b],[z,y]] else []
-- Params: (Rule rank, New element count)
rule2_params :: (Int,Int)
rule2_params = (2, 1)

-- We have to define some beggining state of the universe. This is akin to
-- setting how the universe looks like at t=0, that's why I call it
-- a singularity
universe_singularity1 = [[1,2],[2,3],[3,1],[3,4]]

-- Apply our universal rule once to the Universe parameter "original"
one_step_add rule (rule_rank, rule_newelems) original =
    let nonapplied = ntets original rule_rank
        new_elements = new_elems (maximum (flatten original)) rule_newelems
        applied = map (rule new_elements) (ntets original rule_rank)
        applied_original = flatten (filterByArray applied nonapplied)
        afterStep = rmdups ((original \\ applied_original) 
                                    ++ flatten (filter (\e -> e /= []) applied))
    in afterStep

-- Apply our universal rule n times
nSteps rule ruleparams original n = foldr (.) 
            id (replicate n (one_step_add rule ruleparams)) original