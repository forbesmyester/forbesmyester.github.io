# SyncIt: Storing Data In LocalForage Now Possible



Over the last few weeks I've done a few commits making storing data in [LocalForage](https://mozilla.github.io/localForage/) possible. I knew this would be quite easy as even though [SyncIt](https://github.com/forbesmyester/SyncIt) has up to now only been backed by LocalStorage it was wrapped in a way that all access to data had to be done via asyncronous callbacks, infact all but one of the API access points to the underlying storage were identical except one.

One thing I have noticed is that LocalStorage on Chrome really slows down as you start putting more and more data into it where as LocalForage, which uses [IndexedDB](http://www.w3.org/TR/IndexedDB/) on Chrome starts off initially slower but doesn't really seem to slow down at all, or at least slows down much slower.

So when I'm considering storage client side, I will only really be thinking of LocalStorage when I **know** the data will not grow, for everything else, from now on I'm going to use LocalForage.

