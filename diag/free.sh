/proc/self/maps perl -ne'/-/;print hex($``)-$e,$/;$e=hex($'"'"')'| sort -nr|head -n 1
