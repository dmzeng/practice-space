#Select an org's bin_weights for a specified time period

SELECT bin_weights.*
FROM bin_weights, clusters, orgs
WHERE bin_weights.unit_id = clusters.id AND clusters.org = orgs.id AND orgs.name = '[org name]' AND 
    bin_weights.ignore = 'f' AND bin_weights.change > 0.200001;

#Select a site's bin_weights for a specified time period

SELECT bin_weights.*
FROM bin_weights, clusters, sites
WHERE bin_weights.unit_id = clusters.id AND clusters.site = sites.id AND sites.name = 'Pinterest NY'
    AND bin_weights.ignore = 'f' AND bin_weights.change > 0.200001;

#Copy an org's bin_weights for a specified time period to a CSV file
#Newlines causing conflicts with the copy command, so they're omitted from these query.
#Note: target csv file should be named with the pattern org_name-year-month.csv, i.e. 'pinterest_2018-may.csv'

\copy ( SELECT bin_weights.* FROM bin_weights, clusters, sites WHERE bin_weights.unit_id = clusters.id AND clusters.org = orgs.id AND orgs.name = '[org name]' AND bin_weights.timestamp BETWEEN '[start date]' AND '[end date]' AND bin_weights.ignore = 'f' AND bin_weights.change > 0.200001 ) TO '/home/evoeco/[file name].csv' DELIMITER ',' CSV;

#Copy a site's bin_weights for a specified time period to a CSV file

\copy ( SELECT bin_weights.* FROM bin_weights, clusters, sites WHERE bin_weights.unit_id = clusters.id AND clusters.site = sites.id AND sites.name = '[site name]' AND bin_weights.timestamp BETWEEN '[start date]' AND '[end date]' AND bin_weights.ignore = 'f' AND bin_weights.change > 0.200001 ) TO '/home/evoeco/[file name].csv' DELIMITER ',' CSV;



# I'm avoiding * because it seems like it could potentially be an issue
# I think it is inefficient to join three tables and get all relevant tuples, so ideally
# we should prune sites by a "org name" parameter, then join to clusters, prune by a
# "building name" parameter, then join to bin_weights, then filter by timestamp 
# and for more granularity, a particular cluster

# pre: start and end time (as str representation?), a cluster id
# post: relevant features (cluster id, readable name of cluster, org name, timestamp, 
# 	mode, change in weight, total weight, overweight status, ignore status) sorted chronologically
# note: since awd_ids is an integer array, I'm not sure if I can export that in a .csv 

SELECT b.unit_id as Cluster_ID
	, c.name as Cluster_Name
	, s.name as Organization 
	, b.timestamp as Time_of_Event 
	, b.mode as Bin_mode
	, b.change as Weight_change
	, b.weight as Total_Weight
	, b.overweight as Overweight_Status
	, b.ignore as Ignore_Status 
FROM sites s
LEFT OUTER JOIN clusters c 
	ON s.id = c.site
LEFT OUTER JOIN  bin_weights b
	ON c.id = b.unit_id
WHERE s.name = 'pint_sf' # 
ORDER BY b.timestamp
LIMIT 10; 

# Still debugging why various comands I've been playing with havne't worked by here are some of 

\copy ( SELECT b.unit_id as Cluster_ID, c.name as Cluster_Name, s.name as Organization , b.timestamp as Time_of_Event , b.mode as Bin_mode, b.change as Weight_change, b.weight as Total_Weight, b.overweight as Overweight_Status, b.ignore as Ignore_Status FROM sites s LEFT OUTER JOIN clusters c ON s.id = c.site LEFT OUTER JOIN  bin_weights b ON c.id = b.unit_id WHERE s.name = 'pint_sf'ORDER BY b.timestamp LIMIT 10 ) TO 'test.csv' DELIMITER ',' CSV;

psql -c "COPY ( SELECT b.unit_id as Cluster_ID, c.name as Cluster_Name, s.name as Organization , b.timestamp as Time_of_Event , b.mode as Bin_mode, b.change as Weight_change, b.weight as Total_Weight, b.overweight as Overweight_Status, b.ignore as Ignore_Status FROM sites s LEFT OUTER JOIN clusters c ON s.id = c.site LEFT OUTER JOIN  bin_weights b ON c.id = b.unit_id WHERE s.name = 'pint_sf'ORDER BY b.timestamp LIMIT 10 ) TO STDOUT WITH CSV HEADER " > CSV_FILE.csv
