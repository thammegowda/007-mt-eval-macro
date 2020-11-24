from bleurt paper: "[BLEU has] been repeatedly shown to correlate poorly with human judgment, in particular when all the systems to compare have a similar level of accuracy." (then four citations) You definitely want to understand how the metrics people think...probably check out the recent wmt metrics papers (e.g. https://www.aclweb.org/anthology/W19-5302.pdf) and the best metrics from these.

i feel like we might have mentioned CHRF before? https://www.aclweb.org/anthology/W15-3049/ (not macro though)

ESIM: https://www.aclweb.org/anthology/P19-1269.pdf
tangled up in bleu: https://www.aclweb.org/anthology/2020.acl-main.448.pdf
YISI-1: https://www.aclweb.org/anthology/W19-5358/


\begin{itemize}
\item BLEU was developed in an era when MT was bad in adequacy and fluency.
\item Nowadays MT is pretty good in fluency but there are always adequacy concerns; BLEU doesn't correlate with downstream performance when it's needed for meaning
\item BLEU focuses on frequent types and this harms adequacy
\item Inspired by classifiers, Macro measures are better at tracking adequacy
\item super simple 1-gram macrof1...
\item     correlates well with human judgement 
\item     correlates consistently with downstream information-gathering tasks
\item     discriminates adequacy from fluency in MT comparison
\item we recommend macrof1 when comparing modern MT
\end{itemize}


i think i missed a few key details like the non-mt generation task