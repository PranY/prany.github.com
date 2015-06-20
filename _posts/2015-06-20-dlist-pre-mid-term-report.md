---
layout: post
title: "Dlist Pre-Mid-Term report"
description: "Implementing Thread, Dlist rule and Dlist Runner"
category: GSoC
tags: [Dynamic sublist, Threads]
---
Following up with the previous post, we will take a look at Threads, What they
are? How are they different from Dlist? The need of having Threads in Dlist.
Then we will move to Threads' implementation, followed by concerned models &
interfaces. Then we will jump to Dlist rule which will explain how a dlist is
detected for an incoming message. Next would be the Dlist runner which handles
the built-in commands for a dlist enabled mailing list message. Finally we overview the Override table and its need and some of the migrations done till date.


A **thread** is a collection of messages that can be arranged in a DAG (or even a tree) by using the reply-to relationship.


A **dlist** is a collection of messages defined by having a particular mailbox among their addressees.

_Thanks to Stephen for those definitions!_


Now a dlist which by definition is a collection of messages, needs to be
arranged in some order according to my implementation making threads necessary.
However its completely debatable why are we calling it a structure since my way
of making threads is simply adding another attribute to the message namely 'thread_id'. This id will keep track of where the message belongs in the collection.



#### Thread

dlist(model): This holds Thread and ThreadManager classes, Thread class
primarily deals with the relationships and variables. ThreadManager includes
two methods new_thread() and continue_thread(), new_thread() takes necessary
parameters and calls create_thread() which handles the database, the
new_thread() method is complete and continue_thread() is in process.


```
In : from mailman.interfaces.dlist import IThreadManager

In : thread_manager = getUtility(IThreadManager)

In : thread_manager.new_thread(mlist, msg)

In : msg['thread-id']
Out: 'UQK2WXGBPSGASPABLTG3PZKSV3TZCGVE'
```



#### Dlist rule

dlist(rule): It contains a check whether a mailing list id dlist enabled or not
followed by a match for keyword 'new' separated by '+' delimiter in the subaddress. If everything is fine then rule hits.


```
In : rule = config.rules['dlist']

In : from zope.interface.verify import verifyObject

In : rule = config.rules['dlist']

In : from mailman.interfaces.rules import IRule

In : verifyObject(IRule, rule)
Out: True

In : print(rule.name)
dlist

In : rule.check(mlist, msg, {})
Out: True

In : mlist.dlist_enabled = False

In : rule.check(mlist, msg, {})
Out: False

In : mlist.dlist_enabled = True

In : msg = mfs("""\
From: aperson@example.com
To: test+random@example.com
Subject: This is the subject
Message-ID: random
echo Body
""")

In : rule.check(mlist, msg, {})
Out: False

```



#### Dlist runner

dlist(runner): It is derived from CommandRunner and does the same thing except
for looking for '+new-request' commands instead of '-request' and processing them. I have added a 'Thread-Id' in message details which is visible after the 
message is processed.

```
In : from mailman.testing.documentation import specialized_message_from_string as mfs

In : msg = mfs("""\
   ....: From: aperson@example.com
   ....: To: test+new@example.com
   ....: Subject: random text
   ....: Message-ID: random
   ....: echo Body
   ....: """)

In : from mailman.app.inject import  inject_message

In : from mailman.runners.command import CommandRunner

In : from mailman.runners.dlist import DlistRunner

In : from mailman.testing.helpers import get_queue_messages

In : from mailman.testing.helpers import make_testable_runner

In : filebase = inject_message(mlist, msg, switchboard='dlist')

In : dlist = make_testable_runner(DlistRunner)

In : dlist.run()

In : messages = get_queue_messages('virgin')

In : len(messages)
Out: 1

In : print(messages[0].msg)
Subject: The results of your email commands
From: test-bounces@example.com
To: aperson@example.com
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-ID: <20150619235055.18864.88398@debian>
Date: Sat, 20 Jun 2015 05:20:55 +0530
Precedence: bulk

The results of your email command are provided below.

- Original message details:
From: aperson@example.com
Subject: random text
Date: Sat, 20 Jun 2015 05:20:54 +0530
Message-ID: random
Thread-ID: UQK2WXGBPSGASPABLTG3PZKSV3TZCGVE

- Results:

- Done.

```


#### Override

This model overrides the default user preferences for subscription or 
unsubscription from a particular thread. By default all 'First' posts are
received by all the users and if a user wishes to unsubscribe (assuming its
his/her default status "Receive all mails") 'Override' will store this 
change in preference and will unsubscribe the user. If current status is
"Only receive first post" and user particularly wishes to subscribe to a
thread then Override will store that preference and subscribe the user.

dlist(model): Override and OverrideManager classes are included in the dlist
model, Override contains the basic definitions and relationships, 
OverrideManager included override() method which handles the input and 
override_in() method which is called internally by override() to handle 
database.



#### Upcoming work

Override will be functional soon and then recipients calculation can be done
which will be called internally by continue_thread().

_Possible Implementation_

```
if mlist.dlist_enabled == True:

	recipients_allpost = set(member.address.email
                         for member in mlist.regular_members.members
                         if member.delivery_status == DeliveryStatus.enabled &&
                         if member.preference.dlist_preference = 2)

	recipients_firstpostonly = set(member.address.email
                         for member in mlist.regular_members.members
                         if member.delivery_status == DeliveryStatus.enabled &&
                         if member.preference.dlist_preference = 2)

if mlist.dlist_enabled == False:

	recipients = set(member.address.email
                         for member in mlist.regular_members.members
                         if member.delivery_status == DeliveryStatus.enabled)
```
member_recipients(handler): Above definitions will be added to calculate email
recipients for a dlist enabled mailing list or otherwise.

Since the tables are up for 'Thread' & 'Override' and member is introduced to a
new preference i.e. 'dlist_preference', a member can use 'override(member_id, thread_id, preference)' to change the preference.


#### Challenges

It is easy to design all models and interface and create relevant methods, to
some extent it is easy to write a migration, however the 'thread' table 
required a many-to-one relationship with member, 'override' table required a 
many-to-one relationship with member and simultaneously 'thread' table required
a many-to-many relationship (all relations are backrefs) with 'override', 
handling SQLalchemy for the first time with all these can be a pain, specially 
working out an association table to handle a many-to-many relationship as in 
the case of 'thread' and 'override' table. Also post migrations there were 
difficulties like 'mailman not found' which simply required all Enums in 
migration to be changed to sa.Integer, sometimes there were 'ALTER type' 
issues which corresponds to new migrations sitting over old database (if only 
a type is changed) and we are trying to start mailman or mailman shell.


PS: I will try to add syntax highlighting before my next post to make it
easier for readers. I'm looking forward for reviews just below the post or
on the mailing list.


