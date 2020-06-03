DROP TABLE IF EXISTS `Posts_Feeds`;
DROP TABLE IF EXISTS `ContentFeeds`;
DROP TABLE IF EXISTS `Comments`;
DROP TABLE IF EXISTS `Posts`;
DROP TABLE IF EXISTS `Users`;


CREATE TABLE `Users` (
  `userID` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(255) NOT NULL UNIQUE,
  `password` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  PRIMARY KEY (`userID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `Posts` (
  `postID` int(11) NOT NULL AUTO_INCREMENT,
  `userID` int(11) NOT NULL,
  `timeCreated` datetime NOT NULL DEFAULT(sysdate()),
  `sound` nvarchar(260) NOT NULL,
  `graphic` nvarchar(260) NOT NULL,
  `tags` varchar(255),
  `embedPostID` int(11) DEFAULT NULL,
  `title` varchar(255) NOT NULL,
  `description` text,
  PRIMARY KEY (`postID`),
  INDEX (`userID`),
  FOREIGN KEY (`userID`) REFERENCES `Users`(`userID`) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `Comments` (
  `commentID` int(11) NOT NULL AUTO_INCREMENT,
  `postID` int(11) NOT NULL,
  `userID` int(11),
  `text` varchar(255) NOT NULL,
  PRIMARY KEY (`commentID`),
  INDEX (`userID`),
  INDEX (`postID`),
  FOREIGN KEY (`userID`) REFERENCES `Users`(`userID`) ON UPDATE CASCADE ON DELETE SET NULL,
  FOREIGN KEY (`postID`) REFERENCES `Posts`(`postID`) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `ContentFeeds` (
  `feedID` int(11) NOT NULL AUTO_INCREMENT,
  `userID` int(11) NOT NULL,
  `interests` varchar(255),
  PRIMARY KEY (`feedID`),
  INDEX (`userID`),
  FOREIGN KEY (`userID`) REFERENCES `Users`(`userID`) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `Posts_Feeds` (
  `postID` int(11) NOT NULL,
  `feedID` int(11) NOT NULL,
  PRIMARY KEY (`postID`, `feedID`),
  FOREIGN KEY (`feedID`) REFERENCES `ContentFeeds`(`feedID`) ON UPDATE CASCADE ON DELETE CASCADE,
  FOREIGN KEY (`postID`) REFERENCES `Posts`(`postID`) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



INSERT INTO Users(username, password, email) VALUES
    ('Emma','12345','edgardo.greenfelder@kohler.com'),
    ('Olivia','123456','ibartell@hotmail.com'),
    ('Ava','123456789','max.walter@gutkowski.org'),
    ('Isabella','test1','sophia32@hotmail.com'),
    ('Sophia','password','osinski.sage@bahringer.com'),
    ('Charlotte','12345678','rosalia.gulgowski@ritchie.com'),
    ('Mia','zinch','zgottlieb@frami.com'),
    ('Amelia','g_czechout','hoeger.deanna@turner.biz'),
    ('Harper','asdf','afay@schamberger.org'),
    ('Evelyn','qwerty','brown.bell@hotmail.com');


INSERT INTO Posts(userID, sound, graphic, title) VALUES
    (6,'https://www.computerhope.com/jargon/m/example.mp3','https://cdn.mos.cms.futurecdn.net/rqoDpnCCrdpGFHM6qky3rS-970-80.jpg','1. Sugar, Sugar - The Archies'),
    (7,'https://www.computerhope.com/jargon/m/example.mp3','https://cdn.mos.cms.futurecdn.net/rqoDpnCCrdpGFHM6qky3rS-970-80.jpg','2. Aquarius / Let the Sunshine In - The Fifth Dimension'),
    (8,'https://www.computerhope.com/jargon/m/example.mp3','https://cdn.mos.cms.futurecdn.net/rqoDpnCCrdpGFHM6qky3rS-970-80.jpg','3. I Can''t Get Next to You - The Temptations'),
    (3,'https://www.computerhope.com/jargon/m/example.mp3','https://cdn.mos.cms.futurecdn.net/rqoDpnCCrdpGFHM6qky3rS-970-80.jpg','4. Honky Tonk Women - The Rolling Stones'),
    (10,'https://www.computerhope.com/jargon/m/example.mp3','https://cdn.mos.cms.futurecdn.net/rqoDpnCCrdpGFHM6qky3rS-970-80.jpg','5. Everyday People - Sly and The Family Stone'),
    (8,'https://www.computerhope.com/jargon/m/example.mp3','https://cdn.mos.cms.futurecdn.net/rqoDpnCCrdpGFHM6qky3rS-970-80.jpg','6. Dizzy - Tommy Roe'),
    (7,'https://www.computerhope.com/jargon/m/example.mp3','https://cdn.mos.cms.futurecdn.net/rqoDpnCCrdpGFHM6qky3rS-970-80.jpg','7. Hot Fun In the Summertime - Sly and The Family Stone'),
    (7,'https://www.computerhope.com/jargon/m/example.mp3','https://cdn.mos.cms.futurecdn.net/rqoDpnCCrdpGFHM6qky3rS-970-80.jpg','8. (It Looks Like) I''ll Never Fall In Love Again - Tom Jones'),
    (5,'https://www.computerhope.com/jargon/m/example.mp3','https://cdn.mos.cms.futurecdn.net/rqoDpnCCrdpGFHM6qky3rS-970-80.jpg','9. Build Me Up Buttercup - The Foundations'),
    (7,'https://www.computerhope.com/jargon/m/example.mp3','https://cdn.mos.cms.futurecdn.net/rqoDpnCCrdpGFHM6qky3rS-970-80.jpg','10. Crimson and Clover - Tommy James and The Shondells'),
    (8,'https://www.computerhope.com/jargon/m/example.mp3','https://cdn.mos.cms.futurecdn.net/rqoDpnCCrdpGFHM6qky3rS-970-80.jpg','11. One - Three Dog Night'),
    (5,'https://www.computerhope.com/jargon/m/example.mp3','https://cdn.mos.cms.futurecdn.net/rqoDpnCCrdpGFHM6qky3rS-970-80.jpg','12. Crystal Blue Persuasion - Tommy James and The Shondells'),
    (8,'https://www.computerhope.com/jargon/m/example.mp3','https://cdn.mos.cms.futurecdn.net/rqoDpnCCrdpGFHM6qky3rS-970-80.jpg','13. Hair - The Cowsills'),
    (8,'https://www.computerhope.com/jargon/m/example.mp3','https://cdn.mos.cms.futurecdn.net/rqoDpnCCrdpGFHM6qky3rS-970-80.jpg','14. Too Busy Thinking About My Baby - Marvin Gaye'),
    (7,'https://www.computerhope.com/jargon/m/example.mp3','https://cdn.mos.cms.futurecdn.net/rqoDpnCCrdpGFHM6qky3rS-970-80.jpg','15. Love Theme from "Romeo and Juliet" - Henry Mancini and His Orchestra'),
    (5,'https://www.computerhope.com/jargon/m/example.mp3','https://cdn.mos.cms.futurecdn.net/rqoDpnCCrdpGFHM6qky3rS-970-80.jpg','16. Get Together - The Youngbloods'),
    (7,'https://www.computerhope.com/jargon/m/example.mp3','https://cdn.mos.cms.futurecdn.net/rqoDpnCCrdpGFHM6qky3rS-970-80.jpg','17. Grazing In the Grass - The Friends Of Distinction'),
    (3,'https://www.computerhope.com/jargon/m/example.mp3','https://cdn.mos.cms.futurecdn.net/rqoDpnCCrdpGFHM6qky3rS-970-80.jpg','18. Suspicious Minds - Elvis Presley'),
    (8,'https://www.computerhope.com/jargon/m/example.mp3','https://cdn.mos.cms.futurecdn.net/rqoDpnCCrdpGFHM6qky3rS-970-80.jpg','19. Proud Mary - Creedence Clearwater Revival'),
    (4,'https://www.computerhope.com/jargon/m/example.mp3','https://cdn.mos.cms.futurecdn.net/rqoDpnCCrdpGFHM6qky3rS-970-80.jpg','20. What Does It Take (To Win Your Love) - Jr. Walker & The All Stars');

INSERT INTO Comments(postID, userID, text) VALUES
    (5,5,'a'),
    (19,4,'about'),
    (6,3,'all'),
    (3,2,'also'),
    (2,5,'and'),
    (19,4,'as'),
    (17,3,'at'),
    (12,3,'be'),
    (11,3,'because'),
    (7,1,'but'),
    (11,4,'by'),
    (14,9,'can'),
    (9,7,'come'),
    (3,9,'could'),
    (15,1,'day'),
    (17,6,'do'),
    (14,7,'even'),
    (6,8,'find'),
    (16,5,'first'),
    (4,7,'for'),
    (7,5,'from'),
    (10,6,'get'),
    (17,3,'give'),
    (11,4,'go'),
    (3,4,'have'),
    (4,8,'he'),
    (6,4,'her'),
    (14,9,'here'),
    (15,1,'him'),
    (10,7,'his'),
    (10,8,'how'),
    (17,3,'I'),
    (19,8,'if'),
    (5,3,'in'),
    (14,2,'into'),
    (1,5,'it'),
    (9,7,'its'),
    (10,6,'just'),
    (4,8,'know'),
    (13,4,'like');


INSERT INTO ContentFeeds(userID, interests) VALUES
    (1,'day'),
    (2,'this'),
    (3,'also'),
    (4,'of'),
    (5,'your'),
    (6,'only'),
    (7,'she'),
    (8,'use'),
    (9,'its'),
    (10,'tell');

INSERT INTO Posts_Feeds(postID, feedID) VALUES
    (1,2),
    (1,10),
    (1,6),
    (2,9),
    (3,6),
    (3,4),
    (3,3),
    (4,4),
    (4,8),
    (4,7),
    (4,10),
    (5,2),
    (5,1),
    (5,7),
    (5,9),
    (6,3),
    (6,9),
    (6,4),
    (6,2),
    (7,1),
    (7,9),
    (7,4),
    (7,3),
    (7,2),
    (8,4),
    (9,4),
    (9,3),
    (9,1),
    (10,5),
    (11,4),
    (11,6),
    (12,8),
    (12,5),
    (13,8),
    (13,2),
    (13,6),
    (14,3),
    (15,4),
    (15,2),
    (16,6),
    (16,10),
    (16,9),
    (17,2),
    (17,9),
    (17,4),
    (18,5),
    (18,4),
    (19,7),
    (19,6),
    (19,4);

-- SELECT * FROM Posts_Feeds;
-- SELECT * FROM ContentFeeds;
-- SELECT * FROM Comments;
-- SELECT * FROM Posts;
-- SELECT * FROM Users;
