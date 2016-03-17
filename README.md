# IDN401FinalProject
Final project for Operation Management course at University of Iceland 2016.
Exam schedule optimization via AMPL.

### Hard Constraints
- No student takes two or more exams at the same time.
- Exams for jointly taught courses shall be at the same time.
- The number of seats for each exam-slot shall not be more than 450.
- No student takes more than 2 exams per day.

### Soft Constraints
- The amount of students taking an exam from day to day shall remain fairly even.
- Difficult exams shall be scheduled as early as possible.
- Exams shall be scheduled so they are finished at earliest convenience.

### Líkangerð

Leitast er við að finna heppilegt líkan og lausn á próftöflu vorannar 2016. Með
líkaninu skal svara eftirfarandi spurningum:

A. Hver er lágmarksfjöldi prófstokka sem þarf til að búa til próftöflu? Próftafl-
an þarf einungis að uppfylla þrjú skilyrði (sjá inngang) sem gera próftöfl-
una gjaldgenga. Væri hægt að stytta próftímann ef fjöldi sæta væru næg?
Hversu mikið væri hægt að stytta hann? Hver er þá nauðsynlegur há-
marksfjöldi sæta?

B. Finnið heppilegan mælikvarða á hvíld milli prófa fyrir hópanna 61. Hvaða
gildi tekur sá mælikvarði fyrir auglýsta próftöflu háskólans fyrir vorið 2016?
Getið þið fundið betri lausn? Hvernig er hún betri? Athugið að hér
gerum við ráð fyrir að prófstokkarnir séu 22.

C. Bætið líkan ykkar þannig að nemendur klári prófin sem fyrst og próftímabilið
styttist. Hér gerum við ráð fyrir að heildarfjöldi tiltækra sæta sé 450.
Hvernig dreifast nemendur á prófstokkanna? Breytist hvíldartími á milli
prófa?

D. Reynið nú að færa fjölmennu námskeiðin fyrr á próftímabilið. Hvernig
breytist lausnin? Skoðið hvernig hvíldartími og dreifing nemenda yfir prófstokka
breytist.

E. Stillið nú upp líkani sem hópur ykkar telur gefa bestu lausn fyrir nemenda,
kennara og stjórnendur skólans. Rökstyðjið val ykkar og berið saman við
núverandi próftöflu fyrir vorið. Að hvaða leiti er hún betri?

F. Keyrið líkanið ykkar (liður 5) fyrir ólíkan fjölda prófstokka. Teljið þið að
stytta megi próftímabilið eða þarf ef til vill að lengja það? Rökstyðjið, þá
þarf að athuga hvernig hvíldartími breytist og kostnaður vegna prófhalds.
