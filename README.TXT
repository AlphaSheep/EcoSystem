Copy the files in the BIN and UNIT directories into the respective Turbo Pascal 7.0 directories.

The program BLOBS.EXE will not work under most modern Windows installations, but runs well under DosBox. 
You can download it at http://www.dosbox.com

Turbo Pascal 7.0 is required to set the parameters. You will need to find it yourself.


========================================================

	The artifical Ecosystem

--------------------------------------------------------
	programmed by: Brendan Gray
	started on: 02.07.2006
========================================================

As God it is important that I create a world of my own...

I decided to name the organisms blobs.

Each blob has three natural urges. These determine what 
the blob wants to do at any given moment. They are:
	- To eat, either food, or the dead bodies of 
	   other blobs.
	- To fight, and hopefully kill blobs that get
	   too close. There is no particular reason for
	   this. They are just naturally agressive 
	   creatures
	- To reproduce, by mating with other blobs.
All of these urges exist to some degree in each blob, but
may be more prominant in some blobs than others.

The blobs are also born with three natural abilities in 
order to satisfy their urges. These determine how succesful 
a blob is in carrying out whatever that blob is trying 
to do. These abilities are as follows:
	- Hunting, which determines how succesful the blob 
	   is at finding wild food, but plays no role in 
	   it's ability to find dead blobs.
	- Fighting, which determines how succesful a blob 
	   is in a fight with another blob.
	- Determination, which determines how long a blob 
	   will spend trying to mate with the blob it is 
	   'in love' with.
As with the urges, each ability exists to some degree in 
each blob but one blob may be significantly better at 
something than another blob.

The magnitude of the urges is determined by it's DNA. The 
DNA consists of a string of 20 characters, each representing 
an urge or ability. A blobs colour represents it's dominant 
DNA type. The characters used to represent an ability in a 
blob are as follows, with the colour afterwards in brackets. 
	E - Hunger (blue)
	R - Reproduction (green)
	A - Aggression (red)
	H - Hunting (magenta)
	D - Determination (cyan)
	F - Fighting (yellow)
When a blob is born, it's DNA is constructed by taking 8 
random characters from each of it's parent's DNA strings,
as well as adding in 2 random 'mutation' strings, allowing
for a simple form of evolution. 

Blobs are coloured according to their dominant 
characteristic as explained above. Blobs with no specific 
dominant type is light grey, eggs are white and bodies are 
dark grey;

Blobs can die for one of three possible reasons. 
	- Starvation. A blob must eat, and if it does not eat 
	   for a certain amount of time, for whatever reason, 
	   then it has a high chance of dying.
	- Murder. If a blob gets into a fight with a stronger 
	   blob, then there is chance that it may be killed. 
	   This chance increases as the difference in strength 
	   increases. 
	- Old age. After a blob passes a certain age, there is a 
	   small chance that it may just drop dead. The probability 
	   of a blob dying of old age increases with age.

Mating produces a single egg which hatches after a certain number 
of cycles. There are no children blobs- blobs are born as fully 
capable violent monsters.

















