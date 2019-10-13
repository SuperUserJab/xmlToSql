create database BsipDB
Use BsipDb

create table langtyp
(
   langtypID int  primary key identity(1,1) not null,
   Tip nvarchar(10) not null

);
CREATE TABLE USPatentApplication
(
  USPatentApplicationId INT PRIMARY KEY IDENTITY (1,1) NOT NULL,
   dtdversion nvarchar(30)  null,
  [file] nvarchar (40) null,
  [status] nvarchar (30)not null,
  id nvarchar(30)  null,
  dateproduced nvarchar(30) null,
  datepubl nvarchar(30)  null,
  DrzavaId int FOREIGN KEY REFERENCES Drzava (DrzavaID)
);
Create table Drzava
(
 DrzavaID int PRIMARY KEY IDENTITY(1,1) NOT NULL,
 Naziv nvarchar(20) null,
);
Create table Abstract
(
 AbstractID int primary key identity(1,1) NOT Null,

 Opis nvarchar(max) null,
 idnum nvarchar(6) null,
 numeracija nvarchar(6) null
);

Create Table Dokumenti
(
 DokumentID int primary key identity(1,1) not null,

 Vrsta nvarchar(20)  null,
 Brojdokumenta nvarchar(20)  null,
 Datum nvarchar(20)  null
);

Create table Appreference
(
 AppreferenceID INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
 korisnost nvarchar(30)  null,
);
create table Classificationipcn
(
 ClassificationipcnID INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
 classification nvarchar (40) null,
 [level] nvarchar (40) null,
 section nvarchar (40) null,
 class nvarchar(40) null,
 subclass nvarchar (40) null,
 maingroup nvarchar (40) null,
 subgroup nvarchar (40) null, 
 symbolposition nvarchar(40) null,
 classificationvalue nvarchar (40) null,
 actiondate nvarchar (40) null,
 drzavaId int null,
 classificationstatus nvarchar (40) null,
 classificationdatasource nvarchar (40) null
);

create table UsParties
(
UsPartiesID INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
[sequence] nvarchar (40) null,
apptype nvarchar (40) null, 
designation nvarchar (40) null, 
applicantauthoritycategory nvarchar (40) null
);


create table AddressBook
(
   AddressBookID INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
   city nvarchar(30)  null,
   [state] nvarchar(20) null,
   countryId int FOREIGN KEY REFERENCES Drzava(DrzavaID) NOT NULL
);

create table Inventors
(
 InventorID INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
 [Sequence] nvarchar(10) NOT NULL,
 Designation nvarchar(40) NOT NULL,
 FirstName nvarchar(20) null,
 LastName nvarchar(20) null,
);

create table Assignees
(
AssigneeID int primary key identity(1,1) not null,
OrgName nvarchar(40) null,
[Role] nvarchar(20)  null,
AddressBookID int FOREIGN KEY REFERENCES AddressBook(AddressBookID)
);

create table Drawings
(
DrawingID INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
iddrawings nvarchar(20) null,
);
create table Chemistry
(
 ChemistryID INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
 idref nvarchar(80) null,
 cdx nvarchar(80) null,
 molfile nvarchar(100) null
);

create table UsMath
(
UsMathID INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
idref nvarchar(15) null,
nbfile nvarchar(15) null

);
Create table Img
(
 ImgID int primary key identity(1,1) not null,
 ImgUniqueIdentifier nvarchar(40) UNIQUE NOT NULL,
 he nvarchar(20) null,
 wi nvarchar(30) null,
 [file] nvarchar(40) not null,
 alt nvarchar(30) null,
 imgcontent nvarchar(30) null,
 imgformat nvarchar(30) null,
 orientation nvarchar(30) null,
 USPatentApplicationID int FOREIGN KEY REFERENCES USPatentApplication (USPatentApplicationID)
);


create table Claims
(
 ClaimID INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
 id nvarchar(10) null,
 num nvarchar(10) null,
 claimtext nvarchar(MAX) null,
 idref nvarchar(20) null,
 USPatentApplicationID int FOREIGN KEY REFERENCES USPatentApplication(USPatentApplicationID)
);

DECLARE @filedata XML
SELECT @filedata=CONVERT(XML,BulkColumn,2) from OpenRowSet(bulk 'C:\Users\WIN10\Desktop\Dzeno.xml', Single_Blob)as x;
INSERT INTO USPatentApplication
Select	data.value('@dtd-version','nvarchar(30)') dtdversion,
		data.value('@file', 'nvarchar(40)') [file],
		data.value('@status', 'nvarchar(30)') [status],
		data.value('@id', 'nvarchar(30)') id,
		data.value('@date-produced', 'nvarchar(30)') dateproduced,
		data.value('@date-publ', 'nvarchar(30)') datepubl,
		(
		SELECT D.DrzavaID
		FROM Drzava AS D
		WHERE data.value('@country','nvarchar(40)') LIKE D.Naziv
	  ) AS DrzavaId
FROM @fileData.nodes('/us-patent-application') as x(data)

