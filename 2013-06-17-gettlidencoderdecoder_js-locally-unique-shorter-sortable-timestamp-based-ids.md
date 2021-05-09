# getTLIdEncoderDecoder.js - Locally unique, shorter, sortable timestamp based Id's


I have recently wrote getTLIdEncoderDecoder.js which is a component of SyncIt's upcoming Path based storage.

Given a supplied epoch it will generate you TLId, which is a word I just invented!

What is a TLId? It stands for Time Local Id and gives you a reference based on a timestamp that is locally unique.

Advantages:

1. The are shorter than timestamps (though not by a lot).
2. You can extract the timestamp that the TLId was generated.
3. If you want them ordered by generation time, you do not need to convert them back to timestamps beforehand.

Here's how you use it:

```
// Use one character (32 bit number) to ensure uniqueness within a millisecond
var uniquenessPerMillisecond = 1;
// As close as possible (but lower) than the lowest date to give shorter Id's
var epoch = new Date(1970,0,1).getTime();

// Get the TLId Encoder / Decoder
var encoderDecoder = getTLIdEncoderDecoder(epoch,uniquenessPerMillisecond);

// Encode a date into a unique string
var dates = [
  encoderDecoder.encode(),
  encoderDecoder.encode(new Date(1980,1,6).getTime()),
  encoderDecoder.encode(new Date(1981,3,15).getTime()),
  encoderDecoder.encode(new Date(1986,8,9).getTime()),
  encoderDecoder.encode(new Date(1983,10,3).getTime()),
  encoderDecoder.encode(new Date(1982,0,6).getTime())
];

// Get the dates it was encoded
var originalTimestamps = dates.map(encoderDecoder.decode);

// Sort them in date order
var sortedDates = dates.sort(encoderDecoder.sort);

```

Source code is, of course, located [at](https://github.com/forbesmyester/SyncIt/blob/master/js/getTLIdEncoderDecoder.js) [GitHub](https://github.com/forbesmyester/SyncIt/blob/master/js/getTLIdEncoderDecoder.js)

