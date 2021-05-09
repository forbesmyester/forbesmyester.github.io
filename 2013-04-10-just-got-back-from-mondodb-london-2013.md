# Just got back from MondoDB London 2013



So I just got back from MongoDB London 2013 and here is a quick run down of some of the highlights for me...

Optimising for Performance, Scale and Analytics - David Mytton, Server Density. Talked about spotting problems with your deployment and the things you should watch out for as signs of things going wrong / not working at optimum capacity. Was kind enough to put his [slides online](http://www.serverdensity.com/mongodbdays). The main points were:

- Slow queries in logs
- Timeouts on clients
- Disk IO stats (iostat or mongostat)
- Documents growing, causes moves
- Field name abstraction to something short is a really good idea, because those field names need to be in memory too

High Performance, Scalable MongoDB in a Bare Metal Cloud - Jonathan Wisler, Softlayer. Stressing hybrid cloud and making the note that it might not always be the best idea to put your database in a fully virtual environment like AWS. This point was brought up by lots of people but during his presentation the graphs seemed to say AWS is OK until you don't have enough memory for your working set, and then it is not... As a side note they seem to have a nice way of hosting a hybrid virtual/non-virtual environment that may be worth a better look at.

Using MongoDB Monitoring Service (MMS) - Mark Hillick, 10gen. Was a nice talk about MMS. The alerting options look nice and the graphs/data will help greatly in seeing what is going on... It's free!

It was a great day, heard some great talks and I met some interesting people, best part is I got it free for getting 100%'s on the [MongoDB Courses](https://education.10gen.com/)

