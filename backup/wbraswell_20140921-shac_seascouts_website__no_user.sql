-- MySQL dump 10.13  Distrib 5.5.38, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: shac_seascouts_website
-- ------------------------------------------------------
-- Server version	5.5.38-0ubuntu0.14.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `access`
--

DROP TABLE IF EXISTS `access`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `access` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `access` varchar(50) NOT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `access`
--

LOCK TABLES `access` WRITE;
/*!40000 ALTER TABLE `access` DISABLE KEYS */;
INSERT INTO `access` VALUES (1,'Member','2014-09-21 04:35:45');
/*!40000 ALTER TABLE `access` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `autoresponder`
--

DROP TABLE IF EXISTS `autoresponder`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `autoresponder` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `url_name` varchar(100) NOT NULL,
  `description` text,
  `mailing_list` int(11) DEFAULT NULL,
  `has_captcha` tinyint(4) DEFAULT '0',
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `autoresponder`
--

LOCK TABLES `autoresponder` WRITE;
/*!40000 ALTER TABLE `autoresponder` DISABLE KEYS */;
INSERT INTO `autoresponder` VALUES (1,'Example autoresponder','example',NULL,NULL,0,'2014-09-21 04:36:16');
/*!40000 ALTER TABLE `autoresponder` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `autoresponder_email`
--

DROP TABLE IF EXISTS `autoresponder_email`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `autoresponder_email` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `autoresponder` int(11) NOT NULL,
  `subject` varchar(100) NOT NULL,
  `template` int(11) NOT NULL,
  `delay` int(11) NOT NULL,
  `plaintext` text,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `autoresponder_email_idx_autoresponder` (`autoresponder`),
  KEY `autoresponder_email_idx_template` (`template`),
  CONSTRAINT `autoresponder_email_fk_autoresponder` FOREIGN KEY (`autoresponder`) REFERENCES `autoresponder` (`id`),
  CONSTRAINT `autoresponder_email_fk_template` FOREIGN KEY (`template`) REFERENCES `newsletter_template` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `autoresponder_email`
--

LOCK TABLES `autoresponder_email` WRITE;
/*!40000 ALTER TABLE `autoresponder_email` DISABLE KEYS */;
INSERT INTO `autoresponder_email` VALUES (1,1,'This is an autoresponse email',1,0,'This is the plain text body of the autoresponse email.\n','2014-09-21 04:36:16');
/*!40000 ALTER TABLE `autoresponder_email` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `autoresponder_email_element`
--

DROP TABLE IF EXISTS `autoresponder_email_element`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `autoresponder_email_element` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `type` varchar(20) NOT NULL DEFAULT 'Short Text',
  `content` text,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `autoresponder_email_element_idx_email` (`email`),
  CONSTRAINT `autoresponder_email_element_fk_email` FOREIGN KEY (`email`) REFERENCES `autoresponder_email` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `autoresponder_email_element`
--

LOCK TABLES `autoresponder_email_element` WRITE;
/*!40000 ALTER TABLE `autoresponder_email_element` DISABLE KEYS */;
INSERT INTO `autoresponder_email_element` VALUES (1,1,'body','HTML','<p>\n	This is the HTML body of the autoresponse email.\n</p>\n','2014-09-21 04:36:16');
/*!40000 ALTER TABLE `autoresponder_email_element` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `basket`
--

DROP TABLE IF EXISTS `basket`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `basket` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `session` char(72) DEFAULT NULL,
  `user` int(11) DEFAULT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `basket_idx_session` (`session`),
  KEY `basket_idx_user` (`user`),
  CONSTRAINT `basket_fk_session` FOREIGN KEY (`session`) REFERENCES `session` (`id`),
  CONSTRAINT `basket_fk_user` FOREIGN KEY (`user`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `basket`
--

LOCK TABLES `basket` WRITE;
/*!40000 ALTER TABLE `basket` DISABLE KEYS */;
/*!40000 ALTER TABLE `basket` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `basket_item`
--

DROP TABLE IF EXISTS `basket_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `basket_item` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `basket` int(11) NOT NULL,
  `item` int(11) NOT NULL,
  `quantity` int(11) NOT NULL DEFAULT '1',
  `unit_price` decimal(9,2) NOT NULL DEFAULT '0.00',
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `basket_item_idx_basket` (`basket`),
  KEY `basket_item_idx_item` (`item`),
  CONSTRAINT `basket_item_fk_basket` FOREIGN KEY (`basket`) REFERENCES `basket` (`id`),
  CONSTRAINT `basket_item_fk_item` FOREIGN KEY (`item`) REFERENCES `shop_item` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `basket_item`
--

LOCK TABLES `basket_item` WRITE;
/*!40000 ALTER TABLE `basket_item` DISABLE KEYS */;
/*!40000 ALTER TABLE `basket_item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `basket_item_attribute`
--

DROP TABLE IF EXISTS `basket_item_attribute`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `basket_item_attribute` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `item` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `value` text NOT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `basket_item_attribute_idx_item` (`item`),
  CONSTRAINT `basket_item_attribute_fk_item` FOREIGN KEY (`item`) REFERENCES `basket_item` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `basket_item_attribute`
--

LOCK TABLES `basket_item_attribute` WRITE;
/*!40000 ALTER TABLE `basket_item_attribute` DISABLE KEYS */;
/*!40000 ALTER TABLE `basket_item_attribute` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `blog`
--

DROP TABLE IF EXISTS `blog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `blog` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(100) NOT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `blog`
--

LOCK TABLES `blog` WRITE;
/*!40000 ALTER TABLE `blog` DISABLE KEYS */;
INSERT INTO `blog` VALUES (1,'','2014-09-21 04:35:32'),(2,'Little Blogger','2014-09-21 04:35:54');
/*!40000 ALTER TABLE `blog` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `blog_post`
--

DROP TABLE IF EXISTS `blog_post`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `blog_post` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(120) NOT NULL,
  `url_title` varchar(120) NOT NULL,
  `body` text NOT NULL,
  `author` int(11) DEFAULT NULL,
  `blog` int(11) NOT NULL,
  `hidden` tinyint(4) NOT NULL DEFAULT '0',
  `posted` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `discussion` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `blog_post_idx_author` (`author`),
  KEY `blog_post_idx_blog` (`blog`),
  KEY `blog_post_idx_discussion` (`discussion`),
  CONSTRAINT `blog_post_fk_author` FOREIGN KEY (`author`) REFERENCES `user` (`id`),
  CONSTRAINT `blog_post_fk_blog` FOREIGN KEY (`blog`) REFERENCES `blog` (`id`),
  CONSTRAINT `blog_post_fk_discussion` FOREIGN KEY (`discussion`) REFERENCES `discussion` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `blog_post`
--

LOCK TABLES `blog_post` WRITE;
/*!40000 ALTER TABLE `blog_post` DISABLE KEYS */;
INSERT INTO `blog_post` VALUES (1,'w1n5t0n','w1n5t0n','<p>	I\'m a senior at Cesar Chavez high in San Francisco\'s sunny Mission\n	district, and that makes me one of the most surveilled people in the\n	world. My name is Marcus Yallow, but back when this story starts, I\n	was going by w1n5t0n. Pronounced &quot;Winston.&quot;\n</p>\n<p>	<i>Not</i> pronounced &quot;Double-you-one-enn-five-tee-zero-enn&quot; \n	-- unless you\'re a clueless disciplinary officer who\'s far enough behind \n	the curve that you still call the Internet &quot;the information\n	superhighway.&quot;\n</p> \n<p>	I know just such a clueless person, and his name is Fred Benson, one of\n	three vice-principals at Cesar Chavez. He\'s a sucking chest wound of\n	a human being. But if you\'re going to have a jailer, better a\n	clueless one than one who\'s really on the ball.\n</p> \n<p>	&quot;Marcus Yallow,&quot; he said over the PA one Friday morning. The \n	PA isn\'t very good to begin with, and when you combine that with Benson\'s\n	habitual mumble, you get something that sounds more like someone\n	struggling to digest a bad burrito than a school announcement. But\n	human beings are good at picking their names out of audio confusion\n	-- it\'s a survival trait.\n</p>\n<p>	I grabbed my bag and folded my laptop three-quarters shut -- I didn\'t\n	want to blow my downloads -- and got ready for the inevitable.\n</p> \n<p>	&quot;Report to the administration office immediately.&quot;\n</p> \n<p>	My social studies teacher, Ms Galvez, rolled her eyes at me and I rolled\n	my eyes back at her. The Man was always coming down on me, just\n	because I go through school firewalls like wet kleenex, spoof the\n	gait-recognition software, and nuke the snitch chips they track us\n	with. Galvez is a good type, anyway, never holds that against me\n	(especially when I\'m helping get with her webmail so she can talk to\n	her brother who\'s stationed in Iraq).\n</p>\n<p>	My boy Darryl gave me a smack on the ass as I walked past. I\'ve known\n	Darryl since we were still in diapers and escaping from play-school,\n	and I\'ve been getting him into and out of trouble the whole time. I\n	raised my arms over my head like a prizefighter and made my exit from\n	Social Studies and began the perp-walk to the office.\n</p>\n',3,2,0,'2013-01-01 17:00:00',1),(2,'False Positives','false-positives','<p>	Class ended in ten minutes, and that didn\'t leave me with much time to\n	prepare. The first order of business were those pesky\n	gait-recognition cameras. Like I said, they\'d started out as\n	face-recognition cameras, but those had been ruled unconstitutional.\n	As far as I know, no court has yet determined whether these gait-cams\n	are any more legal, but until they do, we\'re stuck with them.\n</p> \n<p>	&quot;Gait&quot; is a fancy word for the way you walk. People are pretty \n	good at spotting gaits -- next time you\'re on a camping trip, check out \n	the bobbing of the flashlight as a distant friend approaches you. Chances\n	are you can identify him just from the movement of the light, the\n	characteristic way it bobs up and down that tells our monkey brains\n	that this is a person approaching us.\n</p>\n<p>	Gait recognition software takes pictures of your motion, tries to isolate\n	you in the pics as a silhouette, and then tries to match the\n	silhouette to a database to see if it knows who you are. It\'s a\n	biometric identifier, like fingerprints or retina-scans, but it\'s got\n	a lot more &quot;collisions&quot; than either of those. A biometric\n	&quot;collision&quot; is when a measurement matches more than one\n	person. Only you have your fingerprint, but you share your gait with\n	plenty of other people.\n</p> \n<p>	Not exactly, of course. Your personal, inch-by-inch walk is yours and\n	yours alone. The problem is your inch-by-inch walk changes based on\n	how tired you are, what the floor is made of, whether you pulled your\n	ankle playing basketball, and whether you\'ve changed your shoes\n	lately. So the system kind of fuzzes-out your profile, looking for\n	people who walk kind of like you.\n</p> \n<p>	There are a lot of people who walk kind of like you. What\'s more, it\'s \n	easy not to walk kind of like you -- just take one shoe off. Of course,\n	you\'ll always walk like you-with-one-shoe-off in that case, so the\n	cameras will eventually figure out that it\'s still you. Which is why\n	I prefer to inject a little randomness into my attacks on\n	gait-recognition: I put a handful of gravel into each shoe. Cheap and\n	effective, and no two steps are the same. Plus you get a great\n	reflexology foot massage in the process (I kid. Reflexology is about\n	as scientifically useful as gait-recognition).\n</p> \n<p>	The cameras used to set off an alert every time someone they didn\'t\n	recognize stepped onto campus.  \n</p> \n<p>	This did <i>not</i> work.\n</p>\n<p>	The alarm went off every ten minutes. When the mailman came by. When a\n	parent dropped in. When the grounds-people went to work fixing up the\n	basketball court. When a student showed up wearing new shoes.\n</p>\n<p>	So now it just tries to keep track of who\'s where and when. If someone\n	leaves by the school-gates during classes, their gait is checked to\n	see if it kinda-sorta matches any student gait and if it does,\n	whoop-whoop-whoop, ring the alarm!\n</p>\n<p>	Chavez High is ringed with gravel walkways. I like to keep a couple handsful\n	of rocks in my shoulder-bag, just in case. I silently passed Darryl\n	ten or fifteen pointy little bastards and we both loaded our shoes.\n</p>\n',3,2,0,'2013-01-01 18:00:00',2),(3,'Then the world changed forever','then-the-world-changed-forever','<p>	We felt it first, that sickening lurch of the cement under your feet\n	that every Californian knows  instinctively -- <i>earthquake</i>.\n	My first inclination, as always, was to get away: &quot;when in\n	trouble or in doubt, run in circles, scream and shout.&quot; But the\n	fact was, we were already in the safest place we could be, not in a\n	building that could fall in on us, not out toward the middle of the\n	road where bits of falling cornice could brain us.\n</p>\n<p>	Earthquakes are eerily quiet -- at first, anyway -- but this wasn\'t \n	quiet. This was loud, an incredible roaring sound that was louder than \n	anything I\'d ever heard before. The sound was so punishing it drove me \n	to my knees, and I wasn\'t the only one. Darryl shook my arm and pointed\n	over the buildings and we saw it then: a huge black cloud rising from\n	the northeast, from the direction of the Bay.\n</p>\n<p>	There was another rumble, and the cloud of smoke spread out, that spreading\n	black shape we\'d all grown up seeing in movies. Someone had just\n	blown up something, in a big way.\n</p>\n<p>	There were more rumbles and more tremors. Heads appeared at windows up and\n	down the street. We all looked at the mushroom cloud in silence.\n</p>\n<p>	Then the sirens started.\n</p>\n<p>	I\'d heard sirens like these before -- they test the civil defense sirens\n	at noon on Tuesdays. But I\'d only heard them go off unscheduled in\n	old war movies and video games, the kind where someone is bombing\n	someone else from above. Air raid sirens. The wooooooo sound made it\n	all less real.\n</p>\n<p>	&quot;Report to shelters immediately.&quot; It was like the voice of God, \n	coming from all places at once. There were speakers on some of the electric\n	poles, something I\'d never noticed before, and they\'d all switched on\n	at once.\n</p>\n<p>	&quot;Report to shelters immediately.&quot; Shelters? We looked at each \n	other in confusion. What shelters? The cloud was rising steadily, spreading\n	out. Was it nuclear? Were we breathing in our last breaths?\n</p>\n<p>	The girl with the pink hair grabbed her friends and they tore ass\n	downhill, back toward the BART station and the foot of the hills.\n</p>\n\n<p>	&quot;REPORT TO SHELTERS IMMEDIATELY.&quot; There was screaming now, and \n	a lot of running around. Tourists -- you can always spot the tourists, \n	they\'re the ones who think CALIFORNIA = WARM and spend their San Francisco\n	holidays freezing in shorts and t-shirts -- scattered in every direction.\n</p>\n<p>	&quot;We should go!&quot; Darryl hollered in my ear, just barely audible over\n	the shrieking of the sirens, which had been joined by traditional\n	police sirens. A dozen SFPD cruisers screamed past us.\n</p>\n<p>	&quot;REPORT TO SHELTERS IMMEDIATELY.&quot;\n</p>\n<p>	&quot;Down to the BART station,&quot; I hollered. My friends nodded. We closed\n	ranks and began to move quickly downhill.\n</p>\n',3,2,0,'2013-01-01 19:00:00',3),(4,'The madding crowd','the-madding-crowd','<p>	I was as scared as I\'d ever been. There was screaming everywhere now,\n	and more bodies on the floor, and the press from behind was as\n	relentless as a bulldozer. It was all I could do to keep on my feet.\n</p>\n<p>	We were in the open concourse where the turnstiles were. It was hardly\n	any better here -- the enclosed space sent the voices around us\n	echoing back in a roar that made my head ring, and the smell and\n	feeling of all those bodies made me feel a claustrophobia I\'d never\n	known I was prone to.\n</p>\n<p>	People were still cramming down the stairs, and more were squeezing past the\n	turnstiles and down the escalators onto the platforms, but it was\n	clear to me that this wasn\'t going to have a happy ending.\n</p>\n<p>	&quot;Want to take our chances up top?&quot; I said to Darryl.\n</p>\n<p>	&quot;Yes, hell yes,&quot; he said. &quot;This is vicious.&quot;\n</p>\n<p>	I looked to Vanessa -- there was no way she\'d hear me. I managed to get\n	my phone out and I texted her.\n</p>\n<p>	&gt; We\'re getting out of here\n</p>\n<p>	I saw her feel the vibe from her phone, then look down at it and then\n	back at me and nod vigorously. Darryl, meanwhile, had clued Jolu in.\n</p>\n<p>	<i>&quot;<i>What\'s the plan?&quot;</i> Darryl shouted in my ear.\n</p>\n<p>	&quot;We\'re going to have to go back!&quot; I shouted back, pointing \n	at the remorseless crush of bodies.\n</p>\n<p>	&quot;It\'s impossible!&quot; he said.\n</p>\n<p>	&quot;It\'s just going to get more impossible the longer we wait!&quot;\n</p>\n<p>	He shrugged. Van worked her way over to me and grabbed hold of my wrist.\n	I took Darryl and Darryl took Jolu by the other hand and we pushed out.\n</p>\n<p>	It wasn\'t easy. We moved about three inches a minute at first, then\n	slowed down even more when we reached the stairway. The people we\n	passed were none too happy about us shoving them out of the way,\n	either. A couple people swore at us and there was a guy who looked\n	like he\'d have punched me if he\'d been able to get his arms loose. We\n	passed three more crushed people beneath us, but there was no way I\n	could have helped them. By that point, I wasn\'t even thinking of\n	helping anyone. All I could think of was finding the spaces in front\n	of us to move into, of Darryl\'s mighty straining on my wrist, of my\n	death-grip on Van behind me.\n</p>\n<p>	We popped free like Champagne corks an eternity later, blinking in the\n	grey smoky light. The air raid sirens were still blaring, and the\n	sound of emergency vehicles\' sirens as they tore down Market Street\n	was even louder. There was almost no one on the streets anymore --\n	just the people trying hopelessly to get underground. A lot of them\n	were crying. I spotted a bunch of empty benches -- usually staked out\n	by skanky winos -- and pointed toward them.\n</p>\n<p>	We moved for them, the sirens and the smoke making us duck and hunch our\n	shoulders. We got as far as the benches before Darryl fell forward.\n</p>\n<p>	We all yelled and Vanessa grabbed him and turned him over. The side of\n	his shirt was stained red, and the stain was spreading. She tugged\n	his shirt up and revealed a long, deep cut in his pudgy side.\n</p>\n<p>	&quot;Someone freaking <i>stabbed</i> him in the crowd,&quot; Jolu said, \n	his hands clenching into fists. &quot;Christ, that\'s vicious.&quot;\n</p>\n',3,2,0,'2013-01-01 20:00:00',4),(5,'Kidnapped','kidnapped','<p>	The first vehicle that screamed past -- an ambulance -- didn\'t even slow\n	down. Neither did the cop car that went past, nor the firetruck, nor\n	the next three cop-cars. Darryl wasn\'t in good shape -- he was\n	white-faced and panting. Van\'s sweater was soaked in blood.\n</p>\n<p>	I was sick of cars driving right past me. The next time a car appeared\n	down Market Street, I stepped right out into the road, waving my arms\n	over my head, shouting &quot;<i>STOP</i>.&quot;\n	The car slewed to a stop and only then did I notice that it wasn\'t a\n	cop car, ambulance or fire-engine.\n</p>\n<p>	It was a military-looking Jeep, like an armored Hummer, only it didn\'t\n	have any military insignia on it. The car skidded to a stop just in\n	front of me, and I jumped back and lost my balance and ended up on\n	the road. I felt the doors open near me, and then saw a confusion of\n	booted feet moving close by. I looked up and saw a bunch of\n	military-looking guys in coveralls, holding big, bulky rifles and\n	wearing hooded gas masks with tinted face-plates.\n</p>\n<p>	I barely had time to register them before those rifles were pointed at\n	me. I\'d never looked down the barrel of a gun before, but everything\n	you\'ve heard about the experience is true. You freeze where you are,\n	time stops, and your heart thunders in your ears. I opened my mouth,\n	then shut it, then, very slowly, I held my hands up in front of me.\n</p>\n<p>	The faceless, eyeless armed man above me kept his gun very level. I\n	didn\'t even breathe. Van was screaming something and Jolu was\n	shouting and I looked at them for a second and that was when someone\n	put a coarse sack over my head and cinched it tight around my\n	windpipe, so quick and so fiercely I barely had time to gasp before\n	it was locked on me. I was pushed roughly but dispassionately onto my\n	stomach and something went twice around my wrists and then tightened\n	up as well, feeling like baling wire and biting cruelly. I cried out\n	and my own voice was muffled by the hood. \n</p>\n<p>	I was in total darkness now and I strained my ears to hear what was\n	going on with my friends. I heard them shouting through the muffling\n	canvas of the bag, and then I was being impersonally hauled to my\n	feet by my wrists, my arms wrenched up behind my back, my shoulders\n	screaming. \n</p>\n<p>	I stumbled some, then a hand pushed my head down and I was inside the\n	Hummer. More bodies were roughly shoved in beside me.\n</p>\n<p>	&quot;Guys?&quot; I shouted, and earned a hard thump on my head for my trouble. I heard\n	Jolu respond, then felt the thump he was dealt, too. My head rang\n	like a gong.\n</p>\n<p>	&quot;Hey,&quot; I said to the soldiers. &quot;Hey, listen! We\'re just high school\n	students. I wanted to flag you down because my friend was bleeding.\n	Someone stabbed him.&quot; I had no idea how much of this was making\n	it through the muffling bag. I kept talking. &quot;Listen -- this is\n	some kind of misunderstanding. We\'ve got to get my friend to a\n	hospital --&quot;\n</p>\n<p>	Someone went upside my head again. It felt like they used a baton or\n	something -- it was harder than anyone had ever hit me in the head\n	before. My eyes swam and watered and I literally couldn\'t breathe\n	through the pain. A moment later, I caught my breath, but I didn\'t\n	say anything. I\'d learned my lesson.\n</p>\n<p>	Who were these clowns? They weren\'t wearing insignia. Maybe they were\n	terrorists! I\'d never really believed in terrorists before -- I mean,\n	I knew that in the abstract there were terrorists somewhere in the\n	world, but they didn\'t really represent any risk to me. There were\n	millions of ways that the world could kill me -- starting with\n	getting run down by a drunk burning his way down Valencia -- that\n	were infinitely more likely and immediate than terrorists. Terrorists\n	killed a lot fewer people than bathroom falls and accidental\n	electrocutions. Worrying about them always struck me as about as\n	useful as worrying about getting hit by lightning.\n</p>\n<p>	Sitting in the back of that Hummer, my head in a hood, my hands lashed behind\n	my back, lurching back and forth while the bruises swelled up on my\n	head, terrorism suddenly felt a lot riskier.\n</p>\n',3,2,0,'2013-01-01 21:00:00',5),(6,'Liberty vs. Security','liberty-vs-security','<p>	He shoved me into the bathroom. My hands were useless, like lumps of\n	clay on the ends of my wrists. As I wiggled my fingers limply, they\n	tingled, then the tingling turned to a burning feeling that almost\n	made me cry out. I put the seat down, dropped my pants and sat down.\n	I didn\'t trust myself to stay on my feet.\n</p>\n<p>	As my bladder cut loose, so did my eyes. I wept, crying silently and\n	rocking back and forth while the tears and snot ran down my face. It\n	was all I could do to keep from sobbing -- I covered my mouth and\n	held the sounds in. I didn\'t want to give them the satisfaction. \n</p>\n<p>	Finally, I was peed out and cried out and the guy was pounding on the door. I\n	cleaned my face as best as I could with wads of toilet paper, stuck\n	it all down the john and flushed, then looked around for a sink but\n	only found a pump-bottle of heavy-duty hand-sanitizer covered in\n	small-print lists of the bio-agents it worked on. I rubbed some into\n	my hands and stepped out of the john.\n</p>\n<p>	&quot;What were you doing in there?&quot; the guy said.\n</p>\n<p>	&quot;Using the facilities,&quot; I said. He turned me around and grabbed my\n	hands and I felt a new pair of plastic cuffs go around them. My\n	wrists had swollen since the last pair had come off and the new ones\n	bit cruelly into my tender skin, but I refused to give him the\n	satisfaction of crying out.\n</p>\n<p>	He shackled me back to my spot and grabbed the next person down, who, I\n	saw now, was Jolu, his face puffy and an ugly bruise on his cheek. \n</p>\n<p>	&quot;Are you OK?&quot; I asked him, and my friend with the utility belt\n	abruptly put his hand on my forehead and shoved hard, bouncing the\n	back of my head off the truck\'s metal wall with a sound like a clock\n	striking one. &quot;No talking,&quot; he said as I struggled to\n	refocus my eyes. \n</p>\n<p>	I didn\'t like these people. I decided right then that they would pay a\n	price for all this.\n</p>\n<p>	One by one, all the prisoners went to the can, and came back, and when\n	they were done, my guard went back to his friends and had another cup\n	of coffee -- they were drinking out of a big cardboard urn of\n	Starbucks, I saw -- and they had an indistinct conversation that\n	involved a fair bit of laughter.\n</p>\n<p>	Then the door at the back of the truck opened and there was fresh air, not\n	smoky the way it had been before, but tinged with ozone. In the slice\n	of outdoors I saw before the door closed, I caught that it was dark\n	out, and raining, with one of those San Francisco drizzles that\'s\n	part mist.\n</p>\n<p>	The man who came in was wearing a military uniform. A US military\n	uniform. He saluted the people in the truck and they saluted him back\n	and that\'s when I knew that I wasn\'t a prisoner of some terrorists --\n	I was a prisoner of the United States of America.\n</p>\n',3,2,0,'2013-01-01 23:00:00',NULL),(7,'Nothing to hide, nothing to fear','nothing-to-hide-nothing-to-fear','<p>	They set up a little screen at the end of the truck and then came for \n	us one at a time, unshackling us and leading us to the back of the\n	truck. As close as I could work it -- counting seconds off in my\n	head, one hippopotami, two hippopotami -- the interviews lasted about\n	seven minutes each. My head throbbed with dehydration and caffeine\n	withdrawal.\n</p>\n<p>	I was third, brought back by the woman with the severe haircut. Up\n	close, she looked tired, with bags under her eyes and grim lines at\n	the corners of her mouth.\n</p>\n<p>	&quot;Thanks,&quot; I said, automatically, as she unlocked me with a \n	remote and then dragged me to my feet. I hated myself for the automatic \n	politeness, but it had been drilled into me.\n</p>\n<p>	She didn\'t twitch a muscle. I went ahead of her to the back of the truck\n	and behind the screen. There was a single folding chair and I sat in\n	it. Two of them -- Severe Haircut woman and utility belt man --\n	looked at me from their ergonomic super-chairs.\n</p>\n<p>	They had a little table between them with the contents of my wallet and\n	backpack spread out on it.\n</p>\n<p>	&quot;Hello, Marcus,&quot; Severe Haircut woman said. &quot;We have some \n	questions for you.&quot;\n</p>\n<p>	&quot;Am I under arrest?&quot; I asked. This wasn\'t an idle question. If\n	you\'re not under arrest, there are limits on what the cops can and\n	can\'t do to you. For starters, they can\'t hold you forever without\n	arresting you, giving you a phone call, and letting you talk to a\n	lawyer. And hoo-boy, was I ever going to talk to a lawyer.\n</p>\n<p>	&quot;What\'s this for?&quot; she said, holding up my phone. The screen \n	was showing the error message you got if you kept trying to get into its \n	data without giving the right password. It was a bit of a rude message --\n	an animated hand giving a certain universally recognized gesture --\n	because I liked to customize my gear.\n</p>\n<p>	&quot;Am I under arrest?&quot; I repeated. They can\'t make you answer \n	any questions if you\'re not under arrest, and when you ask if you\'re\n	under arrest, they have to answer you. It\'s the rules.\n</p>\n<p>	&quot;You\'re being detained by the Department of Homeland Security,&quot; \n	the woman snapped.\n</p>\n<p>	&quot;Am I under arrest?&quot;\n</p>\n<p>	&quot;You\'re going to be more cooperative, Marcus, starting right now.&quot; \n	She didn\'t say, &quot;or else,&quot; but it was implied.\n</p>\n<p>	&quot;I would like to contact an attorney,&quot; I said. &quot;I would like\n	to know what I\'ve been charged with. I would like to see some form of\n	identification from both of you.&quot;\n</p>\n<p>	The two agents exchanged looks.\n</p>\n<p>	&quot;I think you should really reconsider your approach to this situation,&quot;\n	Severe Haircut woman said. &quot;I think you should do that right\n	now. We found a number of suspicious devices on your person. We found\n	you and your confederates near the site of the worst terrorist attack\n	this country has ever seen. Put those two facts together and things\n	don\'t look very good for you, Marcus. You can cooperate, or you can\n	be very, very sorry. Now, what is this for?&quot;\n</p>\n<p>	&quot;You think I\'m a terrorist? I\'m seventeen years old!&quot;\n</p>\n<p>	&quot;Just the right age -- Al Qaeda loves recruiting impressionable, \n	idealistic kids. We googled you, you know. You\'ve posted a lot of very \n	ugly stuff on the public Internet.&quot;\n</p>\n<p>	&quot;I would like to speak to an attorney,&quot; I said.\n</p>\n<p>	Severe haircut lady looked at me like I was a bug. &quot;You\'re under the\n	mistaken impression that you\'ve been picked up by the police for a\n	crime. You need to get past that. You are being detained as a\n	potential enemy combatant by the government of the United States. If\n	I were you, I\'d be thinking very hard about how to convince us that\n	you are not an enemy combatant. Very hard. Because there are dark\n	holes that enemy combatants can disappear into, very dark deep holes,\n	holes where you can just vanish. Forever. Are you listening to me\n	young man? I want you to unlock this phone and then decrypt the files\n	in its memory. I want you to account for yourself: why were you out\n	on the street? What do you know about the attack on this city?&quot;\n</p>\n<p>	&quot;I\'m not going to unlock my phone for you,&quot; I said, indignant. \n	My phone\'s memory had all kinds of private stuff on it: photos, emails,\n	little hacks and mods I\'d installed. &quot;That\'s private stuff.&quot;\n</p>\n<p>	&quot;What have you got to hide?&quot;\n</p>\n<p>	&quot;I\'ve got the right to my privacy,&quot; I said. &quot;And I want \n	to speak to an attorney.&quot;\n</p>\n<p>	&quot;This is your last chance, kid. Honest people don\'t have anything to \n	hide.&quot;\n</p>\n<p>	&quot;I want to speak to an attorney.&quot; My parents would pay for it. \n	All the FAQs on getting arrested were clear on this point. Just keep\n	asking to see an attorney, no matter what they say or do. There\'s no\n	good that comes of talking to the cops without your lawyer present.\n	These two said they weren\'t cops, but if this wasn\'t an arrest, what\n	was it?\n</p>\n<p>	In hindsight, maybe I should have unlocked my phone for them.\n</p>\n',3,2,0,'2013-01-02 01:00:00',6),(8,'Imprisoned','imprisoned','<p>	When they took the hood off again, I was in a cell.\n</p>\n<p>	The cell was old and crumbled, and smelled of sea air. There was one \n	window high up, and rusted bars guarded it. It was still dark outside. \n	There was a blanket on the floor and a little metal toilet without a \n	seat, set into the wall. The guard who took off my hood grinned at me \n	and closed the solid steel door behind him.\n</p>\n',3,2,0,'2013-01-02 04:00:00',7),(9,'We don\'t like that','we-dont-like-that','<p>	The next time they came to question me, I was filthy and tired, thirsty\n	and hungry. Severe haircut lady was in the new questioning party, as\n	were three big guys who moved me around like a cut of meat. One was\n	black, the other two were white, though one might have been hispanic.\n	They all carried guns. It was like a Benneton\'s ad crossed with a\n	game of Counter-Strike. \n</p>\n<p>	They\'d taken me from my cell and chained my wrists and ankles together. I\n	paid attention to my surroundings as we went. I heard water outside\n	and thought that maybe we were on Alcatraz -- it was a prison, after\n	all, even if it had been a tourist attraction for generations, the\n	place where you went to see where Al Capone and his gangster\n	contemporaries did their time. But I\'d been to Alcatraz on a school\n	trip. It was old and rusted, medieval. This place felt like it dated\n	back to World War Two, not colonial times.\n</p>\n<p>	There were bar-codes laser-printed on stickers and placed on each of the\n	cell-doors, and numbers, but other than that, there was no way to\n	tell who or what might be behind them.\n</p>\n<p>	The interrogation room was modern, with fluorescent lights, ergonomic\n	chairs -- not for me, though, I got a folding plastic garden-chair --\n	and a big wooden board-room table. A mirror lined one wall, just like\n	in the cop shows, and I figured someone or other must be watching\n	from behind it. Severe haircut lady and her friends helped themselves\n	to coffees from an urn on a side-table (I could have torn her throat\n	out with my teeth and taken her coffee just then), and then set a\n	styrofoam cup of water down next to me -- without unlocking my wrists\n	from behind my back, so I couldn\'t reach it. Hardy har har.\n</p>\n<p>	&quot;Hello, Marcus,&quot; Severe Haircut woman said. &quot;How\'s your \n	\'tude doing today?&quot;\n</p>\n<p>	I didn\'t say anything.\n</p>\n<p>	&quot;This isn\'t as bad as it gets you know,&quot; she said. &quot;This \n	is as <i>good</i> as it gets from now on. Even once you tell us what we \n	want to know, even if that convinces us that you were just in the wrong \n	place at the wrong time, you\'re a marked man now. We\'ll be watching you\n	everywhere you go and everything you do. You\'ve acted like you\'ve got\n	something to hide, and we don\'t like that.&quot;\n</p>\n',3,2,0,'2013-01-02 16:00:00',8),(10,'Here\'s what we want from you','heres-what-we-want','<p>	&quot;Hello, Marcus?&quot; she snapped her fingers in front of my face. \n	&quot;Over here, Marcus.&quot; There was a little smile on her face and \n	I hated myself for letting her see my fear. &quot;Marcus, it can be a lot\n	worse than this. This isn\'t the worst place we can put you, not by a\n	damned sight.&quot; She reached down below the table and came out\n	with a briefcase, which she snapped open. From it, she withdrew my\n	phone, my arphid sniper/cloner, my wifinder, and my memory keys. She\n	set them down on the table one after the other.\n</p>\n<p>	&quot;Here\'s what we want from you. You unlock the phone for us today. \n	If you do that, you\'ll get outdoor and bathing privileges. You\'ll get a \n	shower and you\'ll be allowed to walk around in the exercise yard. Tomorrow,\n	we\'ll bring you back and ask you to decrypt the data on these memory\n	sticks. Do that, and you\'ll get to eat in the mess hall. The day\n	after, we\'re going to want your email passwords, and that will get\n	you library privileges.&quot;\n</p>\n<p>	The word &quot;no&quot; was on my lips, like a burp trying to come up,\n	but it wouldn\'t come. &quot;Why?&quot; is what came out instead.\n</p>\n<p>	&quot;We want to be sure that you\'re what you seem to be. This is about \n	your security, Marcus. Say you\'re innocent. You might be, though why an\n	innocent man would act like he\'s got so much to hide is beyond me.\n	But say you are: you could have been on that bridge when it blew.\n	Your parents could have been. Your friends. Don\'t you want us to\n	catch the people who attacked your home?&quot;\n</p>\n<p>	It\'s funny, but when she was talking about my getting &quot;privileges&quot;\n	it scared me into submission. I felt like I\'d done <i>something</i>\n	to end up where I was, like maybe it was partially my fault, like I\n	could do something to change it.\n</p>\n<p>	But as soon as she switched to this BS about &quot;safety&quot; and\n	&quot;security,&quot; my spine came back. &quot;Lady,&quot; I said,\n	&quot;you\'re talking about attacking my home, but as far as I can\n	tell, you\'re the only one who\'s attacked me lately. I thought I lived\n	in a country with a constitution. I thought I lived in a country\n	where I had <i>rights</i>.\n	You\'re talking about defending my freedom by tearing up the Bill of\n	Rights.&quot;\n</p>\n<p>	A flicker of annoyance passed over her face, then went away. &quot;So\n	melodramatic, Marcus. No one\'s attacked you. You\'ve been detained by\n	your country\'s government while we seek details on the worst\n	terrorist attack ever perpetrated on our nation\'s soil. You have it\n	within your power to help us fight this war on our nation\'s enemies.\n	You want to preserve the Bill of Rights? Help us stop bad people from\n	blowing up your city. Now, you have exactly thirty seconds to unlock\n	that phone before I send you back to your cell. We have lots of other\n	people to interview today.&quot;\n</p>\n<p>	She looked at her watch. I rattled my wrists, rattled the chains that\n	kept me from reaching around and unlocking the phone. Yes, I was\n	going to do it. She\'d told me what my path was to freedom -- to the\n	world, to my parents -- and that had given me hope. Now she\'d\n	threatened to send me away, to take me off that path, and my hope had\n	crashed and all I could think of was how to get back on it.\n</p>\n<p>	So I rattled my wrists, wanting to get to my phone and unlock it for\n	her, and she just looked at me coldly, checking her watch.\n</p>\n<p>	&quot;The password,&quot; I said, finally understanding what she wanted \n	of me. She wanted me to say it out loud, here, where she could record it,\n	where her pals could hear it. She didn\'t want me to just unlock the\n	phone. She wanted me to submit to her. To put her in charge of me. To\n	give up every secret, all my privacy. &quot;The password,&quot; I\n	said again, and then I told her the password. God help me, I\n	submitted to her will.\n</p>\n<p>	She smiled a little prim smile, which had to be her ice-queen equivalent\n	of a touchdown dance, and the guards led me away. As the door closed,\n	I saw her bend down over the phone and key the password in.\n</p>\n',3,2,0,'2013-01-02 17:00:00',9),(11,'Anything they ask, answer them','anything-they-ask','<p>	They took my passwords for my USB keys next. Those held some interesting\n	messages I\'d downloaded from one online discussion group or another,\n	some chat transcripts, things where people had helped me out with\n	some of the knowledge I needed to do the things I did. There was\n	nothing on there you couldn\'t find with Google, of course, but I\n	didn\'t think that would count in my favor.\n</p>\n<p>	I got exercise again that afternoon, and this time there were others in\n	the yard when I got there, four other guys and two women, of all ages\n	and racial backgrounds. I guess lots of people were doing things to\n	earn their &quot;privileges.&quot;\n</p>\n<p>	They gave me half an hour, and I tried to make conversation with the most\n	normal-seeming of the other prisoners, a black guy about my age with\n	a short afro. But when I introduced myself and stuck my hand out, he\n	cut his eyes toward the cameras mounted ominously in the corners of\n	the yard and kept walking without ever changing his facial\n	expression.\n</p>\n<p>	But then, just before they called my name and brought me back into the\n	building, the door opened and out came -- Vanessa! I\'d never been\n	more glad to see a friendly face. She looked tired and grumpy, but\n	not hurt, and when she saw me, she shouted my name and ran to me. We\n	hugged each other hard and I realized I was shaking. Then I realized\n	she was shaking, too.\n</p>\n<p>	&quot;Are you OK?&quot; she said, holding me at arms\' length.\n</p>\n<p>	&quot;I\'m OK,&quot; I said. &quot;They told me they\'d let me go if I gave \n	them my passwords.&quot;\n</p>\n<p>	&quot;They keep asking me questions about you and Darryl.&quot;\n</p>\n<p>	There was a voice blaring over the loudspeaker, shouting at us to stop\n	talking, to walk, but we ignored it.\n</p>\n<p>	&quot;Answer them,&quot; I said, instantly. &quot;Anything they ask, \n	answer them. If it\'ll get you out.&quot;\n</p>\n<p>	&quot;How are Darryl and Jolu?&quot;\n</p>\n<p>	&quot;I haven\'t seen them.&quot;\n</p>\n<p>	The door banged open and four big guards boiled out. Two took me and two\n	took Vanessa. They forced me to the ground and turned my head away\n	from Vanessa, though I heard her getting the same treatment. Plastic\n	cuffs went around my wrists and then I was yanked to my feet and\n	brought back to my cell.\n</p>\n<p>	No dinner came that night. No breakfast came the next morning. No one\n	came and brought me to the interrogation room to extract more of my\n	secrets. The plastic cuffs didn\'t come off, and my shoulders burned,\n	then ached, then went numb, then burned again. I lost all feeling in\n	my hands.\n</p>\n<p>	I had to pee. I couldn\'t undo my pants. I really, really had to pee.\n</p>\n<p>	I pissed myself.\n</p>\n<p>	They came for me after that, once the hot piss had cooled and gone clammy,\n	making my already filthy jeans stick to my legs. They came for me and\n	walked me down the long hall lined with doors, each door with its own\n	bar code, each bar code a prisoner like me. They walked me down the\n	corridor and brought me to the interrogation room and it was like a\n	different planet when I entered there, a world where things were\n	normal, where everything didn\'t reek of urine. I felt so dirty and\n	ashamed, and all those feelings of deserving what I got came back to me.\n</p>\n<p>	Severe haircut lady was already sitting. She was perfect: coifed and with\n	just a little makeup. I smelled her hair stuff. She wrinkled her nose\n	at me. I felt the shame rise in me.\n</p>\n<p>	&quot;Well, you\'ve been a very naughty boy, haven\'t you? Aren\'t you a \n	filthy thing?&quot;\n</p>\n<p>	Shame. I looked down at the table. I couldn\'t bear to look up. I wanted \n	to tell her my email password and get gone. \n</p>\n<p>	&quot;What did you and your friend talk about in the yard?&quot;\n</p>\n<p>	I barked a laugh at the table. &quot;I told her to answer your\n	questions. I told her to cooperate.&quot;\n</p>\n<p>	&quot;So do you give the orders?&quot;\n</p>\n<p>	I felt the blood sing in my ears. &quot;Oh come on,&quot; I said. \n	&quot;We play a <i>game</i> together, it\'s called Harajuku Fun Madness. \n	I\'m the <i>team captain</i>. We\'re not terrorists, we\'re high school \n	students. I don\'t give her orders. I told her that we needed to be \n	<i>honest</i> with you so that we could clear up any suspicion and get \n	out of here.&quot;\n</p>\n<p>	She didn\'t say anything for a moment.\n</p>\n<p>	&quot;How is Darryl?&quot; I said.\n</p>\n<p>	&quot;Who?&quot;\n</p>\n<p>	&quot;Darryl. You picked us up together. My friend. Someone had stabbed \n	him in the Powell Street BART. That\'s why we were up on the surface. To \n	get him help.&quot;\n</p>\n<p>	&quot;I\'m sure he\'s fine, then,&quot; she said.\n</p>\n<p>	My stomach knotted and I almost threw up. &quot;You don\'t <i>know</i>?\n	You haven\'t got him here?&quot;\n</p>\n<p>	&quot;Who we have here and who we don\'t have here is not something we\'re \n	going to discuss with you, ever. That\'s not something you\'re going to \n	know. Marcus, you\'ve seen what happens when you don\'t cooperate with us.\n	You\'ve seen what happens when you disobey our orders. You\'ve been a\n	little cooperative, and it\'s gotten you almost to the point where you\n	might go free again. If you want to make that possibility into a\n	reality, you\'ll stick to answering my questions.&quot;\n</p>\n',3,2,0,'2013-01-03 17:00:00',10),(12,'All I could think of was freedom','freedom','<p>	Back in my cell, a hundred little speeches occurred to me. The French \n	call this &quot;esprit d\'escalier&quot; -- the spirit of the staircase,\n	the snappy rebuttals that come to you after you leave the room and\n	slink down the stairs. In my mind, I stood and delivered, telling her\n	that I was a citizen who loved my freedom, which made me the patriot\n	and made her the traitor. In my mind, I shamed her for turning my\n	country into an armed camp. In my mind, I was eloquent and brilliant\n	and reduced her to tears.\n</p>\n<p>	But you know what? None of those fine words came back to me when they\n	pulled me out the next day. All I could think of was freedom. My parents.\n</p>\n<p>	&quot;Hello, Marcus,&quot; she said. &quot;How are you feeling?&quot;\n</p>\n<p>	I looked down at the table. She had a neat pile of documents in front\n	of her, and her ubiquitous go-cup of Starbucks beside her. I found it\n	comforting somehow, a reminder that there was a real world out there\n	somewhere, beyond the walls.\n</p>\n<p>	&quot;We\'re through investigating you, for now.&quot; She let that hang \n	there. Maybe it meant that she was letting me go. Maybe it meant that she\n	was going to throw me in a pit and forget that I existed. \n</p>\n<p>	&quot;And?&quot; I said finally.\n</p>\n<p>	&quot;And I want you to impress on you again that we are very serious \n	about this. Our country has experienced the worst attack ever committed \n	on its soil. How many 9/11s do you want us to suffer before you\'re\n	willing to cooperate? The details of our investigation are secret. We\n	won\'t stop at anything in our efforts to bring the perpetrators of\n	these heinous crimes to justice. Do you understand that?&quot;\n</p>\n<p>	&quot;Yes,&quot; I mumbled.\n</p>\n<p>	&quot;We are going to send you home today, but you are a marked man. You \n	have not been found to be above suspicion -- we\'re only releasing you\n	because we\'re done questioning you for now. But from now on, you\n	<i>belong</i> to us. We will be watching you. We\'ll be waiting for you \n	to make a misstep. Do you understand that we can watch you closely, all \n	the time?&quot;\n</p>\n<p>	&quot;Yes,&quot; I mumbled.\n</p>\n<p>	&quot;Good. You will never speak of what happened here to anyone, ever. \n	This is a matter of national security. Do you know that the death penalty \n	still holds for treason in time of war?&quot;\n</p>\n<p>	&quot;Yes,&quot; I mumbled.\n</p>\n<p>	&quot;Good boy,&quot; she purred. &quot;We have some papers here for you to\n	sign.&quot; She pushed the stack of papers across the table to me.\n	Little post-its with SIGN HERE printed on them had been stuck\n	throughout them. A guard undid my cuffs. \n</p>\n<p>	I paged through the papers and my eyes watered and my head swam. I\n	couldn\'t make sense of them. I tried to decipher the legalese. It\n	seemed that I was signing a declaration that I had been voluntarily\n	held and submitted to voluntary questioning, of my own free will.\n</p>\n<p>	&quot;What happens if I don\'t sign this?&quot; I said. \n</p>\n<p>	She snatched the papers back and made that flicking gesture again. The\n	guards jerked me to my feet. \n</p>\n<p>	&quot;Wait!&quot; I cried. &quot;Please! I\'ll sign them!&quot; They \n	dragged me to the door. All I could see was that door, all I could \n	think of was it closing behind me. \n</p>\n<p>	I lost it. I wept. I begged to be allowed to sign the papers. To be so\n	close to freedom and have it snatched away, it made me ready to do\n	anything. I can\'t count the number of times I\'ve heard someone say,\n	&quot;Oh, I\'d rather die than do something-or-other&quot; -- I\'ve\n	said it myself now and again. But that was the first time I\n	understood what it really meant. I would have rather died than go\n	back to my cell.\n</p>\n<p>	I begged as they took me out into the corridor. I told them I\'d sign\n	anything.\n</p>\n<p>	She called out to the guards and they stopped. They brought me back. They\n	sat me down. One of them put the pen in my hand.\n</p>\n<p>	Of course, I signed, and signed and signed.\n</p>\n',3,2,0,'2013-01-04 17:00:00',11),(13,'A nondescript white 18-wheeler','nondescript-18-wheeler','<p>	A guard passed me my backpack. The woman extended her hand to me. I\n	just looked at it. She put it down and gave me a wry smile. Then she\n	mimed zipping up her lips and pointed to me, and opened the door.\n</p>\n<p>	It was daylight outside, gray and drizzling. I was looking down an alley\n	toward cars and trucks and bikes zipping down the road. I stood\n	transfixed on the truck\'s top step, staring at freedom.\n</p>\n<p>	My knees shook. I knew now that they were playing with me again. In a\n	moment, the guards would grab me and drag me back inside, the bag\n	would go over my head again, and I would be back on the boat and sent\n	off to the prison again, to the endless, unanswerable questions. I\n	barely held myself back from stuffing my fist in my mouth. \n</p>\n<p>	Then I forced myself to go down one stair. Another stair. The last stair.\n	My sneakers crunched down on the crap on the alley\'s floor, broken\n	glass, a needle, gravel. I took a step. Another. I reached the mouth\n	of the alley and stepped onto the sidewalk. \n</p>\n<p>	No one grabbed me.\n</p>\n<p>	I was free.\n</p>\n<p>	Then strong arms threw themselves around me. I nearly cried.\n</p>\n<p>	But it was Van, and she <i>was</i> crying, and hugging me so hard I \n	couldn\'t breathe. I didn\'t care. I hugged her back, my face buried in \n	her hair. \n</p>\n<p>	&quot;You\'re OK!&quot; she said. \n</p>\n<p>	&quot;I\'m OK,&quot; I managed.\n</p>\n<p>	She finally let go of me and another set of arms wrapped themselves\n	around me. It was Jolu! They were both there. He whispered, &quot;You\'re\n	safe, bro,&quot; in my ear and hugged me even tighter than Vanessa had.\n</p>\n<p>	When he let go, I looked around. &quot;Where\'s Darryl?&quot; I asked.\n</p>\n<p>	They both looked at each other. &quot;Maybe he\'s still in the truck,&quot;\n	Jolu said. \n</p>\n<p>	We turned and looked at the truck at the alley\'s end. It was a\n	nondescript white 18-wheeler. Someone had already brought the little\n	folding staircase inside. The rear lights glowed red, and the truck\n	rolled backwards towards us, emitting a steady eep, eep, eep.\n</p>\n<p>	&quot;Wait!&quot; I shouted as it accelerated towards us. &quot;Wait! What about\n	Darryl?&quot; The truck drew closer. I kept shouting. &quot;What\n	about Darryl?&quot;\n</p>\n<p>	Jolu and Vanessa each had me by an arm and were dragging me away. I\n	struggled against them, shouting. The truck pulled out of the alley\'s\n	mouth and reversed into the street and pointed itself downhill and\n	drove away. I tried to run after it, but Van and Jolu wouldn\'t let me\n	go.\n</p>\n<p>	I sat down on the sidewalk and put my arms around my knees and cried. I\n	cried and cried and cried, loud sobs of the sort I hadn\'t done since\n	I was a little kid. They wouldn\'t stop coming. I couldn\'t stop\n	shaking.\n</p>\n',3,2,0,'2013-01-05 16:00:00',12);
/*!40000 ALTER TABLE `blog_post` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_form`
--

DROP TABLE IF EXISTS `cms_form`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_form` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `url_name` varchar(100) NOT NULL,
  `redirect` varchar(200) DEFAULT NULL,
  `action` varchar(20) NOT NULL,
  `email_to` varchar(100) DEFAULT NULL,
  `template` varchar(100) DEFAULT NULL,
  `has_captcha` tinyint(4) DEFAULT '0',
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `cms_form_url_name` (`url_name`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_form`
--

LOCK TABLES `cms_form` WRITE;
/*!40000 ALTER TABLE `cms_form` DISABLE KEYS */;
INSERT INTO `cms_form` VALUES (1,'Contact Form','contact','/','Email','2014@denny.me',NULL,1,'2014-09-21 04:35:38');
/*!40000 ALTER TABLE `cms_form` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_page`
--

DROP TABLE IF EXISTS `cms_page`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_page` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `url_name` varchar(100) NOT NULL,
  `title` varchar(100) NOT NULL,
  `description` text,
  `template` int(11) NOT NULL,
  `section` int(11) DEFAULT NULL,
  `menu_position` int(11) DEFAULT NULL,
  `hidden` tinyint(4) NOT NULL DEFAULT '0',
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `cms_page_url_name` (`section`,`url_name`),
  KEY `cms_page_idx_section` (`section`),
  KEY `cms_page_idx_template` (`template`),
  CONSTRAINT `cms_page_fk_section` FOREIGN KEY (`section`) REFERENCES `cms_section` (`id`),
  CONSTRAINT `cms_page_fk_template` FOREIGN KEY (`template`) REFERENCES `cms_template` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_page`
--

LOCK TABLES `cms_page` WRITE;
/*!40000 ALTER TABLE `cms_page` DISABLE KEYS */;
INSERT INTO `cms_page` VALUES (1,'Home','home','Welcome to ShinyCMS',NULL,1,1,NULL,0,'2014-09-21 04:35:37'),(2,'About ShinyCMS','about','About ShinyCMS',NULL,2,2,1,0,'2014-09-21 04:35:37'),(3,'Feature List','features','Feature List',NULL,2,2,2,0,'2014-09-21 04:35:37'),(4,'Contact Us','contact-us','Contact Us',NULL,3,1,3,0,'2014-09-21 04:35:38');
/*!40000 ALTER TABLE `cms_page` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_page_element`
--

DROP TABLE IF EXISTS `cms_page_element`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_page_element` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `page` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `type` varchar(20) NOT NULL DEFAULT 'Short Text',
  `content` text,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `cms_page_element_idx_page` (`page`),
  CONSTRAINT `cms_page_element_fk_page` FOREIGN KEY (`page`) REFERENCES `cms_page` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_page_element`
--

LOCK TABLES `cms_page_element` WRITE;
/*!40000 ALTER TABLE `cms_page_element` DISABLE KEYS */;
INSERT INTO `cms_page_element` VALUES (1,1,'heading1','Short Text','Introducing ShinyCMS','2014-09-21 04:35:37'),(2,1,'html1','HTML','<p>\n	This website is powered by <a href=\"http://shinycms.org/\">ShinyCMS</a>, \n	an open source content management system which is flexible and easy to \n	use, giving you the ability to change and update your content safely \n	and easily.</p>\n<p>\n	ShinyCMS can provide customised content management solutions for every \n	aspect of your business, from easily edited web pages to blog, forums, \n	paid memberships, an online store and more.</p>\n<p>\n	This text comes from the database and is under CMS control. It is \n	WYSIWYG editable and <i>can</i> <b>include</b> <u>various</u> \n	<b><i><u>formatting</u></i></b>.</p>\n','2014-09-21 04:35:37'),(3,1,'video_url','Short Text','Shiny.jpg','2014-09-21 04:35:37'),(4,2,'heading1','Short Text','Clean and simple content management','2014-09-21 04:35:37'),(5,2,'paragraphs1','Long Text','','2014-09-21 04:35:37'),(6,2,'html1','HTML','<p>\n	ShinyCMS is an open-source content management system intended for use \n	by web designers and web developers who want to keep a clear distinction \n	between the markup they create and the content their clients can edit.</p>\n<p>\n	On a ShinyCMS-powered site, the pages are constructed using template files \n	on disk which are mostly standard HTML (or XHTML). The CMS then inserts \n	text and images specified by the database in places designated by special \n	tokens (the templating language used is the well-known and flexible \n	<a href=\"http://template-toolkit.org/\">Template Toolkit</a>). The only \n	things the end-user can edit are these small pieces of database-driven \n	content - not the whole page.</p>\n<p>\n	This way of working means that it\'s almost impossible for the end-user to \n	accidentally break the page layout when they edit their content. It also \n	means that the page-editing interface is very clear and simple - making \n	it easy for non-technical people to update the website.</p>\n<p>\n	ShinyCMS has a number of features already in place, and more on the way. \n	Take a look at <a href=\"http://shinycms.org/pages/main/features\">our \n	feature list</a> to see what\'s already working, and at our \n	<a href=\"https://github.com/denny/ShinyCMS/blob/master/docs/TODO\">\'to do\' \n	list</a> (on github) for what\'s coming soon.</p>\n<p>\n	ShinyCMS is built in <a href=\"http://www.perl.org/\">Perl</a> using the \n	<a href=\"http://www.catalystframework.org/\">Catalyst</a> framework. \n	We\'re currently working towards a 1.0 release, but if you\'re interested \n	in trying it out before then, you can \n	<a href=\"https://github.com/denny/ShinyCMS\">download a copy of the code \n	here</a> - please drop us an email to &lt;2014 at shinycms.org&gt; to let \n	us know how you\'re getting on, or come and chat to us in #shinycms on \n	irc.freenode.net</p>\n','2014-09-21 04:35:37'),(7,2,'image1','Image','Shiny.jpg','2014-09-21 04:35:37'),(8,3,'heading1','Short Text','Feature List','2014-09-21 04:35:37'),(9,3,'paragraphs1','Long Text','The following is a list of features currently found in ShinyCMS:\n','2014-09-21 04:35:37'),(10,3,'html1','HTML','<ul>\n	<li>\n		CMS Pages\n		<ul>\n			<li>\n				Add/Edit/Delete templates from CMS control\n				<ul>\n					<li>\n						Templates use on-disk files to define page layouts\n						<ul>\n							<li>\n								Inside each template file, you can specify a wrapper template to use with that template (reduces markup duplication inside sections of client sites</li>\n						</ul>\n					</li>\n				</ul>\n			</li>\n			<li>\n				Add/Hide/Delete sections</li>\n			<li>\n				Edit sections\n				<ul>\n					<li>\n						Select a default page for each section</li>\n					<li>\n						Set menu position</li>\n					<li>\n						Set URL stub for section</li>\n				</ul>\n			</li>\n			<li>\n				Edit pages\n				<ul>\n					<li>\n						Select template to use</li>\n					<li>\n						Edit page name, title, meta description and keywords</li>\n					<li>\n						Set section</li>\n					<li>\n						Set menu position</li>\n					<li>\n						Set page URL stub</li>\n					<li>\n						Edit page content\n						<ul>\n							<li>\n								Plain text elements for simplicity</li>\n							<li>\n								WYSIWYG editor widget for HTML elements where required</li>\n						</ul>\n					</li>\n					<li>\n						Preview edits before saving</li>\n				</ul>\n			</li>\n			<li>\n				Display page\n				<ul>\n					<li>\n						Uses template for layout, content/copy comes from database</li>\n				</ul>\n			</li>\n			<li>\n				Auto-generate menus based on menu position settings of sections and pages</li>\n			<li>\n				Auto-generate basic sitemap based on menu positions and &#39;hidden&#39; status</li>\n			<li>\n				Supply search results to site-wide search</li>\n			<li>\n				Pull in &#39;recent updates&#39; from news, blogs and events sections</li>\n			<li>\n				Pull in atom feeds from external blogs&nbsp;</li>\n		</ul>\n	</li>\n</ul>\n<p>\n	&nbsp;</p>\n<ul>\n	<li>\n		CMS Forms\n		<ul>\n			<li>\n				Add/Edit/Delete CMS form handlers</li>\n			<li>\n				Process form submissions\n				<ul>\n					<li>\n						Spam-protection using reCaptcha</li>\n					<li>\n						Trigger an email\n						<ul>\n							<li>\n								Generic or templated</li>\n						</ul>\n					</li>\n				</ul>\n			</li>\n		</ul>\n	</li>\n</ul>\n<p>\n	&nbsp;</p>\n<ul>\n	<li>\n		Shared Content\n		<ul>\n			<li>\n				Add/Edit/Delete shared content\n				<ul>\n					<li>\n						Store snippets of text and HTML that you want to re-use across multiple pages but still allow user to edit (e.g. contact details for use in page footer, etc)</li>\n				</ul>\n			</li>\n		</ul>\n	</li>\n</ul>\n<p>\n	&nbsp;</p>\n<ul>\n	<li>\n		Restricted Content\n		<ul>\n			<li>\n				Have static files (images, documents, etc) which are only available&nbsp;to logged-in users who have a certain User Access type set\n				<ul>\n					<li>\n						Supports multiple User Access types, for user/content categorisation/separation&nbsp;</li>\n				</ul>\n			</li>\n		</ul>\n	</li>\n</ul>\n<p>\n	&nbsp;</p>\n<ul>\n	<li>\n		Menus\n		<ul>\n			<li>\n				Main menu on user-facing site\n				<ul>\n					<li>\n						Auto-generated for sections and pages in CMS Pages area</li>\n				</ul>\n			</li>\n			<li>\n				Admin footer bar on user-facing site\n				<ul>\n					<li>\n						Useful contextual admin links in page footer when admin user is logged in</li>\n				</ul>\n			</li>\n			<li>\n				Admin menus in back-end can be easily re-ordered via template\n				<ul>\n					<li>\n						Only displays menus for features the logged-in user can access&nbsp;</li>\n				</ul>\n			</li>\n		</ul>\n	</li>\n</ul>\n<p>\n	&nbsp;</p>\n<ul>\n	<li>\n		Site-wide search. &nbsp;Currently pulls in results from:\n		<ul>\n			<li>\n				CMS pages</li>\n			<li>\n				News items</li>\n			<li>\n				Blog posts</li>\n			<li>\n				Forum posts</li>\n			<li>\n				Comments</li>\n			<li>\n				Events</li>\n		</ul>\n	</li>\n</ul>\n<p>\n	&nbsp;</p>\n<ul>\n	<li>\n		Site-wide tag listings. &nbsp;Currently links to:\n		<ul>\n			<li>\n				Blog posts</li>\n			<li>\n				Forum posts</li>\n			<li>\n				Shop items</li>\n		</ul>\n	</li>\n</ul>\n<p>\n	&nbsp;</p>\n<ul>\n	<li>\n		404 handler (with home and sitemap links, and search box)</li>\n</ul>\n<p>\n	&nbsp;</p>\n<ul>\n	<li>\n		Style-switcher\n		<ul>\n			<li>\n				Allow users to switch between stylesheets, for accessibility or themes</li>\n		</ul>\n	</li>\n</ul>\n<p>\n	&nbsp;</p>\n<ul>\n	<li>\n		Mobile device detection\n		<ul>\n			<li>\n				Detect if user is browsing from a mobile device\n				<ul>\n					<li>\n						Allows you to present content differently, or present different content&nbsp;&nbsp;</li>\n				</ul>\n			</li>\n		</ul>\n	</li>\n</ul>\n<p>\n	&nbsp;</p>\n<ul>\n	<li>\n		Blogs\n		<ul>\n			<li>\n				Display recent posts\n				<ul>\n					<li>\n						With pagination</li>\n				</ul>\n			</li>\n			<li>\n				Display all posts in a given month\n				<ul>\n					<li>\n						With prev/next month navigation</li>\n				</ul>\n			</li>\n			<li>\n				Display summary of all posts in a given year\n				<ul>\n					<li>\n						With prev/next year navigation&nbsp;</li>\n				</ul>\n			</li>\n			<li>\n				Display all posts with a given tag\n				<ul>\n					<li>\n						With pagination</li>\n				</ul>\n			</li>\n			<li>\n				Display all posts by a given author\n				<ul>\n					<li>\n						With pagination&nbsp;</li>\n				</ul>\n			</li>\n			<li>\n				Display a single post</li>\n			<li>\n				Generate atom feed of recent posts</li>\n			<li>\n				Add/Edit/Hide/Delete posts\n				<ul>\n					<li>\n						Schedule posts (future-date a post and it will appear on the site at the specified date and time)</li>\n					<li>\n						Enable/disable comments</li>\n				</ul>\n			</li>\n			<li>\n				Supply search results to site-wide search</li>\n		</ul>\n	</li>\n</ul>\n<p>\n	&nbsp;</p>\n<ul>\n	<li>\n		Forums\n		<ul>\n			<li>\n				Add/Edit/Hide/Delete section</li>\n			<li>\n				Add/Edit/Hide/Delete forum</li>\n			<li>\n				Add/Edit/Hide/Delete new thread</li>\n			<li>\n				Add comments to thread</li>\n			<li>\n				Delete comments (admin-only)</li>\n			<li>\n				Display all forums in all sections</li>\n			<li>\n				Display forums in a specified section</li>\n			<li>\n				Display threads in a forum</li>\n			<li>\n				Display threads with a given tag</li>\n			<li>\n				Display thread\n				<ul>\n					<li>\n						With nested comments</li>\n				</ul>\n			</li>\n			<li>\n				Supply search results to site-wide search&nbsp;</li>\n		</ul>\n	</li>\n</ul>\n<p>\n	&nbsp;</p>\n<ul>\n	<li>\n		News\n		<ul>\n			<li>\n				View list of news items</li>\n			<li>\n				View item</li>\n			<li>\n				Add/Edit/Hide/Delete news items</li>\n			<li>\n				Supply search results to site-wide search</li>\n		</ul>\n	</li>\n</ul>\n<p>\n	&nbsp;</p>\n<ul>\n	<li>\n		Comments\n		<ul>\n			<li>\n				Currently enabled on:\n				<ul>\n					<li>\n						Blog posts</li>\n					<li>\n						Forum threads</li>\n					<li>\n						Shop items</li>\n				</ul>\n			</li>\n			<li>\n				Display comments\n				<ul>\n					<li>\n						With nested threading</li>\n				</ul>\n			</li>\n			<li>\n				Add comments\n				<ul>\n					<li>\n						Reply to original post or to another comment</li>\n					<li>\n						As logged-in, anonymous, or pseudonymous user\n						<ul>\n							<li>\n								Saves and restores details of pseudonymous users</li>\n							<li>\n								Captcha for anonymous and pseudonymous users</li>\n						</ul>\n					</li>\n				</ul>\n			</li>\n			<li>\n				Hide comments\n				<ul>\n					<li>\n						Allows soft removal of comments in mid-thread</li>\n					<li>\n						Can be restored</li>\n				</ul>\n			</li>\n			<li>\n				Delete comments\n				<ul>\n					<li>\n						Cascade deletes any child comments</li>\n				</ul>\n			</li>\n			<li>\n				Supply search results to site-wide search&nbsp;</li>\n		</ul>\n	</li>\n</ul>\n<p>\n	&nbsp;</p>\n<ul>\n	<li>\n		Users\n		<ul>\n			<li>\n				User registration\n				<ul>\n					<li>\n						With email confirmation stage&nbsp;</li>\n				</ul>\n			</li>\n			<li>\n				Log in / out</li>\n			<li>\n				Recover from forgotten password&nbsp;</li>\n			<li>\n				View user profile\n				<ul>\n					<li>\n						Show recent (and total) blog posts and comments</li>\n					<li>\n						Show recent (and total) forum posts and comments</li>\n				</ul>\n			</li>\n			<li>\n				User can edit their own details</li>\n			<li>\n				Roles (&#39;page editor&#39;, &#39;shop admin&#39;, etc)</li>\n			<li>\n				User administration\n				<ul>\n					<li>\n						Add/Delete users</li>\n					<li>\n						Edit existing users\n						<ul>\n							<li>\n								Edit user details</li>\n							<li>\n								Edit user roles</li>\n						</ul>\n					</li>\n					<li>\n						Admin notes (notes about a user which are only visible to admins)</li>\n				</ul>\n			</li>\n		</ul>\n	</li>\n</ul>\n<p>\n	&nbsp;</p>\n<ul>\n	<li>\n		Shop\n		<ul>\n			<li>\n				Display item</li>\n			<li>\n				Display list of items in a category</li>\n			<li>\n				Display list of recently-added items&nbsp;</li>\n			<li>\n				Display list of all items</li>\n			<li>\n				Display list of categories\n				<ul>\n					<li>\n						With nested sub-categories</li>\n				</ul>\n			</li>\n			<li>\n				Add/Edit/Delete product types</li>\n			<li>\n				Add/Edit/Hide/Delete categories</li>\n			<li>\n				Add/Edit/Hide/Delete items</li>\n			<li>\n				Basket and checkout\n				<ul>\n					<li>\n						Use built-in &#39;ShinyShop&#39; basket and checkout\n						<ul>\n							<li>\n								Payment handlers for physical and virtual goods\n								<ul>\n									<li>\n										Support varous credit card payment processors\n										<ul>\n											<li>\n												Currently supported: CCBill</li>\n										</ul>\n									</li>\n								</ul>\n							</li>\n							<li>\n								View orders</li>\n							<li>\n								Cancel order (before despatch only)</li>\n						</ul>\n					</li>\n					<li>\n						Or, use basic PayPal cart and checkout integration</li>\n				</ul>\n			</li>\n			<li>\n				Subscription payment handlers for setting User Access\n				<ul>\n					<li>\n						Support various credit card payment processors\n						<ul>\n							<li>\n								Currently supported: CCBill</li>\n						</ul>\n					</li>\n					<li>\n						Background task to check renewals and maintain/remove access</li>\n				</ul>\n			</li>\n		</ul>\n	</li>\n</ul>\n<p>\n	&nbsp;</p>\n<ul>\n	<li>\n		Mailshot features\n		<ul>\n			<li>\n				Add/edit/delete mailing lists</li>\n			<li>\n				Add/edit/delete newsletter templates from CMS control</li>\n			<li>\n				HTML newsletters\n				<ul>\n					<li>\n						Create/edit/delete newsletters</li>\n					<li>\n						Background task to send out newsletters to mailing lists</li>\n					<li>\n						View previous newsletters on site</li>\n				</ul>\n			</li>\n			<li>\n				Autoresponders\n				<ul>\n					<li>\n						Add/Edit/Delete autoresponders\n						<ul>\n							<li>\n								Add/Edit/Delete autoresponder emails</li>\n						</ul>\n					</li>\n					<li>\n						Allow users to subscribe to autoresponders</li>\n					<li>\n						Background task to send out autoresponder emails to each recipient at configured time intervals</li>\n				</ul>\n			</li>\n		</ul>\n	</li>\n</ul>\n<p>\n	&nbsp;</p>\n<ul>\n	<li>\n		Events\n		<ul>\n			<li>\n				Display &#39;coming soon&#39; events</li>\n			<li>\n				Display all events starting in a given month\n				<ul>\n					<li>\n						With prev/next month navigation</li>\n				</ul>\n			</li>\n			<li>\n				Display details of a single event\n				<ul>\n					<li>\n						Link to external event website</li>\n					<li>\n						Link to external ticket-booking website</li>\n					<li>\n						Link to Google Map for event location</li>\n				</ul>\n			</li>\n			<li>\n				Add/Edit/Hide/Delete events</li>\n			<li>\n				Supply search results to site-wide search</li>\n		</ul>\n	</li>\n</ul>\n<p>\n	&nbsp;</p>\n<ul>\n	<li>\n		Polls\n		<ul>\n			<li>\n				Basic pollbooths</li>\n			<li>\n				Anon &amp; logged-in voting</li>\n			<li>\n				Basic vote-stacking protection (per-IP for anon, per-user for logged-in)</li>\n		</ul>\n	</li>\n</ul>\n','2014-09-21 04:35:37'),(11,3,'image1','Image','Shiny.jpg','2014-09-21 04:35:37');
/*!40000 ALTER TABLE `cms_page_element` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_section`
--

DROP TABLE IF EXISTS `cms_section`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_section` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `url_name` varchar(100) NOT NULL,
  `description` text,
  `default_page` int(11) DEFAULT NULL,
  `menu_position` int(11) DEFAULT NULL,
  `hidden` tinyint(4) NOT NULL DEFAULT '0',
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `cms_section_url_name` (`url_name`),
  KEY `cms_section_idx_default_page` (`default_page`),
  CONSTRAINT `cms_section_fk_default_page` FOREIGN KEY (`default_page`) REFERENCES `cms_page` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_section`
--

LOCK TABLES `cms_section` WRITE;
/*!40000 ALTER TABLE `cms_section` DISABLE KEYS */;
INSERT INTO `cms_section` VALUES (1,'Home','home',NULL,1,1,0,'2014-09-21 04:35:37'),(2,'More','more',NULL,2,2,0,'2014-09-21 04:35:37');
/*!40000 ALTER TABLE `cms_section` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_template`
--

DROP TABLE IF EXISTS `cms_template`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_template` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `template_file` varchar(100) NOT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_template`
--

LOCK TABLES `cms_template` WRITE;
/*!40000 ALTER TABLE `cms_template` DISABLE KEYS */;
INSERT INTO `cms_template` VALUES (1,'Homepage','homepage.tt','2014-09-21 04:35:36'),(2,'Subpage 1','subpage1.tt','2014-09-21 04:35:36'),(3,'Contact Form','contact-form.tt','2014-09-21 04:35:36');
/*!40000 ALTER TABLE `cms_template` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_template_element`
--

DROP TABLE IF EXISTS `cms_template_element`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_template_element` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `template` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `type` varchar(20) NOT NULL DEFAULT 'Short Text',
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `cms_template_element_idx_template` (`template`),
  CONSTRAINT `cms_template_element_fk_template` FOREIGN KEY (`template`) REFERENCES `cms_template` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_template_element`
--

LOCK TABLES `cms_template_element` WRITE;
/*!40000 ALTER TABLE `cms_template_element` DISABLE KEYS */;
INSERT INTO `cms_template_element` VALUES (1,1,'heading1','Short Text','2014-09-21 04:35:36'),(2,1,'html1','HTML','2014-09-21 04:35:36'),(3,1,'video_url','Short Text','2014-09-21 04:35:37'),(4,2,'heading1','Short Text','2014-09-21 04:35:37'),(5,2,'paragraphs1','Long Text','2014-09-21 04:35:37'),(6,2,'html1','HTML','2014-09-21 04:35:37'),(7,2,'image1','Image','2014-09-21 04:35:37');
/*!40000 ALTER TABLE `cms_template_element` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comment`
--

DROP TABLE IF EXISTS `comment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `comment` (
  `uid` int(11) NOT NULL AUTO_INCREMENT,
  `discussion` int(11) NOT NULL,
  `id` int(11) NOT NULL,
  `parent` int(11) DEFAULT NULL,
  `author` int(11) DEFAULT NULL,
  `author_type` varchar(20) NOT NULL,
  `author_name` varchar(100) DEFAULT NULL,
  `author_email` varchar(200) DEFAULT NULL,
  `author_link` varchar(200) DEFAULT NULL,
  `title` varchar(100) DEFAULT NULL,
  `body` text,
  `posted` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `hidden` tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`uid`),
  KEY `comment_idx_author` (`author`),
  KEY `comment_idx_discussion` (`discussion`),
  CONSTRAINT `comment_fk_author` FOREIGN KEY (`author`) REFERENCES `user` (`id`),
  CONSTRAINT `comment_fk_discussion` FOREIGN KEY (`discussion`) REFERENCES `discussion` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comment`
--

LOCK TABLES `comment` WRITE;
/*!40000 ALTER TABLE `comment` DISABLE KEYS */;
INSERT INTO `comment` VALUES (1,1,1,NULL,3,'Site User',NULL,NULL,NULL,NULL,'\"If it isn\'t Double-you-one-enn-five-tee-zero-enn,\" said Fredrick Benson.\n\n\"Sorry, nope,\" I said. \"I never heard of this R2D2 character of yours.\"\n','2014-09-21 04:35:54',0),(2,1,2,1,3,'Site User',NULL,NULL,NULL,NULL,'\"We have reliable intelligence indicating that you are w1n5t0n\" -- again, he spelled it out, and I began to wonder if he hadn\'t figured out that the 1 was an I and the 5 was an S.\n','2014-09-21 04:35:54',0),(3,1,3,NULL,3,'Site User',NULL,NULL,NULL,NULL,'Benson settled down behind his desk and tapped his class-ring nervously on his blotter. He did this whenever things started to go bad for him. Poker players call stuff like this a \"tell\" -- something that let you know what was going on in the other guy\'s head. I knew Benson\'s tells backwards and forwards.\n','2014-09-21 04:35:54',0),(4,1,4,2,3,'Site User',NULL,NULL,NULL,NULL,'\"You have \'reliable intelligence\'? I\'d like to see it.\"\n\nHe glowered at me. \"Your attitude isn\'t going to help you.\"\n','2014-09-21 04:35:54',0),(5,1,5,3,3,'Site User',NULL,NULL,NULL,NULL,'\"Marcus, I hope you realize how serious this is.\"\n\n\"I will just as soon as you explain what this is, sir.\" I always say \"sir\" to authority figures when I\'m messing with them. It\'s my own tell.\n','2014-09-21 04:35:55',0),(6,13,1,NULL,1,'Site User',NULL,NULL,NULL,NULL,'Hi, I\'m interested in the difference between netbooks and laptops...\n','2014-09-21 04:36:04',0),(7,13,2,1,1,'Site User',NULL,NULL,NULL,NULL,'What kind of thing do you want to know?\n','2014-09-21 04:36:04',0),(8,13,3,NULL,1,'Site User',NULL,NULL,NULL,NULL,'How about tablets?\n','2014-09-21 04:36:04',0),(9,13,4,2,1,'Site User',NULL,NULL,NULL,NULL,'Is there a clear definition of which is which?\n','2014-09-21 04:36:04',0),(10,13,5,3,1,'Site User',NULL,NULL,NULL,NULL,'Yeah, they should probably add a section for those.\n','2014-09-21 04:36:05',0);
/*!40000 ALTER TABLE `comment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comment_like`
--

DROP TABLE IF EXISTS `comment_like`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `comment_like` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `comment` int(11) NOT NULL,
  `user` int(11) DEFAULT NULL,
  `ip_address` varchar(15) NOT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `comment_like_idx_comment` (`comment`),
  KEY `comment_like_idx_user` (`user`),
  CONSTRAINT `comment_like_fk_comment` FOREIGN KEY (`comment`) REFERENCES `comment` (`uid`),
  CONSTRAINT `comment_like_fk_user` FOREIGN KEY (`user`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comment_like`
--

LOCK TABLES `comment_like` WRITE;
/*!40000 ALTER TABLE `comment_like` DISABLE KEYS */;
/*!40000 ALTER TABLE `comment_like` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `confirmation`
--

DROP TABLE IF EXISTS `confirmation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `confirmation` (
  `user` int(11) NOT NULL,
  `code` varchar(32) NOT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`user`,`code`),
  KEY `confirmation_idx_user` (`user`),
  CONSTRAINT `confirmation_fk_user` FOREIGN KEY (`user`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `confirmation`
--

LOCK TABLES `confirmation` WRITE;
/*!40000 ALTER TABLE `confirmation` DISABLE KEYS */;
/*!40000 ALTER TABLE `confirmation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `discussion`
--

DROP TABLE IF EXISTS `discussion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `discussion` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `resource_id` int(11) NOT NULL,
  `resource_type` varchar(50) NOT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `discussion`
--

LOCK TABLES `discussion` WRITE;
/*!40000 ALTER TABLE `discussion` DISABLE KEYS */;
INSERT INTO `discussion` VALUES (1,1,'BlogPost','2014-09-21 04:35:54'),(2,2,'BlogPost','2014-09-21 04:35:56'),(3,3,'BlogPost','2014-09-21 04:35:56'),(4,4,'BlogPost','2014-09-21 04:35:56'),(5,5,'BlogPost','2014-09-21 04:35:56'),(6,7,'BlogPost','2014-09-21 04:35:57'),(7,8,'BlogPost','2014-09-21 04:35:57'),(8,9,'BlogPost','2014-09-21 04:35:58'),(9,10,'BlogPost','2014-09-21 04:35:58'),(10,11,'BlogPost','2014-09-21 04:35:58'),(11,12,'BlogPost','2014-09-21 04:35:59'),(12,13,'BlogPost','2014-09-21 04:35:59'),(13,1,'ForumPost','2014-09-21 04:36:03'),(14,1,'ShopItem','2014-09-21 04:36:11'),(15,2,'ShopItem','2014-09-21 04:36:11'),(16,3,'ShopItem','2014-09-21 04:36:11');
/*!40000 ALTER TABLE `discussion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `event`
--

DROP TABLE IF EXISTS `event`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `event` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `url_name` varchar(100) NOT NULL,
  `description` text,
  `image` varchar(100) DEFAULT NULL,
  `start_date` timestamp NOT NULL DEFAULT '1971-01-01 06:01:01',
  `end_date` timestamp NOT NULL DEFAULT '1971-01-01 06:01:01',
  `postcode` varchar(10) DEFAULT NULL,
  `email` varchar(200) DEFAULT NULL,
  `link` varchar(200) DEFAULT NULL,
  `booking_link` varchar(200) DEFAULT NULL,
  `hidden` tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `event`
--

LOCK TABLES `event` WRITE;
/*!40000 ALTER TABLE `event` DISABLE KEYS */;
INSERT INTO `event` VALUES (1,'Old Event','old-event','This is the first event, it is in the past.',NULL,'2014-08-21 08:36:20','2014-08-21 09:36:20',NULL,NULL,NULL,NULL,0),(2,'Current Event','current','This is the second event, it is happening today!',NULL,'2014-09-21 08:36:20','2014-09-22 08:36:20','EC1V 9AU',NULL,'http://shinycms.org/',NULL,0),(3,'Christmas','xmas','Tis the season to be jolly, tra-la-la-la-la, la-la la la.',NULL,'2014-12-25 05:00:00','2014-12-25 05:00:00',NULL,NULL,NULL,NULL,0);
/*!40000 ALTER TABLE `event` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `feed`
--

DROP TABLE IF EXISTS `feed`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `feed` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `url` varchar(255) NOT NULL,
  `last_checked` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `feed`
--

LOCK TABLES `feed` WRITE;
/*!40000 ALTER TABLE `feed` DISABLE KEYS */;
/*!40000 ALTER TABLE `feed` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `feed_item`
--

DROP TABLE IF EXISTS `feed_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `feed_item` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `feed` int(11) NOT NULL,
  `url` varchar(255) DEFAULT NULL,
  `title` varchar(100) DEFAULT NULL,
  `body` text,
  `posted` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `feed_item_idx_feed` (`feed`),
  CONSTRAINT `feed_item_fk_feed` FOREIGN KEY (`feed`) REFERENCES `feed` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `feed_item`
--

LOCK TABLES `feed_item` WRITE;
/*!40000 ALTER TABLE `feed_item` DISABLE KEYS */;
/*!40000 ALTER TABLE `feed_item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `forum`
--

DROP TABLE IF EXISTS `forum`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `forum` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `section` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `url_name` varchar(100) NOT NULL,
  `description` text,
  `display_order` int(11) DEFAULT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `forum_url_name` (`section`,`url_name`),
  KEY `forum_idx_section` (`section`),
  CONSTRAINT `forum_fk_section` FOREIGN KEY (`section`) REFERENCES `forum_section` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `forum`
--

LOCK TABLES `forum` WRITE;
/*!40000 ALTER TABLE `forum` DISABLE KEYS */;
INSERT INTO `forum` VALUES (1,1,'Laptops','laptops',NULL,NULL,'2014-09-21 04:36:03'),(2,1,'Desktops','desktops',NULL,NULL,'2014-09-21 04:36:03'),(3,2,'Linux','linux',NULL,NULL,'2014-09-21 04:36:03');
/*!40000 ALTER TABLE `forum` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `forum_post`
--

DROP TABLE IF EXISTS `forum_post`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `forum_post` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `forum` int(11) NOT NULL,
  `title` varchar(100) NOT NULL,
  `url_title` varchar(100) NOT NULL,
  `body` text NOT NULL,
  `author` int(11) DEFAULT NULL,
  `posted` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `display_order` int(11) DEFAULT NULL,
  `commented_on` timestamp NOT NULL DEFAULT '1971-01-01 06:01:01',
  `discussion` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `forum_post_idx_author` (`author`),
  KEY `forum_post_idx_discussion` (`discussion`),
  KEY `forum_post_idx_forum` (`forum`),
  CONSTRAINT `forum_post_fk_author` FOREIGN KEY (`author`) REFERENCES `user` (`id`),
  CONSTRAINT `forum_post_fk_discussion` FOREIGN KEY (`discussion`) REFERENCES `discussion` (`id`),
  CONSTRAINT `forum_post_fk_forum` FOREIGN KEY (`forum`) REFERENCES `forum` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `forum_post`
--

LOCK TABLES `forum_post` WRITE;
/*!40000 ALTER TABLE `forum_post` DISABLE KEYS */;
INSERT INTO `forum_post` VALUES (1,1,'General chat','general-chat','We can discuss anything about laptops here!\n',1,'2014-09-21 04:36:03',NULL,'1971-01-01 06:01:01',13);
/*!40000 ALTER TABLE `forum_post` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `forum_section`
--

DROP TABLE IF EXISTS `forum_section`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `forum_section` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `url_name` varchar(100) NOT NULL,
  `description` text,
  `display_order` int(11) DEFAULT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `forum_section_url_name` (`url_name`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `forum_section`
--

LOCK TABLES `forum_section` WRITE;
/*!40000 ALTER TABLE `forum_section` DISABLE KEYS */;
INSERT INTO `forum_section` VALUES (1,'Hardware','hardware',NULL,NULL,'2014-09-21 04:36:03'),(2,'Software','software',NULL,NULL,'2014-09-21 04:36:03');
/*!40000 ALTER TABLE `forum_section` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `gallery`
--

DROP TABLE IF EXISTS `gallery`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `gallery` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `hidden` tinyint(4) NOT NULL DEFAULT '0',
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gallery`
--

LOCK TABLES `gallery` WRITE;
/*!40000 ALTER TABLE `gallery` DISABLE KEYS */;
/*!40000 ALTER TABLE `gallery` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `image`
--

DROP TABLE IF EXISTS `image`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `image` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(200) NOT NULL,
  `mime` varchar(200) NOT NULL,
  `path` text NOT NULL,
  `caption` text,
  `hidden` tinyint(4) NOT NULL DEFAULT '0',
  `uploaded` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `image`
--

LOCK TABLES `image` WRITE;
/*!40000 ALTER TABLE `image` DISABLE KEYS */;
/*!40000 ALTER TABLE `image` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mail_recipient`
--

DROP TABLE IF EXISTS `mail_recipient`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mail_recipient` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `email` varchar(200) NOT NULL,
  `token` varchar(32) NOT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `mail_recipient_email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mail_recipient`
--

LOCK TABLES `mail_recipient` WRITE;
/*!40000 ALTER TABLE `mail_recipient` DISABLE KEYS */;
INSERT INTO `mail_recipient` VALUES (1,'Nice Person','nice.person@example.com','abcd1234abcd1234abcd1234abcd1111','2014-09-21 04:36:15'),(2,'Another Person','another.person@example.com','abcd1234abcd1234abcd1234abcd2222','2014-09-21 04:36:15'),(3,'A. Teacher','a.teacher@example.com','abcd1234abcd1234abcd1234abcd3333','2014-09-21 04:36:15'),(4,'Site Admin','changeme@example.com','abcd1234abcd1234abcd1234abcd4444','2014-09-21 04:36:15');
/*!40000 ALTER TABLE `mail_recipient` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mailing_list`
--

DROP TABLE IF EXISTS `mailing_list`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mailing_list` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `user_can_sub` tinyint(4) DEFAULT '0',
  `user_can_unsub` tinyint(4) DEFAULT '1',
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mailing_list`
--

LOCK TABLES `mailing_list` WRITE;
/*!40000 ALTER TABLE `mailing_list` DISABLE KEYS */;
INSERT INTO `mailing_list` VALUES (1,'Donators and teachers',0,1,'2014-09-21 04:36:15'),(2,'Testing',0,1,'2014-09-21 04:36:15');
/*!40000 ALTER TABLE `mailing_list` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `news_item`
--

DROP TABLE IF EXISTS `news_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `news_item` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `author` int(11) NOT NULL,
  `title` varchar(100) NOT NULL,
  `url_title` varchar(100) NOT NULL,
  `body` text NOT NULL,
  `related_url` varchar(255) DEFAULT NULL,
  `hidden` tinyint(4) NOT NULL DEFAULT '0',
  `posted` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `news_item_idx_author` (`author`),
  CONSTRAINT `news_item_fk_author` FOREIGN KEY (`author`) REFERENCES `user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `news_item`
--

LOCK TABLES `news_item` WRITE;
/*!40000 ALTER TABLE `news_item` DISABLE KEYS */;
INSERT INTO `news_item` VALUES (1,2,'This is the news','this-is-the-news','<p>	HTML content goes here.\n</p>\n',NULL,0,'2010-01-01 17:00:00'),(2,2,'Extra extra','extra-extra','<p>	Read all about it.\n</p>\n',NULL,0,'2010-01-01 18:00:00'),(3,2,'Filler story','filler','<p>	Nothing of interest here.  Move along.\n</p>\n',NULL,0,'2010-01-02 18:00:00');
/*!40000 ALTER TABLE `news_item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `newsletter`
--

DROP TABLE IF EXISTS `newsletter`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `newsletter` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(100) NOT NULL,
  `url_title` varchar(100) NOT NULL,
  `template` int(11) NOT NULL,
  `plaintext` text,
  `list` int(11) DEFAULT NULL,
  `status` varchar(20) NOT NULL DEFAULT 'Not sent',
  `sent` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `newsletter_idx_list` (`list`),
  KEY `newsletter_idx_template` (`template`),
  CONSTRAINT `newsletter_fk_list` FOREIGN KEY (`list`) REFERENCES `mailing_list` (`id`),
  CONSTRAINT `newsletter_fk_template` FOREIGN KEY (`template`) REFERENCES `newsletter_template` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `newsletter`
--

LOCK TABLES `newsletter` WRITE;
/*!40000 ALTER TABLE `newsletter` DISABLE KEYS */;
INSERT INTO `newsletter` VALUES (1,'Donations and a word to teachers and librarians','donations',1,'If you enjoyed the electronic edition of Little Brother and you want to donate \nsomething to say thanks, go to http://craphound.com/littlebrother/donate/ and \nfind a teacher or librarian you want to support.  Then go to Amazon, BN.com, \nor your favorite electronic bookseller and order a copy to the classroom, \nthen email a copy of the receipt (feel free to delete your address and other \npersonal info first!) to freelittlebrother@gmail.com so that Olga can mark \nthat copy as sent.  If you don\'t want to be publicly acknowledged for your \ngenerosity, let us know and we\'ll keep you anonymous, otherwise we\'ll thank \nyou on the donate page.\n',1,'Not sent','2014-09-21 04:36:16');
/*!40000 ALTER TABLE `newsletter` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `newsletter_element`
--

DROP TABLE IF EXISTS `newsletter_element`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `newsletter_element` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `newsletter` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `type` varchar(20) NOT NULL DEFAULT 'Short Text',
  `content` text,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `newsletter_element_idx_newsletter` (`newsletter`),
  CONSTRAINT `newsletter_element_fk_newsletter` FOREIGN KEY (`newsletter`) REFERENCES `newsletter` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `newsletter_element`
--

LOCK TABLES `newsletter_element` WRITE;
/*!40000 ALTER TABLE `newsletter_element` DISABLE KEYS */;
INSERT INTO `newsletter_element` VALUES (1,1,'body','HTML','<p>	A message from Cory Doctorow:\n</p>\n<p>	Every time I put a book online for free, I get emails from readers who \n	want to send me donations for the book. I appreciate their generous\n	spirit, but I\'m not interested in cash donations, because my\n	publishers are really important to me. They contribute immeasurably\n	to the book, improving it, introducing it to an audience I could never\n	reach, helping me do more with my work. I have no desire to cut them\n	out of the loop.\n</p>\n\n<p>	But there has to be some good way to turn that generosity to good use,\n	and I think I\'ve found it.\n</p>\n\n<p>	Here\'s the deal: there are lots of teachers and librarians who\'d love to \n	get hard-copies of Little Brother into their kids\' hands, but don\'t have the\n	budget for it (teachers in the US spend around $1,200 out of pocket\n	each on classroom supplies that their budgets won\'t stretch to cover,\n	which is why I sponsor a classroom at Ivanhoe Elementary in my old\n	neighborhood in Los Angeles; you can adopt a class yourself \n	<a href=\"http://www.adoptaclassroom.org/\">here</a>).\n</p>\n\n<p>	There are generous people who want to send some cash my way to thank me \n	for the free ebooks.\n</p>\n\n<p>	I\'m proposing that we put them together. \n</p>\n\n<p>	If you\'re a teacher or librarian and you want a free copy of Little\n	Brother, email \n	<a href=\"mailto:freelittlebrother@gmail.com\">freelittlebrother@gmail.com</a> \n	with your name and the name and address of your school. It\'ll be \n	<a href=\"http://craphound.com/littlebrother/donate/\">posted to my site</a> \n	by my fantastic helper, Olga Nunes, so that potential donors can see it.\n</p>\n\n<p>	If you enjoyed the electronic edition of Little Brother and you want to\n	donate something to say thanks, \n	<a href=\"http://craphound.com/littlebrother/donate/\">go here</a> \n	and find a teacher or librarian you want to support. Then go to Amazon, \n	BN.com, or your favorite electronic bookseller and order a copy to the\n	classroom, then email a copy of the receipt (feel free to delete your\n	address and other personal info first!) to\n	<a href=\"mailto:freelittlebrother@gmail.com\">freelittlebrother@gmail.com</a> \n	so that Olga can mark that copy as sent. If you don\'t want to be publicly \n	acknowledged for your generosity, let us know and we\'ll keep you \n	anonymous, otherwise we\'ll thank you on the donate page.\n</p>\n\n<p>	I have no idea if this will end up with hundreds, dozens or just a few\n	copies going out -- but I have high hopes!\n</p>\n','2014-09-21 04:36:16');
/*!40000 ALTER TABLE `newsletter_element` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `newsletter_template`
--

DROP TABLE IF EXISTS `newsletter_template`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `newsletter_template` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `filename` varchar(100) NOT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `newsletter_template`
--

LOCK TABLES `newsletter_template` WRITE;
/*!40000 ALTER TABLE `newsletter_template` DISABLE KEYS */;
INSERT INTO `newsletter_template` VALUES (1,'Example newsletter template','example.tt','2014-09-21 04:36:16');
/*!40000 ALTER TABLE `newsletter_template` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `newsletter_template_element`
--

DROP TABLE IF EXISTS `newsletter_template_element`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `newsletter_template_element` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `template` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `type` varchar(20) NOT NULL DEFAULT 'Short Text',
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `newsletter_template_element_idx_template` (`template`),
  CONSTRAINT `newsletter_template_element_fk_template` FOREIGN KEY (`template`) REFERENCES `newsletter_template` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `newsletter_template_element`
--

LOCK TABLES `newsletter_template_element` WRITE;
/*!40000 ALTER TABLE `newsletter_template_element` DISABLE KEYS */;
INSERT INTO `newsletter_template_element` VALUES (1,1,'body','HTML','2014-09-21 04:36:16');
/*!40000 ALTER TABLE `newsletter_template_element` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order`
--

DROP TABLE IF EXISTS `order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `order` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `session` char(72) DEFAULT NULL,
  `user` int(11) DEFAULT NULL,
  `email` varchar(250) NOT NULL,
  `telephone` varchar(20) DEFAULT NULL,
  `billing_address` text NOT NULL,
  `billing_town` varchar(100) NOT NULL,
  `billing_county` varchar(50) DEFAULT NULL,
  `billing_country` varchar(50) NOT NULL,
  `billing_postcode` varchar(10) NOT NULL,
  `delivery_address` text,
  `delivery_town` varchar(100) DEFAULT NULL,
  `delivery_county` varchar(50) DEFAULT NULL,
  `delivery_country` varchar(50) DEFAULT NULL,
  `delivery_postcode` varchar(10) DEFAULT NULL,
  `status` varchar(50) NOT NULL DEFAULT 'Checkout incomplete',
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated` datetime DEFAULT NULL,
  `despatched` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `order_idx_session` (`session`),
  KEY `order_idx_user` (`user`),
  CONSTRAINT `order_fk_session` FOREIGN KEY (`session`) REFERENCES `session` (`id`),
  CONSTRAINT `order_fk_user` FOREIGN KEY (`user`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order`
--

LOCK TABLES `order` WRITE;
/*!40000 ALTER TABLE `order` DISABLE KEYS */;
/*!40000 ALTER TABLE `order` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_item`
--

DROP TABLE IF EXISTS `order_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `order_item` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `order` int(11) NOT NULL,
  `item` int(11) NOT NULL,
  `quantity` int(11) NOT NULL DEFAULT '1',
  `unit_price` decimal(9,2) NOT NULL DEFAULT '0.00',
  `postage` int(11) DEFAULT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `order_item_idx_item` (`item`),
  KEY `order_item_idx_order` (`order`),
  KEY `order_item_idx_postage` (`postage`),
  CONSTRAINT `order_item_fk_item` FOREIGN KEY (`item`) REFERENCES `shop_item` (`id`),
  CONSTRAINT `order_item_fk_order` FOREIGN KEY (`order`) REFERENCES `order` (`id`),
  CONSTRAINT `order_item_fk_postage` FOREIGN KEY (`postage`) REFERENCES `postage_option` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_item`
--

LOCK TABLES `order_item` WRITE;
/*!40000 ALTER TABLE `order_item` DISABLE KEYS */;
/*!40000 ALTER TABLE `order_item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_item_attribute`
--

DROP TABLE IF EXISTS `order_item_attribute`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `order_item_attribute` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `item` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `value` text NOT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `order_item_attribute_idx_item` (`item`),
  CONSTRAINT `order_item_attribute_fk_item` FOREIGN KEY (`item`) REFERENCES `order_item` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_item_attribute`
--

LOCK TABLES `order_item_attribute` WRITE;
/*!40000 ALTER TABLE `order_item_attribute` DISABLE KEYS */;
/*!40000 ALTER TABLE `order_item_attribute` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `paid_list`
--

DROP TABLE IF EXISTS `paid_list`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `paid_list` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `url_name` varchar(100) NOT NULL,
  `description` text,
  `mailing_list` int(11) DEFAULT NULL,
  `has_captcha` tinyint(4) DEFAULT '0',
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `paid_list`
--

LOCK TABLES `paid_list` WRITE;
/*!40000 ALTER TABLE `paid_list` DISABLE KEYS */;
/*!40000 ALTER TABLE `paid_list` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `paid_list_email`
--

DROP TABLE IF EXISTS `paid_list_email`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `paid_list_email` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `paid_list` int(11) NOT NULL,
  `subject` varchar(100) NOT NULL,
  `template` int(11) NOT NULL,
  `delay` int(11) NOT NULL,
  `plaintext` text,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `paid_list_email_idx_paid_list` (`paid_list`),
  KEY `paid_list_email_idx_template` (`template`),
  CONSTRAINT `paid_list_email_fk_paid_list` FOREIGN KEY (`paid_list`) REFERENCES `paid_list` (`id`),
  CONSTRAINT `paid_list_email_fk_template` FOREIGN KEY (`template`) REFERENCES `newsletter_template` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `paid_list_email`
--

LOCK TABLES `paid_list_email` WRITE;
/*!40000 ALTER TABLE `paid_list_email` DISABLE KEYS */;
/*!40000 ALTER TABLE `paid_list_email` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `paid_list_email_element`
--

DROP TABLE IF EXISTS `paid_list_email_element`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `paid_list_email_element` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `type` varchar(20) NOT NULL DEFAULT 'Short Text',
  `content` text,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `paid_list_email_element_idx_email` (`email`),
  CONSTRAINT `paid_list_email_element_fk_email` FOREIGN KEY (`email`) REFERENCES `paid_list_email` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `paid_list_email_element`
--

LOCK TABLES `paid_list_email_element` WRITE;
/*!40000 ALTER TABLE `paid_list_email_element` DISABLE KEYS */;
/*!40000 ALTER TABLE `paid_list_email_element` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `poll_anon_vote`
--

DROP TABLE IF EXISTS `poll_anon_vote`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `poll_anon_vote` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `question` int(11) NOT NULL,
  `answer` int(11) NOT NULL,
  `ip_address` varchar(15) NOT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `poll_anon_vote_idx_answer` (`answer`),
  KEY `poll_anon_vote_idx_question` (`question`),
  CONSTRAINT `poll_anon_vote_fk_answer` FOREIGN KEY (`answer`) REFERENCES `poll_answer` (`id`),
  CONSTRAINT `poll_anon_vote_fk_question` FOREIGN KEY (`question`) REFERENCES `poll_question` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `poll_anon_vote`
--

LOCK TABLES `poll_anon_vote` WRITE;
/*!40000 ALTER TABLE `poll_anon_vote` DISABLE KEYS */;
/*!40000 ALTER TABLE `poll_anon_vote` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `poll_answer`
--

DROP TABLE IF EXISTS `poll_answer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `poll_answer` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `question` int(11) NOT NULL,
  `answer` varchar(100) NOT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `poll_answer_idx_question` (`question`),
  CONSTRAINT `poll_answer_fk_question` FOREIGN KEY (`question`) REFERENCES `poll_question` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `poll_answer`
--

LOCK TABLES `poll_answer` WRITE;
/*!40000 ALTER TABLE `poll_answer` DISABLE KEYS */;
INSERT INTO `poll_answer` VALUES (1,1,'Here','2014-09-21 04:36:24'),(2,1,'There','2014-09-21 04:36:24');
/*!40000 ALTER TABLE `poll_answer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `poll_question`
--

DROP TABLE IF EXISTS `poll_question`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `poll_question` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `question` varchar(100) NOT NULL,
  `hidden` tinyint(4) NOT NULL DEFAULT '0',
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `poll_question`
--

LOCK TABLES `poll_question` WRITE;
/*!40000 ALTER TABLE `poll_question` DISABLE KEYS */;
INSERT INTO `poll_question` VALUES (1,'Poll goes where?',0,'2014-09-21 04:36:24');
/*!40000 ALTER TABLE `poll_question` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `poll_user_vote`
--

DROP TABLE IF EXISTS `poll_user_vote`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `poll_user_vote` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `question` int(11) NOT NULL,
  `answer` int(11) NOT NULL,
  `user` int(11) NOT NULL,
  `ip_address` varchar(15) NOT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `poll_user_vote_idx_answer` (`answer`),
  KEY `poll_user_vote_idx_question` (`question`),
  KEY `poll_user_vote_idx_user` (`user`),
  CONSTRAINT `poll_user_vote_fk_answer` FOREIGN KEY (`answer`) REFERENCES `poll_answer` (`id`),
  CONSTRAINT `poll_user_vote_fk_question` FOREIGN KEY (`question`) REFERENCES `poll_question` (`id`),
  CONSTRAINT `poll_user_vote_fk_user` FOREIGN KEY (`user`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `poll_user_vote`
--

LOCK TABLES `poll_user_vote` WRITE;
/*!40000 ALTER TABLE `poll_user_vote` DISABLE KEYS */;
/*!40000 ALTER TABLE `poll_user_vote` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `postage_option`
--

DROP TABLE IF EXISTS `postage_option`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `postage_option` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `price` decimal(9,2) NOT NULL DEFAULT '0.00',
  `description` text,
  `hidden` tinyint(4) NOT NULL DEFAULT '0',
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `postage_option`
--

LOCK TABLES `postage_option` WRITE;
/*!40000 ALTER TABLE `postage_option` DISABLE KEYS */;
INSERT INTO `postage_option` VALUES (1,'Standard',2.22,NULL,0,'2014-09-21 04:36:10'),(2,'Special',3.33,NULL,0,'2014-09-21 04:36:10'),(3,'Gold',5.55,NULL,0,'2014-09-21 04:36:10');
/*!40000 ALTER TABLE `postage_option` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `queued_email`
--

DROP TABLE IF EXISTS `queued_email`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `queued_email` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` int(11) NOT NULL,
  `recipient` int(11) NOT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `send` datetime NOT NULL,
  `status` varchar(20) NOT NULL DEFAULT 'Not sent',
  PRIMARY KEY (`id`),
  KEY `queued_email_idx_email` (`email`),
  KEY `queued_email_idx_recipient` (`recipient`),
  CONSTRAINT `queued_email_fk_email` FOREIGN KEY (`email`) REFERENCES `autoresponder_email` (`id`),
  CONSTRAINT `queued_email_fk_recipient` FOREIGN KEY (`recipient`) REFERENCES `mail_recipient` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `queued_email`
--

LOCK TABLES `queued_email` WRITE;
/*!40000 ALTER TABLE `queued_email` DISABLE KEYS */;
/*!40000 ALTER TABLE `queued_email` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `queued_paid_email`
--

DROP TABLE IF EXISTS `queued_paid_email`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `queued_paid_email` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` int(11) NOT NULL,
  `recipient` int(11) NOT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `send` datetime NOT NULL,
  `status` varchar(20) NOT NULL DEFAULT 'Not sent',
  PRIMARY KEY (`id`),
  KEY `queued_paid_email_idx_email` (`email`),
  KEY `queued_paid_email_idx_recipient` (`recipient`),
  CONSTRAINT `queued_paid_email_fk_email` FOREIGN KEY (`email`) REFERENCES `paid_list_email` (`id`),
  CONSTRAINT `queued_paid_email_fk_recipient` FOREIGN KEY (`recipient`) REFERENCES `mail_recipient` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `queued_paid_email`
--

LOCK TABLES `queued_paid_email` WRITE;
/*!40000 ALTER TABLE `queued_paid_email` DISABLE KEYS */;
/*!40000 ALTER TABLE `queued_paid_email` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `role`
--

DROP TABLE IF EXISTS `role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `role` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `role` varchar(50) NOT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `role`
--

LOCK TABLES `role` WRITE;
/*!40000 ALTER TABLE `role` DISABLE KEYS */;
INSERT INTO `role` VALUES (1,'CMS Page Editor','2014-09-21 04:35:31'),(2,'CMS Page Admin','2014-09-21 04:35:31'),(3,'CMS Template Admin','2014-09-21 04:35:31'),(4,'CMS Form Admin','2014-09-21 04:35:31'),(5,'Shared Content Editor','2014-09-21 04:35:31'),(6,'File Admin','2014-09-21 04:35:31'),(7,'News Admin','2014-09-21 04:35:31'),(8,'Blog Author','2014-09-21 04:35:31'),(9,'Blog Admin','2014-09-21 04:35:31'),(10,'Forums Admin','2014-09-21 04:35:31'),(11,'Comment Moderator','2014-09-21 04:35:31'),(12,'Poll Admin','2014-09-21 04:35:31'),(13,'Events Admin','2014-09-21 04:35:31'),(14,'Shop Admin','2014-09-21 04:35:31'),(15,'Newsletter Admin','2014-09-21 04:35:31'),(16,'Newsletter Template Admin','2014-09-21 04:35:31'),(17,'User Admin','2014-09-21 04:35:31');
/*!40000 ALTER TABLE `role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `session`
--

DROP TABLE IF EXISTS `session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `session` (
  `id` char(72) NOT NULL DEFAULT '',
  `session_data` text,
  `expires` int(11) DEFAULT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `session`
--

LOCK TABLES `session` WRITE;
/*!40000 ALTER TABLE `session` DISABLE KEYS */;
INSERT INTO `session` VALUES ('session:3bbf44798d7fa76fb443bc6180880d3fbe6a1a34','BQkDAAAABAlUHo2XAAAACV9fdXBkYXRlZAQDAAAAEgUAAAAIbG9jYXRpb24KB0RlZmF1bHQAAAAJ\nZmlyc3RuYW1lCgVhZG1pbgAAAAh1c2VybmFtZQUAAAADYmlvCr9UaGlzIGlzIHRoZSBkZWZhdWx0\nIGFkbWluIHVzZXIgYWNjb3VudC4gIFBsZWFzZSBlaXRoZXIgcmVtb3ZlIGl0IGJlZm9yZSBwdXR0\naW5nIHlvdXIgc2l0ZSBvbmxpbmUsIG9yIGF0IGxlYXN0IG1ha2Ugc3VyZSB0aGF0IHlvdSBjaGFu\nZ2UgdGhlIHBhc3N3b3JkIC0gYW5kIHByZWZlcmFibHksIGNoYW5nZSB0aGUgdXNlcm5hbWUgdG9v\nIQAAAAthZG1pbl9ub3RlcwpKZmJjN2YwMzA0ZjE2YzM5ZTdiMmFlYTM2ZjBjYjI1NTgxMmY3ODEw\nYjUyYjNkMzMxMjlmNGZkNzNkOWQzMDBiMG5Bd0J4VUt2ajYAAAAIcGFzc3dvcmQFAAAADWRpc3Bs\nYXlfZW1haWwFAAAAC3Byb2ZpbGVfcGljBQAAAAhwb3N0Y29kZQoFQWRtaW4AAAAHc3VybmFtZQoT\nMjAxNC0wOS0yMSAwMDozNTozMQAAAAdjcmVhdGVkBQAAAApkaXNjdXNzaW9uCgExAAAAAmlkBQAA\nAAd3ZWJzaXRlChRjaGFuZ2VtZUBleGFtcGxlLmNvbQAAAAVlbWFpbAoBMQAAAAZhY3RpdmUKBUFk\nbWluAAAADGRpc3BsYXlfbmFtZQoBMAAAAA9mb3Jnb3RfcGFzc3dvcmQAAAAGX191c2VyCgdkZWZh\ndWx0AAAADF9fdXNlcl9yZWFsbQlUHoyYAAAACV9fY3JlYXRlZA==\n',1411333103,'2014-09-21 08:30:16'),('session:60040170068e679def89e790f0050c710127a3bb','BQkDAAAAAglUHlZ+AAAACV9fY3JlYXRlZAlUHlZ+AAAACV9fdXBkYXRlZA==\n',1411317566,'2014-09-21 04:39:26');
/*!40000 ALTER TABLE `session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `shared_content`
--

DROP TABLE IF EXISTS `shared_content`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `shared_content` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `type` varchar(20) NOT NULL DEFAULT 'Short Text',
  `content` text,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `shared_content`
--

LOCK TABLES `shared_content` WRITE;
/*!40000 ALTER TABLE `shared_content` DISABLE KEYS */;
INSERT INTO `shared_content` VALUES (1,'site_tagline','Short Text','Clean and simple content management.','2014-09-21 04:35:42'),(2,'powered_by','Long Text','Powered by <a href=\"http://shinycms.org/\">ShinyCMS</a>','2014-09-21 04:35:42');
/*!40000 ALTER TABLE `shared_content` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `shop_category`
--

DROP TABLE IF EXISTS `shop_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `shop_category` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parent` int(11) DEFAULT NULL,
  `name` varchar(100) NOT NULL,
  `url_name` varchar(100) NOT NULL,
  `description` text,
  `hidden` tinyint(4) NOT NULL DEFAULT '0',
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `shop_category_url_name` (`url_name`),
  KEY `shop_category_idx_parent` (`parent`),
  CONSTRAINT `shop_category_fk_parent` FOREIGN KEY (`parent`) REFERENCES `shop_category` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `shop_category`
--

LOCK TABLES `shop_category` WRITE;
/*!40000 ALTER TABLE `shop_category` DISABLE KEYS */;
INSERT INTO `shop_category` VALUES (1,NULL,'Widgets','widgets','This is the widgets section.',0,'2014-09-21 04:36:09'),(2,NULL,'Doodahs','doodahs','This is the doodahs section.',0,'2014-09-21 04:36:09'),(3,1,'Ambidextrous Widgets','ambi-widgets','This is the section for ambidextrous widgets.',0,'2014-09-21 04:36:09');
/*!40000 ALTER TABLE `shop_category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `shop_item`
--

DROP TABLE IF EXISTS `shop_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `shop_item` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `product_type` int(11) NOT NULL,
  `name` varchar(200) NOT NULL,
  `code` varchar(100) NOT NULL,
  `description` text,
  `image` varchar(200) DEFAULT NULL,
  `price` decimal(9,2) DEFAULT NULL,
  `stock` int(11) DEFAULT NULL,
  `restock_date` datetime DEFAULT NULL,
  `hidden` tinyint(4) NOT NULL DEFAULT '0',
  `added` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated` datetime DEFAULT NULL,
  `discussion` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `shop_item_product_code` (`code`),
  KEY `shop_item_idx_discussion` (`discussion`),
  KEY `shop_item_idx_product_type` (`product_type`),
  CONSTRAINT `shop_item_fk_discussion` FOREIGN KEY (`discussion`) REFERENCES `discussion` (`id`),
  CONSTRAINT `shop_item_fk_product_type` FOREIGN KEY (`product_type`) REFERENCES `shop_product_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `shop_item`
--

LOCK TABLES `shop_item` WRITE;
/*!40000 ALTER TABLE `shop_item` DISABLE KEYS */;
INSERT INTO `shop_item` VALUES (1,1,'Blue left-handed widget','blue-lh-widget','A blue widget, suitable for left-handed applications.','blue-dog.jpg',3.14,NULL,NULL,0,'2014-09-21 04:36:10',NULL,14),(2,2,'Red right-handed widget','red-rh-widget','A red widget, suitable for right-handed applications.','redphanatic.jpg',2.72,NULL,NULL,0,'2014-09-21 04:36:10',NULL,15),(3,1,'Green ambidextrous widget','green-ambi-widget','A green widget; swings both ways.','razer.jpg',1.23,NULL,NULL,0,'2014-09-21 04:36:10',NULL,16),(4,3,'Green T-shirt','green-t-shirt','T-shirt with green design.','razer.jpg',5.15,NULL,NULL,0,'2014-09-21 04:36:11',NULL,NULL);
/*!40000 ALTER TABLE `shop_item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `shop_item_category`
--

DROP TABLE IF EXISTS `shop_item_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `shop_item_category` (
  `item` int(11) NOT NULL,
  `category` int(11) NOT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`item`,`category`),
  KEY `shop_item_category_idx_category` (`category`),
  KEY `shop_item_category_idx_item` (`item`),
  CONSTRAINT `shop_item_category_fk_category` FOREIGN KEY (`category`) REFERENCES `shop_category` (`id`),
  CONSTRAINT `shop_item_category_fk_item` FOREIGN KEY (`item`) REFERENCES `shop_item` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `shop_item_category`
--

LOCK TABLES `shop_item_category` WRITE;
/*!40000 ALTER TABLE `shop_item_category` DISABLE KEYS */;
INSERT INTO `shop_item_category` VALUES (1,1,'2014-09-21 04:36:11'),(2,1,'2014-09-21 04:36:11'),(3,1,'2014-09-21 04:36:11'),(3,3,'2014-09-21 04:36:11');
/*!40000 ALTER TABLE `shop_item_category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `shop_item_element`
--

DROP TABLE IF EXISTS `shop_item_element`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `shop_item_element` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `item` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `type` varchar(20) NOT NULL DEFAULT 'Short Text',
  `content` text,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `shop_item_element_idx_item` (`item`),
  CONSTRAINT `shop_item_element_fk_item` FOREIGN KEY (`item`) REFERENCES `shop_item` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `shop_item_element`
--

LOCK TABLES `shop_item_element` WRITE;
/*!40000 ALTER TABLE `shop_item_element` DISABLE KEYS */;
INSERT INTO `shop_item_element` VALUES (1,1,'paypal_button','Long Text','<form target=\"paypal\" action=\"https://www.paypal.com/cgi-bin/webscr\" method=\"post\">\n<input type=\"hidden\" name=\"cmd\" value=\"_s-xclick\">\n<input type=\"hidden\" name=\"hosted_button_id\" value=\"8299526\">\n<input type=\"image\" src=\"https://www.paypal.com/en_GB/i/btn/btn_cart_LG.gif\" border=\"0\" name=\"submit\" alt=\"PayPal - The safer, easier way to pay online.\">\n<img alt=\"\" border=\"0\" src=\"https://www.paypal.com/en_GB/i/scr/pixel.gif\" width=\"1\" height=\"1\">\n</form>\n','2014-09-21 04:36:10'),(2,2,'paypal_button','Long Text','<form target=\"paypal\" action=\"https://www.paypal.com/cgi-bin/webscr\" method=\"post\">\n<input type=\"hidden\" name=\"cmd\" value=\"_s-xclick\">\n<input type=\"hidden\" name=\"hosted_button_id\" value=\"8299566\">\n<input type=\"image\" src=\"https://www.paypal.com/en_GB/i/btn/btn_cart_LG.gif\" border=\"0\" name=\"submit\" alt=\"PayPal - The safer, easier way to pay online.\">\n<img alt=\"\" border=\"0\" src=\"https://www.paypal.com/en_GB/i/scr/pixel.gif\" width=\"1\" height=\"1\">\n</form>\n','2014-09-21 04:36:10'),(3,4,'sizes','Short Text','Small,Medium,Large','2014-09-21 04:36:11'),(4,4,'colours','Short Text','Black,Blacker,Blackest','2014-09-21 04:36:11');
/*!40000 ALTER TABLE `shop_item_element` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `shop_item_like`
--

DROP TABLE IF EXISTS `shop_item_like`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `shop_item_like` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `item` int(11) NOT NULL,
  `user` int(11) DEFAULT NULL,
  `ip_address` varchar(15) NOT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `shop_item_like_idx_item` (`item`),
  KEY `shop_item_like_idx_user` (`user`),
  CONSTRAINT `shop_item_like_fk_item` FOREIGN KEY (`item`) REFERENCES `shop_item` (`id`),
  CONSTRAINT `shop_item_like_fk_user` FOREIGN KEY (`user`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `shop_item_like`
--

LOCK TABLES `shop_item_like` WRITE;
/*!40000 ALTER TABLE `shop_item_like` DISABLE KEYS */;
/*!40000 ALTER TABLE `shop_item_like` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `shop_item_postage_option`
--

DROP TABLE IF EXISTS `shop_item_postage_option`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `shop_item_postage_option` (
  `item` int(11) NOT NULL,
  `postage` int(11) NOT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`item`,`postage`),
  KEY `shop_item_postage_option_idx_item` (`item`),
  KEY `shop_item_postage_option_idx_postage` (`postage`),
  CONSTRAINT `shop_item_postage_option_fk_item` FOREIGN KEY (`item`) REFERENCES `shop_item` (`id`),
  CONSTRAINT `shop_item_postage_option_fk_postage` FOREIGN KEY (`postage`) REFERENCES `postage_option` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `shop_item_postage_option`
--

LOCK TABLES `shop_item_postage_option` WRITE;
/*!40000 ALTER TABLE `shop_item_postage_option` DISABLE KEYS */;
INSERT INTO `shop_item_postage_option` VALUES (1,1,'2014-09-21 04:36:10'),(1,2,'2014-09-21 04:36:10'),(1,3,'2014-09-21 04:36:10'),(2,1,'2014-09-21 04:36:10'),(2,2,'2014-09-21 04:36:10'),(2,3,'2014-09-21 04:36:10'),(3,1,'2014-09-21 04:36:10'),(3,2,'2014-09-21 04:36:10'),(3,3,'2014-09-21 04:36:11'),(4,2,'2014-09-21 04:36:11'),(4,3,'2014-09-21 04:36:11');
/*!40000 ALTER TABLE `shop_item_postage_option` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `shop_product_type`
--

DROP TABLE IF EXISTS `shop_product_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `shop_product_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `template_file` varchar(100) NOT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `shop_product_type`
--

LOCK TABLES `shop_product_type` WRITE;
/*!40000 ALTER TABLE `shop_product_type` DISABLE KEYS */;
INSERT INTO `shop_product_type` VALUES (1,'Standard','standard.tt','2014-09-21 04:36:09'),(2,'Paypal','paypal.tt','2014-09-21 04:36:09'),(3,'T-shirt','t-shirt.tt','2014-09-21 04:36:09');
/*!40000 ALTER TABLE `shop_product_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `shop_product_type_element`
--

DROP TABLE IF EXISTS `shop_product_type_element`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `shop_product_type_element` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `product_type` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `type` varchar(20) NOT NULL DEFAULT 'Short Text',
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `shop_product_type_element_idx_product_type` (`product_type`),
  CONSTRAINT `shop_product_type_element_fk_product_type` FOREIGN KEY (`product_type`) REFERENCES `shop_product_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `shop_product_type_element`
--

LOCK TABLES `shop_product_type_element` WRITE;
/*!40000 ALTER TABLE `shop_product_type_element` DISABLE KEYS */;
INSERT INTO `shop_product_type_element` VALUES (1,2,'paypal_button','Long Text','2014-09-21 04:36:09'),(2,3,'sizes','Short Text','2014-09-21 04:36:09'),(3,3,'colours','Short Text','2014-09-21 04:36:09');
/*!40000 ALTER TABLE `shop_product_type_element` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `subscription`
--

DROP TABLE IF EXISTS `subscription`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `subscription` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `list` int(11) NOT NULL,
  `recipient` int(11) NOT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `subscription_idx_list` (`list`),
  KEY `subscription_idx_recipient` (`recipient`),
  CONSTRAINT `subscription_fk_list` FOREIGN KEY (`list`) REFERENCES `mailing_list` (`id`),
  CONSTRAINT `subscription_fk_recipient` FOREIGN KEY (`recipient`) REFERENCES `mail_recipient` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `subscription`
--

LOCK TABLES `subscription` WRITE;
/*!40000 ALTER TABLE `subscription` DISABLE KEYS */;
INSERT INTO `subscription` VALUES (1,1,1,'2014-09-21 04:36:15'),(2,1,2,'2014-09-21 04:36:15'),(3,1,3,'2014-09-21 04:36:15'),(4,2,4,'2014-09-21 04:36:15');
/*!40000 ALTER TABLE `subscription` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tag`
--

DROP TABLE IF EXISTS `tag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tag` (
  `tag` varchar(50) NOT NULL,
  `tagset` int(11) NOT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`tag`,`tagset`),
  KEY `tag_idx_tagset` (`tagset`),
  CONSTRAINT `tag_fk_tagset` FOREIGN KEY (`tagset`) REFERENCES `tagset` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tag`
--

LOCK TABLES `tag` WRITE;
/*!40000 ALTER TABLE `tag` DISABLE KEYS */;
INSERT INTO `tag` VALUES ('armed forces',6,'2014-09-21 04:35:57'),('cell',8,'2014-09-21 04:35:58'),('crowds',4,'2014-09-21 04:35:56'),('explosions',3,'2014-09-21 04:35:56'),('interview',7,'2014-09-21 04:35:57'),('interview',9,'2014-09-21 04:35:58'),('interview',10,'2014-09-21 04:35:58'),('interview',11,'2014-09-21 04:35:59'),('interview',12,'2014-09-21 04:35:59'),('paperwork',12,'2014-09-21 04:35:59'),('phone',7,'2014-09-21 04:35:57'),('phone',10,'2014-09-21 04:35:58'),('prison',8,'2014-09-21 04:35:58'),('prison',9,'2014-09-21 04:35:58'),('school',1,'2014-09-21 04:35:56'),('school',2,'2014-09-21 04:35:56'),('sirens',3,'2014-09-21 04:35:56'),('surveillance',2,'2014-09-21 04:35:56'),('terrorism',5,'2014-09-21 04:35:57'),('terrorism',7,'2014-09-21 04:35:57'),('test',14,'2014-09-21 04:36:05'),('toilet break',6,'2014-09-21 04:35:57'),('truck',6,'2014-09-21 04:35:57'),('truck',7,'2014-09-21 04:35:57'),('truck',13,'2014-09-21 04:35:59'),('USA',6,'2014-09-21 04:35:57'),('yard',11,'2014-09-21 04:35:59');
/*!40000 ALTER TABLE `tag` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tagset`
--

DROP TABLE IF EXISTS `tagset`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tagset` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `resource_id` int(11) NOT NULL,
  `resource_type` varchar(50) NOT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tagset`
--

LOCK TABLES `tagset` WRITE;
/*!40000 ALTER TABLE `tagset` DISABLE KEYS */;
INSERT INTO `tagset` VALUES (1,1,'BlogPost','2014-09-21 04:35:55'),(2,2,'BlogPost','2014-09-21 04:35:56'),(3,3,'BlogPost','2014-09-21 04:35:56'),(4,4,'BlogPost','2014-09-21 04:35:56'),(5,5,'BlogPost','2014-09-21 04:35:57'),(6,6,'BlogPost','2014-09-21 04:35:57'),(7,7,'BlogPost','2014-09-21 04:35:57'),(8,8,'BlogPost','2014-09-21 04:35:57'),(9,9,'BlogPost','2014-09-21 04:35:58'),(10,10,'BlogPost','2014-09-21 04:35:58'),(11,11,'BlogPost','2014-09-21 04:35:59'),(12,12,'BlogPost','2014-09-21 04:35:59'),(13,13,'BlogPost','2014-09-21 04:35:59'),(14,1,'ForumPost','2014-09-21 04:36:05');
/*!40000 ALTER TABLE `tagset` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `transaction_log`
--

DROP TABLE IF EXISTS `transaction_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `transaction_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `logged` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `status` varchar(20) NOT NULL,
  `notes` text,
  `user` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `transaction_log_idx_user` (`user`),
  CONSTRAINT `transaction_log_fk_user` FOREIGN KEY (`user`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `transaction_log`
--

LOCK TABLES `transaction_log` WRITE;
/*!40000 ALTER TABLE `transaction_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `transaction_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_access`
--

DROP TABLE IF EXISTS `user_access`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_access` (
  `user` int(11) NOT NULL,
  `access` int(11) NOT NULL,
  `subscription_id` varchar(50) DEFAULT NULL,
  `expires` datetime DEFAULT NULL,
  `recurring` int(11) DEFAULT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`user`,`access`),
  KEY `user_access_idx_access` (`access`),
  KEY `user_access_idx_user` (`user`),
  CONSTRAINT `user_access_fk_access` FOREIGN KEY (`access`) REFERENCES `access` (`id`),
  CONSTRAINT `user_access_fk_user` FOREIGN KEY (`user`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_access`
--

LOCK TABLES `user_access` WRITE;
/*!40000 ALTER TABLE `user_access` DISABLE KEYS */;
INSERT INTO `user_access` VALUES (1,1,NULL,NULL,NULL,'2014-09-21 04:35:46');
/*!40000 ALTER TABLE `user_access` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_role`
--

DROP TABLE IF EXISTS `user_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_role` (
  `user` int(11) NOT NULL,
  `role` int(11) NOT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`user`,`role`),
  KEY `user_role_idx_role` (`role`),
  KEY `user_role_idx_user` (`user`),
  CONSTRAINT `user_role_fk_role` FOREIGN KEY (`role`) REFERENCES `role` (`id`),
  CONSTRAINT `user_role_fk_user` FOREIGN KEY (`user`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_role`
--

LOCK TABLES `user_role` WRITE;
/*!40000 ALTER TABLE `user_role` DISABLE KEYS */;
INSERT INTO `user_role` VALUES (1,1,'2014-09-21 04:35:31'),(1,2,'2014-09-21 04:35:31'),(1,3,'2014-09-21 04:35:31'),(1,4,'2014-09-21 04:35:31'),(1,5,'2014-09-21 04:35:32'),(1,6,'2014-09-21 04:35:32'),(1,7,'2014-09-21 04:35:32'),(1,8,'2014-09-21 04:35:32'),(1,9,'2014-09-21 04:35:32'),(1,10,'2014-09-21 04:35:32'),(1,11,'2014-09-21 04:35:32'),(1,12,'2014-09-21 04:35:32'),(1,13,'2014-09-21 04:35:32'),(1,14,'2014-09-21 04:35:32'),(1,15,'2014-09-21 04:35:32'),(1,16,'2014-09-21 04:35:32'),(1,17,'2014-09-21 04:35:32'),(2,7,'2014-09-21 04:35:50'),(3,8,'2014-09-21 04:35:54');
/*!40000 ALTER TABLE `user_role` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2014-09-21  5:14:44
