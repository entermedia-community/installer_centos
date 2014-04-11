# */5 * * * * /home/entermedia/memlog.sh

ps -C java -o "comm %cpu rss" --no-headers | awk '{a[$1] = $1; b[$1] += $2; c[$1] += $3}END{for (i in a)printf "%s, %0.1f, %0.1f\n", a[i], b[i], c[i]}' >> em.log
