era(Ancient).
era(Classical).
era(Medieval).
era(Renaissance).


tech(Agriculture).
in_era(Agriculture, Ancient).
diff(Agriculture, Easy).
leads_to(Agriculture,Pottery).
leads_to(Agriculture,Animal Husbandry).
leads_to(Agriculture,Archery).
leads_to(Agriculture, Mining).

tech(Animal Husbandry).
in_era(Animal Husbandry, Ancient).
diff(Animal Husbandry, Medium).
requires(Animal Husbandry, Agriculture).
leads_to(Animal Husbundry, Trapping).
leads_to(Animal Husbandry,The Wheel).

tech(Trapping).
in_era(Trapping,Ancient).
diff(Trapping, Medium).
requires(Trapping,Animal Husbandry).

tech(Archery).
in_era(Archery,Ancient).
diff(Archery, Nightmare).
requires(Archery,Agriculture).
leads_to(Archery,The Wheel).

tech(Pottery).
in_era(Pottery,Ancient).
diff(Pottery, Medium).
requires(Pottery,Agriculture).
leads_to(Pottery,Sailing).
leads_to(Pottery,Calendar).
leads_to(Pottery,Writing).

tech(Sailing).
in_era(Sailing,Medieval).
diff(Sailing, Easy).
requires(Sailing,Pottery).

tech(Calendar).
in_era(Calendar,Ancient).
diff(Calendar, Hard).
requires(Calendar,Pottery).

tech(Writing).
in_era(Writing,Medieval).
diff(Writing, Hard).
requires(Writing,Pottery).


tech(Mining).
in_era(Mining,Ancient).
diff(Mining, Medium).
requires(Mining,Agriculture).
leads_to(Mining,Masonry).
leads_to(Mining,Bronze Working).

tech(Bronze Working).
in_era(Bronze Working,Ancient).
diff(Bronze Working, Easy).
requires(Bronze Working,Mining).

tech(The Wheel).
in_era(The Wheel,Ancient).
diff(The Wheel, Hard).
requires(The Wheel,Animal Husbandry).
requires(The Wheel,Archery).
leads_to(The Wheel,Mathematics).
leads_to(The Wheel,Horseback Riding).
leads_to(The Wheel, Construction).

tech(Horseback Riding).
in_era(Horseback Riding,Medieval).
diff(Horseback Riding, Easy).
requires(Horseback Riding,The Wheel).


tech(Mathematics).
in_era(Mathematics,Classical).
diff(Mathematics, Nightmare).
requires(Mathematics,The Wheel).
leads_to(Mathematics,Currency).
leads_to(Mathematics,Engineering).

tech(Currency).
in_era(Currency,Classical).
diff(Currency, Medium).
requires(Currency,Mathematics).

tech(Masonry).
in_era(Masonry,Ancient).
diff(Masonry, Hard).
requires(Masonry,Mining).
leads_to(Masonry,Construction).

tech(Construction).
in_era(Construction,Classical).
diff(Construction, Medium).
requires(Construction,Masonry).
requires(Construction, The Wheel).
leads_to(Construction,Engineering).

tech(Engineering).
in_era(Engineering,Classical).
diff(Engineering, Nightmare).
requires(Engineering,Mathematics).
requires(Engineering,Construction).
leads_to(Engineering,Metal Casting).
leads_to(Engineering,Machinery).


tech(Iron Working).
in_era(Iron Working,Medieval).
diff(Iron Working, Hard).

tech(Metal Casting).
in_era(Metal Casting,Medieval).
diff(Metal Casting, Easy).
requires(Metal Casting,Iron Working).
requires(Metal Casting,Engineering).
leads_to(Metal Casting,Physics).
leads_to(Metal Casting,Steel).

tech(Steel).
in_era(Steel,Medieval).
diff(Steel, Easy).
requires(Steel, Metal Casting).

tech(Guilds).
in_era(Guilds,Medieval).
diff(Guilds, Easy).
requires(Guilds,Currency).
leads_to(Guilds,Machinery).
leads_to(Guilds,Chivalry).

tech(Chivalry).
in_era(Chivalry,Medieval).
diff(Chivalry, Medium).
requires(Chivarly,Guilds).

tech(Machinery).
in_era(Machinery,Medieval).
diff(Medieval, Nightmare).
requires(Machinery,Guilds).
requires(Machinery,Engineering).
leads_to(Machinery,Printing Press).

tech(Physics).
in_era(Physics,Medieval).
diff(Physics, Nightmare).
requires(Physics,Metal Casting).
leads_to(Physics,Printing Press).
leads_to(Physics,Gunpowder).

tech(Gunpowder).
in_era(Gunpowder,Medieval).
diff(Gunpowder, Medium).
requires(Gunpowder,Physics).

tech(Printing Press).
in_era(Printing Press,Renaissance).
diff(Printing, Nightmare).
requires(Printing Press,Chivarly).
requires(Printing Press,Physics).
requires(Printing Press,Machinery).
leads_to(Printing Press,Economics).
leads_to(Printing Press,Metallurgy).

tech(Economics).
in_era(Economics,Renaissance).
diff(Economics, Nightmare).
requires(Economics,Printing Press).

tech(Metallurgy).
in_era(Metallurgy,Renaissance).
diff(Metallurgy, Easy).
requires(Metallurgy,Printing Press).