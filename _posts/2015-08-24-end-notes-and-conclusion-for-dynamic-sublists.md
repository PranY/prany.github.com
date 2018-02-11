---
layout: post
title: "End notes and conclusion for Dynamic Sublists"
description: "Overall implementation changes and end notes"
category: GSoC
tags: [Dynamic sublist, Threads]
---
Here is the much delayed blog I was supposed to put long ago but I could not for some reasons. So I will be clubbing all the info in this post and make this as my concluding post for GSoC 2015 under GNU Mailman.
To start with, I successfully completed all the segments of code under dynamic list project by the mid–term, however as soon as I thought of combining everything and sending a merge request I realized the overall output was not as expected. Then started the debugging which actually turned almost everything upside down (Thanks to Abhilash Raj for helping me with core functionality)
The command runner was the source for my Dlist runner which was actually missing the Dlist rules I had designed earlier, this was happening because I misunderstood the message flow in pipelines. The new structure is as below

<center>
<img src="assets/images/flow.png" alt="Message Flow">
</center>

#### Changes from previous implementation
Previously the flow was LMTP --> Command --> Dlist which skipped all the rules. The message filtering and pipeline flow remains the same as previous with minor changes.
Now the Dlist runner is renewed and it handles the new set of commands namely “new”, “continue”, “subscribe” and “unsubscribe” without affecting the subaddress dictionary and split_recipient  in LMTP. This is possible due to a new split_dlist__recipient in LMTP which exclusively handles the Dlist commands. Dlist enabled lists have different addresses. They are of type `listname+new@domain`, `listname+threadid@domain`, `listname+new+threadid@domain` and `listname+threadid+subscribe/ubsubcribe@domain`. These addresses are more or less self explanatory and  `listaname+new+threadid@domain` might be deprecated later (Just designed for testing purpose)
Earlier I was storing the threadid in msg[‘thread-id’] which was not the correct place(As Abhilash pointed out) so it has been moved to msgdata[‘thread-id’]

Everything else is as proposed earlier and working accurately. Though a few doctests and documentation is missing but that will be done shortly.

#### Acknowledgment

It was a great experience working along with Terri and Steve (mentors) and Abhilash, Florian and Barry (guide). Working with core couldn't have been possible without Abhilash and Barry, more importantly I learned how to code in a proper manner thanks to Steve (Checking for typos, code places, docstrings and everything that makes a code pythonic followed by PEP8-ing). Florian managed to get me out of "communication gap" with mentors every once in a while and strongly supported me in challenging times. I thankful to everybody for everything.

#### End note

Dlist implementation is complete according to the proposal however its best utilization would come in after it's integration with Postorius, so I'll take a little time off and then start the integration myself as a continued work post GSoC '15.

Cheers (_)3 GNU Mailman
