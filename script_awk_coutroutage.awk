BEGIN {
i = 0;
count1 = 0;
count2 =0;
}
{
action = $1;
for(seqno = 0; seqno < 100; seqno++) {

if(action == "s") {
count1++;
}
if(action == "r") {
count2++;

}
}
}
END{


printf("Stats\n");
printf("recus: %d\n",count2);
printf("envoyé: %d\n", count1);
printf("Cout routage %f\n", count1/count2);

}
