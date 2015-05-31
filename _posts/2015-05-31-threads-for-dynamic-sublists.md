---
layout: post
title: "Threads for Dynamic sublists"
description: "Introducing concept of threads for handling dynamic sublists"
category: GSoC
tags: [Dynamic sublist, Threads]
---

GNU Mailman currently deals with emails as messages which flow in a complex
pipeline and then eventually get dropped/bounced or posted at the target address.
These messages are not kept in a structure which makes it very complicated to
implement dynamic sublists i.e. to subscribe or unsubscribe from a particular
set of messages better called as 'conversation', this dependency needs '**Thread**'
structure to solve the above problem.

Threading or conversation threading is a feature used by many email clients,
newsgroups and internet forums in which the software aids the user by visually
grouping messages with their replies. These groups are called a conversation,
topic thread, or simply a thread. However in our implementation we are more
interested to make threads which are meaningful rather than grouping them visually.


### Implementation

To understand the thread implementation we will take reference from 'X-Message-ID'
which is a random HASH generated from a 'Message-ID' which is a subpart of message.
The newly generated 'X-Thread-ID' will act as a marker for messages which are to be
grouped under the same thread.


#### Requirement

Since the concept is 'Thread' in general is vast and needs more time to be implemented
across Mailman, we aim to use this concept only for those mailing lists which are
initially 'dlist_enabled' or simply saying dynamic list enabled via mailing list
object's attribute. Another requirement to start a thread would be email commands.
Mailman support email commands which are primarily set of instructions in a fixed
format, for example a message sent 'To: list-subscribe@example.com' with some
subject and body will be handled by mailman's 'command runners' and mailman will
understand that you want to join 'list@example.com', there are other options to
do the same from 'Subject' and 'Body' of the message since 'command runner' parse
those as well.

We will use similar format for dynamic lists 'list+new+subject@domain.com', here
its important for a user to add 'new' keyword in 'To:' or 'cc:' because the 'rules'
governing dynamic list will check for the same. Once above requirements are met
the rule will hit and we proceed to handling the message.


#### Code

In order to implement thread we need to _modify_ / **add** below files

* _command [runner]_
* _email [utilities]_
* **dlist [rules]**
* **thread [interfaces]**
* **thread [model]**


#### Completed task

Meeting the very first requirement i.e. 'dlist_enabled' attribute for the mailing
list object.

Review: [Gitlab repo][1] - Activity

* attribute added
* unittest added
* doctest added

[1]: "https://gitlab.com/godricglow/mailman/"

