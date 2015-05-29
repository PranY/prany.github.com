---
layout: post
title: "Using ipython as prompt"
description: "Using ipython as prompt for handling mailman objects"
category: "Notes"
tags: [Mailman,Dlist,GSOC]
---

Mailman's setup works as mentioned in /mailman/docs/START.rst, however
if we try to run ipython by changing mailman.cfg (use_ipython: yes) venv does
not recognise the default ipython at /usr/bin/ipython3 which explains some issue
with $PATH variable in venv. If we build outside the venv in mailman folder 
`$ python3.4 setup.py develop` it may install everything but while running
mailman 

`› mailman start` 

`Starting Mailman's master runner`

`/usr/bin/python3.4: can't open file '/usr/bin/master': [Errno 2] No such file or directory`

this might come as a problem. As a hack we can activate venv and start mailman
and then deactivate and check `mailman status` which will be `running`, now we
can use ipython as our prompt for commands. Its obvious that we must install
ipython inside venv with `pip install ipython`. That is the sole purpose of 
having a venv in first place. However while avoiding ipython installation we
get this hack exposed and working, we must check out mailman core working
since this was expected to happens but the question is should this be happening
at all?