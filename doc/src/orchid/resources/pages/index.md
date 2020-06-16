---
title: Home
---
# Arg2P
<!--- ![Arg2P Logo][logo] --->

<!--- [logo]: {{ 'assets/media/logo-Arg2P.png'|asset|scale(0.65)  }} --->

<p align="center">
  <img width="460" src={{ 'assets/media/logo-Arg2P.png'|asset|scale(0.65)  }}>
</p>


tuProlog (2P henceforth) is multi-paradigm logic programming framework written in Kotlin.

> Arg2P is an argumentation engine built on the top of 2P. Arg2P is a lightweight implementation of the ASPIC<sup>+</sup>-like system for structured  argumentation. 

In a nutshell, <span style="color: blue">arguments are produced from a set of defeasible rules</span>, and attack relationships between arguments are captured by argumentation graphs. The arguments of such graphs are labelled by following a labelling semantics. This simple framework will suffice to illustrate our upcoming investigation into persuasive burdens within an argumentation setting. 

In addition, we use defeasible rule schemata to account for <span style="color: blue">deontic</span> reasoning, towards doctrine reification, as presented in Riveret et al. 2019.

Moreover, the model has been extended following the <span style="color: blue">burden of proof</span> model presented in Calegari and Sartor 2020.

More information about the format of the knowledge base and rules can be found on the [basic syntax]({{ site.baseUrl }}/wiki/syntax).