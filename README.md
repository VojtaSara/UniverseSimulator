# Universe Simulator

The simplified idea taken from Stephen Wolfram's book "Project to find
the fundamental theory of physics" is that our universe could be represented
with a (hyper)graph. Moreover, time is just some one universal rule that is 
applied to the graph every "Planck time" (discrete time required) which stays 
constant for the duration of all of time. 

This might seem strange, but if we would say that every single quark in the
universe is a vertex and all fundamental forces are (hyper)edges between 
quarks or something, it becomes more plausible, we just need an absolutely
insanely large (hyper)graph.

Another way to look at this is that a graph with some set of graph rewriting
rules is a sort of a grammar and is Turing complete. Seeing that, the
fundamental argument here is just that the universe can be simulated on a 
computer. 

The "Universal rule" is just graph rewriting as I said, it is a function
that takes in (hyper)edges and outputs some reconfiguration of the inputted
(hyper)edges possibly with new vertices. Two examples:

Rule ([X,Y],[X,Z]) -> ([Y,X],[Z,X])
finds all vertices that connect to two other vertices and
simply reverses edges in question. 
For example in the following graph, edges ([3,1],[3,4]) get pattern matched
in our rule and ([1,3],[4,3]) is outputted so those two edges get affected.

In the next iteration of the rule, edges ([1,2],[1,3]) and ([4,1],[4,3])
would be affected.

 ┌──►2────────┐     ┌──►2────────┐
 │            │     │            │
 │            │     │            │
 1◄────────┐  │     1───┐        │
 ▲         │  │  ►  ▲   │        │  ► ...
 │   ┌─────3◄─┘     │   └────►3◄─┘
 │   │              │         ▲
 │   ▼              │         │
 └───4              └───4─────┘

Much more interesting are rules that add a new vertex, for example
Rule ([X,Y],[X,Z]) -> ([X,W],[W,Y],[X,Z])

Here it is again applied to our graph, again, the left side of the rule
pattern matches and the right side describes the new configuration.
 ┌──►2────────┐     ┌──►2────────┐
 │            │     │            │
 │            │     │            │
 1◄────────┐  │     1◄──┐        │
 ▲         │  │  ►  ▲   │        │  ► ...
 │   ┌─────3◄─┘     │   5◄────3◄─┘
 │   │              │   │
 │   ▼              │   ▼
 └───4              └───4
And thats it! Rules can act on completely disconnected parts of the graph,
for example ([X,Y], [U,V]) on the left side of a rule would just pattern
match with any pair of edges.

Usage:
$ nSteps rule2 rule2_params universe_singularity 4

This applies the rule2 defined in the file to the universe singularity 4 times in a row. Replacing 4 with a sufficiently large number and defining an appropriate rule to replace rule2 should result in simulating our universe. Run the experiment at your own risk, if intelligent life emerges, do NOT interrupt the simulation :).
