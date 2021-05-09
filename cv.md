---
layout: post
title: Matthew Forrester
---

## Personal Information

 *   _Telephone:_ **07957 572988**
 *   _Email:_ **blcv19@speechmarks.com**
 *   _Date of Birth:_ **1980**
 *   _Location:_ **London**
 *   _Driving License:_ **Full UK Clean**
 *   _Blog:_ **[matt-at.keyboard-writes-code.com](http://matt-at.keyboard-writes-code.com)**
 *   _GitHub:_ **[github.com/forbesmyester](http://github.com/forbesmyester)**

## Overview

I have been a software developer since 2001 and have accumulated a wealth of experience from a variety of different projects. I find great enjoyment from both writing great code and finding solutions to real-life business problems.

I have experience of leading projects from inception to completion including drawing up requirements by talking to key stakeholders, validating those requirements via mock-ups and presentations, technology selection, design and documentation, development, putting in continuous integration, systems administration and ongoing monitoring.

I consider myself to be a software craftsman and put significant thought into finding elegant simple solutions which can be easily understood and tested. Sometimes the best solutions are not code.

I am always keen to learn new things even when they are far outside of my normal comfort zone.

## Experience

### MediaSense (Principal Developer): 07/2016 - Present

MediaSense advises large national and international organisations on how they buy media. The media industry is often driven by Excel documents over Email. A key part of my role is to try and change internal processes from this into something more reliable, efficient and accountable.

At MediaSense I consult with Analysts, Founders, CEOs, Account Managers and Directors to draw up and validate requirements for projects. After this I will take these projects through the whole project life-cycle.

During my tenure I have led multiple success projects from inception, these are:

#### TViQ

[TViQ](https://www.media-sense.com/our-services/tviq/) is a single page application which presents a dashboard that enables viewing industry standard metrics such as prime time, premium position, audience reach and size as well as proprietary measures such as cost benchmarking and efficiency. It is used as a promotional tool and subscription service sold to CMOs of large national and international businesses.

The TViQ service is comprised of multiple services such as:

 * Data collection service that is a mix of **PostgreSQL** and **Python** running on **Apache NiFi** and is monitored using **Metabase**.
 * The Back End is wrote in **NodeJS** using **TypeScript**, **PostgreSQL** and hosted in **AWS** on **EC2 AutoScaling** along with **CloudWatch**, **S3** and **SQS**. It is stood up using **Docker** and **Hashicorp Terraform**.
 * The front end is wrote in **TypeScript** with **Redux**, **GlimmerJS**, **Sass** as well as **Vega** for drawing graphs.

#### Hephaestus

Hephaestus is a front end administration system for **AWS Lake Formation**, **Glue**, **Athena**, **IAM** and **S3**. It is built in **TypeScript**, **AWS CDK** and **PostgreSQL**. It allows the following functions:

 * Enables the user to define a Glue database, IAM users and an S3 Bucket to upload a large series of data files for ingestion.
 * Give the user the ability to map fields within the source data to destination (**Apache Parquet**) partitions.
 * Configures Glue Crawlers and Jobs to process the data.

#### Spot List Cleaner

The role of Spot List Cleaner is to take raw data from BARB, clean it, enrich it with data from other sources and finally output a cleaned version for analysis in Tableau.

Essentially it is a large pipeline however many of the stages require human decision making and has the added complication of having to deal with large Excel files. It comprises of the following services:

 * A **NodeJS** / **TypeScript** back end service which accepts an Excel file and with sits in the middle of a spreadsheet reading service, micro-services that supply information for enrichment and a single page application where most of the user interaction occurs.
 * A single page application built in **GlimmerJS** and **Redux** which streams data from the back end using **EventSource** and allows the user to control the enrichment of the Excel document.
 * The Excel reading service wrote using **Swagger3** / **OpenAPI**, **C#** and **PostgreSQL** which gives programmatic access to spreadsheets along with the ability to define the header line(s) as well as column types, thus converting the spreadsheet into clean data source.
 * Multiple data services built in **Clojure** which interact with a different **PostgreSQL** schemas.
 * Two final services for taking spend and data about special purchases supplied by agencies and spreading / matching them to further enriched the BARB data. These are wrote in **TypeScript**, **SQL** and **GlimmerJS**.

#### Integrity Checker

An in-Excel task pane which allows users to take third party, hand crafted often inconsistent spreadsheet and convert it into clean data. It performs the following functions:

 * Can retrieve schemas from a centralized store or generate one from the spreadsheet. Schemas are stored as an Excel sheet.
 * Validates the data against that schema, highlighting errors and generating health statistics.
 * Can derive columns based on other columns
 * Add an ID to the spreadsheet so further transformations by other tools can be tracked and thus, a full history can be established.
 * Add checksums to sets of fields so unauthorized edits by third parties can be quickly identified.

The purpose of this is to allow the data to be processed using other tools, both bespoke and off-the-shelf, allowing further automation. Integrity Checker is developed using the **Excel JavaScript API**.

Integrity checker has gone from a small closed beta to full UK and International usage (multiple time zones) with zero input from the development team. It will be a key component of the current effort to establish company wide databasing capability.

#### Effective hosting and development

I have brought about changes to how internal systems are developed. Previously we had services deployed directly onto a single virtual machine connected to **MongoDB**. We have transitioned to a **PostgreSQL** and **Kubernetes** environment. We also have an internal **Jenkins** CI/CD pipeline which builds **Docker** images and automatically deploys them to live / production depending on branch name.

The major advantage of this approach is that previously the layout / configuration of services lived in peoples heads, now it is well documented with some Markdown but mostly in **Kubernetes** YAML definitions, **Terraform** HCL and **Ansible** YAML.

### Land Technologies (Lead Developer): 09/2015 - 07/2016

Land Technologies collates and presents information for house builders to help them make decisions on possible land purchases. I led the data collection projects which were primarily **NodeJS** / **AWS SQS** / **AWS Beakstalk** based systems as well as taking a key role in **Database Administration** (transitioning us to **PostgreSQL** / **PostGIS**), **Systems Administration** and **Monitoring**. Outside of project related work I introduced **TDD** and **linting** as part of the development processes.

### Daily Mail (Senior Developer): 09/2014 - 09/2015

At Daily Mail I have worked across two teams. Firstly in the Content Creator team where I developed and integrated a service for storing / visualizing auto saves. The system was planned out and using **RAML** (similar to OpenAPI/Swagger) and developed on **Express**, **Mocha**, **Elasticsearch**, **MySQL**, **ESLint** and **Expect.JS** using **TDD** principles. Later I worked on a team creating a **Haskell** based news service for discovering breaking news.

### Pod Point Ltd (Senior Developer): 04/2014 - 09/2014

Pod Point are selling chargers and services for running electric cars. A lot of the work was spent understanding how charger and server communicate though a **RESTful** back end to ensure data and communication is done correctly. Later I used this knowledge and data to develop a Pay As you Go **HTML5** mobile app using **RAML** and **TDD** (**PHPUnit** and **Codeception**). I have also deployed it into **AWS CloudFormation** using **Ansible**.

### CityHook / Indigo Connect (Developer): 01/2014 - 03/2014 (Contract)

CityHook is trying to redefine the airport transfer business. Their technology stack is based on **NodeJS** / **ExpressJS** and backed primarily by a **CouchDB** database. A great deal of the time has been spent modularizing the existing code base to enable it to be unit testable while working on administration systems for CityHook employees and external customers.

### MediaEquals (Lead Developer): 02/2007 - 12/2013

MediaEquals is a B2B media trading system designed to support the multiple workflows used by media agencies / publishers including BuyNow, Offer / Negotiation (with full change and cancel processes) and Auctions. It was selected and used successfully to sell all the outdoor media for the 2012 Olympic Games.

During this time I have led the majority of the development, planning major features, organized releases and processes, configured nightly build systems, provisioning / configuring servers, transitioning to **AWS** (from a private data centre) and selected key services for developers such and version control and bug track software. Outside of the purely technical skills I have had a large amount of input into requirements capture and specifications.

Inventor on patent [US20090287610A1](https://patents.google.com/patent/US20090287610A1).

### IPC Media (Developer): 11/2006 - 02/2007 (Contract)

This contract was for the re-release of the high traffic CountryLife.co.uk website. It utilised the **PHP** **Symfony** framework.

### Pearson (Developer): 07/2006 - 11/2006 (Contract)

Working on the Knowledgebox platform which was a Flash based interface communicating with a backend through **XML**. Most of the work was to analyse the existing system using **Java**/SAPDB and rewrite it with tests using **PHP**/**MySQL** as it was felt that this would be easier to support at external customer sites.

### Speechmarks.com (Owner / Developer): 09/2003 - 09/2005, 12/2005 - 07/2006

I sometimes in-between contracts worked with other freelance professionals on alternative projects. These projects have included some eCommerce websites, developing an early ORM/CMS with Hybrid Media and the Youemail platform with Creative Alliance.

### Technophobia.co.uk (Developer): 09/2005 - 12/2005 (Contract)

I contracted with Technophobia to aid with development of the Haggle4Me website. My main task was to design, implement and integrate the financial control systems with the credit card payment provider.

### Direct X Training (Technical Trainer): 05/2003 - 9/2003 (Redundant)

I trained and worked as a Technical Trainer for NVQ candidates doing IT related courses. This included running a workshop, visiting candidates at workplaces to check their progress and helping them achieve their goals.

### Creative Alliance (Lead Developer): 08/2002 - 05/2003 (Contract)

I led a small development team creating the Youemail communication platform which incorporated email, SMS notifications / payment, calendars, forums and contact management. I designed and implemented all back-end systems as well as collaborating on interface design.

### QED IT Group (Developer): 04/2001 - 07/2002 (Company Liquidated)

At QED I worked in a small team developing two Delphi based applications called EMIR and BOSS. I later led an effort to introduce more modern methods into the development process such as Unit Testing and Version Control.

### Technicks (Developer): 05/2000 - 04/2001

I originally was the only website developer at Technicks but as the development team grew I became Development Team Leader. This role often required me to meet customers and draw up requirements and development plans.

## Skills

**Node/JavaScript:** having used JavaScript to varying degrees throughout my career it is the technology I have most experience with. My preferred tool-kit is based around **NodeJS**, **ExpressJS**, **NPM** and **TypeScript**. I prefer focussing on the back-end but have good knowledge of **React**, **Redux**, **Svelte** and **GlimmerJS**.

**HTML/CSS:** Throughout my career my output has often been web pages and I have become proficient with these technologies. I quite enjoy the challenge of writing clean, semantic HTML and using tools like **SASS** / **SCSS** to give the desired look.

**Test Driven Development / Refactoring:** Throughout my career. I believe any code which is non trivial should be tested.

**SQL / PostgreSQL:** Throughout my career I have performed basic administration and (now) can write advanced queries using concepts such as common table expressions, window functions and building custom aggregates.

**APIs and RESTful Design:** MediaEquals - Present: Experience of **RESTful API** design using **RAML** and **Swagger3** / **OpenAPI**. Outside of this I have used and deployed API's using **SOAP**, **XML-RPC** and **SMS**. I Would like to learn about gRPC and / or Thrift.

**Amazon Web Services** MediaEquals - Present: AWS Certified Cloud Practitioner and studying for the SysOps Associate certification. I have good experience of using **Terraform**, **AWS APIs** and the **AWS CLI based tools**.

**Unix / Linux:** I have been using Linux since before starting my professional career setting up such things as DNS, firewalls, web servers, and email services. I am fully capable of writing reliable BASH scripts as well as using powerful tools such as `parallel`, `find`, `sed` and `awk` when the need arises.

**Docker / Microservices / Kubernetes:** Daily Mail - Present: Using tools like Docker and Kubernetes I have achieved service configuration as code, which I believe is incredibly valuable both for predictable releases and documentation.

**Metabase** I have found this useful for monitoring.

**Clojure** Daily Mail - Present: At MediaSense I inherited and continue to maintain multiple software services wrote in Clojure. I continue to be interested in functional languages, including Clojure.

**NoSQL Databases (MongoDB / CouchDB / Elasticsearch / Redis):** Cityhook - Present: I have commercial experience with a range of NoSQL databases.

**Python / C# / Haskell / Java** I have rarely used these languages as my main language but am proficient and capable in them.

**Rust** Personal Projects: I'm really interested in using this language but my only experience is on personal projects which are available publicly in my GitHub profile.

**PHP:** Creative Alliance - MediaEquals: Many years experience.

**Documentation** I like code friendly documentation, such as **ASCIIDoctor** / **Markdown** and enjoy code driven diagramming tools such as **GraphViz** and **BurntSushi's ERD**.

**Apache NiFi:** MediaSense - Present: For managing ingestion of data and lots of data hygiene related tasks.

**KNIME / Alteryx** These tools are sometimes useful for prototyping before writing real code.

**Version Control:** I have used CVS, Subversion, Mercurial and Git and have managed the last three.

**Public Speaking** I have talked at the SkillsMatter and the London Node User Group multiple times as well as giving internal workplace presentations.

## Patents

Co-Author of US Patent US2009/0287610 A1: Negotiation of a package of inventory, taking the form of offers and counter offers between a single major party and a plurality of minor parties.

## Education

### HND Computing

> 07/98 - 05/2000: University of Lincolnshire and Humberside 6 Distinctions, 13 Merits and 7 Passes

### A Levels

> 07/96 - 06/98 : Franklin College, Grimsby A-Levels in Computing, Maths and Business

### GCSE's

> 07/94 - 06/96: Lindsey School, Cleethorpes

## Hobbies / Free time

The main ways I enjoy spending my free time are:

 * Listening to audio books.
 * Skating / Skateboarding.
 * Learning Japanese.
 * Looking at new technologies through books, media and meetups.
 * Cooking / Barbecue (I have a Raspberry Pi powered Kamado)
 * Personal Projects.
 * Mountain Biking
 * I have a [blog](http://matt-at.keyboard-writes-code.com) where I write about things that interest me.

<style>
h1, h2, h3, h4, h5 { font-weight: bold; }
</style>
