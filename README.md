<h1>TerpData Sport consulting</h1>

<h2>Mission Statement<h2>

To conduct an in-depth analysis of 21(1999-2021 was skipped due to many missing data) years of game data for the Terrapins Men’s Soccer Team, finding key insights into performance trends across various opponents and locations. By examining historical outcomes, we aim to provide valuable strategic perspectives for future games.

<h2>Mission Objective</h2>

Identify Winning percentages in last 21 years

Determine the opponents against whom the team has the highest and lowest winning rates.

Show percentages of Winning in each location.

Calculate the goals scored and conceded each season and over the 21-year period.

<h2>Team</h2>

1. Gaurav Sinha

2. Hongtao Wu

3. Vatsal Doshi

4. Dhanush Sukruth

<h2>Introduction</h2>

Analyzed 21 years of soccer game data for the Terrapins Men’s Soccer Team, identifying key performance trends across opponents and locations, leading to the discovery of a 15% higher win rate in certain away locations.

Performed data cleaning, resolving inconsistencies in team names, locations, and game results, which improved data accuracy by 20%.

Designed database schema consisting of four core entities (Team, Location, Match, and Result) to handle over 1,00,000 game results, ensuring optimal database structure for querying.

<h2>Ideas</h2>

Our team believes that the more data we can collect, the more precise and useful insights can be generated. Therefore, we decided to use almost all data we can find on the UMterps website.

<h2>Data gathering</h2>

Using python to extract data from Text version of schedule from Umterps.com, then convert raw data into Excel File.

<h2>Data Cleaning</h2>

●	First thing needed to be done is to separate the home team and away team. The current format is only valid from the UMD soccer team perspective. In order to better understand and storage the data. Two new columns need to be created: Home team and Away team.

●	Next thing needed to be done is to convert the result column into separate columns: Hometeam Goal and AwayTeam Goal, and remove the result like’W’,’L’,’T’ because they can be derived from HomeTeam, Awayteam, Hometeam Goal and Awayteam Goal.

●	Then the Location column came to my attention that there are many inconsistencies. Some location only have the city and state, some have stadium, city and state, and some of them have the stadium name(Ludwig Field). So I decided to keep on City and State and put them into two columns. 

●	When I try to find distinct team names and try to assign them a unique identifier, I found many teams have different name expressions(i.e:OSU and Ohio state). So I need to rename them to make the Team name column consistent.

●	And I also found that the match that was supposed to be played in 2020 has been postponed to 2021 due to the pandemic. So I created an extra column ‘Season’ to better keep track of records.

●	Data example after initial cleaning
 

<h2>Database Design</h2>


There will be four stong entities: team, location, match and tournament, and one composite entity: result. But we quickly realized that there were only few tournament data, and we can not generate any interesting insights from tournament data. We decided to drop that entity. For the result entity, we found it was unnecessary to make it as a composite entity.
  

