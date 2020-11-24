



Hi TG,
It's great to hear from you! I'm sorry that the repo is empty. As you know, I moved from ISI to Brandeis when I was wrapping up the camera ready for this paper, and while I had the best of intentions of getting everything up in the repo, it never happened. I planned to clean up my mess this past summer, but then COVID happened. It hasn't helped that you are so far the only person to show interest in this work :). At least we have one fan!

I believe I have everything you need, but it will take a little bit of organizing because the results were spread across three filesystems at ISI and hastily archived as I was leaving. I should be able to get back to you next week.

A few thoughts on how that paper turned out. The paper Dan and I did was a good start, but I think there's a lot of room for improvement. One of the key issues with the methodology is that we did not have hand-annotated (for relevance) multilingual corpora to work with. There are some CLEF evaluations out there that have some usable multilingual annotations, but things vary a fair amount year over year and each task was done in different languages with different goals.

I originally constrained the project to have an IR collection that was parallel (Europarl), which allowed us to use English IR results as a sort of "bronze standard" annotation, but was also chosen so that we could measure MT metrics on the actual IR collection if we wanted to. But we never did (unlike the experiments we ran on MATERIAL data). Part of the problem was that I ran out of time to do this, but this is kind of a rare situation so I didn't really push on it more: how often does one actually have a parallel IR collection? In this case, the Europarl collection was quite small and I also realized that it is not quite as parallel as it claims to be. (The sentence alignment step used in Europarl must be excluding a fair amount of stuff, I think.)

But unless you are particularly interested in how badly the neural IR model performed on MT output, I would recommend using the Europarl data only. The relevance paradigm is also much better (as opposed to Wiki, where only one article is relevant per query).

The thing that is very puzzling from the paper is in Table 2, specifically that based on the collection (Europarl or Wiki), the IR metrics are more or less sensitive to higher-order translation evaluation. I ran out of time to analyze this more. It probably has more to do with the queries than the documents, but this begs the question of if any study is going to get consistent results if using multiple collections or types of queries.

Also, the paper only includes BLEU; basically we found from early experiments that there wasn't a ton of value in doing other metrics, and we could barely make things fit in the paper. If I had to do this again, I might include CHRF3, although I have found that most useful in more extreme low resource settings (like that subword segmentation paper I mentioned on Twitter), and the usual suspects like ROUGE and METEOR.

Please see the attached handout, which was from the end of Pratik's internship. (Take everything with a grain of salt; I didn't use any of his code or experiments for the final paper because I wasn't fully confident in them.) It doesn't include a table, but it discusses our impressions about how different metrics worked. A really interesting finding from that handout was that F1 and precision were pretty much king, although BLEU was very close. So I think you should definitely include per-sentence term F1, at least on non-stop words. That was using the MATERIAL metric and notion of relevance, which as you know, are very strange.

I'm of course happy to provide you whatever you need from the previous paper, and I'll do so soon. But if you're interested in collaborating, I'd be very excited to do so. I spent a lot of time working out the complexities of dealing with this problem, and would love to continue.

Constantine Lignos
Assistant Professor of Linguistics in Computer Science
Pronouns: he/him/his

---------- Forwarded message ---------
From: Thamme Gowda <tg@isi.edu>
Date: Fri, Oct 9, 2020 at 5:17 PM
Subject: Info on your MT IR EMNLP2019 paper
To: Constantine Lignos <lignos@isi.edu>, constantine@lignos.org <constantine@lignos.org>
Cc: Daniel Cohen <dcohen@cs.umass.edu>


Hello Constantine, 

I hope you are doing great at your new job.
I am looking forward to your new paper on BPE that you recently mentioned on twitter!

BTW, I am working on a new paper related to MT IR evaluation measures.
I found you and Dan (CC’d) have this related work:  https://lignos.org/papers/Lignos-et-al_MT-IR_EMNLP2019.pdf 

I am planning to use your work as a baseline and trying to reuse experiments for an easier comparison. 

I already looked inside  this repo https://github.com/ConstantineLignos/mt-clir-emnlp-2019  that is ref’d in paper,  but  it is empty.
Do you still have access to these following files?

MT output and reference files for all experiments -- so I can compute BLEU and its alternatives for a comparison
Optionally a Excel/CSV/TSV file having BLEU and other scores – so I can do some sanity check
Excel/CSV/TSV of RBO / IR scores -- so I can compute correlations with MT scores (maybe Dan will provide it?)

It would be best if you could upload these files to github when you get time.

 

what I am trying to do:
I have an MT measure that is better than BLEU. It has been useful lately in MATERIAL program. 
I am trying to justify the use of my new measure using downstream task like CL-IR.
The Table 2 in your paper is exactly what we are trying to do ( but with some more MT measures like BLEU)
Table

Description automatically generated

 

Thanks in advance

TG