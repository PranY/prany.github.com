---
layout: post
title: "Implementation changes and work summary"
description: " Implementation changes in Dlist command acceptance and override method"
category: GSoC
tags: [Dynamic sublist, Threads]
---

This blog post includes a summary of all the work done till now as well as it accounts for few necessary changes and the reasons for the same.

In the previous post we discussed Threads, Dlist rule, Dlist runner and a partial implementation of override table followed by recipient calculation. Since the proposed work was based on Syster's implementation of Dlist, completely reproducing it was the expected course of project. However working with GNU mailman 3.0 and diving deep into the functioning of Dlist, few things required reasonable changes in implementation, therefore altering the proposed work.

#### Implementation changes

Until the previous post, the rule which checked for a Dlist message had two conditions, first the mailing list should be Dlist enabled (which is done via mailing list attribute) and second it must have the keyword 'new'. To do this the LMTP runner was modified, 'new-request' keywords were appended to the SUBADDRESS_NAMES dictionary. These were checked by the Dlist runner to process the 'request'. So a typical 'listname+new-request@domain' was required in 'To:', If a user wishes to add a post, the 'request' part will not be needed similar to mailman's default implementation. But to post to a particular thread (Threads are discussed in detail in the previous post) the user must provide the thread_id (a unique identifier for a thread), now this thread id is a sha1 hex which is extremely hard to input manually in any of the message fields. As a solution (first change in implementation), 'listname+ThreadID-request@domain' is automatically added to 'Reply-To:' which will help a user to post to a particular thread. After this change the rule will not hit since 'new' keyword is not found. Therefore the rule was changed (second change in implementation) as, first the mailing list should be Dlist enabled and second a regex query looking for '+sometext-' or '+sometext@' identifiers. This 'sometext' can be 'new' or 'threadID'. Still the job is not complete since the LMTP runner does not understand the new implementation, the 'split_recipient' method was changed (third implementation change) after a discussion with Barry. Now the LMTP runner can process the 'Reply-To' and no other keywords are manually appended for Dlist rule. Current 'request' allows all functionality but what if a user wish to change the Dlist preference using a 'request'?. Now there are two possibilities, first if the request is 'join/leave' after the threadID, we can simply 'subscribe/unsubscribe' the member from that thread and change the Dlist preference as per logic, second we can take the preference as request and do the same. Currently both the methods are supported and either can be discarded later after evaluating suggestions.


#### New work

Dlist(model): continue_thread() added, currently uses preference based request input.

member_recipients(handler): Calculates recipients as per Dlist preference, for first post only another check is required, which ensures no recipient if there is a threadID in msg['Reply-To'] because that conveys its not the first post.

email(utilities): Replicated add_message_hash to add_thread_hash, only difference is it takes twice catenated message-Id to generate the sha1 hex.


#### Progress check

```
In [1]: from mailman.interfaces.dlist import IThreadManager

In [2]: from mailman.interfaces.listmanager import IListManager

In [3]: from mailman.interfaces.domain import IDomainManager

In [4]: from mailman.app.lifecycle import create_list

In [5]: from zope.component import getUtility

In [6]: thread_manager = getUtility(IThreadManager)

In [7]: list_manager = getUtility(IListManager)

In [8]: domain_manager = getUtility(IDomainManager)

In [9]: mlist = list_manager.get('test@example.com')

In [10]: mlist.dlist_enabled = True

In [11]: mlist.members.member_count
Out[11]: 2

In [12]: from mailman.testing.documentation import specialized_message_from_string as mfs

In [13]: msg = mfs("""\
   ....: From: aperson@example.com
   ....: To: test+new-request@example.com
   ....: Subject: echo Subject
   ....: Message-ID: random
   ....: echo Body 
   ....: """)

In [14]: from mailman.interfaces.dlist import IThreadManager

In [15]: thread_manager = getUtility(IThreadManager)

#Since we already have a thread from previous post, threadID is used directly

In [16]: msg['Reply-to'] = 'test+VN7TPR2NKLDC52USSJBJIXTZ47P5MCMT-firstpost@example.com'

In [17]: thread_manager.continue_thread(mlist, msg)

```

#### Challenge

The continue_thread() method is working fine without errors and the implementation seems logical yet there is no entry in database, association table might be the issue! Need code review and help on this front.

PS: If this is resolved soon, a non-unit/doctested version of Dlist can be assumed complete. Rest of the time will be used for tests, documentation and suggestions for work till date. 