select * from USPatentApplication

DECLARE @filedata XML
SELECT @filedata=CONVERT(XML,BulkColumn,2) from OpenRowSet(bulk 'C:\Users\WIN10\Desktop\Dzeno.xml', Single_Blob)as x;
INSERT INTO langtyp
Select	data.value('@lang', 'nvarchar(10)') Tip
FROM @fileData.nodes('/us-patent-application') as x(data)

select * from langtyp

declare @filedata XML
SELECT @filedata=CONVERT(XML,BulkColumn,2) from OpenRowSet(bulk 'C:\Users\WIN10\Desktop\Dzeno.xml', Single_Blob)as x;
insert into Drzava
select 
      data.value('@country', 'nvarchar(20)') Naziv
from @fileData.nodes('/us-patent-application') as x(data)


declare @filedata XML
SELECT @filedata=CONVERT(XML,BulkColumn,2) from OpenRowSet(bulk 'C:\Users\WIN10\Desktop\Dzeno.xml', Single_Blob)as x;
insert into Abstract
select 
      data.value('p[1]','nvarchar(max)') Opis,
		
		data.value('p[1]/@num', 'nvarchar(6)') numeracija,
		data.value('p[1]/@id', 'nvarchar(6)') idnum
from @fileData.nodes('/us-patent-application/abstract')as x(data)

SELECT * FROM Abstract

declare @filedata XML
SELECT @filedata=CONVERT(XML,BulkColumn,2) from OpenRowSet(bulk 'C:\Users\WIN10\Desktop\Dzeno.xml', Single_Blob)as x;
insert into Dokumenti
select 
      data.value('doc-number[1]','nvarchar(20)') Brojdokumenta,
	  data.value('kind[1]', 'nvarchar(20)') Vrsta,
      data.value('date[1]', 'nvarchar(20)') Datum
from @fileData.nodes('/us-patent-application/us-bibliographic-data-application/publication-reference/document-id')as x(data)

select * from Dokumenti
drop table Dokumenti
--provjeriti
-- koji dio ponovo neradi

declare @filedata XML
SELECT @filedata=CONVERT(XML,BulkColumn,2) from OpenRowSet(bulk 'C:\Users\WIN10\Desktop\Dzeno.xml', Single_Blob)as x;
insert into Appreference
select 
      data.value('@appl-type','nvarchar(30)') korisnost
	  
from @fileData.nodes('us-patent-application/us-bibliographic-data-application/application-reference')as x(data)

SELECT * FROM Appreference

declare @filedata XMl
SELECT @filedata=CONVERT(XML,BulkColumn,2) from OpenRowSet(bulk 'C:\Users\WIN10\Desktop\Dzeno.xml', Single_Blob)as x;
insert into Classificationipcn
select 
      data.value('ipc-version-indicator[1]/date[1]','nvarchar(40)') classification,
	  data.value('classification-level[1]','nvarchar(40)') [level],
	  data.value('section[1]','nvarchar(40)') section,
	  data.value('class[1]','nvarchar(40)') class,
	  data.value('subclass[1]','nvarchar(40)') subclass,
	  data.value('main-group[1]','nvarchar(40)') maingroup,
	  data.value('subgroup[1]','nvarchar(40)') subgroup,
	  data.value('symbol-position[1]','nvarchar(40)') symbolposition,
	  data.value('classification-value[1]','nvarchar(40)') classificationvalue,
	  data.value('action-date[1]/date[1]','nvarchar(40)') actiondate,
	  -- test code start line for contry FK int 
	  (
		SELECT D.DrzavaID
		FROM Drzava AS D
		WHERE data.value('generating-office[1]/country[1]','nvarchar(40)') LIKE D.Naziv
	  ) AS drzavaId,
	  -- test code end
	  data.value('classification-status[1]','nvarchar(40)') classificationstatus ,
	  data.value('classification-data-source[1]','nvarchar(40)') classificationdatasource
	  
from @fileData.nodes('us-patent-application/us-bibliographic-data-application/classifications-ipcr/classification-ipcr')as x(data)

SELECT * FROM Drzava
select * from Classificationipcn


declare @filedata XMl
SELECT @filedata=CONVERT(XML,BulkColumn,2) from OpenRowSet(bulk 'C:\Users\WIN10\Desktop\Dzeno.xml', Single_Blob)as x;
insert into UsParties
select 
      data.value('@sequence','nvarchar(40)') [sequence],
	  data.value('@app-type','nvarchar(40)') apptype,
	  data.value('@designation','nvarchar(40)') designation,
	  data.value('@applicant-authority-category','nvarchar(40)') applicantauthoritycategory	  
from @fileData.nodes('us-patent-application/us-bibliographic-data-application/us-parties/us-applicants/us-applicant')as x(data)

SELECT * FROM UsParties

declare @filedata XMl
SELECT @filedata=CONVERT(XML,BulkColumn,2) from OpenRowSet(bulk 'C:\Users\WIN10\Desktop\Dzeno.xml', Single_Blob)as x;
insert into AddressBook
select 
	  data.value('address[1]/city[1]','nvarchar(20)') city,
	  data.value('address[1]/state[1]','nvarchar(20)') [state],
	  -- test code CountryId FK
	  (
		SELECT D.DrzavaID
		FROM Drzava AS D
		WHERE data.value('address[1]/country[1]','nvarchar(30)') LIKE D.Naziv
	  )
	  -- end test code
from @fileData.nodes('us-patent-application/us-bibliographic-data-application/us-parties/us-applicants/us-applicant/addressbook')as x(data)

declare @filedata XMl
SELECT @filedata=CONVERT(XML,BulkColumn,2) from OpenRowSet(bulk 'C:\Users\WIN10\Desktop\Dzeno.xml', Single_Blob)as x;
insert into Inventors
select 
		data.value('@sequence','nvarchar(10)') [Sequence],
		data.value('@designation','nvarchar(40)') Designation,
		data.value('addressbook[1]/first-name[1]','nvarchar(20)') FirstName,
		data.value('addressbook[1]/last-name[1]','nvarchar(20)') LastName
	  
from @fileData.nodes('us-patent-application/us-bibliographic-data-application/us-parties/inventors/inventor')as x(data)
SELECT * FROM Inventors
declare @filedata XMl
SELECT @filedata=CONVERT(XML,BulkColumn,2) from OpenRowSet(bulk 'C:\Users\WIN10\Desktop\Dzeno.xml', Single_Blob)as x;
insert into Assignees
select 
		data.value('orgname[1]','nvarchar(40)') OrgName,
		data.value('role[1]','nvarchar(20)') [role],
		(
			SELECT AB.AddressBookID
			FROM AddressBook AS AB
			WHERE data.value('address[1]/city[1]','nvarchar(40)') LIKE AB.city
		) AS AddressBookID
	  
from @fileData.nodes('us-patent-application/us-bibliographic-data-application/assignees/assignee/addressbook')as x(data)

select * from Assignees

declare @filedata XMl
SELECT @filedata=CONVERT(XML,BulkColumn,2) from OpenRowSet(bulk 'C:\Users\WIN10\Desktop\Dzeno.xml', Single_Blob)as x;
insert into Img
select	
		img.value('@id','nvarchar(20)') ImgUniqueIdentifier,		
		img.value('@he','nvarchar(20)') he,
		img.value('@wi','nvarchar(30)') wi,
		img.value('@file','nvarchar(40)') [file],
		img.value('@alt','nvarchar(30)') alt,
		img.value('@img-content','nvarchar(30)') imgcontent,
		img.value('@img-format','nvarchar(30)') imgformat,
		img.value('@orientation','nvarchar(30)') orientation,
		(
			SELECT USP.USPatentApplicationID
			FROM USPatentApplication AS USP
			WHERE data.value('@file','nvarchar(40)') LIKE USP.[file]
		) AS USPatentApplicationID


FROM @fileData.nodes('us-patent-application') AS x(data)	
OUTER APPLY @fileData.nodes('us-patent-application/drawings/figure/img')as c(img)

select * from Img


declare @filedata XMl
SELECT @filedata=CONVERT(XML,BulkColumn,2) from OpenRowSet(bulk 'C:\Users\WIN10\Desktop\Dzeno.xml', Single_Blob)as x;
insert into Claims
select	
		claim.value('@id','nvarchar(10)') id,		
		claim.value('@num','nvarchar(10)') num,
		claim.value('claim-text[1]','nvarchar(MAX)') claimtext,
		claim.value('claim-text[1]/claim-ref[1]','nvarchar(20)') idref,
		(	SELECT USP.USPatentApplicationID
			FROM USPatentApplication AS USP
			WHERE data.value('@file','nvarchar(40)') LIKE USP.[file]
		) AS USPatentApplicationID
	  
from @fileData.nodes('us-patent-application')as x(data)
OUTER APPLY @fileData.nodes('us-patent-application/claims/claim') AS c(claim)

SELECT * FROM  Claims

declare @filedata XMl
SELECT @filedata=CONVERT(XML,BulkColumn,2) from OpenRowSet(bulk 'C:\Users\WIN10\Desktop\dzenkas.xml', Single_Blob)as x;
insert into Chemistry
select	
		data.value('@idref','nvarchar(80)') idref,		
		data.value('@cdx-file','nvarchar(80)') cdx,
	   data.value('@mol-file','nvarchar(100)') molfile

from @fileData.nodes('us-patent-application/us-chemistry')as x(data)

SELECT * FROM Chemistry

declare @filedata XMl
SELECT @filedata=CONVERT(XML,BulkColumn,2) from OpenRowSet(bulk 'C:\Users\WIN10\Desktop\dzenkas.xml', Single_Blob)as x;
insert into UsMath
select	
		data.value('@idref','nvarchar(80)') idref,		
		data.value('@cdx-file','nvarchar(80)') cdx,
	   data.value('@mol-file','nvarchar(100)') molfile
	  
from @fileData.nodes('us-patent-application/us-chemistry')as x(data)

